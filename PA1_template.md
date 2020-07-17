Activity Analysis
======================

In this project we are going to analyse the activity of individuals.

Let us first load and process the data!


```r
activity <- read.csv("activity.csv")
activity$date <- as.Date(activity$date)
activityWNA <- subset(activity,complete.cases(activity))
```

Let us now find the mean of no. of steps taken daily!


```r
dailysteps <- with(activityWNA,tapply(steps,date,sum))
hist(dailysteps,col = "sky blue",main = "Histogram of no. of steps taken per day")
```

![plot of chunk mean steps](figure/mean steps-1.png)

```r
meansteps <- round(mean(dailysteps))
mediansteps <- median(dailysteps)
```

The mean of no. of steps taken daily is 1.0766 &times; 10<sup>4</sup> and median is 10765.

Now that we have analyzed the data on the basis of days, we should now analyze the data on the basis of intervals


```r
intervalsteps <- aggregate(steps~interval, activityWNA,mean)
plot(intervalsteps$interval,intervalsteps$steps,type = "l",xlab="5 min intervals",ylab = "average steps")
```

![plot of chunk time series interval](figure/time series interval-1.png)

```r
maxsteps <- max(intervalsteps$steps)
max_interval <- intervalsteps[which.max(intervalsteps$steps),1]
```

The maximum no. of steps in a five minute interval average across all the dates is 206.1698113 occurs during 835-840.

Now let us try to average out the Not Available Data.

```r
activityNA <- activity[!complete.cases(activity),]
countNA <- nrow(activityNA)
```

The no. of NA in the data is 2304.


```r
for(i in 1:nrow(activity)){
        if(is.na(activity[i,1])){
                interval1 <- activity[i,3]
                activity[i,1] <- intervalsteps[intervalsteps$interval==2220,]$steps
        }
}
dailysteps2 <- with(activity,tapply(steps,date,sum))
hist(dailysteps2,col = "sky blue",main = "Histogram of no. of steps taken per day")
```

![plot of chunk replacing NA](figure/replacing NA-1.png)

```r
meansteps2 <- round(mean(dailysteps2))
mediansteps2 <- median(dailysteps2)
```

The mean of no. of steps taken daily is 9621 and median is 1.0395 &times; 10<sup>4</sup>.

So, as we see the mean and median have been significantly changed if we replace the NA values with the average of the values for the same interval on other days.


```r
day <- weekdays(as.Date(activityWNA$date))
day0 <- vector()
for(i in 1:nrow(activityWNA)){
        if(day[i]=="Saturday" | day[i] == "Sunday"){
                day0[i] <- "weekend"
        }
        else{
                day0[i] <- "weekday"
        }
}
activityWNA$day0 <- day0
intervalsteps2 <- aggregate(steps~interval+day0,activityWNA,mean)
library(lattice)
xyplot(steps~interval | day0,intervalsteps2,type = "l",layout = c(1,2),xlab = "interval",ylab = "No. of steps")
```

![plot of chunk weekdays vs weekends](figure/weekdays vs weekends-1.png)





