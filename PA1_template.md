---
title: "Reproducible Research: Peer Assessment 1"
author: "SiranC"
date: "3/20/2020"
output: 
        html_document:
                keep_md: true
---



## Introduction

It is now possible to collect a large amount of data about personal movement using activity monitoring devices such as a Fitbit, Nike Fuelband, or Jawbone Up. These type of devices are part of the “quantified self” movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. But these data remain under-utilized both because the raw data are hard to obtain and there is a lack of statistical methods and software for processing and interpreting the data.

This project makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

The data for this project can be downloaded from this repository.

## Loading and preprocessing the data

#### 1.Set the working directory.


```r
setwd(dir = '/Users/shaoz/Desktop/JHU_DataScience/Course 5 Week2')
#setwd(dir = '/Users/...')
```

#### 2.Download the activity file.


```r
library(data.table)
fileUrl = 'https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip'
if (!file.exists('./repdata_data_activity.zip')) {
        download.file(fileUrl, destfile = './repdata_data_activity.zip')
        unzip("repdata_data_activity.zip")
}
```

#### 3.Load and preprocess the data.


```r
data <- read.csv('./activity.csv', stringsAsFactors = FALSE)
data$date <- as.Date(data$date, '%Y-%m-%d')
```

## What is mean total number of steps taken per day?

#### 1.Calculate the total number of steps taken per day.


```r
totalSteps_day <- aggregate(steps ~ date, data, sum)
```

```
##         date steps
## 1 2012-10-02   126
## 2 2012-10-03 11352
## 3 2012-10-04 12116
## 4 2012-10-05 13294
## 5 2012-10-06 15420
## 6 2012-10-07 11015
```

#### 2.Make a histogram of the total number of steps taken each day using base plotting system.


```r
hist(totalSteps_day$steps,
     breaks = 20,
     main = 'Total Number of Steps Taken Each Day',
     col = 'yellow',
     xlab = 'Number of Steps'
)
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

#### 3.Calculate and report the mean and median of the total number of steps taken per day.


```r
totSteps_day_Mean <-  mean(totalSteps_day$steps)
totSteps_day_Mean
```

```
## [1] 10766.19
```

```r
totSteps_day_Median <- median(totalSteps_day$steps)
totSteps_day_Median
```

```
## [1] 10765
```

## What is the average daily activity pattern?

#### 1.Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis) using base plotting system.


```r
aveStep_interval <- aggregate(steps ~ interval, data, mean)
plot(aveStep_interval$interval,aveStep_interval$steps, 
     type = 'l',
     col = 'blue',
     main = 'Average Number of Steps Taken Each Day in Each 5-min interval',
     ylab = 'Number of Steps',
     xlab = 'Interval')
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

#### 2.Find the 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps.


```r
steps_interval_Max <-
        aveStep_interval[which.max(aveStep_interval$steps), 1]
steps_interval_Max
```

```
## [1] 835
```

So, the **835** interval contains the maximum number of steps.

## Imputing missing values

#### 1.Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs).

Here is the raw data looks like:


```
##    steps       date interval
## 1     NA 2012-10-01        0
## 2     NA 2012-10-01        5
## 3     NA 2012-10-01       10
## 4     NA 2012-10-01       15
## 5     NA 2012-10-01       20
## 6     NA 2012-10-01       25
## 7     NA 2012-10-01       30
## 8     NA 2012-10-01       35
## 9     NA 2012-10-01       40
## 10    NA 2012-10-01       45
```


```r
sum(is.na(data$steps))
```

```
## [1] 2304
```
There are **2304** missing values in the `steps` column.

#### 2.Devise a strategy for filling in all of the missing values in the dataset. Create a new dataset that is equal to the original dataset but with the missing data filled in.

I'll use the value of average steps taken in 5-min interval, which calculated previously, to replace the NA values.


```r
## Reread the raw data and use average steps in 5-min interval value 
## to replace the NA values in 'steps' column 
newData <- read.csv('./activity.csv', stringsAsFactors = FALSE)
newData$steps[is.na(newData$steps)] <-
        aveStep_interval$steps[which(is.na(newData$steps))]
```

New data looks like:


