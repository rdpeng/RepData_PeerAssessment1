# Reproducible Research: Peer Assessment 1

## Loading and preprocessing the data


```r
data_table <- read.csv("activity.csv")
```

## What is mean total number of steps taken per day?

```r
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.2.2
```

```r
total.steps <- tapply(data_table$steps, data_table$date, FUN=sum, na.rm=TRUE)
qplot(total.steps, binwidth=1000, xlab="Total number of steps taken each day")
```

![](PA1_template_files/figure-html/mean_median-1.png) 

```r
mean(total.steps, na.rm=TRUE)
```

```
## [1] 9354.23
```

```r
median(total.steps, na.rm=TRUE)
```

```
## [1] 10395
```

## What is the average daily activity pattern?

```r
averages <- aggregate(x=list(steps=data_table$steps),
                      by=list(interval=data_table$interval), FUN=mean, na.rm=TRUE)
ggplot(data=averages, aes(x=interval, y=steps)) + geom_line() + xlab("5-minute interval") + ylab("Average number of steps taken")
```

![](PA1_template_files/figure-html/average_daily-1.png) 

## Inputing missing values
