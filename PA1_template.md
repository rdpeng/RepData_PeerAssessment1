---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---

Setting Global option to set Echo ==True


```r
options(echo = TRUE)
```

## Loading and preprocessing the data

```r
getwd()
```

```
## [1] "/Users/golu/Documents/GitHub/RepData_PeerAssessment1"
```

```r
unzip("activity.zip")
activityData <- read.csv("activity.csv")
head(activityData)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
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
library(ggplot2)
activityDataWithoutNA<- na.omit(activityData)
##summarise(group_by(activityDataWithoutNA,date),sum(steps))
totalStepsPerday<- aggregate(steps ~ date,data = activityDataWithoutNA,FUN = sum)
hist(totalStepsPerday$steps,xlab = "Steps taken each day",ylab = "Interval",main = "Total number of steps taken each day",col = "orange",breaks = 50)
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

```r
meanTotalSteps <- mean(totalStepsPerday$steps)
meanTotalSteps
```

```
## [1] 10766.19
```

```r
medianTotalSteps <- median(totalStepsPerday$steps)
medianTotalSteps
```

```
## [1] 10765
```

## What is the average daily activity pattern?

```r
avgDailyActivityPattern<- aggregate(steps~interval,data =activityDataWithoutNA,FUN = mean)
plot(avgDailyActivityPattern$interval,avgDailyActivityPattern$step,type="l",xlab = " 5 min Interval",ylab = "Average number of steps taken")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

```r
maxStepsInterval<- avgDailyActivityPattern$interval[which.max(avgDailyActivityPattern$steps)]
maxStepsInterval
```

```
## [1] 835
```



## Imputing missing values

```r
library(plyr)
```

```
## -------------------------------------------------------------------------
```

```
## You have loaded plyr after dplyr - this is likely to cause problems.
## If you need functions from both plyr and dplyr, please load plyr first, then dplyr:
## library(plyr); library(dplyr)
```

```
## -------------------------------------------------------------------------
```

```
## 
## Attaching package: 'plyr'
```

```
## The following objects are masked from 'package:dplyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
```

```r
numberOfRowswithNA <- sum(is.na(activityData$steps))
numberOfRowswithNA
```

```
## [1] 2304
```

```r
activityData2 <- activityData
NAinData<- is.na(activityData2$steps)
avg_interval <- tapply(activityData2$steps, activityData2$interval, mean, na.rm=TRUE, simplify = TRUE)
activityData2$steps[NAinData]<- avg_interval[as.character(activityData2$interval[NAinData])]
sum(is.na(activityData2))
```

```
## [1] 0
```

```r
totalStepsPerday2<- aggregate(steps ~ date,data = activityData2,FUN = sum)
totalStepsPerday2
```

```
##          date    steps
## 1  2012-10-01 10766.19
## 2  2012-10-02   126.00
## 3  2012-10-03 11352.00
## 4  2012-10-04 12116.00
## 5  2012-10-05 13294.00
## 6  2012-10-06 15420.00
## 7  2012-10-07 11015.00
## 8  2012-10-08 10766.19
## 9  2012-10-09 12811.00
## 10 2012-10-10  9900.00
## 11 2012-10-11 10304.00
## 12 2012-10-12 17382.00
## 13 2012-10-13 12426.00
## 14 2012-10-14 15098.00
## 15 2012-10-15 10139.00
## 16 2012-10-16 15084.00
## 17 2012-10-17 13452.00
## 18 2012-10-18 10056.00
## 19 2012-10-19 11829.00
## 20 2012-10-20 10395.00
## 21 2012-10-21  8821.00
## 22 2012-10-22 13460.00
## 23 2012-10-23  8918.00
## 24 2012-10-24  8355.00
## 25 2012-10-25  2492.00
## 26 2012-10-26  6778.00
## 27 2012-10-27 10119.00
## 28 2012-10-28 11458.00
## 29 2012-10-29  5018.00
## 30 2012-10-30  9819.00
## 31 2012-10-31 15414.00
## 32 2012-11-01 10766.19
## 33 2012-11-02 10600.00
## 34 2012-11-03 10571.00
## 35 2012-11-04 10766.19
## 36 2012-11-05 10439.00
## 37 2012-11-06  8334.00
## 38 2012-11-07 12883.00
## 39 2012-11-08  3219.00
## 40 2012-11-09 10766.19
## 41 2012-11-10 10766.19
## 42 2012-11-11 12608.00
## 43 2012-11-12 10765.00
## 44 2012-11-13  7336.00
## 45 2012-11-14 10766.19
## 46 2012-11-15    41.00
## 47 2012-11-16  5441.00
## 48 2012-11-17 14339.00
## 49 2012-11-18 15110.00
## 50 2012-11-19  8841.00
## 51 2012-11-20  4472.00
## 52 2012-11-21 12787.00
## 53 2012-11-22 20427.00
## 54 2012-11-23 21194.00
## 55 2012-11-24 14478.00
## 56 2012-11-25 11834.00
## 57 2012-11-26 11162.00
## 58 2012-11-27 13646.00
## 59 2012-11-28 10183.00
## 60 2012-11-29  7047.00
## 61 2012-11-30 10766.19
```

```r
hist(totalStepsPerday2$steps,xlab = "Steps taken each day",ylab = "Interval",main = "Total number of steps taken each day",col = "orange",breaks = 50)
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

```r
meanTotalSteps2 <- mean(totalStepsPerday2$steps)
meanTotalSteps2
```

```
## [1] 10766.19
```

```r
medianTotalSteps2 <- median(totalStepsPerday2$steps)
medianTotalSteps2
```

```
## [1] 10766.19
```

```r
summary(activityData)
```

```
##      steps                date          interval     
##  Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
##  1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
##  Median :  0.00   2012-10-03:  288   Median :1177.5  
##  Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
##  3rd Qu.: 12.00   2012-10-05:  288   3rd Qu.:1766.2  
##  Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
##  NA's   :2304     (Other)   :15840
```

```r
summary(activityData2)
```

```
##      steps                date          interval     
##  Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
##  1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
##  Median :  0.00   2012-10-03:  288   Median :1177.5  
##  Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
##  3rd Qu.: 27.00   2012-10-05:  288   3rd Qu.:1766.2  
##  Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
##                   (Other)   :15840
```
## Are there differences in activity patterns between weekdays and weekends?

```r
activityData2<- activityData2%>%
        mutate(typeofday= ifelse(weekdays(as.Date(activityData2$date))=="Saturday" | weekdays(as.Date(activityData2$date))=="Sunday", "Weekend", "Weekday"))
head(activityData2)
```

```
##       steps       date interval typeofday
## 1 1.7169811 2012-10-01        0   Weekday
## 2 0.3396226 2012-10-01        5   Weekday
## 3 0.1320755 2012-10-01       10   Weekday
## 4 0.1509434 2012-10-01       15   Weekday
## 5 0.0754717 2012-10-01       20   Weekday
## 6 2.0943396 2012-10-01       25   Weekday
```

```r
avgStepperInterval<- aggregate(steps ~ interval, data = activityData2, FUN = mean, na.rm = TRUE)
head(avgStepperInterval)
```

```
##   interval     steps
## 1        0 1.7169811
## 2        5 0.3396226
## 3       10 0.1320755
## 4       15 0.1509434
## 5       20 0.0754717
## 6       25 2.0943396
```

```r
ggplot(activityData2, aes(x =interval , y=steps, color=typeofday)) + geom_line() +
       labs(title = "Ave Daily Steps (type of day)", x = "Interval", y = "Total Number of Steps") +
       facet_wrap(~ typeofday, ncol = 1, nrow=2)
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

