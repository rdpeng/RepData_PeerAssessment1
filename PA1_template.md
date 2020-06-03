---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---


## Loading and preprocessing the data

```r
library(data.table)
options(scipen=999)
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
  summarise(steptotal = sum(steps,na.rm=T))
head(activitystat,5)
```

```
## # A tibble: 5 x 2
##   date       steptotal
##   <date>         <int>
## 1 2012-10-01         0
## 2 2012-10-02       126
## 3 2012-10-03     11352
## 4 2012-10-04     12116
## 5 2012-10-05     13294
```

```r
ggplot(data=activitystat,mapping=aes(steptotal))+
  geom_histogram(binwidth = 1000)+
  labs(x='Total number of steps', y='Frequency')
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)
  
The mean total steps taken per day was 9354.2 and the median was 10395.  

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
  summarise(steptotal = sum(imputeSteps))
ggplot(data=activityimpstat,mapping=aes(steptotal))+
  geom_histogram(binwidth = 1000)+
  labs(x='Total number of steps', y='Frequency')
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)

```r
head(activityimpstat,5)
```

```
## # A tibble: 5 x 2
##   date       steptotal
##   <date>         <dbl>
## 1 2012-10-01    10766.
## 2 2012-10-02      126 
## 3 2012-10-03    11352 
## 4 2012-10-04    12116 
## 5 2012-10-05    13294
```
  
The resulting mean and median steps per day from the imputation was 10766.2 and 10766.2. The differences between the imputed and non-imputed data for these parameters are 1412 and 371.2. 


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
