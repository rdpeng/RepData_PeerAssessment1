---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---


## Loading and preprocessing the data
Load libs, load csv, convert date column

```r
  library(dplyr, quietly = TRUE, warn.conflicts = FALSE )
```

```
## Warning: package 'dplyr' was built under R version 4.0.2
```

```r
  library(ggplot2, quietly = TRUE)
  activity <- read.csv("activity.csv")
  activity[,'date']<- as.Date(activity[,'date'])
```


## What is mean total number of steps taken per day?

```r
  # Prepare Histogramm of daily steps
  activity_day <- group_by(activity,date)
  Day_steps <- summarize(activity_day, sum(steps))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
  colnames(Day_steps)<- c("date","steps")
  hist(Day_steps$steps, breaks = c(0,2500,5000,7500,10000,12500,15000,17500,20000,22500,25000), main = "Histogram of steps per day", ylab = "Total number of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

```r
  # Prepare Mean and Median
  Mean_steps <- mean(Day_steps$steps[which(!is.na(Day_steps$steps))])
  Median_steps <- median(Day_steps$steps[which(!is.na(Day_steps$steps))])
  print(paste("Steps per day: ",format(Mean_steps, digits = 6),"(Mean)",Median_steps,"(Median)"))
```

```
## [1] "Steps per day:  10766.2 (Mean) 10765 (Median)"
```


## What is the average daily activity pattern?

```r
  # Activity pattern, 5 min intervals
  activity_nonNA <- subset(activity,steps>=0)
  activity_interval <- group_by(activity_nonNA,interval)
  Interval_steps <- summarize(activity_interval, mean(steps))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
  colnames(Interval_steps)<- c("interval","mean_steps")
  qplot(interval,mean_steps, data = Interval_steps, geom = c("line"), main = "Average steps in each interval")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

```r
  maxinterval <- subset(Interval_steps, mean_steps == max(Interval_steps$mean_steps))
  print(paste("Interval with max. steps:",maxinterval[1,1]))
```

```
## [1] "Interval with max. steps: 835"
```



## Imputing missing values
Concept for imputing: use the average steps for the interval to fill NA data

```r
  #Imputing missing values
  NA_rows <- nrow(subset(activity,is.na(steps)))
  print(paste("Rows with NA values:",NA_rows))
```

```
## [1] "Rows with NA values: 2304"
```

```r
  # Use average of the intervall to fill missing data: activity_filledNA
  activity_filledNA <- merge(activity,Interval_steps, by = 'interval')
  NA_vec <- is.na(activity_filledNA[,'steps'])
  activity_filledNA[NA_vec,'steps']<-activity_filledNA[NA_vec,'mean_steps'] 
  
    # calculate hist, mean and median for new data
  # Prepare Histogramm of daily steps
  activity_day <- group_by(activity_filledNA,date)
  Day_steps_filledNA <- summarize(activity_day, sum(steps))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
  colnames(Day_steps_filledNA)<- c("date","steps")

  # The imputed.activity dataset is plotted
  hist(Day_steps_filledNA$steps, ylim = c(0,35), xlab = "Total Number of Steps", ylab = "Frequency", main = "Histogram: Steps Taken Each Day",breaks = c(0,2500,5000,7500,10000,12500,15000,17500,20000,22500,25000))
  # The actvity dataset (with the missing values) is plotted over the imputed.activity
  hist(Day_steps$steps, ylim = c(0,35), xlab = "Total Number of Steps", ylab = "Frequency", col = "Blue",breaks = c(0,2500,5000,7500,10000,12500,15000,17500,20000,22500,25000), add=TRUE) 
  legend("topright", c("Imputed", "Raw data"), col=c("Grey", "Blue"), lwd=6)
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

```r
  # Prepare Mean and Median, no change due to choosen strategy of interval average, median changing slightly
  Mean_steps_nonNA <- mean(Day_steps_filledNA$steps)
  Median_steps_nonNA <- median(Day_steps_filledNA$steps)
  print(paste("Steps per day with corrected NA values: ",format(Mean_steps_nonNA, digits = 6),"(Mean)",format(Median_steps_nonNA,digits = 6),"(Median)"))
```

```
## [1] "Steps per day with corrected NA values:  10766.2 (Mean) 10766.2 (Median)"
```
Due to chosen strategy for imputing NA values there is nearly no difference in mean or median value. In the histogram only the bar for the average number is increased.


## Are there differences in activity patterns between weekdays and weekends?



```r
  # Calculate weekday, replace day by Weekday or -end
  activity_filledNA <- mutate(activity_filledNA, weekday = weekdays(date))
  
  #Replacing all the weekdays with factor "Weekday" and weekends with "Weekend"
  
  activity_filledNA$weekday <- gsub("Montag|Dienstag|Mittwoch|Donnerstag|Freitag","Weekday", activity_filledNA$weekday)
  activity_filledNA$weekday <- gsub("Samstag|Sonntag", "Weekend", activity_filledNA$weekday)
  activity_filledNA$weekday <- as.factor(activity_filledNA$weekday)
  
  #Making a panel plot with ggplot 2 package containing a time series plot of the 5-minute interval and the
  #average number of steps taken, averaged across all weekday days or weekend days.
  #Filtering the mean steps over 5 min interval, separated by Weekday and Weekend factor variables
  Intervall_steps_Week <- aggregate(steps~interval+weekday, activity_filledNA, mean)
  p1 <- ggplot(Intervall_steps_Week, aes(interval, steps)) + facet_grid(weekday~.) + geom_line() + xlab("Time") + ylab("Total Steps")
  print(p1)
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

