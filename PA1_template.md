---
title: "Untitled"
author: "Jiangjue"
date: "2015年9月18日"
output: html_document
---


```r
a<-read.csv("activity.csv",sep=",",header = T)
a$interval<-as.factor(a$interval)
```

**What is mean total number of steps taken per day?**


```r
a_sum<-data.frame()
for(i in 1:61){
  a_sum[i,1]<-levels(a$date)[i]
  a_sum[i,2]<-sum(a$step[a$date==levels(a$date)[i]])
}
colnames(a_sum)<-c("date","total_steps")
hist(a_sum$total_steps)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png) 

```r
me<-mean(a_sum$total_steps,na.rm=T)
med<-median(a_sum$total_steps,na.rm = T)
```
The mean of the total number of steps taken per day is 1.0766189 &times; 10<sup>4</sup>.  
The median of the total number of steps taken per day is 10765.

**What is the average daily activity pattern?**

```r
a2<-data.frame()
a$interval<-as.factor(a$interval)
for(i in 1:288){
  a2[i,1]<-levels(a$interval)[i]
  a2[i,2]<-mean(a$steps[a$interval==levels(a$interval)[i]],na.rm = T)
}
colnames(a2)<-c("interval","averge_steps")
plot(a2$interval,a2$averge_steps,type="l")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

```r
maxx<-max(a2$averge_steps,na.rm = T)
mast<-a2$interval[a2$averge_steps==maxx]
mast<-mast[!is.na(mast)]
```
on average across all the days in the dataset, 835 contains the maximum number of steps.

**Imputing missing values**

```r
nato<-sum(is.na(a$steps))
aa<-a
aa$interval<-as.factor(aa$interval)
for(i in 1:288){
  aa$steps[((is.na(aa$steps)))&aa$interval==levels(aa$interval)[i]]<-a2$averge_steps[a2$interval==levels(a$interval)[i]]
}
aa_sum<-data.frame()
for(i in 1:61){
  aa_sum[i,1]<-levels(aa$date)[i]
  aa_sum[i,2]<-sum(a$step[aa$date==levels(aa$date)[i]])
}
colnames(aa_sum)<-c("date","total_steps")
hist(aa_sum$total_steps)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

```r
me2<-mean(aa_sum$total_steps,na.rm=T)
med2<-median(aa_sum$total_steps,na.rm = T)
```
total number of missing values is 2304.    
The mean of the total number of steps taken per day is 1.0766189 &times; 10<sup>4</sup>.    
The median of the total number of steps taken per day is 10765.  
After imputing the data with  mean for that 5-minute interval, the mean and median value are identical with unimputing data.

**Are there differences in activity patterns between weekdays and weekends?**


```r
aa$weekdays<-weekdays(as.POSIXct(a$date, tz = "GMT"), abbreviate = FALSE)
aa$weekdays[aa$weekdays==c("星期一")|aa$weekdays==c("星期二")|
             aa$weekdays==c("星期三")|aa$weekdays==c("星期四")
           |aa$weekdays==c("星期五")]<-c("weekday")
aa$weekdays[aa$weekdays==c("星期六")|aa$weekdays==c("星期日")]<-c("weekend")
b<-aa
b$interval<-as.factor(b$interval)
b2<-data.frame()
k<-1
for(i in 1:288){
  b2[k,1]<-levels(b$interval)[i]
  b2[k,2]<-mean(b$steps[b$interval==levels(b$interval)[i]&b$weekdays=="weekday"],na.rm = T)
  b2[k,3]<-c("weekday")
  k<-k+1
  b2[k,1]<-levels(b$interval)[i]
  b2[k,2]<-mean(b$steps[b$interval==levels(b$interval)[i]&b$weekdays=="weekend"],na.rm = T)
  b2[k,3]<-c("weekend")
  k<-k+1
}
colnames(b2)<-c("interval","number of steps","weekdays")
library(lattice)
b2<- transform(b2, weekdays = factor(weekdays))
xyplot(number.of.steps ~ interval | weekdays,data=b2,type="l",layout = c(1,2))
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 

