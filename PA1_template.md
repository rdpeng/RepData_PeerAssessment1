# Reproducible Research: Peer Assessment 1

### Loading and preprocessing the data

```r
unzip("activity.zip")
amd <- read.csv("activity.csv", header=TRUE, colClasses=c("integer","Date","integer"))
head(amd)
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
summary(amd)
```

```
##      steps            date               interval   
##  Min.   :  0.0   Min.   :2012-10-01   Min.   :   0  
##  1st Qu.:  0.0   1st Qu.:2012-10-16   1st Qu.: 589  
##  Median :  0.0   Median :2012-10-31   Median :1178  
##  Mean   : 37.4   Mean   :2012-10-31   Mean   :1178  
##  3rd Qu.: 12.0   3rd Qu.:2012-11-15   3rd Qu.:1766  
##  Max.   :806.0   Max.   :2012-11-30   Max.   :2355  
##  NA's   :2304
```

### What is mean total number of steps taken per day?

```r
# group total number of steps by the date
amd_group_steps_by_date <- aggregate(steps ~ date, amd, sum, na.action=na.omit)

# histogram of the total number of steps taken each day
hist(amd_group_steps_by_date$steps, main="Frequency of Total Number of Steps per Date",
     breaks = seq(0, 25000, 1000), xlab = "Steps per Date", ylab = "Frequency (n)")
```

![plot of chunk unnamed-chunk-2](./PA1_template_files/figure-html/unnamed-chunk-2.png) 

```r
# the mean total number of steps taken per date
mean(amd_group_steps_by_date$steps)
```

```
## [1] 10766
```

```r
# the median total number of steps taken per date
median(amd_group_steps_by_date$steps)
```

```
## [1] 10765
```

### What is the average daily activity pattern?

```r
# group mean number of steps by the interval
amd_average_steps_by_interval <- aggregate(steps ~ interval, amd, mean, na.action=na.omit)

# plot of the average steps per interval
plot(amd_average_steps_by_interval$interval, amd_average_steps_by_interval$steps,
     type="l", xlab="Interval", ylab="Steps")
```

![plot of chunk unnamed-chunk-3](./PA1_template_files/figure-html/unnamed-chunk-3.png) 

```r
# the interval with the highest average steps
amd_average_steps_by_interval$interval[which.max(amd_average_steps_by_interval$steps)]
```

```
## [1] 835
```

### Imputing missing values

```r
# vector with all ids of all rows with missing step count
idx <- which(is.na(amd$steps)==TRUE)
```
There are 2304 rows with missing step counts. We will represent missing values with the average step count for the corresponding interval identifier.

```r
# add a row with the average steps by interval
amd$avg_steps <- by(amd$steps, amd$interval, function(x) { round(mean(x,na.rm=TRUE)) })

# store the average steps by interval for a missing row as the step count
amd$steps[idx] <- amd$avg_steps[idx]

# group total number of steps by the date
amd_group_steps_by_date <- aggregate(steps ~ date, amd, sum, na.action=na.omit)

# histogram of the total number of steps taken each day
hist(amd_group_steps_by_date$steps, main="Frequency of Total Number of Steps per Date",
     breaks = seq(0, 25000, 1000), xlab = "Steps per Date", ylab = "Frequency (n)")
```

![plot of chunk unnamed-chunk-5](./PA1_template_files/figure-html/unnamed-chunk-5.png) 

```r
# the mean total number of steps taken per date
mean(amd_group_steps_by_date$steps)
```

```
## [1] 10766
```

```r
# the median total number of steps taken per date
median(amd_group_steps_by_date$steps)
```

```
## [1] 10762
```

Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

The method used to represent missing data has resulted in the histogram contracting towards the average. The highest frequency dates has risen considerably although the median has only slightly changed (mean was the same).

### Are there differences in activity patterns between weekdays and weekends?

```r
lt <- as.POSIXlt(amd$date, format = "%Y-%m-%d")
weekdays <- lt$wday
weekdays[weekdays == 0] = 0
weekdays[weekdays == 6] = 0
weekdays[weekdays != 0] = 1
weekdays_factor <- factor(weekdays, levels = c(0, 1))

# Add the factor variable to the data
amd$weekday <- weekdays_factor

# Calculate the mean
amd_steps_mean_per_weekday <- tapply(amd$steps, list(amd$interval, amd$weekday), mean, 
                              na.rm = T)

par(mfrow = c(2, 1))
with(amd, {
  par(mai = c(0, 1, 1, 0))
  plot(amd_steps_mean_per_weekday[, 1], type = "l", main = ("Steps vs. Interval"), 
       xaxt = "n", ylab = "Weekends", col="red")
  title = ("Number of Steps vs Interval")
  par(mai = c(1, 1, 0, 0))
  plot(amd_steps_mean_per_weekday[, 2], type = "l", xlab = "Interval",
       ylab = "Weekdays", col="blue")
  })
```

![plot of chunk unnamed-chunk-6](./PA1_template_files/figure-html/unnamed-chunk-6.png) 

There are clear differences between weekend and weekend steps during intervals. The biggest would be the sharp spike in the morning on weekdays followed by a drop then steady steps for the rest of the day. Weekends tend to have steps spread out randomly through the day.
