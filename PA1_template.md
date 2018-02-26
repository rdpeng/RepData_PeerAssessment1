---
title: "Reproducible Research: Peer Assessment 1"
author: "Melissa Villalta"
output: 
  html_document:
    keep_md: true
---

```r
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.4.3
```

```r
library(plyr)
library(dplyr)
```

```
## Warning: package 'dplyr' was built under R version 3.4.2
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:plyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(reshape2)
library(lattice)
```


## Loading and preprocessing the data

    1. Load the data


```r
activities <- read.csv("activity.csv")
str(activities)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

    2. Process/transform the data (if necessary) into a format suitable for your analysis

```r
activities <- read.csv("activity.csv",colClasses=c("numeric","Date","numeric"))
str(activities)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Date, format: "2012-10-01" "2012-10-01" ...
##  $ interval: num  0 5 10 15 20 25 30 35 40 45 ...
```


## What is mean total number of steps taken per day?

    1. Make a histogram of the total number of steps taken each day


```r
sum_by_day <- tapply(activities$steps,activities$date,sum,na.rm=TRUE)

hist(sum_by_day,col = "red",xlab="Total Steps per Date",main="Histogram of Total Number of Steps Taken Each Day (NA removed)")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

    2. Calculate and report the mean and median total number of steps taken per day
    
    a. Mean of total number of steps taken per day

```r
mean(sum_by_day)
```

```
## [1] 9354.23
```
    b. Median of total number of steps taken per day
    

```r
median(sum_by_day)
```

```
## [1] 10395
```

## What is the average daily activity pattern?

    a. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis)and the average number of steps taken, averaged across all days (y-axis)


```r
mean_by_int <- tapply(activities$steps,activities$interval,mean,na.rm=TRUE)

plot(row.names(mean_by_int),mean_by_int,type="l",xlab="Intervals (in min)", ylab="Average of Total Steps",main="Time Series Plot of the Average of Total Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

    b. Which 5-minute interval, on average across all the days in the dataset,contains the maximum number of steps?


```r
max_Num <- max(mean_by_int)
match(max_Num,mean_by_int)
```

```
## [1] 104
```
Index is 104, now looking for the interval


```r
mean_by_int[104]
```

```
##      835 
## 206.1698
```


## Imputing missing values

    a. Calculate and report the total number of missing values in the dataset(i.e. the total number of rows with NAs)

```r
sum(is.na(activities))
```

```
## [1] 2304
```
    b. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
    
    

```r
activities_na <- activities[is.na(activities),]
activities_no_na <- activities[complete.cases(activities),]
activities_na$steps <- as.numeric(mean_by_int)
```

    c. Create a new dataset that is equal to the original dataset but with the missing data filled in.
    

```r
new_activities <- rbind(activities_na,activities_no_na)
new_activities <- new_activities[order(new_activities[,2],new_activities[,3]),]
```

    d. Make a histogram of the total number of steps taken each day.


```r
new_sum_by_date <- tapply(new_activities$steps,new_activities$date,sum)

hist(new_sum_by_date,col="dark blue",xlab="Total Steps by Date",main="Adjusted Histogram of Total Steps by Date (no missing values)")
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)<!-- -->
   
    Calculate and report the mean and median total number of steps taken per day. Do these values    differ from the estimates from the first part of the assignment?
    What is the impact of imputing missing data on the estimates of the total daily number of steps?
    


```r
mean(new_sum_by_date)
```

```
## [1] 10766.19
```


```r
median(new_sum_by_date)
```

```
## [1] 10766.19
```

## Are there differences in activity patterns between weekdays and weekends?

    a. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.


```r
days <- weekdays(new_activities[,2])

new_activities <- cbind(new_activities,days)
new_activities$days <- revalue(new_activities$days,c("Monday"="weekday","Tuesday"="weekday","Wednesday"="weekday","Thursday"="weekday","Friday"="weekday"))
new_activities$days <- revalue(new_activities$days,c("Saturday"="weekend","Sunday"="weekend"))
```
    b. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).
    

```r
new_mean_by_int <- tapply(new_activities$steps,list(new_activities$interval,new_activities$days),mean)

new_mean_by_int <- melt(new_mean_by_int)
colnames(new_mean_by_int) <- c("interval","day","steps")

xyplot(new_mean_by_int$steps ~ new_mean_by_int$interval | new_mean_by_int$day, layout=c(1,2),type="l",main="Time Series Plot of the Average of Total Steps (weekday vs. weekend)",xlab="Time intervals (in minutes)",ylab="Average of Total Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-17-1.png)<!-- -->
