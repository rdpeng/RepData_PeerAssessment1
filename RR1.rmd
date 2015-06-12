---
title: "RR Assignment 1 version 3"
author: "TAG"
date: "Friday, June 12, 2015"
output: pdf_document
---

* Introduction
It is now possible to collect a large amount of data about personal movement using activity monitoring devices such as a Fitbit, Nike Fuelband, or Jawbone Up. These type of devices are part of the "quantified self" movement -- a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. But these data remain under-utilized both because the raw data are hard to obtain and there is a lack of statistical methods and software for processing and interpreting the data.

This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.



* Data
The data for this assignment was downloaded from a fork of the course web site:

https://github.com/tag395/RepData_PeerAssessment1

The variables included in this dataset are:

•steps: Number of steps taking in a 5-minute interval (missing values are coded as  NA )


•date: The date on which the measurement was taken in YYYY-MM-DD format


•interval: Identifier for the 5-minute interval in which measurement was taken


The dataset is stored in a comma-separated-value (CSV) file and there are a total of 17,568 observations in this dataset.
The first step in the assignment is to load the data.


```{r}
activity <- read.csv("activity.csv",
                     header = TRUE,
                     sep = ",",
                     na.strings = "NA",
                     colClasses = c(date = "Date")
                     )

```

The next step is to make a histogram of the total steps take each day. First I will load the "dpylr" library, then create the histogram plot.


```{r, echo = FALSE}
library(dplyr)
total.steps.per.day <- activity %>%
                       group_by(date) %>%
                       summarize(total.steps = sum(steps, na.rm = FALSE))
head(total.steps.per.day)
hist(total.steps.per.day$total.steps, 
     main = "Distribution of Total Number of Steps per Day", 
     xlab = "Total Number of Steps per Day", 
     ylab = "Frequency (Number of Days)", 
     breaks=20,   col = "green")

```

Next I will calculate the mean and the medium of the total number of steps taken per day.

```{r}
mean(total.steps.per.day$total.steps, na.rm=TRUE)
median(total.steps.per.day$total.steps, na.rm=TRUE)

```

Let's look next at the average daily activity patterns. I will construct a time series plot of the 5 minute interval and the average number of steps taken, average across all days. First to group the data:

```{r}
avg.steps.per.interval <- activity %>%
                          group_by(interval) %>%
                          summarize(avg.steps = mean(steps, na.rm = TRUE))
head(avg.steps.per.interval)

```

Now to crate the plot:

```{r}
plot(strptime(sprintf("%04d", avg.steps.per.interval$interval), format="%H%M"),
     avg.steps.per.interval$avg.steps, type = "l", 
     main = "Average Daily Activity", 
     xlab = "Time of Day (HH:MM)", 
     ylab = "Average Number of Steps")

```

Determine the 5 minute interval on average across all the days in the dataset that contains the maximum number of steps:

```{r}
filter(avg.steps.per.interval, avg.steps==max(avg.steps))
```



* Imputing missing values
Note that there are a number of days/intervals where there are missing values (coded as  NA ). The presence of missing days may introduce bias into some calculations or summaries of the data.

1.Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with  NA s)

```{r}
sum(is.na(activity))
```

2.The strategy for filling in all of the missing values in the dataset will be to use the mean for that 5-minute interval.

```{r}
activity.imputed <- inner_join(activity, 
                               avg.steps.per.interval, 
                               by="interval") %>% 
                    mutate(steps=ifelse(is.na(steps),avg.steps,steps)) %>%
                    select(date,interval,steps)
head(activity.imputed)

```

3.Create a new dataset that is equal to the original dataset but with the missing data filled in.

```{r}
total.steps.per.day.imputed <- activity.imputed %>%
                               group_by(date) %>%
                               summarize(total.steps = sum(steps,na.rm=FALSE))

```

4.Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```{r, echo = FALSE}
hist(total.steps.per.day.imputed$total.steps, 
     main = "Distribution of Total Number of Steps per Day", 
     xlab = "Total Number of Steps per Day", 
     ylab = "Frequency (Number of Days)", 
     breaks=20,   col = "blue")

```

Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```{r}
mean(total.steps.per.day.imputed$total.steps)
median(total.steps.per.day.imputed$total.steps)

```


Answer: Yes there is a slight difference in changing the mean.
