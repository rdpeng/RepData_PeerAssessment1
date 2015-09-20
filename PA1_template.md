Reproducible Research: Peer Assessment 1
========================================
##Introduciton

This peer assesment consists in analize a data base with information about personal activity monitoring, from different devices.
The information we have to analize:  
***steps**: Number of steps taking in a 5-minute interval (missing values are coded as NA);  
***date**: The date on which the measurement was taken in YYYY-MM-DD format;  
**interval**: Identifier for the 5-minute interval in which measurement was taken. 

###Loading the data base
The first step to analize the data is load the data base with the information above.
1. Load the data: we utilized the commando to load csv files:

```r
  activity <- read.csv("C:/Users/Marcel/Desktop/Coursera/Pesquisa reprodutivel/Proj 1/activity.csv")
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

The path C:/Users/Marcel/Desktop/Coursera/Pesquisa reprodutivel/Proj 1/ is the place where the file activity.csv is saved, in my local computer.

**What is mean total number of steps taken per day?**  
Let's calculate the total number of steps in the data base (using the dply package):

```r
    library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
  st_day<-summarise(group_by(activity, date), steps = sum(steps))
  st_day
```

```
## Source: local data frame [61 x 2]
## 
##          date steps
## 1  2012-10-01    NA
## 2  2012-10-02   126
## 3  2012-10-03 11352
## 4  2012-10-04 12116
## 5  2012-10-05 13294
## 6  2012-10-06 15420
## 7  2012-10-07 11015
## 8  2012-10-08    NA
## 9  2012-10-09 12811
## 10 2012-10-10  9900
## ..        ...   ...
```
A histogram of the total number of steps taken each day

```r
  hist(st_day$steps)
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 

mean of the total number of steps taken per day

```r
  mean(st_day$steps, na.rm = TRUE)
```

```
## [1] 10766.19
```

median of the total number of steps taken per day

```r
  median(st_day$steps, na.rm = TRUE)
```

```
## [1] 10765
```

**What is the average daily activity pattern?**  
A time series of the 5-minute interval X the average number of steps taken, averaged across all days

```r
  st_day_avg <- summarise(group_by(activity, interval), steps_mn = mean(steps, na.rm = TRUE))
  plot(st_day_avg$interval, st_day_avg$steps_mn, type = "l", xlab = "5-minute interval ", ylab = "average number of steps ")
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png) 

The 5-minute interval, wich contains the maximum number of steps is (using the dply package):

```r
  filter(st_day_avg, steps_mn == max(st_day_avg$steps_mn))$interval
```

```
## [1] 835
```

**Imputing missing values**  
The total number of missing values in the dataset:

```r
  sum(is.na(activity$steps))
```

```
## [1] 2304
```
Our strategy for filling in all of the missing values in the dataset will be put the value of the mean of steps per interval.
The dataset activity_new will be a new dataset that is equal to the original dataset but with the missing data filled in.

```r
  library(kimisc)
```

```
## Warning: package 'kimisc' was built under R version 3.2.2
```

```r
  activity_mn_it <- merge(activity, st_day_avg, by.x = "interval", by.y = "interval")
  activity_mn_it$steps_f <- coalesce.na(activity_mn_it$steps, activity_mn_it$steps_mn)
  activity_new <- select(activity_mn_it,  steps = steps_f, date = date, interval = interval)
  head(activity_new, n=3)
```

```
##      steps       date interval
## 1 1.716981 2012-10-01        0
## 2 0.000000 2012-11-23        0
## 3 0.000000 2012-10-28        0
```

Making a histogram of the total number of steps taken each day

```r
  ## number steps day
  st_day_f <- summarise(group_by(activity_new, date), steps = sum(steps))
  
  ##histogram
  hist(st_day_f$steps)
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png) 

Calculating the mean 

```r
mean(st_day_f$steps, na.rm = TRUE)
```

```
## [1] 10766.19
```

and median total number of steps taken per day. 

```r
median(st_day_f$steps, na.rm = TRUE)
```

```
## [1] 10766.19
```

These values of median is diferent after filling in all of the missing values, but the mean stay the same.
The impact, with this strategy, was very low.

**Are there differences in activity patterns between weekdays and weekends?**  
Creating a new factor variable indicating whether a given date is a weekday or weekend day.  
*sábado = saturnday  
*domingo = sunday  


```r
  activity_new$is_wen <- as.factor(weekdays(as.Date(activity_new$date)) %in% c("sábado", "domingo"))
  levels(activity_new$is_wen) <- list(weekday = "FALSE", weekend = "TRUE")
```
Making a panel plot containing a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days.  


```r
  st_day_avg_it <- summarise(group_by(activity_new, interval, is_wen), steps_mn_f = mean(steps))
  par(mfrow = c(2, 1))
  plot(filter(st_day_avg_it, is_wen == "weekend")$interval, filter(st_day_avg_it, is_wen == "weekend")$steps_mn_f, type = "l", xlab = "5-minute interval ", ylab = "average number of steps ", main = "Weekend")
  plot(filter(st_day_avg_it, is_wen == "weekday")$interval, filter(st_day_avg_it, is_wen == "weekday")$steps_mn_f, type = "l", xlab = "5-minute interval ", ylab = "average number of steps ", main = "Weekday")
```

![](PA1_template_files/figure-html/unnamed-chunk-14-1.png) 
