---
title: "Reproducible research assignment 1"
author: "Raja"
date: "Saturday, May 16, 2015"
output: html_document
---

```r
library(dplyr)
```


```r
temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip", temp)
data <- read.csv(unz(temp, "activity.csv"))
unlink(temp)
```

The total number of steps taken each day

```r
dataNAZero <- data
dataNAZero$steps[is.na(dataNAZero$steps)] <- 0
dataNAZeroByDay <- tapply(dataNAZero$steps, dataNAZero$date, FUN=sum)
dataNAZeroByDay
```

```
## 2012-10-01 2012-10-02 2012-10-03 2012-10-04 2012-10-05 2012-10-06 
##          0        126      11352      12116      13294      15420 
## 2012-10-07 2012-10-08 2012-10-09 2012-10-10 2012-10-11 2012-10-12 
##      11015          0      12811       9900      10304      17382 
## 2012-10-13 2012-10-14 2012-10-15 2012-10-16 2012-10-17 2012-10-18 
##      12426      15098      10139      15084      13452      10056 
## 2012-10-19 2012-10-20 2012-10-21 2012-10-22 2012-10-23 2012-10-24 
##      11829      10395       8821      13460       8918       8355 
## 2012-10-25 2012-10-26 2012-10-27 2012-10-28 2012-10-29 2012-10-30 
##       2492       6778      10119      11458       5018       9819 
## 2012-10-31 2012-11-01 2012-11-02 2012-11-03 2012-11-04 2012-11-05 
##      15414          0      10600      10571          0      10439 
## 2012-11-06 2012-11-07 2012-11-08 2012-11-09 2012-11-10 2012-11-11 
##       8334      12883       3219          0          0      12608 
## 2012-11-12 2012-11-13 2012-11-14 2012-11-15 2012-11-16 2012-11-17 
##      10765       7336          0         41       5441      14339 
## 2012-11-18 2012-11-19 2012-11-20 2012-11-21 2012-11-22 2012-11-23 
##      15110       8841       4472      12787      20427      21194 
## 2012-11-24 2012-11-25 2012-11-26 2012-11-27 2012-11-28 2012-11-29 
##      14478      11834      11162      13646      10183       7047 
## 2012-11-30 
##          0
```

Histogram of steps per day

```r
hist(dataNAZeroByDay, main="Histogram of number of steps per day", xlab="No of steps", ylab="Frequency")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 


The MEAN and MEDIAN of number of steps per day

```r
meanByDay <- tapply(dataNAZero$steps, dataNAZero$date, FUN=mean)
plot(x=c(0:60),y=meanByDay, type="l", xlab="Day", ylab="Average no of steps")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 

```r
medianByDay <- tapply(dataNAZero$steps, dataNAZero$date, FUN=median)
plot(x=c(0:60),y=medianByDay, type="l", xlab="Day", ylab="median no of steps")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-2.png) 


AVERAGE number of steps per interval

```r
meanByInt<- tapply(dataNAZero$steps, dataNAZero$interval, FUN=mean)
plot(x=dataNAZero$interval[0:288],y=meanByInt, type="l", xlab="Interval", ylab="Average no of steps")
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png) 

TIME interval for max number of mean steps

```r
meanByInt[meanByInt==max(meanByInt)]
```

```
##      835 
## 179.1311
```
Total number of missing values


```r
dataInit <- data
sum(is.na(dataInit$steps))
```

```
## [1] 2304
```

```r
dataMeanByDay <- tapply(dataNAZero$steps, dataNAZero$date, FUN=mean)
filledinData <- data.frame(steps=character(0), interval=character(0), date=character(0))
for(i in 1:61){
  d <- names(dataMeanByDay)[i]
  dataMeanByDate <- dataMeanByDay[i]
  dataByDate <- dataInit[dataInit$date == d,]
  dataByDate$steps[is.na(dataByDate$steps)] <- dataMeanByDate
  filledinData <- rbind(filledinData, dataByDate)
}
```

Adding Weekend/Weekday to the dataset

```r
isWeekEnd <-  weekdays(as.Date(dataNAZero$date)) %in% c("Saturday","Sunday") 
dataNAZero$wend <- "Weekday"
dataNAZero$wend[isWeekEnd] <- "Weekend"
d <- with(dataNAZero, tapply(steps, list(interval,wend), mean))
dim(d)
```

```
## [1] 288   2
```

```r
dim(data)
```

```
## [1] 17568     3
```

```r
plot(x=dataNAZero$interval[0:288],y=d[,1], type="l", xlab="Weekday Interval", ylab="Average no of steps")
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png) 

```r
plot(x=dataNAZero$interval[0:288],y=d[,2], type="l", xlab="Weekend Interval", ylab="Average no of steps")
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-2.png) 
