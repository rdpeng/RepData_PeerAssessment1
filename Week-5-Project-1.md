---
title: "Week 5 Project 1"
output: 
   html_document:
           keep_md: true
---



## Loading and preprocessing the data

```r
library(readstata13)
activity = read.csv("/Users/mcheng/Week 5/activity.csv")
activity$date <- as.Date(activity$date, "%Y-%m-%d", tz = "Europe/Zurich")
class(activity$date)
```

```
## [1] "Date"
```

## What is mean total number of steps taken per day?

```r
library(dplyr)
```

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

```r
total <- activity %>% group_by(date) %>% summarise(total = sum(steps, na.rm = T))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
total
```

```
## # A tibble: 61 x 2
##    date       total
##    <date>     <int>
##  1 2012-10-01     0
##  2 2012-10-02   126
##  3 2012-10-03 11352
##  4 2012-10-04 12116
##  5 2012-10-05 13294
##  6 2012-10-06 15420
##  7 2012-10-07 11015
##  8 2012-10-08     0
##  9 2012-10-09 12811
## 10 2012-10-10  9900
## # … with 51 more rows
```

```r
hist(total$total, main = "Total number of steps taken per day", xlab = "Total steps taken per day", ylim = c(0, 30))
```

![](Week-5-Project-1_files/figure-html/total-1.png)<!-- -->

```r
mean(total$total, na.rm = T)
```

```
## [1] 9354.23
```

```r
median(total$total, na.rm = T)
```

```
## [1] 10395
```

## What is the average daily activity pattern?

```r
average <- activity %>% group_by(interval) %>% summarise(average = mean(steps, na.rm = T))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
average
```

```
## # A tibble: 288 x 2
##    interval average
##       <int>   <dbl>
##  1        0  1.72  
##  2        5  0.340 
##  3       10  0.132 
##  4       15  0.151 
##  5       20  0.0755
##  6       25  2.09  
##  7       30  0.528 
##  8       35  0.868 
##  9       40  0     
## 10       45  1.47  
## # … with 278 more rows
```

```r
plot(average$interval, average$average, type = "l", lwd = 2, xlab="Interval", ylab="Average number of steps", main="Average number of steps per interval")
```

![](Week-5-Project-1_files/figure-html/average-1.png)<!-- -->

```r
average[which.max(average$average), ]$interval
```

```
## [1] 835
```

## Imputing missing values

```r
sum(is.na(activity$steps))
```

```
## [1] 2304
```

```r
missing_index <- is.na(activity$steps)
m <- mean(average$average)
activity_imputed <- activity
activity_imputed[missing_index,1]<-m
activity_imputed_1 <- activity_imputed %>% group_by(date) %>% summarise(sum = sum(steps))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
hist(activity_imputed_1$sum, xlab = "Total steps per day", ylim = c(0,30), main = "Total number of steps taken each day")
```

![](Week-5-Project-1_files/figure-html/missing value-1.png)<!-- -->

```r
mean(activity_imputed_1$sum)
```

```
## [1] 10766.19
```

```r
median(activity_imputed_1$sum)
```

```
## [1] 10766.19
```

## Are there differences in activity patterns between weekdays and weekends?

```r
activity_imputed$weekday <- weekdays(activity_imputed$date)
activity_imputed <- activity_imputed %>% mutate(day = ifelse(weekday=="Saturday" | weekday=="Sunday", "Weekend", "Weekday"))
```

```r
as.factor(activity_imputed$day)
```

```r
average2 <- activity_imputed %>% group_by(day, interval) %>% summarise(mean = mean(steps))
```

```
## `summarise()` regrouping output by 'day' (override with `.groups` argument)
```

```r
average2
```

```
## # A tibble: 576 x 3
## # Groups:   day [2]
##    day     interval  mean
##    <chr>      <int> <dbl>
##  1 Weekday        0  7.01
##  2 Weekday        5  5.38
##  3 Weekday       10  5.14
##  4 Weekday       15  5.16
##  5 Weekday       20  5.07
##  6 Weekday       25  6.30
##  7 Weekday       30  5.61
##  8 Weekday       35  6.01
##  9 Weekday       40  4.98
## 10 Weekday       45  6.58
## # … with 566 more rows
```

```r
library(lattice)
with(average2, xyplot(mean ~ interval | day, 
                     type = "l",      
                     main = "Number of Steps within Intervals by day",
                     xlab = "Daily Intervals",
                     ylab = "Number of Steps"))
```

![](Week-5-Project-1_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

