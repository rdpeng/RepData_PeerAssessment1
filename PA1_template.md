---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---

## Week 2 - Reproducible Research

### Code for reading in the dataset and/or processing the data


```r
activity.df <- 
        read.csv('activity.csv', header = TRUE, stringsAsFactors = FALSE)
```



### Histogram of the total number of steps taken each day


```r
steps <- aggregate(activity.df$steps, by=list(date = activity.df$date)
                , sum, na.rm = TRUE)

hist(steps$x, xlab='Steps per day', ylab='Total', main ='')
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

### Mean and median number of steps taken each day



```r
mean(steps$x)
```

```
## [1] 9354.23
```

```r
median(steps$x)
```

```
## [1] 10395
```

### Time series plot of the average number of steps taken


```r
interval.df <- aggregate(activity.df$steps, by=list(interval = activity.df$interval)
                   , mean, na.rm = TRUE)

plot(x = interval.df$interval, y= interval.df$x, type = "l", xlab = 'Interval', ylab = 'Average numbers of steps', main = '')
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

### The 5-minute interval that, on average, contains the maximum number of steps


```r
interval.df$interval[which.max(interval.df$x)]
```

```
## [1] 835
```

### Code to describe and show a strategy for imputing missing data


```r
sum(is.na(activity.df$steps))
```

```
## [1] 2304
```

```r
mean_activity <- mean(activity.df$steps, na.rm=TRUE)

activity.df$steps <- ifelse(is.na(activity.df$steps), 
                            mean_activity, activity.df$steps)
```

### Histogram of the total number of steps taken each day after missing values are imputed


```r
steps <- aggregate(activity.df$steps, by=list(date = activity.df$date)
                   , sum, na.rm = TRUE)

hist(steps$x)
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

### Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends


```r
activity.df$date <- as.Date(activity.df$date, format = "%Y-%m-%d")

activity.df$weekday_tmp <- weekdays(activity.df$date)

activity.df$weekday <- ifelse(activity.df$weekday_tmp == "Sunday" | activity.df$weekday_tmp == "Saturday",
                                "Weekend", "weekday")

weekend_week <- aggregate(activity.df$steps, by=list(weekend = activity.df$weekday, interval = activity.df$interval), mean, na.rm = TRUE)

par(mfrow=c(2,2))

weekend.df <- subset(weekend_week, weekend_week$weekend == "Weekend")
weekday.df <- subset(weekend_week, weekend_week$weekend != "Weekend")

plot(x = weekend.df$interval, y= weekend.df$x, type = "l")
plot(x = weekday.df$interval, y= weekday.df$x, type = "l")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->



