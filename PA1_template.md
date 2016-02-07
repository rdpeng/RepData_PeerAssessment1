
```r
require(ggplot2)

# set otion to print numbers in a 'fashion' way
options("scipen" = 10)

# set locale to get weekdays in English
Sys.setlocale("LC_TIME","English")
```

```
## [1] "English_United States.1252"
```
---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---

## Loading and preprocessing the data

```r
# check if the csv file is already unziped or unzip it
if(!file.exists('activity.csv')){
    unzip('activity.zip')
}

# read data
activity<-read.csv("./activity.csv",as.is=T)
```

## What is mean total number of steps taken per day?
### 1. Make a histogram of the total number of steps taken each day

```r
# calculate sum of steps per day
stepsbyday<-aggregate(steps~date,activity,sum,na.rm=TRUE)
# plot the histogram
hist(stepsbyday$steps, col='darkgreen', xlab='Total steps', main='histogram of the total number of steps taken each day')
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

### 2. Calculate and report the mean and median total number of steps taken per day

```r
# calculate mean
act_mean<-mean(stepsbyday$steps)
act_mean
```

```
## [1] 10766.19
```

```r
# calculate median
act_median<-median(stepsbyday$steps)
act_median
```

```
## [1] 10765
```

The mean total number of steps taken per day is **10766.1886792** and the median is **10765**.


## What is the average daily activity pattern?
### 1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
stepsbyinterval<-aggregate(steps~interval,activity,mean,na.rm=TRUE)
plot(stepsbyinterval$interval,stepsbyinterval$steps, type='l',ylab='Average steps',xlab='5-minute interval',main='Average steps by 5-minute interval')
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 

### 2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
int<-stepsbyinterval[which.max(stepsbyinterval$steps),]
int
```

```
##     interval    steps
## 104      835 206.1698
```
The interval containing the maximum average number of steps is **835**, with a total of **206.1698113**.


## Imputing missing values
### 1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)


```r
# calculate rows with NAs
NArows<-activity[!complete.cases(activity),]
nrow(NArows)
```

```
## [1] 2304
```

The number of rows with missing values is **2304**.


### 2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

We decided to fill NAs based on the mean of valid number of steps by interval already calculated.

### 3. Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
# clone activity dataset to activity_filled
activity_filled<-activity

# loop all rows and fill the ones with NAs
for (n in 1:nrow(activity_filled)){
  if(is.na(activity_filled$steps[n])){
      activity_filled$steps[n]<-stepsbyinterval[which(activity_filled$interval[n]==stepsbyinterval$interval),'steps']
  }
}
```

### 4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. 


```r
# calculate sum of steps per day
stepsbyday_filled<-aggregate(steps~date,activity_filled,sum,na.rm=TRUE)
# plot the histogram
hist(stepsbyday_filled$steps, col='darkgreen', xlab='Total steps', main='histogram of the total number of steps taken each day')
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png) 

```r
# calculate mean
act_mean<-mean(stepsbyday_filled$steps)
act_mean
```

```
## [1] 10766.19
```

```r
# calculate median
act_median<-median(stepsbyday_filled$steps)
act_median
```

```
## [1] 10766.19
```

The mean total number of steps taken per day is **10766.1886792** and the median is **10766.1886792**.

Do these values differ from the estimates from the first part of the assignment? **No, they remained almost the same.**

What is the impact of imputing missing data on the estimates of the total daily number of steps? **We noticed an increase on the frequency as expected since we inserted more values. As we used mean values to fill the NA values, the shape of the histogram and the mean and median values remained almost the same.**


## Are there differences in activity patterns between weekdays and weekends?
### 1. Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
# create a period column and fill with weekend or weekday
activity_filled$period<-weekdays(strptime(activity_filled$date,format='%Y-%m-%d'))
activity_filled[activity_filled$period=='Saturday' | activity_filled$period=='Sunday',]$period<-'weekend'
activity_filled[activity_filled$period!='weekend',]$period<-'weekday'
```

### 2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). The plot should look something like the following, which was created using simulated data:


```r
# aggregate average steps by interval + period (weekday or weekend)
stepsbyperiod<-aggregate(steps~interval+period,activity_filled,mean)

# plot histogram weekday vs weekend

ggplot(data=stepsbyperiod) + geom_line(aes(interval,steps,col=period)) +
      facet_grid(period ~ ., scales="fixed", space="fixed") + labs(y="Average number of steps", title="Average number of steps by 5-minute period on weekends and weekdays")
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png) 

As we can see on the plots, the number of steps starts to increase earlier during weekdays. On the other hand, the average number of steps during the weekends (42.3664013) is slightly greater than the weekdays average (35.6105812).
