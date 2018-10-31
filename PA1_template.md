---
title: "Reproducible Research project 1"
author: "Ruchi Patel"
date: "October 5, 2018"
output: html_document:    keep_md: true

---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## 1. Reading and preprocessing the data

### a.Load the data 

```{r}

if (!file.exists("./project1_week2")){dir.create("./project1_week2")}


FitBit_File <- "./project1_week2/download_FitBitdata.zip"

FitBit_URL <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
  
download.file(url=FitBit_URL,destfile=FitBit_File, method = "curl")

unzip(zipfile = "./project1_week2/download_FitBitdata.zip" , exdir = "./project1_week2")

```

### b.Process/transform the data

```{r}

# Read CSV file and store it to FitBit_data variable
FitBit_data <- read.csv("./project1_week2/activity.csv")

#converting date factor to date
FitBit_data$date <- as.Date(FitBit_data$date)

```

## 2. Histogram of the total number of steps taken each day

### a. Calculate the total number of steps taken per day


```{r}

FitBit_stepsbydate <- aggregate(FitBit_data$steps, by = list(Date = FitBit_data$date), FUN = sum)

names(FitBit_stepsbydate)[names(FitBit_stepsbydate) == "x"] <- "Total_steps"

Date_ymd <- as.Date(FitBit_stepsbydate$Date, "%Y-%m-%d")

head(FitBit_stepsbydate)

```

### b. Plot a histogram of the total number of steps taken each day.

```{r}

library(ggplot2)

histogram <- ggplot(data = FitBit_stepsbydate, aes(Total_steps)) + 
  geom_histogram(binwidth = 1500, 
                 col="red",
                 aes(fill=..count..),
                 alpha=.8) +
  xlab("Total Number of Steps Taken Each Day") +
  ylab("Count") +
  ggtitle("Histogram of the Total Number of Steps Taken Each Day")
  
print(histogram)

```

![](FigureS/Rplot01.png)<!-- -->

## 3. Mean and median number of steps taken each day


### a. mean of the total number of steps per day

```{r}

mean(na.omit(FitBit_stepsbydate$Total_steps))

```

### b. median of the total number of steps per day

```{r}

median(na.omit(FitBit_stepsbydate$Total_steps))

```

## 4. Time series plot of the average number of steps taken

### a. Make a time series plot (i.e. \color{red}{\verb|type = "l"|}type="l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```{r}

five_min_steps <- aggregate(steps ~ interval, data = FitBit_data, FUN =mean)
head(five_min_steps)

```

### b. Tiemseries plot of 5 min.s time interval
```{r}

TimeSeries1 <- ggplot(data = five_min_steps, aes(x = interval, y = steps)) + 
  geom_line(color="red", size =2) +
  xlab("Time Intervals (5 Minutes is an unit)") + 
  ylab("Total Number of Steps") +
  ggtitle("Average Number of Steps Taken of the 5-Minute Interval")
print(TimeSeries1)

```
![](FigureS/Rplot02.png)<!-- -->
 
 
## 5. The 5-minute interval that, on average, contains the maximum number of steps

```{r}

five_min_steps[which(five_min_steps$steps == max(five_min_steps$steps)),]

```

## 6. Code to describe and show a strategy for imputing missing data

### a. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with ????????s)

```{r}

sapply(FitBit_data, FUN = function(x) sum(is.na(x)))

```

### b. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc. 

#### Use the mean for that 5 -minute interval to replace all the missing values in the dataset and check if all the NAs have been replaced.

```{r}
library(dplyr)

mean_impute <- function(num) replace(num, is.na(num), mean(num, na.rm = TRUE))

meanday <- (FitBit_data %>% group_by(interval) %>% mutate(steps = mean_impute(steps)))

head(meanday)

```

```{r}
#check if all NAs have been replaced.. The result should be same as replaced missing values with mean for 5 min. interval
sum(is.na(meanday))

```

### c. Create a new dataset that is equal to the original dataset but with the missing data filled in.

```{r}

new_dataset <- as.data.frame(meanday)

head(new_dataset)

```

## 7. Histogram of the total number of steps taken each day after missing values are imputed

### a. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps? 

```{r}
new_steps <- aggregate(new_dataset$steps, by = list(new_dataset$date), FUN = sum)

names(new_steps)[names(new_steps) == "x"] <- "Total"

names(new_steps)[names(new_steps) == "Group.1"] <- "Date"

new_hist <- ggplot(data = new_steps, aes(Total)) + 
    geom_histogram(binwidth = 1500, colour = "cyan") +
    xlab("Total Number of Steps per Day") +
    ylab("Count") +
    ggtitle("Histogram of the Total Number of Steps per Day by imputing Nan values with 5 min. interval Data")
print(new_hist)

```
![](FigureS/Rplot03.png)<!-- -->


## 8. Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends


### a. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
```{r}

new_dataset$WeekendOrWeekday <- ifelse(weekdays(as.Date(new_dataset$date)) %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"), "Weekday", "Weekend")

head(new_dataset)
```

### b. Make a panel plot containing a time series plot (i.e. \color{red}{\verb|type = "l"|}type="l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 

```{r}

new_dataset <- (new_dataset %>% group_by(interval, WeekendOrWeekday) %>% summarise(Mean = mean(steps)))

ggplot(new_dataset, mapping = aes(x = interval, y = Mean)) + geom_line(color = "red", size = 2) +
    facet_grid(WeekendOrWeekday ~.) + xlab("Interval") + ylab("Mean of   Steps") +
 ggtitle("Comparison of the average number of steps taken per 5-minute interval across weekdays and weekends")

```
![](FigureS/Rplot04.png)<!-- -->
