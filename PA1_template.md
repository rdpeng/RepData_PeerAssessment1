---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---

loading all packages


```r
library(dplyr)
```

```
## Warning: package 'dplyr' was built under R version 3.6.3
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
library(knitr)
```

```
## Warning: package 'knitr' was built under R version 3.6.2
```

## Loading and preprocessing the data

Show any code that is needed to

1. Load the data (i.e. \color{red}{\verb|read.csv()|}read.csv())

2. Process/transform the data (if necessary) into a format suitable for your analysis


```r
## setwd
setwd("D:/Desktop/JuanMa/Coursera/Data Science/Reproducible Research/Course Project 1")

## Loading and preprocessing the data
data <- read.table("activity.csv", header = TRUE, sep = ",")
data$date<- as.Date(data$date)

# remove NA
data2<- data[!is.na(data$steps),]
```

## What is mean total number of steps taken per day?
For this part of the assignment, you can ignore the missing values in the dataset.

1. Calculate the total number of steps taken per day

2. If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day

3. Calculate and report the mean and median of the total number of steps taken per day


```r
# calculate de total steps per day
df<- data.frame(steps.day = with(data2, tapply(steps, date, FUN=sum)))
```


```r
## Histogram of the total number of steps taken each day
hist(df$steps.day, 
     main = "Total number of steps per day", 
     xlab = "Steps in a day")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->


```r
mean.day<- mean(df$steps.day)
median.day<- median(df$steps.day)
```

## What is the average daily activity pattern?




## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?

