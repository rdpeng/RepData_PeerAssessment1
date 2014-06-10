# Reproducible Research: Peer Assessment 1

## Loading and preprocessing the data

Required R libraries:

* ggplot2
* knitr



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

To answer the question we can try to make a time series plot.

In the axis x it will be represented the intervals, seeing the column data of interval we can see that it's represented in intervals of 5 minutes

In the axis y it will be represented the average number of steps taken for each interval.

Graphic representation:


```r
average_steps<-data.frame(cbind(activity$interval,
                                tapply(activity$steps,
                                       activity$interval, 
                                       mean, 
                                       na.rm = TRUE)))


colnames(average_steps) <- c("interval", "steps")

ggplot(data=average_steps,
       aes(x=interval,
           y=steps)) + 
  geom_line(color='blue',
            size=0.5) + 
  ggtitle("Daily activity pattern") +
  xlab("Intervals of 5 minutes") +
  ylab("Number of steps") 
```

![plot of chunk Q2 - time series plot with average daily activity pattern](./figures/Q2 - time series plot with average daily activity pattern.png) 

Calculate the maximum and minimun frequency in an interval:


```r
max_steps_interval <- average_steps[which.max(average_steps$steps),
                                    "interval"]
min_steps_interval <- average_steps[which.min(average_steps$steps),
                                    "interval"]

paste("Max steps interval:",
      max_steps_interval,
      "- Time:",
      intervalToHour(max_steps_interval))
```

```
## [1] "Max steps interval: 835 - Time: 08:35:00 "
```

```r
paste("Min steps interval:",
      min_steps_interval,
      "- Time:",
      intervalToHour(min_steps_interval))
```

```
## [1] "Min steps interval: 40 - Time: 12:40:00 "
```

## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
