---
title: "Repdata034_PA2"
author: "Zoltan Kovacs"
date: "2015. november 15."
output: html_document
---


### Loading and preprocessing the data
Load the data

```r
# require package
library(lattice)

# Read and show data
dfActivity <- read.csv("activity.csv", stringsAsFactors=FALSE)
```

```
## Warning in file(file, "rt"): cannot open file 'activity.csv': No such file
## or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

```r
head(dfActivity,3)
```

```
##   steps       date interval weekday    wDay
## 1    NA 2012-10-01        0   hétfõ weekend
## 2    NA 2012-10-01        5   hétfõ weekend
## 3    NA 2012-10-01       10   hétfõ weekend
```

Process/transform the data (if necessary) into a format suitable for your analysis. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

```r
# Convert string to date
dfActivity$date <- as.Date(dfActivity$date, "%Y-%m-%d")

# Set weekdays and weekends from weekdays
dfActivity$weekday=weekdays(dfActivity$date)
# dfActivity$weekday = factor(dfActivity$weekday)
listWeekdays <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
dfActivity$wDay <- factor((dfActivity$weekday %in% listWeekdays),
                          levels=c(FALSE, TRUE), labels=c('weekend', 'weekday'))

# Clean up data
rm(listWeekdays)

# Show data
head(dfActivity, 3)
```

```
##   steps       date interval weekday    wDay
## 1    NA 2012-10-01        0   hétfõ weekend
## 2    NA 2012-10-01        5   hétfõ weekend
## 3    NA 2012-10-01       10   hétfõ weekend
```

### What is mean total number of steps taken per day?
Calculate the total number of steps taken per day

```r
# Aggregate data
TotalSteps <- aggregate(steps ~ date, data = dfActivity, sum, na.rm = TRUE)
```

Make a histogram of the total number of steps taken each day

```r
# Create histogram
hist(TotalSteps$steps, main = "Total steps", xlab = "Day", col = "red")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

Calculate and report the mean and median of the total number of steps taken per day

```r
# Mean of steps
mean(TotalSteps$steps)
```

```
## [1] 10766.19
```

```r
# Median of steps
median(TotalSteps$steps)
```

```
## [1] 10765
```

### What is the average daily activity pattern?
Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
MeanSteps <- aggregate(steps ~ interval, data = dfActivity, mean, na.rm = TRUE)
plot(MeanSteps$interval, MeanSteps$steps, type="l",  col="blue",
     xlab="Interval",  ylab="Average of steps", 
     main="Time-series of the mean of steps per intervals")
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png) 

Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
# Print maximum interval
MeanSteps$interval[which.max(MeanSteps$steps)]
```

```
## [1] 835
```

### Imputing missing values
Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```r
# Print number of NAs
sum(is.na(dfActivity))
```

```
## [1] 2304
```

Devise a strategy for filling in all of the missing values in the dataset.

```r
# Create an empty vector for storing (and calculating NA steps) steps
NewNAfreeVector = numeric()
for (i in 1:nrow(dfActivity)) {
    if (is.na(dfActivity[i, "steps"])) {
        ActualStep <- subset(MeanSteps, interval == dfActivity[i, "interval"])$steps
    } else {
        ActualStep <- dfActivity[i, "steps"]
    }
    NewNAfreeVector <- c(NewNAfreeVector, ActualStep)
}
```

Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
# Fill the missing data in a new dataset
dfActivity2 = dfActivity
dfActivity2$steps = NewNAfreeVector
```

Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.

```r
# Aggregate data
TotalStepsWithoutNA <- aggregate(steps ~ date, data = dfActivity, sum, na.rm = TRUE)

# Create histogram
hist(TotalStepsWithoutNA$steps, main = "Total steps (NA filled with means)", xlab = "Day", col = "red")
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png) 

### Are there differences in activity patterns between weekdays and weekends?
Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).

```r
stepsWeekDay <- aggregate(steps ~ interval + wDay, data = dfActivity, mean)
xyplot(steps ~ interval | wDay, stepsWeekDay, type = "l", layout = c(1, 2),
       xlab = "Interval", ylab = "Number of steps")
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png) 
