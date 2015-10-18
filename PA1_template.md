---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---
## Loading the data using read.csv() function and change class of date variable to Date.

```r
activ <- read.csv('./activity.csv')
activ$date <- as.Date(activ$date)
```
## Creating a data frema stepsPerDay with sums of steps done per each day.

```r
activNotNA <- subset(activ, activ$steps!='NA')
Date <- as.Date(unique(activNotNA$date))
stepsPerDay <- data.frame(Date)
stepsPerDay$sumStep <- tapply(activNotNA$steps, activNotNA$date, sum, na.rm =TRUE)
```
## The following code will create the histogram, the mean and the meadian of steps per day.

```r
hist(stepsPerDay$sumStep)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

```r
mean(stepsPerDay$sumStep)
```

```
## [1] 10766.19
```

```r
median(stepsPerDay$sumStep)
```

```
## [1] 10765
```
## Creating a data frame stepsPerInterval with sums of steps done per each 5-minute interval.

```r
Interval <- unique(activ$interval)
stepsPerInterval <- data.frame(Interval)
stepsPerInterval$sumStep <- tapply(activ$steps, activ$interval, sum, na.rm =TRUE)
plot(stepsPerInterval$Interval, stepsPerInterval$sumStep, type = 'l')
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

```r
stepsPerInterval$Interval[which(stepsPerInterval$sumStep==max(stepsPerInterval$sumStep))]
```

```
## [1] 835
```
## Number of missing values:

```r
sum(is.na(activ))
```

```
## [1] 2304
```
## Calculating mean of steps per each interval and use this values to fill missing values.

```r
stepsPerInterval$intervalMean <- stepsPerInterval$sumStep/length(Interval)
activFull <- merge(activ, stepsPerInterval, by.x = 'interval', by.y = 'Interval')
activFull$steps[is.na(activFull$steps)] <- activFull$intervalMean[is.na(activFull$steps)]
activFull$sumStep <- NULL
activFull$intervalMean <- NULL
```
## Creating histogram for the new data set and then calculating the mean and the median.

```r
Date <- as.Date(unique(activ$date))
stepsPerDayFull <- data.frame(Date)
stepsPerDayFull$sumStep <- tapply(activFull$steps, activFull$date, sum)

hist(stepsPerDayFull$sumStep)
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png) 

```r
mean(stepsPerDayFull$sumStep)
```

```
## [1] 9614.069
```

```r
median(stepsPerDayFull$sumStep)
```

```
## [1] 10395
```
## As you can see, these values are not the same as in the previous calculation.
## Are there differences in activity patterns between weekdays and weekends?

```r
activFull$weekday <- c('weekday')
activFull$weekday[as.POSIXlt(activFull$date)$wday>=6 ] <- 'weekend'
activFull2=aggregate(steps~interval+weekday,activFull, mean)
library(lattice)
xyplot(steps~interval|factor(weekday),data=activFull2,aspect=1/2,type="l")
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png) 
