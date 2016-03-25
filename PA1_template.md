# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
Load the data from file and preprocess it.


```r
md <- read.csv("activity.csv",sep=",")
md$date <- strptime(md$date, format="%Y-%m-%d")
md$rawdate <- strftime(md$date, format="%Y-%m-%d") 
md$daytype <- as.factor(ifelse(weekdays(md$date)=="samedi"|weekdays(md$date)=="dimanche","weekend","weekday"))
```



## What is mean total number of steps taken per day?
Calculate dayly totals of steps and the mean and the median of these values


```r
dateagg <- aggregate(steps~rawdate, md, FUN=sum)
vmean <- mean(md$steps,na.rm=T)
vmedian <- median(md$steps,na.rm=T)
hist(dateagg$steps,main="Total number of steps taken each day",xlab="",ylab="")  
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)

  
The mean of the dayly total of steps is 37.3825996.  
The median of the dayly total of steps is 0.   


## What is the average daily activity pattern?
Calculate the average number of steps taken per 5-minute interval, averaged across all days.


```r
intagg <- aggregate(steps~interval, md, FUN=mean)
vmax <- intagg[intagg$steps==max(intagg$steps),1]
plot(intagg$interval,intagg$steps, type="l", ylab="Averaged number of steps", xlab="5-minutes interval")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)

The interval with the average maximum number of steps is 835th interval.

## Imputing missing values

First, a new data set is created with the original data set and the average number of steps by interval.
A new variable "imputed.steps" is created that contains the value of steps when this one is not missing
and the average number of steps by interval when the value is missing.


```r
vsumna <- sum(is.na(md$steps))

names(intagg)[names(intagg)=="steps"]<- "averageByInterval"
newmd <- merge(md,intagg,all.x=T,by.x="interval",by.y="interval")
newmd$imputed.steps <- ifelse(is.na(newmd$steps), newmd$averageByInterval, newmd$steps)

dateagg2 <- aggregate(imputed.steps~rawdate, newmd, FUN=sum)
vmean2 <- mean(md$steps,na.rm=T)
vmedian2 <- median(md$steps,na.rm=T)
hist(dateagg2$imputed.steps,main="Total number of steps taken each day (imputed values)",xlab="",ylab="")  
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)
  
Number of missing values: 2304.  
Mean number of steps (with imputed values): 37.3825996.  
Median number of steps (with imputed values): 0.  


## Are there differences in activity patterns between weekdays and weekends?


```r
daytypeagg <- aggregate(imputed.steps~(interval*daytype), newmd, FUN=mean)
library(ggplot2)
g <- ggplot(daytypeagg,aes(interval,imputed.steps))
g <- g+geom_line()+ylab("Averaged number of steps")+xlab("Interval")
g+facet_grid(daytype ~ .)+ggtitle("Differences between weekdays and weekends")
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)


