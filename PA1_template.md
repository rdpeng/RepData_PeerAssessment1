# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data

```r
#import necessary libraries
library(data.table)
library(lubridate)
```

```
## 
## Attaching package: 'lubridate'
## 
## The following objects are masked from 'package:data.table':
## 
##     hour, mday, month, quarter, wday, week, yday, year
```

```r
library(ggplot2)
library(lattice)


unzip('activity.zip')
data <- fread('activity.csv',header = TRUE)
data[,date:=as.Date(date)]
```

```
##        steps       date interval
##     1:    NA 2012-10-01        0
##     2:    NA 2012-10-01        5
##     3:    NA 2012-10-01       10
##     4:    NA 2012-10-01       15
##     5:    NA 2012-10-01       20
##    ---                          
## 17564:    NA 2012-11-30     2335
## 17565:    NA 2012-11-30     2340
## 17566:    NA 2012-11-30     2345
## 17567:    NA 2012-11-30     2350
## 17568:    NA 2012-11-30     2355
```


## What is mean total number of steps taken per day?

#### 1. Calculate the total number of steps taken per day

```r
#select and sum steps where not equal NA
sumsOfSteps <- data[!is.na(steps),sum(steps),by=date]

#change variable name V1 to sumOfSteps
sumsOfSteps <- sumsOfSteps[,sumOfSteps:=as.numeric(V1)]
#remove V1 and display sumsOfSteps
sumsOfSteps[,V1:=NULL]
```

```
##           date sumOfSteps
##  1: 2012-10-02        126
##  2: 2012-10-03      11352
##  3: 2012-10-04      12116
##  4: 2012-10-05      13294
##  5: 2012-10-06      15420
##  6: 2012-10-07      11015
##  7: 2012-10-09      12811
##  8: 2012-10-10       9900
##  9: 2012-10-11      10304
## 10: 2012-10-12      17382
## 11: 2012-10-13      12426
## 12: 2012-10-14      15098
## 13: 2012-10-15      10139
## 14: 2012-10-16      15084
## 15: 2012-10-17      13452
## 16: 2012-10-18      10056
## 17: 2012-10-19      11829
## 18: 2012-10-20      10395
## 19: 2012-10-21       8821
## 20: 2012-10-22      13460
## 21: 2012-10-23       8918
## 22: 2012-10-24       8355
## 23: 2012-10-25       2492
## 24: 2012-10-26       6778
## 25: 2012-10-27      10119
## 26: 2012-10-28      11458
## 27: 2012-10-29       5018
## 28: 2012-10-30       9819
## 29: 2012-10-31      15414
## 30: 2012-11-02      10600
## 31: 2012-11-03      10571
## 32: 2012-11-05      10439
## 33: 2012-11-06       8334
## 34: 2012-11-07      12883
## 35: 2012-11-08       3219
## 36: 2012-11-11      12608
## 37: 2012-11-12      10765
## 38: 2012-11-13       7336
## 39: 2012-11-15         41
## 40: 2012-11-16       5441
## 41: 2012-11-17      14339
## 42: 2012-11-18      15110
## 43: 2012-11-19       8841
## 44: 2012-11-20       4472
## 45: 2012-11-21      12787
## 46: 2012-11-22      20427
## 47: 2012-11-23      21194
## 48: 2012-11-24      14478
## 49: 2012-11-25      11834
## 50: 2012-11-26      11162
## 51: 2012-11-27      13646
## 52: 2012-11-28      10183
## 53: 2012-11-29       7047
##           date sumOfSteps
```

#### 2. Make a histogram of the total number of steps taken each day

