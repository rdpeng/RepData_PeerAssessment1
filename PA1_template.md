# Reproducible Research: Peer Assessment 1


## Purpose

This document details the analysis performed on data from a personal activity monitoring device. This device collected the number of steps taken at 5 minute intervals throughout the day during the months of October and November, 2012.


## 1. Loading and preprocessing the data

The activity data is read into a data frame using the following code. To aid understanding, a summary of the datset is given showing the three variables: steps, date and interval.

```r
data <- read.table(unz("activity.zip", "activity.csv"), header=T, sep=",")
summary(data)
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


## 2. What is mean total number of steps taken per day?
The total number of steps per day are then calculated using the aggregate function, and the results are plotted using a histogram


```r
stepsPerDay<-aggregate(cbind(steps) ~ date, data = data, FUN = sum, na.rm = TRUE)

hist(stepsPerDay$steps,
     main="Histogram of total number of steps per day",
     ylab="Frequency",
     xlab="Steps",
     col="coral")
```

![](PA1_template_files/figure-html/stepsPerDay-1.png) 


The mean and median steps per day are then calculated by way of the following code before presenting the findings in the table below:

```r
library(xtable)
meanStepsPerDay<-aggregate(cbind(steps) ~ date, data = data, FUN = mean, na.rm = TRUE)
medianStepsPerDay<-aggregate(cbind(steps) ~ date, data = data, FUN = median, na.rm = TRUE)
meanMedian<- data.frame(meanStepsPerDay$date,meanStepsPerDay$steps,medianStepsPerDay$steps)
names(meanMedian)<-c("date","mean steps","median steps")
meanMedian<-xtable(meanMedian[1:3])
print(meanMedian, type="html")
```

<!-- html table generated in R 3.2.1 by xtable 1.7-4 package -->
<!-- Wed Oct 14 15:13:19 2015 -->
<table border=1>
<tr> <th>  </th> <th> date </th> <th> mean steps </th> <th> median steps </th>  </tr>
  <tr> <td align="right"> 1 </td> <td> 2012-10-02 </td> <td align="right"> 0.44 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 2 </td> <td> 2012-10-03 </td> <td align="right"> 39.42 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 3 </td> <td> 2012-10-04 </td> <td align="right"> 42.07 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 4 </td> <td> 2012-10-05 </td> <td align="right"> 46.16 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 5 </td> <td> 2012-10-06 </td> <td align="right"> 53.54 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 6 </td> <td> 2012-10-07 </td> <td align="right"> 38.25 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 7 </td> <td> 2012-10-09 </td> <td align="right"> 44.48 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 8 </td> <td> 2012-10-10 </td> <td align="right"> 34.38 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 9 </td> <td> 2012-10-11 </td> <td align="right"> 35.78 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 10 </td> <td> 2012-10-12 </td> <td align="right"> 60.35 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 11 </td> <td> 2012-10-13 </td> <td align="right"> 43.15 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 12 </td> <td> 2012-10-14 </td> <td align="right"> 52.42 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 13 </td> <td> 2012-10-15 </td> <td align="right"> 35.20 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 14 </td> <td> 2012-10-16 </td> <td align="right"> 52.38 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 15 </td> <td> 2012-10-17 </td> <td align="right"> 46.71 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 16 </td> <td> 2012-10-18 </td> <td align="right"> 34.92 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 17 </td> <td> 2012-10-19 </td> <td align="right"> 41.07 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 18 </td> <td> 2012-10-20 </td> <td align="right"> 36.09 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 19 </td> <td> 2012-10-21 </td> <td align="right"> 30.63 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 20 </td> <td> 2012-10-22 </td> <td align="right"> 46.74 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 21 </td> <td> 2012-10-23 </td> <td align="right"> 30.97 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 22 </td> <td> 2012-10-24 </td> <td align="right"> 29.01 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 23 </td> <td> 2012-10-25 </td> <td align="right"> 8.65 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 24 </td> <td> 2012-10-26 </td> <td align="right"> 23.53 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 25 </td> <td> 2012-10-27 </td> <td align="right"> 35.14 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 26 </td> <td> 2012-10-28 </td> <td align="right"> 39.78 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 27 </td> <td> 2012-10-29 </td> <td align="right"> 17.42 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 28 </td> <td> 2012-10-30 </td> <td align="right"> 34.09 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 29 </td> <td> 2012-10-31 </td> <td align="right"> 53.52 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 30 </td> <td> 2012-11-02 </td> <td align="right"> 36.81 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 31 </td> <td> 2012-11-03 </td> <td align="right"> 36.70 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 32 </td> <td> 2012-11-05 </td> <td align="right"> 36.25 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 33 </td> <td> 2012-11-06 </td> <td align="right"> 28.94 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 34 </td> <td> 2012-11-07 </td> <td align="right"> 44.73 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 35 </td> <td> 2012-11-08 </td> <td align="right"> 11.18 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 36 </td> <td> 2012-11-11 </td> <td align="right"> 43.78 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 37 </td> <td> 2012-11-12 </td> <td align="right"> 37.38 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 38 </td> <td> 2012-11-13 </td> <td align="right"> 25.47 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 39 </td> <td> 2012-11-15 </td> <td align="right"> 0.14 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 40 </td> <td> 2012-11-16 </td> <td align="right"> 18.89 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 41 </td> <td> 2012-11-17 </td> <td align="right"> 49.79 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 42 </td> <td> 2012-11-18 </td> <td align="right"> 52.47 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 43 </td> <td> 2012-11-19 </td> <td align="right"> 30.70 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 44 </td> <td> 2012-11-20 </td> <td align="right"> 15.53 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 45 </td> <td> 2012-11-21 </td> <td align="right"> 44.40 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 46 </td> <td> 2012-11-22 </td> <td align="right"> 70.93 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 47 </td> <td> 2012-11-23 </td> <td align="right"> 73.59 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 48 </td> <td> 2012-11-24 </td> <td align="right"> 50.27 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 49 </td> <td> 2012-11-25 </td> <td align="right"> 41.09 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 50 </td> <td> 2012-11-26 </td> <td align="right"> 38.76 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 51 </td> <td> 2012-11-27 </td> <td align="right"> 47.38 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 52 </td> <td> 2012-11-28 </td> <td align="right"> 35.36 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 53 </td> <td> 2012-11-29 </td> <td align="right"> 24.47 </td> <td align="right"> 0.00 </td> </tr>
   </table>
## 3. What is the average daily activity pattern?

The average steps per time interval across all days is calculated and plotted using the code shown below. 


```r
avgStepsPerInt<-aggregate(cbind(steps) ~ interval, data = data, FUN = mean, na.rm = TRUE)
high<-which.max(avgStepsPerInt$steps)
highInt<-avgStepsPerInt[high,]$interval
plot(avgStepsPerInt$interval, avgStepsPerInt$steps, type="l", xlab="Time Interval", ylab="Number of Steps",xaxt="n")
     title ("Average Steps per Time Interval")
     axis(1, at = seq(0, 2600, by = 50), las=2)
