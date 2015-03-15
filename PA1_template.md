---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
 
---

It is now possible to collect a large amount of data about personal movement using activity monitoring devices such as a Fitbit, Nike Fuelband, or Jawbone Up. These type of devices are part of the "quantified self" movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. But these data remain under-utilized both because the raw data are hard to obtain and there is a lack of statistical methods and software for processing and interpreting the data.

This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

## Loading and preprocessing the data


```r
activity <- read.csv("activity.csv")
```

## What is mean total number of steps taken per day?


```r
# I sum up all steps taken per day
Stepsperday <- aggregate(activity$steps, list(date = activity$date), sum, na.rm=T)

names(Stepsperday) <- c("date", "steps")

# I prepare a histogram of the total steps taken each day 

hist(Stepsperday$steps, col="blue",breaks = c(0,2000,4000,6000, 8000,10000,12000,14000,16000,18000,20000,22000,24000,26000),xlab="Numer of steps per day", 
main="Histogram of the total steps taken each day")

#Calculation of the mean and median values
##Mean value for total steps taken each day with NA values
Daystepsmean <- mean(Stepsperday$steps)

Daystepsmean
```

```
## [1] 9354.23
```

```r
##Median value for total steps taken each day with NA values
Daystepsmedian <- median(Stepsperday$steps)

Daystepsmedian
```

```
## [1] 10395
```

```r
#Add mean and median values to histogram
abline(v=Daystepsmean,col="red")
abline(v=Daystepsmedian,col="yellow")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png) 


## What is the average daily activity pattern?



```r
#Calculate average count of steps for each interval
Interstepmean <- aggregate(activity$steps, list(Interval = activity$interval), mean, na.rm=T)
names(Interstepmean) <- c("interval","stpavg")

#Realise plot for relation between Interval and average number of steps 
plot(Interstepmean$interval, Interstepmean$stpavg, type = "l",
xlab = "Intervals", ylab = "Avg number of steps", 
main = "Average steps per 5-min interval", col = "red")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

```r
#Calculating max interval
max_interval <- Interstepmean[which.max(Interstepmean$stpavg),]

max_interval$interval
```

```
## [1] 835
```

**The interval for the maximum number of steps is 835**


## Imputing missing values


```r
#The purpose is to substitute each NAs values with mean value for each interval

#Merge tables with original data of activity and data with mean values
MergedActivity <- merge(activity,Interstepmean,by="interval")

names(MergedActivity) <- c("interval","steps", "date", "meansteps" )

#Substitute NA value by mean value for each register
for (i in 1:nrow(MergedActivity)) {
    if (is.na(MergedActivity$steps[i])==TRUE) {
        MergedActivity$steps[i] <- MergedActivity$meansteps[i]
    }
}
#Preparing new histogram  of the total steps taken each day to compare with the first one
Stepsperday2 <- aggregate(as.numeric(MergedActivity$steps), list(date = MergedActivity$date), sum)
names(Stepsperday2) <- c("date", "steps")

hist(Stepsperday2$steps, col="green",breaks = c(0,2000,4000,6000, 8000,10000,12000,14000,16000,18000,20000,22000,24000,26000),xlab="Numer of steps per day", 
     main="Histogram of the total steps taken each day")

#Calculation of the mean and median values

##Mean value for total steps taken each day withot NA values
Daystepsmean2 <- mean(Stepsperday2$steps)

Daystepsmean2
```

```
## [1] 10766.19
```

```r
## [1] 9510.033

##Median value for total steps taken each day withot NA values
Daystepsmedian2 <- median(Stepsperday2$steps)

Daystepsmedian2
```

```
## [1] 10766.19
```

```r
#Add mean and median values to histogram
abline(v=Daystepsmean2,col="blue")
abline(v=Daystepsmedian2,col="black")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

**The mean value for total number of steps taken daily without NA's is clearly situated more to the right of the plot. Meanwhile medians remain the same value**

## Are there differences in activity patterns between weekdays and weekends?



```r
library(lubridate)
# Format date and divide data between weekdays and weekend
activity$date <- as.Date(activity$date)
activity$wday <- as.character(wday(activity$date))
activweekend <- subset(activity, activity$wday == "1" | activity$wday == "7")
activweekday <- subset(activity, activity$wday != "1" | activity$wday != "7")

# Calculate average number of steps per 5-min interval for weekdays and weekend

Stepmeanweekday <- aggregate(activweekday$steps, list(interval = activweekday$interval), mean, na.rm = T)

Stepmeanweekend <- aggregate(activweekend$steps, list(interval = activweekend$interval), mean, na.rm = T)

names(Stepmeanweekday) <- c("interval", "steps")
names(Stepmeanweekend) <- c("interval", "steps")
# Prepare a two plots to compare intervals vs steps for weekend and weekdays

par(mfrow = c(2, 1))
plot(Stepmeanweekday$interval, Stepmeanweekday$steps, type = "l", 
    col = "orange", ylab = "Average steps", xlab = "5 min intervals", main = "Average steps 5-minute interval during weekdays")

plot(Stepmeanweekend$interval, Stepmeanweekend$steps, type = "l", 
    col = "darkgreen", ylab = "Average steps", xlab = "5 min intervals", main = "Average steps 5-minute interval during weekend")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 

**Comparing the average number of steps in 5-min intervals during a labour days and weekend, I notice than much more sport activity during a weekend.** 