```r
#draw histogram
hist(sumsOfSteps[,sumOfSteps],breaks = 30,main='Sum of Steps per Day',xlab = 'Sum of Steps',col='red',density = 20)
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 

#### 3. Calculate and report the mean and median of the total number of steps taken per day

```r
#calculate mean by ignoring NA values
meanOfSteps <- data[!is.na(steps),mean(steps),by=date]
meanOfSteps <- meanOfSteps[,mean:=V1]
#report mean per day
meanOfSteps[,V1:=NULL]
```

```
##           date       mean
##  1: 2012-10-02  0.4375000
##  2: 2012-10-03 39.4166667
##  3: 2012-10-04 42.0694444
##  4: 2012-10-05 46.1597222
##  5: 2012-10-06 53.5416667
##  6: 2012-10-07 38.2465278
##  7: 2012-10-09 44.4826389
##  8: 2012-10-10 34.3750000
##  9: 2012-10-11 35.7777778
## 10: 2012-10-12 60.3541667
## 11: 2012-10-13 43.1458333
## 12: 2012-10-14 52.4236111
## 13: 2012-10-15 35.2048611
## 14: 2012-10-16 52.3750000
## 15: 2012-10-17 46.7083333
## 16: 2012-10-18 34.9166667
## 17: 2012-10-19 41.0729167
## 18: 2012-10-20 36.0937500
## 19: 2012-10-21 30.6284722
## 20: 2012-10-22 46.7361111
## 21: 2012-10-23 30.9652778
## 22: 2012-10-24 29.0104167
## 23: 2012-10-25  8.6527778
## 24: 2012-10-26 23.5347222
## 25: 2012-10-27 35.1354167
## 26: 2012-10-28 39.7847222
## 27: 2012-10-29 17.4236111
## 28: 2012-10-30 34.0937500
## 29: 2012-10-31 53.5208333
## 30: 2012-11-02 36.8055556
## 31: 2012-11-03 36.7048611
## 32: 2012-11-05 36.2465278
## 33: 2012-11-06 28.9375000
## 34: 2012-11-07 44.7326389
## 35: 2012-11-08 11.1770833
## 36: 2012-11-11 43.7777778
## 37: 2012-11-12 37.3784722
## 38: 2012-11-13 25.4722222
## 39: 2012-11-15  0.1423611
## 40: 2012-11-16 18.8923611
## 41: 2012-11-17 49.7881944
## 42: 2012-11-18 52.4652778
## 43: 2012-11-19 30.6979167
## 44: 2012-11-20 15.5277778
## 45: 2012-11-21 44.3993056
## 46: 2012-11-22 70.9270833
## 47: 2012-11-23 73.5902778
## 48: 2012-11-24 50.2708333
## 49: 2012-11-25 41.0902778
## 50: 2012-11-26 38.7569444
## 51: 2012-11-27 47.3819444
## 52: 2012-11-28 35.3576389
## 53: 2012-11-29 24.4687500
##           date       mean
```

```r
#calculate median by ignoring NA values
medianOfSteps <-  data[!is.na(steps),as.double(median(steps)),by=date]
medianOfSteps <- medianOfSteps[,median:=V1]
#report median per day
medianOfSteps[,V1:=NULL]
```

```
##           date median
##  1: 2012-10-02      0
##  2: 2012-10-03      0
##  3: 2012-10-04      0
##  4: 2012-10-05      0
##  5: 2012-10-06      0
##  6: 2012-10-07      0
##  7: 2012-10-09      0
##  8: 2012-10-10      0
##  9: 2012-10-11      0
## 10: 2012-10-12      0
## 11: 2012-10-13      0
## 12: 2012-10-14      0
## 13: 2012-10-15      0
## 14: 2012-10-16      0
## 15: 2012-10-17      0
## 16: 2012-10-18      0
## 17: 2012-10-19      0
## 18: 2012-10-20      0
## 19: 2012-10-21      0
## 20: 2012-10-22      0
## 21: 2012-10-23      0
## 22: 2012-10-24      0
## 23: 2012-10-25      0
## 24: 2012-10-26      0
## 25: 2012-10-27      0
## 26: 2012-10-28      0
## 27: 2012-10-29      0
## 28: 2012-10-30      0
## 29: 2012-10-31      0
## 30: 2012-11-02      0
## 31: 2012-11-03      0
## 32: 2012-11-05      0
## 33: 2012-11-06      0
## 34: 2012-11-07      0
## 35: 2012-11-08      0
## 36: 2012-11-11      0
## 37: 2012-11-12      0
## 38: 2012-11-13      0
## 39: 2012-11-15      0
## 40: 2012-11-16      0
## 41: 2012-11-17      0
## 42: 2012-11-18      0
## 43: 2012-11-19      0
## 44: 2012-11-20      0
## 45: 2012-11-21      0
## 46: 2012-11-22      0
## 47: 2012-11-23      0
## 48: 2012-11-24      0
## 49: 2012-11-25      0
## 50: 2012-11-26      0
## 51: 2012-11-27      0
## 52: 2012-11-28      0
## 53: 2012-11-29      0
##           date median
```


## What is the average daily activity pattern?
#### 1. Make a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
avgPattern <- data[!is.na(steps),mean(steps),by=interval]
avgPattern <- avgPattern[,averageSteps:=V1]

#report avgPattern
avgPattern[,V1:=NULL]
```

```
##      interval averageSteps
##   1:        0    1.7169811
##   2:        5    0.3396226
##   3:       10    0.1320755
##   4:       15    0.1509434
##   5:       20    0.0754717
##  ---                      
## 284:     2335    4.6981132
## 285:     2340    3.3018868
## 286:     2345    0.6415094
## 287:     2350    0.2264151
## 288:     2355    1.0754717
```

