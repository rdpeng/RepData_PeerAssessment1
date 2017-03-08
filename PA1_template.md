# Reproducible Research: Peer Assessment 1



## Loading and preprocessing the data

```r
if(!file.exists('activity.csv')){
    unzip('activity.zip')
}
data <- read.csv("activity.csv", header=T, sep=",")
```

## What is mean total number of steps taken per day?

##### 1. Calculate total number of steps taken each day and make a histogram

```r
total.steps <- tapply(data$steps, data$date, FUN=sum, na.rm=TRUE)
qplot(total.steps, xlab='Total steps per day', ylab='Frequency', binwidth=400)
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

##### 2. Calculate and report the mean and median of the total number of steps taken per day

```r
mean.steps <- mean(total.steps)
meadian.steps <- median(total.steps)
```
* Mean total number of steps taken per day: 9354.2295082
* Median total number of steps taken per day:  10395


## What is the average daily activity pattern?

##### 3. Calculate the average number of steps taken, averaged across all days, per 5-minute interval:

```r
avg.StepsPerInterval <- aggregate(x=list(steps=data$steps), by=list(interval=data$interval), FUN=mean, na.rm=TRUE)
```

##### 4. Make a time series plot of the calculation

```r
ggplot(data=avg.StepsPerInterval, aes(x=interval, y=steps)) +
    geom_line() +
    xlab("5-minute interval") +
    ylab("Average number of steps taken")
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

##### 5. Find the 5-minute interval, on average across all the days in the dataset, that contains the maximum number of steps

```r
maxSteps <- which.max(avg.StepsPerInterval$steps)
interval.maxSteps <- avg.StepsPerInterval[maxSteps,'interval']
Number.maxSteps <- avg.StepsPerInterval[maxSteps,'steps']
```

* Interval with maximum number of steps: 835
* Maximum number of steps: 206.1698113


## Imputing missing values

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

##### 6. Calculate and report the total number of missing values in the dataset. 

```r
number.MissingValues <- length(which(is.na(data$steps)))
```

* Number of missing values: 2304

##### 7. All of the missing values are filled in with mean value for that 5-minute interval and saved to a new dataset.

```r
fill.val <- function(steps, interval) {
    if (!is.na(steps))
        fill <- c(steps)
    else
        fill <- (avg.StepsPerInterval[avg.StepsPerInterval$interval==interval, "steps"])
    return(fill)
}
filled.data <- data
filled.data$steps <- mapply(fill.val, filled.data$steps, filled.data$interval)
```

##### 8. Using the filled data set, we make a histogram of the total number of steps taken each day and calculate the mean and median total number of steps.

```r
total.steps <- tapply(filled.data$steps, filled.data$date, FUN=sum)
qplot(total.steps, xlab="Total steps per day (NA's filled with mean value)", ylab="Frequency", binwidth=400)
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

```r
mean.imputed <- mean(total.steps)
median.imputed <- median(total.steps)
```

* Mean after imputing missing values: 1.0766189\times 10^{4}
* Median after imputing missing values:  1.0766189\times 10^{4}

Unsurprisingly, mean and median values are higher after imputing missing data. In the original data, there are some days with `steps` values equals to `NA` for any `interval`. The total number of steps are in these cases set to 0s by default. However, after replacing missing `steps` values with the mean `steps` of associated `interval` value, these 0 values are no longer part of the histogram. 


## Are there differences in activity patterns between weekdays and weekends?

##### 9. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
filled.data$dayType <-  ifelse(as.POSIXlt(filled.data$date)$wday %in% c(0,6), 'weekend', 'weekday')
```

##### 10. Make a panel plot containing plots of average number of steps taken on weekdays and weekends.

```r
avg.filled.data <- aggregate(steps ~ interval + dayType, data=filled.data, mean)
ggplot(avg.filled.data, aes(interval, steps)) + 
    geom_line() + 
    facet_grid(dayType ~ .) +
    xlab("5-minute interval") + 
    ylab("Average number of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-12-1.png)<!-- -->
