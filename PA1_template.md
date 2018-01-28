---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---
setwd("C:/Users/Merle/Documents/GitHub/RepData_PeerAssessment1")

## Loading and preprocessing the data

```r
activity.df <- 
        read.csv('activity.csv', header = TRUE, stringsAsFactors = FALSE)
```


## What is mean total number of steps taken per day?

```r
steps <- aggregate(activity.df$steps, by=list(date = activity.df$date)
                , sum, na.rm = TRUE)

hist(steps$x, xlab='Steps per day', ylab='Total', main ='')
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

```r
mean(steps$x)
```

```
## [1] 9354.23
```


## What is the average daily activity pattern?

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


## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
