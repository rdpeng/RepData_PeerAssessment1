# Reproducible Research: Peer Assessment 1

Bikash Maharjan
March 26, 2016  

# Introduction

This report is a part of an assignment for Data Science Specialization Course offered by John Hopkins University through Coursera. Here, we are creating a report on a study of Activity Monitorin Data answering various questions about the dataset.



## Loading and preprocessing the data
- Extract zip file

```r
if(!file.exists("activity.csv"))
{
    if(file.exists("activity.zip"))
    {
        unzip("activity.zip")
    }
}
```

- Load Data

```r
activity<-read.csv("activity.csv")
```

- Process/transform the data (if necessary) into a format suitable for your analysis

```r
activity$steps<-as.numeric(activity$steps)
```

## What is mean total number of steps taken per day?

- Calculate the total number of steps taken per day

```r
totalSteps<-aggregate(steps~date,data=activity,FUN=sum,na.rm=TRUE)
```

- Make a histogram of the total number of steps taken each day

```r
hist(totalSteps$steps,breaks=15,col="Red",xlab="Total Steps",ylab="Number of days", main = "Histogram of Total Number of Steps taken each day")
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)\

- Calculate and report the mean and median of the total number of steps taken per day

```r
stepsMean<-mean(totalSteps$steps)
stepsMedian<-median(totalSteps$steps)
```


```
## [1] "Mean:  10766.1886792453"
```

```
## [1] "Median:  10765"
```

## What is the average daily activity pattern?
- Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
averageSteps<-aggregate(steps~interval,data = activity,FUN=mean,na.rm=TRUE)
plot(averageSteps$interval,averageSteps$steps,type="l",xlab="5-minute interval",ylab="Average Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)\

- Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
averageSteps[which.max(averageSteps$steps),]$interval
```

```
## [1] 835
```

## Imputing missing values
- Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)


```r
sum(is.na(activity$steps))
```

```
## [1] 2304
```

- Devise a strategy for filling in all of the missing values in the dataset. Using mean for that 5-minute interval

```r
averageStepsForInterval<-function(intVal)
{
    averageSteps[averageSteps$interval==intVal,]$steps
}
```

- Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
newActivity<-activity

for(i in 1:nrow(newActivity))
{
    if(is.na(newActivity[i,]$steps))
    {
        newActivity[i,]$steps<-averageStepsForInterval(newActivity[i,]$interval)
    }
}
```

- Make a histogram of the total number of steps taken each day

```r
newTotalSteps<-aggregate(steps~date,data=newActivity,FUN=sum)
hist(newTotalSteps$steps,xlab="Total Steps",ylab="Number of Days",col = "blue",breaks=15)
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)\

- Calculate and report the mean and median total number of steps taken per day.


```r
mean(newTotalSteps$steps)
```

```
## [1] 10766.19
```

```r
median(newTotalSteps$steps)
```

```
## [1] 10766.19
```

- Do these values differ from the estimates from the first part of the assignment?

No, the mean and median do not really differ 

## Are there differences in activity patterns between weekdays and weekends?
- Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.


```r
newActivity$day<-ifelse(weekdays(as.Date(newActivity$date)) %in% c("Saturday","Sunday"),"weekend","weekday")
newActivity$day=factor(newActivity$day,levels=c("weekday","weekend"))
```

- Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).


```r
newActivity=aggregate(steps~interval+day,newActivity,mean)
library(lattice)
xyplot(steps~interval|factor(day),data=newActivity,aspect=1/2,type="l",ylab="Number of Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-16-1.png)\
