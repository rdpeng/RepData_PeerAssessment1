<<<<<<< HEAD
Peer Assessment 1 Assignment
-----------------------------

*Load the Data*

The first step in this assignment is to load the activity monitoring data. The code to 

do this is below. 


```r
x<-read.csv("activity.csv")
```

*What is mean total number of steps taken per day?*

We now want to generate a histogram for the total number of steps taken each day. The 

code to do this is shown below, followed by the histogram itself. 


```r
y<-na.omit(aggregate(x[1],x[2],sum))
s<-y[,2]
hist(s,main="Histogram of total number of steps taken each day",xlab="Total number of steps taken each day")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png) 

We now want to calculate and report the mean and median total number of steps taken per 

day. The code is shown below followed by the output. 


```r
#mean  
mean(s)
```

```
## [1] 10766.19
```

```r
#median 
median(s)
```

```
## [1] 10765
```

The mean number of steps taken per day is 10766.19 steps and the median number of steps 

taken per day is 10765 steps. 

*What is the average daily activity pattern?*

Next, we will generate a time series plot (i.e. type = "l") of the 5-minute interval 

(x-axis) and the average number of steps taken, averaged across all days (y-axis). The 

code is shown below, followed by the time series plot. 


```r
aa<-na.omit(x)
aaa<-aggregate(aa[1],aa[3],mean)
ss<-aaa[,2]
sss<-aaa[,1]
plot(sss,ss,type="l",main = "Time Series Plot of Average Daily Activity",xlab="5 minute interval",ylab="Average number of steps taken, averaged across all days")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

We now will determine which 5-minute interval, on average across all the days in the 

dataset, contains the maximum number of steps. The code to determine this is shown below 

followed by the output. 


```r
aaa[aaa[2]==max(aaa[2]),]
```

```
##     interval    steps
## 104      835 206.1698
```

The 5-minute interval 835 contains the maximum number of steps, on average across all the 

days in the dataset. This is confirmed in the time series plot above where the x value of 

the maximum is a slightly to the left of 1000 corresponding to the 835 value in the 

output and the y value of the maximum is slightly above 200 corresponding to the 206.1698 

value in the output.

*Inputting missing values*

We will now calculate and report the total number of missing values in the dataset (i.e. 

the total number of rows with NAs). The code is below, followed by the output. 


```r
nrow(x)-nrow(na.omit(x))
```

```
## [1] 2304
```

The total number of missing values in the dataset or total number of rows with NAs is 

2304.

Now, we will develop a strategy for filling in all of the missing values in the dataset. 

The strategy will be to fill in the missing values with the mean for the 5 minute

interval.This strategy will be used to create a new dataset that is equal to the 

original dataset but with the missing data filled.The code for this is below. 


```r
x2<-x
for(i in 1:nrow(x2)){
  if(is.na(x2[i,1])){
		for(ii in 1:nrow(aaa)){
			if(x2[i,3]==aaa[ii,1]){
				x2[i,1]<-aaa[ii,2]
			}
		}
	}
}
```

Now we will generate a histogram for the total number of steps taken each day. This is 

similar to our previous histogram, except now we are including the rows with missing 

data filled.The code for this is below, followed by the histogram. 


```r
yy<-aggregate(x2[1],x2[2],sum)
s<-yy[,2]
hist(s,main="Histogram of total number of steps taken each day",xlab="Total number of steps taken each day")
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png) 

We now want to calculate and report the mean and median total number of steps taken per 

day once the missing NA values are filled in. The code is shown below followed by the 

output. 


```r
#mean  
mean(s)
```

```
## [1] 10766.19
```

```r
#median 
median(s)
```

```
## [1] 10766.19
```

The mean total number of steps taken per day is the same as when we omitted rows with NA 

values. There was a mean 10766.19 steps per day omitting NA values and a mean of 10766

.19 steps per day when filling in for those NA values. However, the median total number 

of steps taken per day has increased when we fill in the mean for the 5-minute interval 

in place of NA values. There was a median of 10,765 steps per day when omitting NA 

values and a median of 10,766.19 steps per day when filling in for those NA values. 

*Are there differences in activity patterns between weekdays and weekends?*

We will now create a new factor variable in the dataset with two levels – “weekday” and 

“weekend” indicating whether a given date is a weekday or weekend day. The code for this 

is shown below.


```r
sss<-x2[,2,]
x2[["Day of Week"]]<-weekdays(as.Date(sss))
for (i in 1:nrow(x2)){
  if(x2[i,4]=="Saturday"|x2[i,4]=="Sunday")
		x2[i,4]<-"weekend"
	else
		x2[i,4]<-"weekday"
}
```

Finally, we will make a panel plot containing a time series plot (i.e. type = "l") of 

the 5-minute interval (x-axis) and the average number of steps taken, averaged across 

all weekday days and all weekend days (y-axis). The code to do this is shown below, 

followed by the panel plot. 


```r
weekendavg<-numeric()
weekendinterval<-numeric()
weekdayavg<-numeric()
weekdayinterval<-numeric()
for (i in 1:nrow(x2)){
  if(x2[i,4]=="weekend"){
		weekendavg<-c(weekendavg,x2[i,1])
		weekendinterval<-c(weekendinterval,x2[i,3])
		}
	else
	{
		weekdayavg<-c(weekdayavg,x2[i,1])
		weekdayinterval<-c(weekdayinterval,x2[i,3])	
	}
}
weekendvector<-data.frame(weekendavg,weekendinterval)
weekdayvector<-data.frame(weekdayavg,weekdayinterval)
d<-aggregate(weekendvector[1],weekendvector[2],mean)
e<-aggregate(weekdayvector[1],weekdayvector[2],mean)
dd<-d[,1]
ee<-d[,2]
ff<-e[,2]
library(lattice)
weekday<-ff 
weekend<-ee
Interval<-dd
xyplot(weekday + weekend ~ Interval, layout = c(1,2), type = "l", outer = TRUE,ylab="Average number of steps taken, averaged across all days")
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png) 

=======
---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---


## Loading and preprocessing the data



## What is mean total number of steps taken per day?



## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
>>>>>>> 80edf39c3bb508fee88e3394542f967dd3fd3270
