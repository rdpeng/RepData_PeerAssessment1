# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data

```
## 
## Attaching package: 'dplyr'
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

## What is mean total number of steps taken per day?

### Here is the histogram for mean total number of steps taken per day:

```r
days <- group_by(rawdata, date)
daystep <- summarize(days,  steps=sum(steps, na.rm=TRUE))
q <- ggplot(daystep, aes(steps)) + geom_histogram(bins=10)
q   
```

![](PA1_template_files/figure-html/unnamed-chunk-1-1.png)

```r
avestep <- mean(daystep$steps)
medianstep <- median(daystep$steps)
summary(daystep$steps)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##       0    6778   10400    9354   12810   21190
```

The average total number of steps taken per day is 9354.2295082 and the median is 10395. 

## What is the average daily activity pattern?

This time series plot shows the average daily activity pattern:

```r
intervals <- group_by(rawdata, interval)
timeser <- summarize(intervals,  steps=mean(steps, na.rm=TRUE))
q <- ggplot(timeser, aes(interval, steps)) + geom_line()
q
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)

```r
maxstep <- max(timeser$steps)
maxinterval <- timeser[match(maxstep,timeser$steps),1]
maxinterval
```

```
## Source: local data frame [1 x 1]
## 
##   interval
##      (int)
## 1      835
```
The 835 5-min interval contains maxmim number of steps.

## Imputing missing values

### Here is the histogram showing daily activity distribution after missing values are filled in:

```r
numofmissing <- sum(is.na(rawdata))
# this function replace NA in a data frame with mean value in that interval and return a data frame with 
# the missing data filled in
replace <- function(df){
  inter <- group_by(rawdata, interval)
  timeser1 <- summarize(intervals,  steps=mean(steps, na.rm=TRUE))
  df$steps[is.na(df$steps)] <- timeser1$steps[match(df$interval, timeser1$interval)][is.na(df$steps)]
  df
}
  
rawdata1 <- replace(rawdata)  # replace missing value
# draw histogarm for daily steps distribution  
days1 <- group_by(rawdata1, date)
daystep1 <- summarize(days1,  steps=sum(steps))
q <- ggplot(daystep1, aes(steps)) + geom_histogram(bins=10)
q
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)

```r
avestep1 <- mean(daystep1$steps)
medianstep1 <- median(daystep1$steps)
summary(daystep1$steps)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##      41    9819   10770   10770   12810   21190
```
We can see the original data have 2304 missing value. After they are filled in, both numbers of mean and median are increased, however, imputing missing value has biger effect on the calculationg of mean value.   

## Are there differences in activity patterns between weekdays and weekends?

```r
rawdata1$date <- as.Date(rawdata1$date)
weekday <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
rawdata2 <- mutate(rawdata1,wday=factor((weekdays(rawdata1$date) %in% weekday),levels=c(FALSE, TRUE), labels=c('weekend', 'weekday'))) 

intervals1 <- group_by(rawdata2, wday,interval)
timeser2 <- summarize(intervals1,  steps=mean(steps))
g <- ggplot(timeser2, aes(interval, steps)) + geom_line() + facet_grid(wday~ .)
g
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)

From the plot, we can see the person in weekends is more active than weekdays.
