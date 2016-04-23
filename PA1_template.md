# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
1. Code for reading the data from activity.csv file

```r
activityDF = read.csv('activity.csv', header = T)

head(activityDF)
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

## What is mean total number of steps taken per day?
2. Histogram of the total number of steps taken each day
Histogram plot of aggregate number of steps taken each day:

```r
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.1.3
```

```r
stepsByDate <- aggregate(steps ~ date, activityDF, sum)
qplot(steps, data = stepsByDate,  binwidth = 500, main = 'Total number of steps per day', xlab = 'Number of steps')
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)
3. Mean and median number of steps taken each day
We calculate the mean and the median numbers of the steps taken each day:

- Mean of steps taken each day.

```r
mean(stepsByDate$steps)
```

```
## [1] 10766.19
```
- Median of steps taken each day.

```r
median(stepsByDate$steps) 
```

```
## [1] 10765
```

## What is the average daily activity pattern?
4. Time series plot of the average number of steps taken

Time series plot with average steps taken every day.

```r
avgDay <- aggregate(steps ~ interval, activityDF, mean)
qplot(interval, steps, data = avgDay, geom = 'line', main = 'Average daily activity', xlab = '5-min interval', ylab = 'Average number of steps')
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)

5. The 5-minute interval that, on average, contains the maximum number of steps

Calculate which 5-minute interval contains the maximum number of steps:

```r
avgDay[which.max(avgDay$steps), ]
```

```
##     interval    steps
## 104      835 206.1698
```

## Imputing missing values
6. Code to describe and show a strategy for imputing missing data.

The strategy is to create a new dataset that is equal to the original dataset but with the missing values filled in with use the mean/median for that day.


```r
stepsByDate <- aggregate(steps ~ date, data = activityDF, FUN=sum)
filledDF <- merge(activityDF, stepsByDate, by="date", suffixes=c("",".new"))
naSteps <- is.na(filledDF$steps)
filledDF$steps[naSteps] <- filledDF$steps.new[naSteps]
filledDF <- filledDF[,1:3]
```

7. Histogram of the total number of steps taken each day after missing values are imputed

Plot the histogram of the total of steps taken each day after missing values are filled in.

```r
stepsByDate <- aggregate(steps ~ date, data=filledDF, FUN=sum)
barplot(stepsByDate$steps, names.arg=stepsByDate$date, xlab="Date", ylab="Number of Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)
## Are there differences in activity patterns between weekdays and weekends?

8. Panel plot comparing the average number of steps taken per 5-minute interval across weekdays ans weekends
use the weekday() function to differ weekdays and weekends and panel plot to compare both datasets.


```r
WeekPart <- function(date) {
  if(weekdays(as.Date(date)) %in% c("sábado", "domingo")) {
		day <- "Weekend"
	} else {
		day <- "Weekday"
	}
}

filledDF$weekPart <- as.factor(sapply(filledDF$date, WeekPart))

library(reshape2)

melted <- melt(filledDF, measure.vars="steps")

meanSteps <- dcast(melted, weekPart+interval~variable, mean)

library(lattice)

xyplot(steps~interval|weekPart,
	data=meanSteps,
	xlab="Interval",
	ylab="Number of steps",
	type="l",
	layout=c(1,2)
)
```

![](PA1_template_files/figure-html/unnamed-chunk-9-1.png)
