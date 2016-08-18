# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
Unzip and read the csv file.  Convert date to correct format

```r
dat <- read.csv(unz("activity.zip","activity.csv"))
#sapply(dat$date,as.Date)
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

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```r
# Number of NA's in 'steps'
sum(is.na(dat$steps))
```

```
## [1] 2304
```

```r
# Confirm no other NA's in other columns:
summary(dat)
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
Method for imputing NA values:
- From looking through the data, most of the NA values are due to entire days worth of data missing.  For this reason, I will replace every NA value with a static number.  The number I am choosing is simply the average steps taken in a day divided by the number of 5 minute intervals in a day.  This equates to:

```r
#Mean # of steps in a day (calculated earlier) divided by (24 hours * 60 mins in an hour / 5 mins in an interval)
9354.23/(24*60/5)
```

```
## [1] 32.47997
```
This is a very unsophisticated method, since in reality there won't be steps at all intervals of the day (due to sleeping), but for the purposes of this exercise it will suffice.

3. The following code copies the original dataset and adds in the imputed values.

```r
dat[is.na(dat)] <- (9354.23/(24*60/5))
```

The next piece of code gives a histogram (similar to before) but now with the imputed values dataset.

```r
#1. calculate total number of steps per day
dat_summary <- ddply(dat,.(date),summarize,sum=sum(steps,na.rm=TRUE))
#2. histogram of steps per day
ggplot(data=dat_summary,aes(dat_summary$sum))+geom_histogram(bins=30)
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

Mean number of steps taken per day:

```r
mean(dat_summary$sum)
```

```
## [1] 10581.01
```

Median number of steps taken per day:

```r
median(dat_summary$sum)
```

```
## [1] 10395
```

The mean value of number of steps taken does differ compared to when we first calculated it (it is larger now), but the median value is the same.  The impact of imputing data, in the case of our unsophisticated method, was that the average number of daily steps increased by about 10%.  Imputing data should not cause such a drastic change in average number of daily steps, so we can conclude that our method was not very good.


## Are there differences in activity patterns between weekdays and weekends?
1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.


```r
dat$day_type <- weekdays(as.Date(dat$date))
my_func <- function(x) { if(x=="Saturday" | x=="Sunday") {"Weekend"} else {"Weekday"}}
dat$day_type <- sapply(dat$day_type,my_func)
```


2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).


```r
split <- split(dat,dat$day_type)
weekday <- split[[1]]
weekend <- split[[2]]
weekday <- ddply(weekday,.(interval),summarize,mean=mean(steps))
weekend <- ddply(weekend,.(interval),summarize,mean=mean(steps))
p1 <- ggplot(data=weekday,aes(interval,mean))+geom_line()+labs(title="Weekday")+ylim(0,250)
p2 <- ggplot(data=weekend,aes(interval,mean))+geom_line()+labs(title="Weekend")+ylim(0,250)

library(gridExtra)
grid.arrange(p1,p2,nrow=2)
```

![](PA1_template_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

It appears that the average activity level during the weekend is higher, but the weekday has a higher peak activity level.  Perhaps the user takes a short jog in the morning on weekdays, but does not on the weekend.  And then, user is at a desk most of day for the weekdays, but is out and about more during the weekends.







