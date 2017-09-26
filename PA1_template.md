---
title: "Course 5 Project 1"
output: html_document
---

## Introduction
It is now possible to collect a large amount of data about personal movement using activity monitoring devices such as a Fitbit, Nike Fuelband, or Jawbone Up. These type of devices are part of the "quantified self" movement -- a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. But these data remain under-utilized both because the raw data are hard to obtain and there is a lack of statistical methods and software for processing and interpreting the data.

This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

Create a temporary file for storing the zip file from the url
```{r}
temp <- tempfile()
fileURL <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
```

Download the zip file from the url and store it in the temp file
```{r}
download.file(fileURL, temp)
```

Unzip the zip file, read it the csv file and store it in the file calls data
```{r}
data <- read.csv(unz(temp, "activity.csv"))
unlink(temp)
```

## What is mean total number of steps taken per day?
Load the dplyr package
```{r message = FALSE}
library(dplyr)
```

Group the data by date and sum up the steps taken each day
```{r}
step_gp_by_date <- data %>% 
        group_by(date) %>% 
        summarise(sum = sum(steps))
```

#### Use histogram to plot the steps taken each day
```{r message = FALSE}
library(ggplot2)
g <- ggplot(step_gp_by_date, aes(sum))
g + geom_histogram() +
        labs(title = "Total number of steps taken each day",
             x = "Total Steps")
```

#### Mean and median of steps taken per day
```{r}
step_gp_by_date2 <- data %>% 
        group_by(date) %>% 
        summarise(mean = mean(steps),
                  median = median(steps)) %>% 
        print(n = 61)
```

## What is the average daily activity pattern?
Group the data by date and then by time interval
Find the average number of steps taken
```{r}
step_gp_by_interval <- data %>% 
        group_by(interval) %>% 
        summarise(average = mean(steps, na.rm = TRUE))
```

#### A time series plot of the 5-minute interval and the average number of steps taken, averaged across all days
```{r}
par(mar = c(5, 4, 4, 2), mfrow = c(1, 1))
plot(step_gp_by_interval, 
     type = "l",
     main = "A time series plot of the 5-minute interval",
     xlab = "5-minute interval",
     ylab = "average number of steps taken")
```

#### Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
```{r}
max_step <- step_gp_by_interval[which.max(step_gp_by_interval$average), ]
```
The 5-minute interval of `r max_step[1]` contains the maximum number of steps which are `r max_step[2]`.

## Imputing missing values
#### Report the total number of missing values in the dataset
```{r}
num_na <- table(is.na(data$steps))[2]
```
The total number of missing values is `r num_na`.

#### Devise a strategy for filling in all of the missing values in the dataset.
1. The mean for that 5-minute interval is used for filling in the missing value
2. Once the missing value was found, its corresponding 5-minute interval will be used to subset the data.
3. The mean steps taken on that 5-minute interval will be calculated for replacing the missing value.
```{r}
y <- data$steps
for (i in 1:length(y)) {
        if (is.na(y[i]) == TRUE) {
                interval_index <- data[i, 3]
                sub_data <- subset(data, data$interval == interval_index)
                sub_mean <- mean(sub_data$steps, na.rm = TRUE)
                y[i] <- sub_mean
        }
}
```

#### Create a new dataset with the missing value filled in
```{r}
data2 <- data
data2$steps <- y
```

Check any NA after imputing missing values
```{r}
table(is.na(data2$steps))
```

Group the new dataset by date and sum up the steps taken each day
```{r}
new_step_gp_by_date <- data2 %>% 
        group_by(date) %>% 
        summarise(sum = sum(steps))
```

#### Use histogram to plot the steps taken each day of the new dataset
```{r message = FALSE}
h <- ggplot(new_step_gp_by_date, aes(sum))
h + geom_histogram() + 
        labs(title = "Total number of steps taken each day",
             x = "Total Steps")
```

#### Mean and median of steps taken per day of the new dataset
```{r}
new_step_gp_by_date2 <- data2 %>% 
        group_by(date) %>% 
        summarise(mean = mean(steps),
                  median = median(steps)) %>% 
        print(n = 61)
```
##### These values differ from the estimates from the first part of the assignment.

## Are there differences in activity patterns between weekdays and weekends?

#### Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day
```{r}
Sys.setlocale("LC_TIME", "English")
z <- strptime(data2$date, "%Y-%m-%d")
data2$weekdays <- weekdays(z)

for (i in 1:length(data2$weekdays)) {
        if (data2$weekdays[i] == "Saturday") {
                data2$weekdays[i] <- "weekend"
        } else if (data2$weekdays[i] == "Sunday") {
                data2$weekdays[i] <- "weekend"
        } else {
                data2$weekdays[i] <- "weekday"
        }
}

data2$weekdays <- as.factor(data2$weekdays)
```

#### Make a panel plot containing a time series plot of the 5-minute interval and the average number of steps taken, averaged across all weekday days or weekend days
```{r}
gp_by_weekdays <- data2 %>% 
        group_by(weekdays, interval) %>% 
        summarise(average = mean(steps))

f <- ggplot(gp_by_weekdays, aes(x = interval, y = average))
f + geom_line() +
        facet_grid(.~weekdays) +
        labs(title = "A time series plot of the 5-min interval",
             y = "Average number of steps taken")
```