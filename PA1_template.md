# Reproducible Reserach: Course Project 1



### 1. Load and preprocess the data
Load and process/transform the data into a format suitable for analysis.
  

```r
Activity <- read.table("activity.csv", header=TRUE, sep=",")
Activity$date <- as.Date(Activity$date)
```

### 2. Mean Total Number of Steps Taken Per Day
Make a histogram of the total number of steps taken each day.


```r
steps_day <- aggregate(steps ~ date, Activity, sum)
hist(steps_day$steps,
     main="Histogram of Total Steps Per Day",
     xlab="total no. of steps taken per day",
     ylab="frequency (days)",
     border="dark green",
     xlim=c(25,21200),
     breaks=10)
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

### 3. Mean and median of the total number of steps taken per day
Calculate the total number of steps taken per day.


```r
stepsSummary <- summary(steps_day$steps)
```

The mean total number of steps taken per day is 1.0766189\times 10^{4}.
The median total number of steps taken per day is 1.0765\times 10^{4}.

### 4. Average Daily Activity Pattern - Time Series Plot


```r
avgSteps_day <- aggregate(steps ~ interval, Activity, mean)

plot(avgSteps_day$steps, type="l",
     main="Average Daily Activity Pattern",
     xlab="5 minute interval",
     ylab="average number steps taken",
     col="dark green",
     lwd=1, frame.plot=FALSE)
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

### 5. The 5-minute interval that, on average, contains the maximum number of steps


```r
maxStep <- which.max(avgSteps_day$steps)
avgMaxStep <- avgSteps_day$steps[maxStep]
```

Interval 104 at 0835 contains the maximum average number of steps, with an average of 206.1698113 steps.  

### 6. Imputing missing values

a. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with 𝙽𝙰s)


```r
missingValues <- sum(is.na(Activity$steps))
```
There are 2304 rows with missing values.

b. Fill in missing values with the mean for that 5-minute interval. Create a new dataset that is equal to the original dataset with the missing data filled in.


```r
newActivity <- Activity
newActivity$steps[is.na(Activity$steps)] <- avgSteps_day$steps[is.na(Activity$steps)]
```

### 7. Histogram of the total number of steps taken each day after missing values are imputed

a. Make a histogram of the total number of steps taken each day after imputing missing values.


```r
newSteps_day <- aggregate(steps ~ date, newActivity, sum)
hist(newSteps_day$steps,
     main="Histogram of Total Steps Per Day, with imputed missing values",
     xlab="total no. of steps taken per day",
     ylab="frequency (days)",
     border="dark green",
     xlim=c(25,21200),
     breaks=10)
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

b. Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
newStepsSummary <- summary(newSteps_day$steps)
```

The mean total number of steps taken per day is 1.0766189\times 10^{4}.
The median total number of steps taken per day is 1.0765594\times 10^{4}.

These values are very similar to the original total steps per day. Imputing the mean value of each 5-minute interval for missing values caused the Median number of steps per day to increase to the value of the Mean number of steps per day.

### 8. Are there differences in activity patterns between weekdays and weekends?

a. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.


```r
week_days <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
weekdayFactor <- factor((weekdays(newActivity$date) %in% week_days), levels = c(FALSE, TRUE), 
                labels = c("weekend","weekday"))
factorActivity <- cbind(newActivity,weekdayFactor)
factorAvgSteps_day <- aggregate(steps ~ interval + weekdayFactor, factorActivity, mean)
```

b. Make a panel plot containing a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).


```r
library(ggplot2)
library(ggthemes)
panel_plot <- ggplot(factorAvgSteps_day, aes(x=interval, y=steps))
panel_plot + 
    geom_line(color="dark green") +
    facet_grid(facets=weekdayFactor ~ .) +
    theme_economist(dkpanel=TRUE)
```

![](PA1_template_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

