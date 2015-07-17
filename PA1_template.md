# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data


```r
DF <- read.csv("activity.csv")
```



## What is mean total number of steps taken per day?

Simply takes the sum of the intervals about each date and removing all NAs.


```r
StepsPerDay <- sapply(split(DF,DF$date),function(f)sum(f$steps,na.rm = T))
hist(StepsPerDay,main = "Total number of steps per day",xlab = "Number of steps",ylab = "Frequency")
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

```r
median(StepsPerDay)
```

```
## [1] 10395
```

```r
mean(StepsPerDay)
```

```
## [1] 9354.23
```


## What is the average daily activity pattern?


```r
library(ggplot2)
Intervals <- as.numeric(levels(as.factor(DF$interval))) ## Storing numerically the interval values
StepInt <- sapply(split(DF,DF$interval),function(f)mean(f$steps,na.rm = T))
qplot(Intervals,StepInt,geom = "line",main = "Averaged Steps by Intervals",xlab = "Intervals (minutes)",ylab = "Number of Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 

```r
names(StepInt)<-Intervals
names(StepInt[StepInt==max(StepInt)])
```

```
## [1] "835"
```

You can see that at interval 835 there is the most steps (on average).



## Imputing missing values

Total missing values count: 2304.


```r
sum(is.na(DF$steps)|is.na(DF$date)|is.na(DF$interval))
```

```
## [1] 2304
```

To fill in missing values I input the mean for that interval. Another sensible approach is to input the mean of the day's steps (to conserve the mean for the day) but some date's step data are entirely missing. Ergo I use the former.


```r
for(i in 1:length(DF$steps))if(is.na(DF[i,"steps"])){
      DF[i,"steps"] <- unname(StepInt[Intervals==DF[i,"interval"]])
}
```

Plotting:


```r
SimTotalSteps <- sapply(split(DF,DF$date),function(f)sum(f$steps))
hist(SimTotalSteps,main = "Simulated Data (NAs filled)",xlab = "Number of steps",ylab = "Frequency")
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png) 



## Are there differences in activity patterns between weekdays and weekends?


```r
daytype <- weekdays(strptime(DF$date,"%Y-%m-%d"))
DF[,"daytype"] <- as.factor(sapply(daytype,function(f){if(f=="Sunday"|f=="Saturday"){"weekend" }else{"weekday"}}))
qplot(Intervals,StepInt,data = DF,geom = "line",main = "Averaged Steps by Intervals (Sim data)",xlab = "Intervals (minutes)",ylab = "Number of Steps",facets = .~daytype)
```

```
## Warning in data.frame(x = c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55,
## : row names were found from a short variable and have been discarded
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png) 