```r
#draw the plot
g <- ggplot(avgPattern,aes(y=averageSteps,x=interval))
g+geom_line(aes(colour=averageSteps))+scale_colour_gradient(low='blue')+ggtitle('Average Daily Activity Pattern')+xlab('interval (5-min)')+ylab('Average Steps (per interval)')
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png) 

#### 2. The interval which has maximum mean value

```r
#find maximum 
max <- avgPattern[,max(averageSteps)]
avgPattern[averageSteps==max]
```

```
##    interval averageSteps
## 1:      835     206.1698
```
On average across all the days in the dataset 5-min interval 835 contains the maximum number of steps with mean 206.17

## Imputing missing values
#### 1. Calculate and report the total number of missing values in the dataset

```r
#calculate NA values 
data[is.na(steps),.N]
```

```
## [1] 2304
```
Total number of NA values is 2304 in the dataset.

#### 2&3. Filling in all of the missing values in the dataset 
 - The strategy for this part is filling NA values in with the mean for corresponding 5-minute interval

```r
#change type of steps integer to double and copy data.table to a new data set
newDataSet <- copy(data[,steps := as.double(steps)]) 
#assign average steps by interval to NA values 
newDataSet[is.na(steps) & interval==avgPattern[,interval],steps:=avgPattern[,averageSteps]]
```

```
##            steps       date interval
##     1: 1.7169811 2012-10-01        0
##     2: 0.3396226 2012-10-01        5
##     3: 0.1320755 2012-10-01       10
##     4: 0.1509434 2012-10-01       15
##     5: 0.0754717 2012-10-01       20
##    ---                              
## 17564: 4.6981132 2012-11-30     2335
## 17565: 3.3018868 2012-11-30     2340
## 17566: 0.6415094 2012-11-30     2345
## 17567: 0.2264151 2012-11-30     2350
## 17568: 1.0754717 2012-11-30     2355
```
#### 4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.


```r
newSumsOfSteps <- newDataSet[,sum(steps),by=date]
hist(newSumsOfSteps[,V1],breaks = 30,main='Sum of Steps per Day',xlab = 'Sum of Steps',col='blue',density = 20)
```

![](PA1_template_files/figure-html/unnamed-chunk-9-1.png) 
##### Mean of steps in imputed data set:

```r
newMeanOfSteps <- newDataSet[,mean(steps),by=date]
newMeanOfSteps <- newMeanOfSteps[,mean:=V1]
newMeanOfSteps[,V1:=NULL]
```

```
##           date       mean
##  1: 2012-10-01 37.3825996
##  2: 2012-10-02  0.4375000
##  3: 2012-10-03 39.4166667
##  4: 2012-10-04 42.0694444
##  5: 2012-10-05 46.1597222
##  6: 2012-10-06 53.5416667
##  7: 2012-10-07 38.2465278
##  8: 2012-10-08 37.3825996
##  9: 2012-10-09 44.4826389
## 10: 2012-10-10 34.3750000
## 11: 2012-10-11 35.7777778
## 12: 2012-10-12 60.3541667
## 13: 2012-10-13 43.1458333
## 14: 2012-10-14 52.4236111
## 15: 2012-10-15 35.2048611
## 16: 2012-10-16 52.3750000
## 17: 2012-10-17 46.7083333
## 18: 2012-10-18 34.9166667
## 19: 2012-10-19 41.0729167
## 20: 2012-10-20 36.0937500
## 21: 2012-10-21 30.6284722
## 22: 2012-10-22 46.7361111
## 23: 2012-10-23 30.9652778
## 24: 2012-10-24 29.0104167
## 25: 2012-10-25  8.6527778
## 26: 2012-10-26 23.5347222
## 27: 2012-10-27 35.1354167
## 28: 2012-10-28 39.7847222
## 29: 2012-10-29 17.4236111
## 30: 2012-10-30 34.0937500
## 31: 2012-10-31 53.5208333
## 32: 2012-11-01 37.3825996
## 33: 2012-11-02 36.8055556
## 34: 2012-11-03 36.7048611
## 35: 2012-11-04 37.3825996
## 36: 2012-11-05 36.2465278
## 37: 2012-11-06 28.9375000
## 38: 2012-11-07 44.7326389
## 39: 2012-11-08 11.1770833
## 40: 2012-11-09 37.3825996
## 41: 2012-11-10 37.3825996
## 42: 2012-11-11 43.7777778
## 43: 2012-11-12 37.3784722
## 44: 2012-11-13 25.4722222
## 45: 2012-11-14 37.3825996
## 46: 2012-11-15  0.1423611
## 47: 2012-11-16 18.8923611
## 48: 2012-11-17 49.7881944
## 49: 2012-11-18 52.4652778
## 50: 2012-11-19 30.6979167
## 51: 2012-11-20 15.5277778
## 52: 2012-11-21 44.3993056
## 53: 2012-11-22 70.9270833
## 54: 2012-11-23 73.5902778
## 55: 2012-11-24 50.2708333
## 56: 2012-11-25 41.0902778
## 57: 2012-11-26 38.7569444
## 58: 2012-11-27 47.3819444
## 59: 2012-11-28 35.3576389
## 60: 2012-11-29 24.4687500
## 61: 2012-11-30 37.3825996
##           date       mean
```
##### Median of steps in imputed data set:

```r
newMedianOfSteps <- newDataSet[,median(steps),by=date]
newMedianOfSteps <- newMedianOfSteps[,median:=V1]
newMedianOfSteps[,V1:=NULL]
```

```
##           date   median
##  1: 2012-10-01 34.11321
##  2: 2012-10-02  0.00000
##  3: 2012-10-03  0.00000
##  4: 2012-10-04  0.00000
##  5: 2012-10-05  0.00000
##  6: 2012-10-06  0.00000
##  7: 2012-10-07  0.00000
##  8: 2012-10-08 34.11321
##  9: 2012-10-09  0.00000
## 10: 2012-10-10  0.00000
## 11: 2012-10-11  0.00000
## 12: 2012-10-12  0.00000
## 13: 2012-10-13  0.00000
## 14: 2012-10-14  0.00000
## 15: 2012-10-15  0.00000
## 16: 2012-10-16  0.00000
## 17: 2012-10-17  0.00000
## 18: 2012-10-18  0.00000
## 19: 2012-10-19  0.00000
## 20: 2012-10-20  0.00000
## 21: 2012-10-21  0.00000
## 22: 2012-10-22  0.00000
## 23: 2012-10-23  0.00000
## 24: 2012-10-24  0.00000
## 25: 2012-10-25  0.00000
## 26: 2012-10-26  0.00000
## 27: 2012-10-27  0.00000
## 28: 2012-10-28  0.00000
## 29: 2012-10-29  0.00000
## 30: 2012-10-30  0.00000
## 31: 2012-10-31  0.00000
## 32: 2012-11-01 34.11321
## 33: 2012-11-02  0.00000
## 34: 2012-11-03  0.00000
## 35: 2012-11-04 34.11321
## 36: 2012-11-05  0.00000
## 37: 2012-11-06  0.00000
## 38: 2012-11-07  0.00000
## 39: 2012-11-08  0.00000
## 40: 2012-11-09 34.11321
## 41: 2012-11-10 34.11321
## 42: 2012-11-11  0.00000
## 43: 2012-11-12  0.00000
## 44: 2012-11-13  0.00000
## 45: 2012-11-14 34.11321
## 46: 2012-11-15  0.00000
## 47: 2012-11-16  0.00000
## 48: 2012-11-17  0.00000
## 49: 2012-11-18  0.00000
## 50: 2012-11-19  0.00000
## 51: 2012-11-20  0.00000
## 52: 2012-11-21  0.00000
## 53: 2012-11-22  0.00000
## 54: 2012-11-23  0.00000
## 55: 2012-11-24  0.00000
## 56: 2012-11-25  0.00000
## 57: 2012-11-26  0.00000
## 58: 2012-11-27  0.00000
## 59: 2012-11-28  0.00000
## 60: 2012-11-29  0.00000
## 61: 2012-11-30 34.11321
##           date   median
```
As one can see the results from part1 vs part2 of sum, mean and median values differ in some ways:

 - First of all sums of steps increased dramatically because we just replaced 2304 NA values to corresponding mean by interval

 - Mean values doesn't changed for valid rows, but there are some days have only NA values. These days' mean change NA to 37.3825996
 
 - Median values stay as the same but again the days with only NA values changed to 34.11321

## Are there differences in activity patterns between weekdays and weekends?
#### 1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

```r
Sys.setlocale('LC_TIME','en_US')
```

```
## [1] "en_US"
```

```r
newDataSet <- newDataSet[,day:='weekday']
newDataSet <- newDataSet[weekdays(date)=='Sunday' | weekdays(date)=='Saturday', day:='weekend']
newDataSet <- newDataSet[,mean:=mean(steps),keyby=interval]
newDataSet <- newDataSet[,day:=as.factor(day)]
```
#### 2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis)


```r
xyplot(mean~interval|day,newDataSet,type = "l",lwd=1,  layout = c(1, 2),xlab = "Interval", ylab = "Avg. Number of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png) 

