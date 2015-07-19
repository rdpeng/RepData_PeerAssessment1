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
The total number of missing values was `r nas`.

```{r echo=TRUE}

nsteps <- data.frame(date=activity$date[is.na(activity$steps)], interval = activity$interval[is.na(activity$steps)], steps=steps_interval[match(steps_interval$interval, activity$interval[is.na(activity$steps)]),3])

activity <- subset(activity, !is.na(steps))
activity <- rbind(activity, nsteps)
dailysteps2 <- aggregate(activity$steps, by = list(activity$date), sum, na.rm=TRUE)
names(dailysteps2) <- c("Date", "steps")

barplot(dailysteps2$steps, names.arg=dailysteps2$Date, xlab="Date",las=2, ylab="Steps", main="Number of Steps per Day", col="light blue")

new_mean <- mean(dailysteps2$steps)  
new_median <- median(dailysteps2$steps)
```

The mean steps `r new_mean` and median steps `r new_median` were very close when na's were replaced with average median at corresponding intervals.

## Are there differences in activity patterns between weekdays and weekends?
## Are there differences in activity patterns between weekdays and weekends?
Create weekdays/weekends identifiers

```{r weeklypattern, echo=TRUE}
activity$week <- as.factor(ifelse(weekdays(activity$date) %in% c("Saturday","Sunday"), "Weekend", "Weekday"))

meansteps2 <- aggregate(activity$steps, by = list(activity$week, activity$interval), mean, na.rm=TRUE)
mediansteps2 <- aggregate(activity$steps, by = list(activity$week, activity$interval), median, na.rm=TRUE)

intsteps2 <- cbind(meansteps2[], mediansteps2$x)
names(intsteps2) = c("weekday", "interval","mean.steps", "median.steps")

library(ggplot2)

ggplot(intsteps2, aes(x = interval, y = mean.steps)) + ylab("Number of Steps") + geom_line() + facet_grid(weekday~.)
```
The patterns show that weekend activities delayed for certain amount of time compared to the weekday pattern.
