

#COURSERA:Reproducible Research's 1st peer assignment


##Loading and preprocessing the data


```r
data<-read.csv("d:/Coursera/5Reproducible Research/project1/activity.csv",header=T)
```


##What is mean total number of steps taken per day?

ignore the missing values in the dataset.


1.Make a histogram of the total number of steps taken each day


```r
day<-levels(data$date);num<-rep(0,times=61)
total<-data.frame(day,num)
for(i in 1:61){
    total$num[i]<-sum(data$steps[data$date==day[i]],na.rm=T)
}
library(ggplot2)
qplot(num,data=total,fill=day)
```

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust this.
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png) 


2.Calculate and report the mean and median total number of steps taken per day


```r
mean(total$num)
```

```
## [1] 9354.23
```

```r
median(total$num)
```

```
## [1] 10395
```


##What is the average daily activity pattern?


1.Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
int<-levels(as.factor(data$interval));average<-rep(0,times=288)
ave<-data.frame(int,average)
for(i in 1:288){
    ave$average[i]<-mean(data$steps[data$interval==int[i]],na.rm=T)
}
plot(ave$average~ave$int,type="b")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 


2.Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
ave$int[which.max(ave$average)]
```

```
## [1] 835
## 288 Levels: 0 10 100 1000 1005 1010 1015 1020 1025 1030 1035 1040 ... 955
```


##Imputing missing values


1.Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)


```r
sum(!complete.cases(data))
```

```
## [1] 2304
```


2.Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.


```r
data$newsteps<-data$steps
for(i in 1:17568){
    if(is.na(data[i,1])){
        data[i,4]<-ave$average[ave$int==data[i,3]]
    }
}
```


3.Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
newdata<-data.frame(data[,4],data[,2],data[,3])
```


4.Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
newtotal<-data.frame(day,num)
for(i in 1:61){
    newtotal$num[i]<-sum(newdata[newdata[,2]==day[i],1])
}
library(ggplot2)
qplot(num,data=newtotal,fill=day)
```

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust this.
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png) 

```r
mean(newtotal$num)
```

```
## [1] 10766.19
```

```r
median(newtotal$num)
```

```
## [1] 10766.19
```

These values do differ from the estimates from the first part of the assignment.


##Are there differences in activity patterns between weekdays and weekends?


1.Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.


```r
newdata$wd<-weekdays(as.Date(newdata[,2]))
newdata$wd[newdata$wd=="星期六"|newdata$wd=="星期日"]<-"weekend"
newdata$wd[newdata$wd %in% c("星期一","星期二","星期三","星期四","星期五")]<-"weekday"
```


2.Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.


```r
oldpar<-par(mfrow=c(2,1))
weekdaydata<-newdata[newdata$wd=="weekday",]
WeekdayNewAve<-data.frame(int,average)
for(i in 1:288){
    WeekdayNewAve$average[i]<-mean(weekdaydata[weekdaydata[,3]==int[i],1])
}
plot(WeekdayNewAve$average~WeekdayNewAve$int)
weekenddata<-newdata[newdata$wd=="weekend",]
WeekendNewAve<-data.frame(int,average)
for(i in 1:288){
    WeekendNewAve$average[i]<-mean(weekenddata[weekenddata[,3]==int[i],1])
}
plot(WeekendNewAve$average~WeekendNewAve$int)
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png) 

```r
par(oldpar)
```



