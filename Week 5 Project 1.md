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
hist(total$total, main = "Total number of steps taken per day", xlab = "Total steps taken per day", ylim = c(0, 30))
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png)

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
plot(average$interval, average$average, type = "l", lwd = 2, xlab="Interval", ylab="Average number of steps", main="Average number of steps per interval")
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png)

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

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png)

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
library(lattice)
with(average2, xyplot(mean ~ interval | day, 
                     type = "l",      
                     main = "Number of Steps within Intervals by day",
                     xlab = "Daily Intervals",
                     ylab = "Number of Steps"))
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png)


```r
library(knitr)
knit2html("Week 5 Project 1.Rmd",
          spin(hair="Week 5 Project 1.R", 
               knit = FALSE), force_v1 = TRUE)
```

```
## 
## 
## processing file: Week 5 Project 1.Rmd
```

```
## Error in parse_block(g[-1], g[1], params.src, markdown_mode): Duplicate chunk label 'setup', which has been used for the chunk:
## knitr::opts_chunk$set(echo = TRUE)
```

```r
if (interactive()) browseURL("Week-5-Project-1.html")
```
