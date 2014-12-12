# Reproducible Research: Peer Assessment 1
<br>

### Loading and preprocessing the data  
<br>
1. Load the data.

```r
unzip(zipfile="activity.zip")
x <- read.csv("activity.csv")
```
<br>

2. Process/transform the data (if necessary) into a format suitable for your analysis.

```r
x$interval <- factor(x$interval)
```

<br>

### What is the mean total number of steps taken per day?  
<br>
1. Make a histogram of the total number of steps taken each day.

```r
total <- tapply(x$steps, x$date, sum)
hist(total, main = "Number of Steps Per Day", xlab = "Total", bg = NA)
```

![](PA1_template_files/figure-html/3-1.png) 

2. Calculate and report the **mean** and **median** total number of steps taken per day.

*The mean.*

```r
round(mean(total, na.rm = TRUE))
```

```
## [1] 10766
```

*The median.*

```r
round(median(total, na.rm = TRUE))
```

```
## [1] 10765
```

<br>

### What is the average daily activity pattern?  
<br>
1. Make a time series plot (i.e. `type = "l"`) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis).

```r
interval <- as.numeric(levels(x$interval))
mean <- as.numeric(tapply(x$steps, x$interval, mean, na.rm = TRUE))
averages <- data.frame(interval, mean, row.names = NULL)

start <- as.POSIXlt("00:55", format = "%H:%M")
end <- as.POSIXlt("23:55", format = "%H:%M")
time <- seq(from = start, to = end, by = "1 hours")
time <- strftime(time, format = "%H:%M")

with(averages,
     plot(interval, mean, type = "l", xaxt = "n", yaxt = "n",
          main = "Average Number of Steps Per Five Minute Interval",
          xlab = "Start Time of Interval", ylab = "Mean", bg = NA))
     axis(1, labels = time, at = seq(from = 55, to = 2355, by = 100), las = 2,
          cex.axis = .75)
     axis(2, at = seq(from = 25, to = 225, by = 50), las = 1, cex.axis = .75)     
```

![](PA1_template_files/figure-html/6-1.png) 

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
averages[averages$mean == max(averages$mean), ]
```

```
##     interval     mean
## 104      835 206.1698
```

*The interval starting at 08:35.*

<br>

### Imputing missing values
<br>
Note that there are a number of days/intervals where there are missing
values (coded as `NA`). The presence of missing days may introduce
bias into some calculations or summaries of the data.  
<br>
1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with `NA`s).

```r
sum(!complete.cases(x))
```

```
## [1] 2304
```
<br>

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

*For the sake of simplicity, I will just impute the mean number of steps of all intervals averaged across all days.*  
<br>

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
x2 <- x
x2$steps <- as.numeric(x2$steps)
impute <- round(mean(averages$mean))
x2$steps[is.na(x2$steps)] <- impute
```
<br>

4. Make a histogram of the total number of steps taken each day and Calculate and report the **mean** and **median** total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
total2 <- tapply(x2$steps, x2$date, sum)
hist(total2, main = "Number of Steps Per Day", xlab = "Total", bg = NA)
```

![](PA1_template_files/figure-html/10-1.png) 

```r
round(mean(total2, na.rm = TRUE))
```

```
## [1] 10752
```

```r
round(median(total2, na.rm = TRUE))
```

```
## [1] 10656
```

*Imputing the missing values does not significantly alter the results in this case. The distrbution is more or less unchanged, as are the mean and median.*

<br>

### Are there differences in activity patterns between weekdays and weekends?
<br>

For this part the `weekdays()` function may be of some help here. Use
the dataset with the filled-in missing values for this part.

1. Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
x2$date <- as.POSIXlt(x2$date)
x2$date <- weekdays(x2$date)
x2$date <- factor(x2$date)
levels(x2$date) <- c("weekday", "weekday", "weekday", "weekday", "weekday", 
                     "weekend", "weekend")
```
<br>

2. Make a panel plot containing a time series plot (i.e. `type = "l"`) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).

```r
weekday <- x2[x2$date == "weekday", ]
interval2 <- as.numeric(levels(weekday$interval))
mean2 <- as.numeric(tapply(weekday$steps, weekday$interval, mean))
averages2 <- data.frame(interval2, mean2, row.names = NULL)

weekend <- x2[x2$date == "weekend", ]
interval3 <- as.numeric(levels(weekend$interval))
mean3 <- as.numeric(tapply(weekend$steps, weekend$interval, mean))
averages3 <- data.frame(interval3, mean3, row.names = NULL)

start <- as.POSIXlt("00:55", format = "%H:%M")
end <- as.POSIXlt("23:55", format = "%H:%M")
time <- seq(from = start, to = end, by = "2 hours")
time <- strftime(time, format = "%H:%M")

par(mfrow = c(1, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0), bg = NA)
with(averages2, 
     plot(interval2, mean2, type = "l", xaxt="n", yaxt = "n", main = "Weekday",  
          xlab = "Start Time of Interval", ylab = "Mean"))
     axis(1, labels = time, at = seq(from = 55, to = 2355, by = 200), las = 2,
          cex.axis = .75)
     axis(2, at = seq(25, 225, by = 50), las = 1, cex.axis = .75) 
with(averages3,
     plot(interval, mean, type = "l", xaxt="n", yaxt = "n", main = "Weekend", 
          xlab = "Start Time of Interval", ylab = "Mean"))
     axis(1, labels = time, at = seq(from = 55, to = 2355, by = 200), las = 2,
          cex.axis = .75)
     axis(2, at = seq(25, 225, by = 50), las = 1, cex.axis = .75)
     mtext("               Average Number of Steps Per Five Minute Interval",
           outer = TRUE)
```

![](PA1_template_files/figure-html/12-1.png) 
