# Peer-graded Assignment: Course Project 1
##Author: Linying Zhang
##Date: 13-Feb-2018


```r
library(ggplot2)
```

## Loading the data

```r
data <- read.csv('activity.csv')
#explorate data
head(data)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```

```r
summary(data)
```

```
##      steps                date          interval     
##  Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
##  1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
##  Median :  0.00   2012-10-03:  288   Median :1177.5  
##  Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
##  3rd Qu.: 12.00   2012-10-05:  288   3rd Qu.:1766.2  
##  Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
##  NA's   :2304     (Other)   :15840
```

## What is mean total number of steps taken per day?
####1.total number of steps per day

```r
stepsPerDay <- tapply(data$steps, data$date, sum, na.rm = TRUE)
```
####2.histogram

```r
#dimname(stepsPerDay)  #dates
stepsdatafram<- data.frame(stepsPerDay)

ggplot(stepsdatafram,aes(x=stepsPerDay))+ 
        geom_histogram(fill="blue", binwidth = 1000) +
        labs(title = 'Total number of steps per day', x = 'steps')
```

![plot of chunk unnamed-chunk-52](figure/unnamed-chunk-52-1.png)
####3.mean and median of the total number of steps taken per day

```r
mean(stepsPerDay)
```

```
## [1] 9354.23
```

```r
median(stepsPerDay)
```

```
## [1] 10395
```


## What is the average daily activity pattern?
####1.a time series plot of the 5-minute interval and the average number of steps taken, averaged across all days

```r
stepsInterval <- aggregate(x=list(AvgSteps=data$steps), by = list(interval=data$interval), FUN = mean, na.rm = TRUE)
ggplot(stepsInterval, aes(x = interval, y=AvgSteps)) +
        geom_line(color="blue") +
        labs(title = "Mean Steps by Interval", x = "Interval", y = "Mean Steps")
```

![plot of chunk unnamed-chunk-54](figure/unnamed-chunk-54-1.png)
#2.Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
stepsInterval[which.max(stepsInterval$AvgSteps), 1]
```

```
## [1] 835
```



## Imputing missing values
##### 1.Calculate and report the total number of missing values in the dataset

```r
sum(is.na(data$steps))
```

```
## [1] 2304
```

##### 2.Devise a strategy for filling in all of the missing values in the dataset. 
Fill using median interval steps
##### 3.Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
library(Hmisc)
dataImputed <- data
for(i in seq(0,2355, by=5)){
        dataImputed[dataImputed$interval == i,]$steps <- impute(data[data$interval == i,]$steps, fun=median)
}
```


##### 4.Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.

```r
stepsPerDay2 <- tapply(dataImputed$steps, dataImputed$date, FUN = sum)
stepsPerDayfram <- data.frame(stepsPerDay2)
ggplot(stepsPerDayfram, aes(x=stepsPerDay)) +
        geom_histogram(binwidth = 1000) +
        labs(title = 'Total number of steps per day with Impute data', x = 'steps')
```

![plot of chunk unnamed-chunk-58](figure/unnamed-chunk-58-1.png)

```r
mean(stepsPerDay2)
```

```
## [1] 9503.869
```

```r
median(stepsPerDay2)
```

```
## [1] 10395
```
####Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?
The mean is larger than the first part. The median is the same.
After imputing missing data, the mean changes a little.

----

## Are there differences in activity patterns between weekdays and weekends?
##### 1.Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.


```r
dataImputed$date <- as.Date(as.character(dataImputed$date))
dataImputed$weekday <- weekdays(dataImputed$date)
dataImputed$week <- ifelse(dataImputed$weekday =="Saturday" | dataImputed$weekday =="Sunday", 'Weekend', 'Weekday')
```
##### 2. Make a panel plot containing a time series plot

```r
stepsInterval2 <- aggregate(x=(list(AvgSteps = dataImputed$steps)), by = list(interval = dataImputed$interval, weekday = dataImputed$week), FUN = mean)
ggplot(stepsInterval2, aes(x=interval, y=AvgSteps, color = weekday)) +
        geom_line()+
        facet_grid(weekday ~ .) +
        labs(title = "Mean Steps by Interval", x = "Interval", y = "Mean Steps")
```

![plot of chunk unnamed-chunk-60](figure/unnamed-chunk-60-1.png)


