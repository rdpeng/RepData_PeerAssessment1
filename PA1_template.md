---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---
# Reproducible Research: Peer Assessment 1

This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

## Loading the data

The data is loaded:
```r
df <- read.csv("activity.csv")
```


## What is mean total number of steps taken per day?

1. The total number of steps taken per day is calculated:
```r
tdf <- aggregate(df$steps, by = list(df$date), FUN = sum)
```

2. A histogram of the total number of steps taken each day is the following:
```r
hist(tdf$steps, xlab="Number of steps taken per day", main="A histogram of the total number of steps taken each day")
```

3. The **mean** and **median** total number of steps taken per day are calculated:
```r
smean <- mean(tdf$steps)
smedian <- median(tdf$steps)
abline(v=smean, col="red")
abline(v=smedian, col="blue")
legend('topright', c("Mean","Median"), lty=1,  col=c("red","blue"), cex=0.8 )
```

## What is the average daily activity pattern?

1. A time series plot (i.e. `type = "l"`) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis) is made:
```r
mdf <- aggregate(df$steps, by = list(df$interval), FUN = mean, na.rm=T)
plot(mdf$"Group.1", mdf$x, type="l")
```

2. The 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps is 835

## Imputing missing values

1. The total number of missing values in the dataset (i.e. the total number of rows with `NA`s) is:2304

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

4. Make a histogram of the total number of steps taken each day and Calculate and report the **mean** and **median** total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

## Are there differences in activity patterns between weekdays and weekends?

1. Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

1. Make a panel plot containing a time series plot (i.e. `type = "l"`) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). The plot should look something like the following, which was created using **simulated data**:
