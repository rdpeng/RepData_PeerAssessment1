---
title: 'Reproducible Research: Peer Assessment 1'
author: "Mostafa Amin"
output: 
  html_document:
    keep_md: true
---



## Loading and preprocessing the data

```r
activity <- read.csv("C:\\Users\\Mostafa\\Documents\\activity.csv", sep = ",", header = TRUE)
```

## What is mean total number of steps taken per day?

###Number of steps per day

```r
steps <- activity %>%
  group_by(date) %>%
  summarize(steps = sum(steps))
```

###Histogram of the total number of steps taken each day

```r
hist(steps$steps, xlab = "Steps per Day", main = "Total number of steps taken each day", col = "turquoise")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

###The mean and median total number of steps taken per day

```r
mean <- mean(steps$steps, na.rm=TRUE)
median <- median(steps$steps, na.rm=TRUE)
```


```r
mean
```

```
## [1] 10766.19
```

```r
median
```

```
## [1] 10765
```

##What is the average daily activity pattern?

###Average number of steps per interval

```r
interval <- activity %>%
  group_by(interval) %>%
  summarize(steps = mean(steps, na.rm = TRUE))
```

###time series plot

```r
plot.ts(interval$steps, xlab = "Interval", ylab = "Average steps", col = "Maroon")
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

###The interval with maximum number of steps

```r
interval[which.max(interval$steps),]
```

```
## # A tibble: 1 x 2
##   interval steps
##      <int> <dbl>
## 1      835  206.
```

## Imputing missing values

###Calculate and report the total number of missing values in the dataset

```r
sum(is.na(activity))
```

```
## [1] 2304
```

###Imputing strategy and new dataset

```r
impact <- activity 
for (i in 1:nrow(impact)) {
    if (is.na(impact$steps[i])) {
        impact$steps[i] <- interval[which(impact$interval[i] == interval$interval), ]$steps
    }
}
```


```r
sum(is.na(impact))
```

```
## [1] 0
```

###Number of steps per day of the imputed data

```r
imp_steps <- impact %>%
  group_by(date) %>%
  summarize(steps = sum(steps))
```

###Histogram of the total number of steps taken each day of the imputed data

```r
hist(imp_steps$steps, xlab = "Steps per Day", main = "Total number of steps taken each day of the imputed data", col = "orange")
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

###The mean and median total number of steps taken per day of the imputed data

```r
imp_mean <- mean(imp_steps$steps, na.rm=TRUE)
imp_median <- median(imp_steps$steps, na.rm=TRUE)
```


```r
imp_mean
```

```
## [1] 10766.19
```

```r
imp_median
```

```
## [1] 10766.19
```

Imputing the data resulted in mean and median became the same value

## Are there differences in activity patterns between weekdays and weekends?

### Creating new variable (daytype)

```r
library(chron)
```

```
## Warning: package 'chron' was built under R version 3.5.1
```

```r
impact$daytype = chron::is.weekend(impact$date)
impact$daytype <- ifelse(impact$daytype=="TRUE", "weekend", "weekday")
```

### Average steps

```r
interval_wk <- impact %>%
  group_by(interval, daytype) %>%
  summarise(steps = mean(steps))
```

###The plot

```r
library(ggplot2)
plot <- ggplot(interval_wk, aes(x=interval, y=steps, color = daytype)) +
  geom_line() +
  facet_wrap(~daytype, ncol = 1, nrow=2)
print(plot)
```

![](PA1_template_files/figure-html/unnamed-chunk-18-1.png)<!-- -->