```

![](PA1_template_files/figure-html/stepsPerInt-1.png) 



From the plot one can see that  interval **835** contains the maximum number of steps.


## 4. Imputing missing values


```r
numNA<-length(which(is.na(data)))
```

From the code above we can establish that there are **``2304``** intervals without a value. The presence of missing values may introduce bias into some calculations or summaries of the data. To overcome this issue a strategy of substituting the mean value of the resepctive interval for the missing values, has been adopted by way of the following code.


```r
mergedData<-merge(data, avgStepsPerInt, by="interval")
NARows <- is.na(mergedData$steps.x)
mergedData$steps.x[NARows] <- mergedData$steps.y[NARows]
```

With the NA values substituted, the analysis detailed in section 2 is replayed show the effect of missing values within the data set. 


```r
stepsPerDay2<-aggregate(cbind(steps.x) ~ date, data = mergedData, FUN = sum, na.rm = TRUE)

hist(stepsPerDay2$steps.x,
     main="Histogram of total number of steps per day (with NAs substituted)",
     ylab="Frequency",
     xlab="Steps",
     col="coral")
```

![](PA1_template_files/figure-html/stepsPerDaySubst-1.png) 

**TO BE COMPLETED**

## 5. Are there differences in activity patterns between weekdays and weekends?

Averages per interval for both week days and weekendd were calculated using the code below. These avearages were then plot alongside each other to show the differences in activity patterns between them.



```r
# --- Convert date variable to date format
suppressPackageStartupMessages(library(timeDate))
mergedData$date <- as.POSIXct(strptime(mergedData$date, "%Y-%m-%d",tz = "GMT"))

# --- add new column signifying weekday(TRUE) or weekend(FALSE)
mergedData["weekday"]<- isWeekday(mergedData$date)

# --- Calc average per interval/day type (weekday/weekend)
avgStepsPerInt<-aggregate(cbind(steps.x) ~ weekday+interval, data = mergedData, FUN = mean, na.rm = TRUE)
weekDayData<-subset(avgStepsPerInt,avgStepsPerInt$weekday==TRUE)
weekEndData<-subset(avgStepsPerInt,avgStepsPerInt$weekday==FALSE)

# --- Plot the difference between weekday and weekend steps
par(mfrow=c(2,1))
plot(weekDayData$interval, weekDayData$steps, type="l", xlab="Time Interval", ylab="Number of Steps",xaxt="n",
ylim=range(0:250))
title ("Average Steps per Time Interval on Week Days")
axis(1, at = seq(0, 2600, by = 50), las=2)
plot(weekEndData$interval, weekEndData$steps, type="l", xlab="Time Interval", ylab="Number of Steps",xaxt="n",
     ylim=range(0:250))
title ("Average Steps per Time Interval on Weekends")
axis(1, at = seq(0, 2600, by = 50), las=2)
```

![](PA1_template_files/figure-html/diffActPatts-1.png) 
