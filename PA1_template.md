---
title: "Reproducible Research: Project 1"
author: "Sandeep Kola"
date: '2017-05-12'
---


```
## Warning: package 'knitr' was built under R version 3.3.3
```


```r
library(ggplot2)
library(scales)
library(Hmisc)
```
Load the required the data.

```r
if(!file.exists('activity.csv')){
        unzip("repdata%2Fdata%2Factivity.zip")
}
activityData <- read.csv('activity.csv')
```

## What is mean total number of steps taken per day?

1.Calculate the total number of steps taken per day

```r
totalStepsDay <- tapply(activityData$steps, activityData$date, sum, na.rm = TRUE)
```

2.Make a histogram of the total number of steps taken each day

```r
qplot(totalStepsDay, xlab = "Total steps per day", ylab = "Frequency", binwidth=500)
```

![](PA1_template_files/figure-html/simulationdata1-1.png)<!-- -->

3.Calculate and report the mean and median of the total number of steps taken per day

```r
mean(totalStepsDay)
```

```
## [1] 9354.23
```

```r
median(totalStepsDay)
```

```
## [1] 10395
```
## What is the average daily activity pattern?

1.Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
averageStepsPerTimeBlock <- aggregate(x=list(meanSteps=activityData$steps), by=list(interval=activityData$interval), FUN=mean, na.rm=TRUE)

ggplot(data=averageStepsPerTimeBlock, aes(x=interval, y=meanSteps)) +
        geom_line() +
        xlab("5-minute interval") +
        ylab("average number of steps taken") 
```

![](PA1_template_files/figure-html/simulationdata3-1.png)<!-- -->
2.Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
mostNumberOfSteps <- which.max(averageStepsPerTimeBlock$meanSteps)
timeofMostNumberOfSteps <- timeMostSteps <-  gsub("([0-9]{1,2})([0-9]{2})", "\\1:\\2", averageStepsPerTimeBlock[mostNumberOfSteps,'interval'])
timeofMostNumberOfSteps
```

```
## [1] "8:35"
```
## Imputing missing values

1.Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```r
numberOfMissingValues <- length(which(is.na(activityData$steps)))
```
2.Devise a strategy for filling in all of the missing values in the dataset. 
3.Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
library(impute)
imputedActivityData <- activityData
imputedActivityData$steps <- impute(activityData$steps, fun = mean)
```
4.Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.

```r
imputedDataStepsByDay <- tapply(imputedActivityData$steps, imputedActivityData$date, sum)
qplot(imputedDataStepsByDay, xlab='Total steps per day (Imputed)', ylab='Frequency using binwith 500', binwidth=500)
```

![](PA1_template_files/figure-html/simulationdata7-1.png)<!-- -->

```r
mean(imputedDataStepsByDay)
```

```
## [1] 10766.19
```

```r
median(imputedDataStepsByDay)
```

```
## [1] 10766.19
```
## Are there differences in activity patterns between weekdays and weekends?
1.Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
imputedActivityData$dateType <- ifelse(as.POSIXlt(imputedActivityData$date)$wday %in%
c(0,6), 'weekend', 'weekday')
```
2.Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).

```r
averagedImputedActivityData <- aggregate(steps ~ interval + dateType, data=imputedActivityData, mean)
ggplot(averagedImputedActivityData, aes(interval, steps)) + 
        geom_line() + 
        facet_grid(dateType ~ .) +
        xlab("5-minute interval") + 
        ylab("avarage number of steps")
```

![](PA1_template_files/figure-html/simulationdata9-1.png)<!-- -->
