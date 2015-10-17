---
title: "rr project pa1"
output: html_document
---

Loading and preprocessing the data
Show any code that is needed to
Load the data (i.e. read.csv())
Process/transform the data (if necessary) into a format suitable for your analysis


```r
library(lattice)
a<-na.omit(read.csv("activity.csv"))
```


What is mean total number of steps taken per day?
For this part of the assignment, you can ignore the missing values in the dataset.
Calculate the total number of steps taken per day
If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day
Calculate and report the mean and median of the total number of steps taken per day

```r
agg.d<-aggregate(steps~date,data=a,sum)
hist(agg.d$steps)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png) 

```r
print("mean:  ",quote=FALSE)
```

```
## [1] mean:
```

```r
mean(agg.d$steps)
```

```
## [1] 10766.19
```

```r
print("median:  ",quote=FALSE)
```

```
## [1] median:
```

```r
median(agg.d$steps)
```

```
## [1] 10765
```

What is the average daily activity pattern?
Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
barplot(agg.d$steps)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

```r
agg.int<-aggregate(steps~interval,data=a,mean)
with(agg.int,plot(interval,steps,type="l"))
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-2.png) 

```r
i<-which.max(agg.int$steps)
print("interval with maximum number of steps:",quote=FALSE)
```

```
## [1] interval with maximum number of steps:
```

```r
agg.int[i,1]
```

```
## [1] 835
```

Imputing missing values
Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.
Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
Create a new dataset that is equal to the original dataset but with the missing data filled in.
Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
b<-read.csv("activity.csv")
print("Number of blanks:",quotes=FALSE)
```

```
## [1] "Number of blanks:"
```

```r
sum(is.na(b$steps))
```

```
## [1] 2304
```

```r
c<-merge(b,agg.int,by="interval")
c.new<-c[order(c$date,c$interval),]
nas<-is.na(c.new$steps.x)
nonas<-!is.na(c.new$steps.x)
replace<-nas*c.new$steps.y
#need to set NA's in c.new$steps.y to 0
c.new$steps.x[is.na(c.new$steps.x)] <- 0
keep<-nonas*c.new$steps.x
c.new[,5]<-replace+keep
dataNew<-c.new[,c(1,3,5)]
colnames(dataNew)[3]<-"steps"

agg.dataNew<-aggregate(steps~date,data=dataNew,sum)
hist(agg.dataNew$steps)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

```r
print("mean:  ",quote=FALSE)
```

```
## [1] mean:
```

```r
mean(agg.dataNew$steps)
```

```
## [1] 10766.19
```

```r
#replacing with the mean yields median = mean
print("median:  ",quote=FALSE)
```

```
## [1] median:
```

```r
median(agg.dataNew$steps)
```

```
## [1] 10766.19
```

Are there differences in activity patterns between weekdays and weekends?
For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.
Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.
Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.

```r
wd<-weekdays(as.Date(dataNew$date))
weekday<-c("Monday","Tuesday","Wednesday","Thursday","Friday")
dataNew$wdf<-as.factor(ifelse(wd %in% weekday, "weekday","weekend"))
agg.int.New<-aggregate(steps~interval+wdf,data=dataNew,mean)
with(agg.int.New,xyplot(steps~interval|wdf,type="l"))
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 



