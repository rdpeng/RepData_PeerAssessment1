# Reproducible Research: Peer Assessment 1

## Loading and preprocessing the data

The data for this assignment can be downloaded from the course web site:

* Dataset: [Activity monitoring data [52K]] (https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip)

Quick summary:


```r
activity <- read.csv("./activity.csv")
activity$date <- as.Date(activity$date)
summary(activity)
```

```
##      steps            date               interval   
##  Min.   :  0.0   Min.   :2012-10-01   Min.   :   0  
##  1st Qu.:  0.0   1st Qu.:2012-10-16   1st Qu.: 589  
##  Median :  0.0   Median :2012-10-31   Median :1178  
##  Mean   : 37.4   Mean   :2012-10-31   Mean   :1178  
##  3rd Qu.: 12.0   3rd Qu.:2012-11-15   3rd Qu.:1766  
##  Max.   :806.0   Max.   :2012-11-30   Max.   :2355  
##  NA's   :2304
```

Required R libraries:

* ggplot2
* knitr




## What is mean total number of steps taken per day?

To calculate the mean of the total number of steps taken per day it's 
neccesary to ignore the missing values (NA) on the column steps.

Graphic representation:


```r
qplot(date,  
      weight=activity$steps, 
      data = activity, 
      main="Number of steps taken per day", 
      xlab="Days", 
      ylab="Number of steps",
      binwidth = 1,
      color=I("black"),
      fill=I("blue"),
      border="black")
```

![plot of chunk Q1 - histogram total number of steps per day](./figures/Q1 - histogram total number of steps per day.png) 



```r
mean_steps<-mean(tapply(activity$steps, activity$date, sum, na.rm = TRUE))
median_steps<-median(tapply(activity$steps, activity$date, sum, na.rm = TRUE))
```
- Mean steps: 9354.2295
- Median steps: 10395


## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
