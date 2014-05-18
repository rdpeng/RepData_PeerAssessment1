# Peer Assessment 1 of Reproduce Research
========================================================


```r
library(lattice)
```


## Loading and preprocessing the data

```r
activity <- read.csv("activity.csv", header = TRUE, colClasses = c("integer", 
    "Date", "integer"))
head(activity)
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
tail(activity)
```

```
##       steps       date interval
## 17563    NA 2012-11-30     2330
## 17564    NA 2012-11-30     2335
## 17565    NA 2012-11-30     2340
## 17566    NA 2012-11-30     2345
## 17567    NA 2012-11-30     2350
## 17568    NA 2012-11-30     2355
```


## What is mean total number of steps taken per day?
- Make a histogram of the total number of steps taken each day

```r
totalStepsByDay <- sapply(with(activity, split(steps, date)), sum, na.rm = T)
hist(totalStepsByDay, xlab = "Total Steps Per Day", main = "Histogram of Total Steps Per Day")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

- Calculate and report the mean and median total number of steps taken per day

```r
meanStepsByDay <- mean(totalStepsByDay)
medianStepsByDay <- median(totalStepsByDay)
```

## What is the average daily activity pattern?
- Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
avgStepsByInterval <- sapply(with(activity, split(steps, interval)), mean, na.rm = T)
intervals <- names(avgStepsByInterval)
plot(intervals, avgStepsByInterval, type = "l")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 

```r

names(which.max(avgStepsByInterval))
```

```
## [1] "835"
```

## Inputing missing values
- Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```r
sum(is.na(activity))
```

```
## [1] 2304
```

- Filling in all of the missing values in the dataset with the mean for that 5-minute interval.
- Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
missingIndices <- which(is.na(activity))
new_activity <- activity
for (i in missingIndices) {
    if (is.na(activity[i, ]$steps)) {
        new_activity[i, ]$steps = avgStepsByInterval[as.character(activity[i, 
            ]$interval)]
    }
}
```


- Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.

```r
totalStepsByDayNew <- sapply(with(new_activity, split(steps, date)), sum, na.rm = T)
hist(totalStepsByDayNew, xlab = "Total Steps Per Day", main = "Histogram of Total Steps Per Day New")
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

```r
newMeanStepsByDay <- mean(totalStepsByDayNew)
newMedianStepsByDay <- median(totalStepsByDayNew)
```

The new mean of steps is **1.0766 &times; 10<sup>4</sup>** and the old one is **9354.2295**  
The new median of steps is **1.0766 &times; 10<sup>4</sup>** and the old one is **10395**

## Are there differences in activity patterns between weekdays and weekends?
- Create a new factor variable in the dataset with two levels  weekday and weekend indicating whether a given date is a weekday or weekend day.

```r
new_activity$dayType <- with(new_activity, ifelse(weekdays(date) == "Saturday" | 
    weekdays(date) == "Sunday", "Weekend", "Weekday"))
```


- Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).

```r
avgStepsByInterval_DT <- with(new_activity, aggregate(steps, by = list(interval, 
    dayType), mean))
names(avgStepsByInterval_DT) <- c("interval", "dayType", "steps")
xyplot(steps ~ interval | dayType, data = avgStepsByInterval_DT, type = "l", 
    layout = c(1, 2), ylab = "Number of Steps")
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 

