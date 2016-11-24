# Reproducible Research Course Project 1

##Global setting
Always make code visible

```r
echo=TRUE
message=FALSE
warning=FALSE
```

## Loading and preprocessing the data

1. Load the data (i.e. read.csv())
2. Process/transform the data (if necessary) into a format suitable for your analysis


```r
#unzip and import data
unzip(zipfile="activity.zip")
activity <- read.csv("activity.csv")

#libraries
library(ggplot2)
library(plyr)
library(lattice)
```

## What is mean total number of steps taken per day?

1. Calculate the total number of steps taken per day


```r
#Remove NAs
activity_NA_Removed <- activity[!is.na(activity$steps),]

#Calculate total steps per day
TotalSteps <- tapply(activity_NA_Removed$steps, activity_NA_Removed$date, sum, na.rm=TRUE)
head(as.data.frame(TotalSteps))
```

```
##            TotalSteps
## 2012-10-01         NA
## 2012-10-02        126
## 2012-10-03      11352
## 2012-10-04      12116
## 2012-10-05      13294
## 2012-10-06      15420
```


2. Make a histogram of the total number of steps taken each day


```r
#Remove NAs
activity_NA_Removed <- activity[!is.na(activity$steps),]

#Calculate total steps per day
TotalStepsPerDay <- tapply(activity_NA_Removed$steps, activity_NA_Removed$date, sum, na.rm=TRUE)

#Plot Histogram
hist(TotalStepsPerDay,
     col="darkgrey",
     breaks=10,
     xlab="Daily Total Steps",
     ylab="Frequency",
     main="Histogram of total steps per day")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

3. Calculate and report the mean and median total number of steps taken per day


```r
# Mean
Mean <- mean(TotalStepsPerDay, na.rm=TRUE)
print(Mean)
```

```
## [1] 10766.19
```

```r
# Median
Median <- median(TotalStepsPerDay, na.rm=TRUE)
print(Median)
```

```
## [1] 10765
```



## What is the average daily activity pattern?

1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
#Remove NAs
activity_NA_Removed <- activity[!is.na(activity$steps),]

#calculate average number of steps per interval across all days
Interval_Data <- ddply(activity_NA_Removed, .(interval), summarize, Avg = mean(steps))

#Line plot of average number of steps per interval across all days 
ggplot(Interval_Data, aes(x=interval, y=Avg)) +
    geom_line() +
    xlab("5-minute Interval") +
    ylab("Steps") +
    ggtitle("Frequency of Steps per Time Interval")
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png)<!-- -->


2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
Interval_Data[which.max(Interval_Data$Avg),]
```

```
##     interval      Avg
## 104      835 206.1698
```



## Imputing missing values
Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)


```r
missing_values <- is.na(activity$steps)
# How many missing
sum(missing_values)
```

```
## [1] 2304
```



2. Replace the missing values in the dataset with average 5 minutes interval calculated in the previous section


```r
#Create a new activity data to replace the NAs
activity2 <-activity

#index the location of NAs
NAs <-is.na(activity2$steps)

#replace the the location of NAs with  average 5 minutes interval
avg_interval<- tapply(activity2$steps, activity2$interval, mean, na.rm=TRUE)
activity2$steps[NAs] <- avg_interval[as.character(activity2$interval[NAs])]
```



3. Make a histogram of the total number of steps taken each day


```r
#Calculate total steps per day
TotalStepsPerDay2 <- tapply(activity2$steps, activity2$date, sum, na.rm=TRUE)

#Plot Histogram
hist(TotalStepsPerDay2,
     col="darkgrey",
     breaks=10,
     xlab="Daily Total Steps",
     ylab="Frequency",
     main="Histogram of total steps per day (with imputed NA Values)")
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->


4. Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of Imputing missing data on the estimates of the total daily number of steps?


```r
# Mean
NewMean <-mean(tapply(activity2$steps, activity2$date, sum))
print(NewMean)
```

```
## [1] 10766.19
```

```r
# Median
NewMedian <- median(tapply(activity2$steps, activity2$date, sum))
print(NewMedian)
```

```
## [1] 10766.19
```

```r
#MeanDiff
NewMean - Mean
```

```
## [1] 0
```

```r
#MedianDiff     
NewMedian - Median
```

```
## [1] 1.188679
```

After imputting the missing data, the new mean and median are identical, and they are very close to the old set of mean and median. The Imputing missing data has resulted in higher frequency in the center region of the histogram. which makes sense as there is more daily total steps with the mean average than before.


## Are there differences in activity patterns between weekdays and weekends?
1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.


```r
#Create new varible called WeekType 
activity2$WeekType <- ifelse(weekdays(as.Date(activity2$date))%in% c("Saturday", "Sunday"), "Weekend", "Weekday")
```

2. Make a panel plot containing a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).**


```r
#calculate average number of steps per interval and per weektype
interval_data3 <- ddply(activity2, .(interval, WeekType), summarize, Avg = mean(steps))

#Plot data in a panel plot
xyplot(Avg ~ interval | factor(WeekType),
       data=interval_data3,
       type="l",
       layout = c(2, 1),
       xlab="5-minute interval",
       ylab="Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)<!-- -->