```
##        steps       date interval
## 1  1.7169811 2012-10-01        0
## 2  0.3396226 2012-10-01        5
## 3  0.1320755 2012-10-01       10
## 4  0.1509434 2012-10-01       15
## 5  0.0754717 2012-10-01       20
## 6  2.0943396 2012-10-01       25
## 7  0.5283019 2012-10-01       30
## 8  0.8679245 2012-10-01       35
## 9  0.0000000 2012-10-01       40
## 10 1.4716981 2012-10-01       45
```

#### 3.Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
totalSteps_day_2 <- aggregate(steps ~ date, newData, sum)
hist(totalSteps_day_2$steps, 
     breaks = 20,
     main = 'Total Number of Steps Taken Each Day w/o Missing Value',
     col = 'green',
     xlab = 'Number of Steps')
```

![](PA1_template_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

Here are the mean and median total number of steps taken per day values calculated from imputed data:


```r
totSteps_day_Mean_2 <-  mean(totalSteps_day_2$steps)
totSteps_day_Mean_2
```

```
## [1] 10766.19
```

```r
totSteps_day_Median_2 <- median(totalSteps_day_2$steps)
totSteps_day_Median_2
```

```
## [1] 10765.59
```

Compare the difference between those values,

dataset | Mean | Median
------- | ------- | -------
raw | 10766.19 | 10765
imputed | 10766.19 | 10765.59 

we can see that there is almost no impact on the estimates of the total daily number of steps if we use the average number of steps taken in 5-min interval.

## Are there differences in activity patterns between weekdays and weekends?

#### 1.Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.


```r
newData$date <- as.Date(newData$date, '%Y-%m-%d')
## add two columns,'days' and 'whatDays', in the newData to represent 
## the day of week and whether is a weekday or weekend day 
weekend <- c('Saturday', 'Sunday')
newData <- dplyr::mutate(newData, days = weekdays(newData$date))
whatDays <- unlist(lapply(newData$days, function(x) {
        if (x %in% weekend) {'Weekend'}
        else {'Weekday'}
}))
newData <- dplyr::mutate(newData, whatDays = whatDays)
```

Data contains new variables looks like:


```
##        steps       date interval   days whatDays
## 1  1.7169811 2012-10-01        0 Monday  Weekday
## 2  0.3396226 2012-10-01        5 Monday  Weekday
## 3  0.1320755 2012-10-01       10 Monday  Weekday
## 4  0.1509434 2012-10-01       15 Monday  Weekday
## 5  0.0754717 2012-10-01       20 Monday  Weekday
## 6  2.0943396 2012-10-01       25 Monday  Weekday
## 7  0.5283019 2012-10-01       30 Monday  Weekday
## 8  0.8679245 2012-10-01       35 Monday  Weekday
## 9  0.0000000 2012-10-01       40 Monday  Weekday
## 10 1.4716981 2012-10-01       45 Monday  Weekday
```

#### 2.Make a panel plot containing a time series plot (i.e. type="l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).


```r
## First, separate the weekdays and weekends data to calculate the average steps taken in 5-min interval
weekdayData <- dplyr::filter(newData,whatDays == 'Weekday')
aveStep_interval_weekday <-
        aggregate(steps ~ interval, weekdayData, mean)
aveStep_interval_weekday <- dplyr::mutate(aveStep_interval_weekday,
        whatDays = rep('Weekday',length(aveStep_interval_weekday$interval)))

weekendData <- dplyr::filter(newData,whatDays == 'Weekend')
aveStep_interval_weekend <-
        aggregate(steps ~ interval, weekendData, mean)
aveStep_interval_weekend <- dplyr::mutate(aveStep_interval_weekend, 
        whatDays = rep('Weekend', length(aveStep_interval_weekend$interval)))

## Then, merge them to one dataset and use ggplot2 plotting system to demonstrate the pattern difference
newData_whatDays <- dplyr::bind_rows(aveStep_interval_weekday,aveStep_interval_weekend)

library(ggplot2)
ggplot(newData_whatDays,aes(interval,steps,color = whatDays)) +
        geom_line() +
        facet_wrap(~whatDays , ncol = 1, nrow=2) +
        xlab('Interval') + 
        ylab('Number of steps')
```

![](PA1_template_files/figure-html/unnamed-chunk-18-1.png)<!-- -->

We can see that there are differences in activity patterns between weekdays and weekends. For weekdays, more steps observed between 500 to 1000 intervals than others.
