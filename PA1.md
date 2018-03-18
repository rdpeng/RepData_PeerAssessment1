---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: yes
editor_options: 
  chunk_output_type: inline
---


## Loading and preprocessing the data
1. Change the working directory to the folder and load the data file

```r
setwd("/Users/she/Documents/GitHub/RepData_PeerAssessment1")
activity <- read.csv("activity.csv")
```
2. Review data

```r
head(activity)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```

```r
str(activity)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

```r
summary(activity)
```

```
##      steps                date          interval     
##  Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
##  1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
##  Median :  0.00   2012-10-03:  288   Median :1177.5  
##  Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
##  3rd Qu.: 12.00   2012-10-05:  288   3rd Qu.:1766.2  
##  Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
##  NA's   :2304     (Other)   :15840
```
3. Process/transform the data (if necessary) into a format suitable 

```r
activity$date <- as.Date(as.character(activity$date))
```

```
## Warning in strptime(xx, f <- "%Y-%m-%d", tz = "GMT"): unknown timezone
## 'zone/tz/2018c.1.0/zoneinfo/America/New_York'
```

```r
activity_complete <- na.omit(activity)
head(activity_complete)
```

```
##     steps       date interval
## 289     0 2012-10-02        0
## 290     0 2012-10-02        5
## 291     0 2012-10-02       10
## 292     0 2012-10-02       15
## 293     0 2012-10-02       20
## 294     0 2012-10-02       25
```

## What is mean total number of steps taken per day?
1. Make a histogram of the total number of steps taken each day

```r
stepsByDay <- tapply(activity_complete$steps, activity_complete$date, sum, na.rm=TRUE)
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.2.5
```

```r
qplot(stepsByDay, xlab='Total steps per day', ylab='Frequency', main="Histogram of the Total Number of Steps Taken Each Day",binwidth=500)
```

![](PA1_files/figure-html/stepData-1.png)<!-- -->

2. Calculate and report the mean and median total number of steps taken per day
* Mean

```r
round(mean(stepsByDay),0)
```

```
## [1] 10766
```
* Median

```r
round(median(stepsByDay),0)
```

```
## [1] 10765
```

## What is the average daily activity pattern?
1. Import ggplot package

```r
library(ggplot2)
```
2. Create a data frame of steps aggregating into averages within each 5 minutes interval

```r
stepsByInterval <- aggregate(x=list(meanSteps=activity_complete$steps), by=list(interval=activity_complete$interval), FUN=mean)
```
3. Create a time series plot

```r
ggplot(data=stepsByInterval, aes(x=interval, y=meanSteps)) +
    geom_line() +
    xlab("5-minute interval") +
    ylab("average number of steps taken") +
    ggtitle("Average Number of Steps Taken of the 5-Minute Interval")
```

![](PA1_files/figure-html/timeSeriesPlot-1.png)<!-- -->

## Imputing missing values
Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

1. Calculate and report the total number of missing values in the dataset
(i.e. the total number of rows with NAs)

```r
nrow(activity) - nrow(activity_complete)
```

```
## [1] 2304
```
2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
* Use the mean for that 5 -minute interval to replace all the missing values in the dataset
3. Create a new dataset that is equal to the original dataset but with the missing data filled in
* Replace missing values with mean total steps for each interval across all of the days
* Merge the mean data with original data

```r
names(stepsByInterval)[2] <- "mean.steps"
activity_imputed <- merge(activity, stepsByInterval)
```
* If steps is NA, replace the value with mean totals of the day

```r
activity_imputed$steps[is.na(activity_imputed$steps)] <- activity_imputed$mean.steps[is.na(activity_imputed$steps)]
```
4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?
* Create the histogram

```r
stepsByDay_imputed <- tapply(activity_imputed$steps, activity_imputed$date, sum)
qplot(stepsByDay_imputed, xlab='Total steps per day (Imputed)', ylab='Frequency', main="Histogram of the Total Number of Steps Taken Each Day with Imputed Data", binwidth=500)
```

![](PA1_files/figure-html/stepsByDay-1.png)<!-- -->

* Calculate and report the mean and median total number of steps taken per day of the new dataseet

* Mean

```r
round(mean(stepsByDay_imputed),0)
```

```
## [1] 10766
```
* Median

```r
round(median(stepsByDay_imputed),0)
```

```
## [1] 10766
```

## Are there differences in activity patterns between weekdays and weekends?
For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

```r
activity_imputed$dateType <-  ifelse(as.POSIXlt(activity_imputed$date)$wday %in% c(0,6), 'weekend', 'weekday')
```

2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). The plot should look something like the following, which was creating using simulated data:

```r
stepsByInterval_imputed <- aggregate(steps ~ interval + dateType, data = activity_imputed, mean)
ggplot(stepsByInterval_imputed, aes(interval, steps)) +
    geom_line() +
    facet_grid(dateType ~ .) +
    xlab("5-minute interval") +
    ylab("average number of steps taken") +
    ggtitle("Average Number of Steps Taken of the 5-Minute Interval")
```

![](PA1_files/figure-html/timeSeriesPlot_imputed-1.png)<!-- -->
