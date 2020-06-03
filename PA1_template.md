---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---


## Loading and preprocessing the data

```r
library(data.table)
if (!file.exists('activity.csv')){
  if (!file.exists('activity.zip')){
    download.files('https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip',
                   destfile='activity.zip',method='curl')}
  unzip('activity.zip')
}
activity <- fread('activity.csv', sep=',', header=T, na.strings='NA')
activity$date <- as.Date(activity$date)
```


## What is mean total number of steps taken per day?

```r
library(dplyr)
library(ggplot2)
activitystat <- activity %>% group_by(date) %>% select(-interval) %>% 
  summarise(steptotal = sum(steps,na.rm=T), mean = mean(steps,na.rm=T), median = median(steps,na.rm=T))
head(activitystat,5)
```

```
## # A tibble: 5 x 4
##   date       steptotal    mean median
##   <date>         <int>   <dbl>  <dbl>
## 1 2012-10-01         0 NaN         NA
## 2 2012-10-02       126   0.438      0
## 3 2012-10-03     11352  39.4        0
## 4 2012-10-04     12116  42.1        0
## 5 2012-10-05     13294  46.2        0
```

```r
ggplot(data=activitystat,mapping=aes(steptotal))+
  geom_histogram(binwidth = 1000)+
  labs(x='Total number of steps', y='Frequency')
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)

## What is the average daily activity pattern?

```r
library(dplyr)
library(ggplot2)
activeperiod <- activity %>% group_by(interval) %>% select(-date) %>% 
  summarise(mean = mean(steps,na.rm=T))
ggplot(data=activeperiod,mapping=aes(interval,mean))+
    geom_line(size=1)+
    labs(x='Period', y='Mean number of steps')
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)
  
Across all days, the maximum number of steps is taken within the 5-min interval up to 835.

## Imputing missing values
There are 2304 rows with missing values(s). To impute these, the average of the steps taken in that period across days were computed.

```r
library(dplyr)
activity$imputeSteps <- ave(activity$steps,activity$interval,FUN=function(x)
  ifelse(is.na(x),mean(x,na.rm=T),x))
activityimpstat <- activity %>% group_by(date) %>% select(date,imputeSteps) %>% 
  summarise(steptotal = sum(imputeSteps), mean = mean(imputeSteps), 
            median = median(imputeSteps))
ggplot(data=activityimpstat,mapping=aes(steptotal))+
  geom_histogram(binwidth = 1000)+
  labs(x='Total number of steps', y='Frequency')
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)

```r
head(activityimpstat,5)
```

```
## # A tibble: 5 x 4
##   date       steptotal   mean median
##   <date>         <dbl>  <dbl>  <dbl>
## 1 2012-10-01    10766. 37.4     34.1
## 2 2012-10-02      126   0.438    0  
## 3 2012-10-03    11352  39.4      0  
## 4 2012-10-04    12116  42.1      0  
## 5 2012-10-05    13294  46.2      0
```
Roughly speaking, the differences between the imputed and non-imputed data are 9.2728655 &times; 10<sup>8</sup>, 0, 0 in terms of total steps taken, mean, and median across days.


## Are there differences in activity patterns between weekdays and weekends?

```r
library(ggplot2)
library(dplyr)
weekdays = c('Monday','Tuesday','Wednesday','Thursday','Friday')
weekend = c('Saturday','Sunday')
activity$day <- factor(weekdays(activity$date),levels=c(weekdays,weekend),
                       labels=c(rep('weekday',5),rep('weekend',2)))
activityimpstat <- activity %>% group_by(day,interval) %>% select(date,interval:day) %>% 
  summarise(mean = mean(imputeSteps))
ggplot(data=activityimpstat,mapping=aes(interval,mean))+
  geom_line(size=1)+
  facet_grid(day~.)+
  labs(x='Interval',y='Average number of steps')
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)
