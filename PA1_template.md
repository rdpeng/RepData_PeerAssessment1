# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data


```r
activity <- read.csv("activity.csv")
```

## What is mean total number of steps taken per day?
I use the dplyr package to handle the data and do the calculations.


```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
activity$date <- as.Date(activity$date)
options(digits=1)
daily_steps <- group_by(activity, date) %>% summarise_each(funs(sum(., na.rm = TRUE)))
barplot(daily_steps$steps, names.arg=daily_steps$date, xlab="Date",las=2, ylab="Steps", main="Number of Steps per Day", col="light blue")
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

```r
mean <- mean(daily_steps$steps)
median <- median(daily_steps$steps)
```

The mean daily steps was 9354.2, and the median daily steps was 10395.

## What is the average daily activity pattern?
To plot a time series plot average daily steps vs 5 min intervals.


```r
steps_interval <- aggregate(steps~interval, data=activity, FUN= "mean") 
names(steps_interval) <- c("interval", "steps")
plot(steps_interval, type = "l")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 

```r
max <- steps_interval$interval[which.max(steps_interval$steps)]
max_steps <- steps_interval$steps[which.max(steps_interval$steps)]
```

The 835's 5-min interval had the max number of average 206.2 steps.

## Imputing missing values
1. Calculate the total nubmer of missing values in the data set.


```r
nas <- sum(is.na(activity))
```
The total number of missing values was 2304.

2. fill in the missing values in the data set.



## Are there differences in activity patterns between weekdays and weekends?
