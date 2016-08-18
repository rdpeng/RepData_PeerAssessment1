# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
Unzip and read the csv file.  No preprocessing needed

```r
dat <- read.csv(unz("activity.zip","activity.csv"))
```

## What is mean total number of steps taken per day?

```r
library(plyr)
library(ggplot2)
#1. calculate total number of steps per day
dat_summary <- ddply(dat,.(date),summarize,sum=sum(steps,na.rm=TRUE))
#2. histogram of steps per day
ggplot(data=dat_summary,aes(dat_summary$sum))+geom_histogram(bins=30)
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

3a. The following code gives the mean number of steps taken per day:

```r
mean(dat_summary$sum)
```

```
## [1] 9354.23
```

3b. The following code gives the median number of steps taken per day:

```r
median(dat_summary$sum)
```

```
## [1] 10395
```


## What is the average daily activity pattern?
1. Here is a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis).

```r
dat_summary2 <- ddply(dat,.(interval),summarize,mean=mean(steps,na.rm=TRUE))
ggplot(data=dat_summary2,aes(interval,mean))+geom_line()
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
dat_summary2$interval[which.max(dat_summary2$mean)]
```

```
## [1] 835
```


## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
