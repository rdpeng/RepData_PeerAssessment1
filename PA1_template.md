# PA1_template.Rmd
Neil  
April 9, 2017  
This is the Course Project #2 for Reproducible Research course.



## R Markdown

First thing I do is read the data in with the following code. 


```r
setwd("C:/Users/Neil/Desktop")
data<-read.csv("repdata_data_activity/activity.csv")
```

Then I group total steps by date


```r
library(dplyr)
```

```
## Warning: package 'dplyr' was built under R version 3.3.3
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
data2<-group_by(data,date)
data3<-summarize(data2,totalsteps=sum(steps))
```

Then I make a histogram of the total number of steps taken each day


```r
hist(data3$totalsteps)
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

Calculate and report the mean and median of the total number of steps taken per day using the following code:


```r
mean(data3$totalsteps,na.rm=TRUE)
```

```
## [1] 10766.19
```

```r
median(data3$totalsteps,na.rm=TRUE)
```

```
## [1] 10765
```

What is the average daily activity pattern?
1. Make a time series plot (i.e.  ) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis) 


```r
ByInterval<-group_by(data,interval)
AverageStepsByInterval<-summarize(ByInterval,averagesteps=mean(steps,na.rm=TRUE))
plot(AverageStepsByInterval$interval,AverageStepsByInterval$averagesteps,type="l")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

The 5-minute interval, on average across all the days in the dataset, that contains the maximum number of steps is:


```r
AverageStepsByInterval<-as.data.frame(AverageStepsByInterval)
AverageStepsByInterval[AverageStepsByInterval$averagesteps==max(AverageStepsByInterval$averagesteps),1]
```

```
## [1] 835
```

The total number of missing values in the dataset is



```r
sum(is.na(data$steps))
```

```
## [1] 2304
```


My strategy for filling in all of the missing values in the dataset is to replacte the NAs with the mean for that 5-minute interval, the following code does that. 


```r
datanoNA<-data
for(i in 1:length(datanoNA$steps)){
  if(is.na(datanoNA$steps[i])){
    interval<-datanoNA[i,3]
    intervalset<-datanoNA[datanoNA$interval==interval,]
    datanoNA$steps[i]<-mean(intervalset$steps,na.rm=TRUE)
  }
  
}
```

A histogram of the total number of steps taken each day is:



```r
data2<-group_by(datanoNA,date)
data4<-summarize(data2,totalsteps=sum(steps,na.rm=TRUE))
hist(data4$totalsteps)
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

The mean and median total number of steps taken per day are calculated with the following code:


```r
mean(data4$totalsteps,na.rm=TRUE)
```

```
## [1] 10766.19
```

```r
median(data4$totalsteps,na.rm=TRUE)
```

```
## [1] 10766.19
```

The mean did not change because the day's with NAs were replaced with the mean 10766.19. The median went up to 10766.19 because that is now the value in the middle of the dataset. 

The below chunk of code creates a new factor variable in the dataset called "dayorend" with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.


```r
data2$day<-0
data2$dayorend<-0
for(i in 1:length(data2$date)){
data2$day[i]<-weekdays(as.POSIXct(data2$date[i]))
if(data2$day[i]=="Sunday" | data2$day[i]=="Saturday"){
 data2$dayorend[i]<-"weekend"
}
else{data2$dayorend[i]<-"weekday"}
}
data2$dayorend<-as.factor(data2$dayorend)
```

Below is a panel plot containing a time series plot (i.e.  ) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).


```r
weekdays<-data2[data2$dayorend=="weekday",]
weekenddays<-data2[data2$dayorend=="weekend",]
ByIntervalWeekDay<-group_by(weekdays,interval)
ByIntervalWeekendDay<-group_by(weekenddays,interval)
AveWeekday<-summarize(ByIntervalWeekDay,averagesteps=mean(steps,na.rm=TRUE))
AveWeekendday<-summarize(ByIntervalWeekendDay,averagesteps=mean(steps,na.rm=TRUE))
par(mfrow = c(2, 1), mar = c(2, 2, 2, 2))
plot(AveWeekday$interval,AveWeekday$averagesteps,main="Weekday",type="l")
plot(AveWeekendday$interval,AveWeekendday$averagesteps,type="l",main="Weekend")
```

![](PA1_template_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

