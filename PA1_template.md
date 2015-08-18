# Reproducible Research: Peer Assessment 1

## Attaching required packages

```r
library(lubridate)
library(lattice)
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:lubridate':
## 
##     intersect, setdiff, union
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

## Loading and preprocessing the data

```r
activity<- read.csv(unz("activity.zip", "activity.csv"))
activity$date<- as.Date(activity$date)
str(activity)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Date, format: "2012-10-01" "2012-10-01" ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

## What is the mean total number of steps taken per day?

### 1.Total number of steps taken per day

```r
steps_per_day<- activity %>% 
  group_by(date) %>% 
  summarize(total_steps = sum(steps),
            average_steps = mean(steps))
str(steps_per_day)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	61 obs. of  3 variables:
##  $ date         : Date, format: "2012-10-01" "2012-10-02" ...
##  $ total_steps  : int  NA 126 11352 12116 13294 15420 11015 NA 12811 9900 ...
##  $ average_steps: num  NA 0.438 39.417 42.069 46.16 ...
##  - attr(*, "drop")= logi TRUE
```

### 2. Histogram of the total number of steps taken each day

```r
hist(steps_per_day$total_steps, breaks=15, 
     main="Histogram of the total number of steps taken each day",
     xlab="Total number of steps taken each day")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 

### 3. The mean and median of the total number of steps taken per day

```r
summary(steps_per_day$total_steps)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##      41    8841   10760   10770   13290   21190       8
```

## What is the average daily activity pattern?

### 1. Plot of the 5-minute interval and the average number of steps taken, averaged across all days

```r
steps_per_interval <- steps_per_interval<- activity %>% 
  group_by(interval) %>% 
  summarize(average_steps = mean(steps, na.rm=TRUE))
str(steps_per_interval)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	288 obs. of  2 variables:
##  $ interval     : int  0 5 10 15 20 25 30 35 40 45 ...
##  $ average_steps: num  1.717 0.3396 0.1321 0.1509 0.0755 ...
##  - attr(*, "drop")= logi TRUE
```

```r
plot(steps_per_interval$interval, steps_per_interval$average_steps, type="l",
     main="Average number of steps taken per 5-minute interval",
     xlab="Interval", ylab="Average number of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png) 

### 2. The 5 min interval with the maximum number of steps

```r
arrange(steps_per_interval, desc(average_steps))
```

```
## Source: local data frame [288 x 2]
## 
##    interval average_steps
## 1       835      206.1698
## 2       840      195.9245
## 3       850      183.3962
## 4       845      179.5660
## 5       830      177.3019
## 6       820      171.1509
## 7       855      167.0189
## 8       815      157.5283
## 9       825      155.3962
## 10      900      143.4528
## ..      ...           ...
```
On average across all the days in the dataset, the 835 contains the maximum number of steps.

## Imputing missing values

### 1. Total number of missing values in the dataset

```r
summary(activity)
```

```
##      steps             date               interval     
##  Min.   :  0.00   Min.   :2012-10-01   Min.   :   0.0  
##  1st Qu.:  0.00   1st Qu.:2012-10-16   1st Qu.: 588.8  
##  Median :  0.00   Median :2012-10-31   Median :1177.5  
##  Mean   : 37.38   Mean   :2012-10-31   Mean   :1177.5  
##  3rd Qu.: 12.00   3rd Qu.:2012-11-15   3rd Qu.:1766.2  
##  Max.   :806.00   Max.   :2012-11-30   Max.   :2355.0  
##  NA's   :2304
```
The total number of missing values in the dataset (i.e. the total number of rows with NAs) is 2304.

### 2. Strategy for filling in all of the missing values in the dataset
The mean 5-minute interval,averaged across all days, is used for filling the missing values.

### 3. A new dataset, activity2, that is equal to the original dataset but with the missing data filled in

```r
activity2<-activity
activity2$steps[is.na(activity2$steps)]<-steps_per_interval$average_steps
summary(activity2)
```

```
##      steps             date               interval     
##  Min.   :  0.00   Min.   :2012-10-01   Min.   :   0.0  
##  1st Qu.:  0.00   1st Qu.:2012-10-16   1st Qu.: 588.8  
##  Median :  0.00   Median :2012-10-31   Median :1177.5  
##  Mean   : 37.38   Mean   :2012-10-31   Mean   :1177.5  
##  3rd Qu.: 27.00   3rd Qu.:2012-11-15   3rd Qu.:1766.2  
##  Max.   :806.00   Max.   :2012-11-30   Max.   :2355.0
```

### 4. Histogram of the total number of steps taken each day after the missing data is filled in

```r
steps_per_day2<- activity2 %>% 
  group_by(date) %>% 
  summarize(total_steps = sum(steps))

hist(steps_per_day2$total_steps, breaks=15, 
     main="Histogram of the total number of steps taken each day",
     xlab="Total number of steps taken each day")
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png) 

The mean and median total number of steps taken per day for activity2 (i.e after missing data is filled in) and for activity (i.e before missing data is filled in) are shown below:

```r
summary(steps_per_day2$total_steps) # after missing data is filled in
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##      41    9819   10770   10770   12810   21190
```

```r
summary(steps_per_day$total_steps)  # before missing data is filled in
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##      41    8841   10760   10770   13290   21190       8
```
The mean value remains the same as the mean for the first part of the assignment while the median value differ from the median estimate for the first part of the assignment. The median is now the same as the mean.
Imputing missing data has an impact on the estimates of the total daily number of steps. It prevents discarding any case that has a missing value, which could introduce bias or affect the representativeness of the results.

## Are there differences in activity patterns between weekdays and weekends?

### 1. New factor variable, wDay_wEnd, is added with two levels – “Weekday” and “Weekend” indicating whether a given date is a weekday or weekend day.

```r
weekdays <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
wDay_wEnd <- activity2 %>% 
  mutate(wDay_wEnd= factor((weekdays(activity2$date) %in% weekdays), 
                           levels=c(FALSE, TRUE), labels=c('Weekend', 'Weekday'))) %>%
  group_by(interval, wDay_wEnd) %>%
  mutate(average_steps = mean(steps))
head(wDay_wEnd)
```

```
## Source: local data frame [6 x 5]
## Groups: interval, wDay_wEnd
## 
##       steps       date interval wDay_wEnd average_steps
## 1 1.7169811 2012-10-01        0   Weekday    2.25115304
## 2 0.3396226 2012-10-01        5   Weekday    0.44528302
## 3 0.1320755 2012-10-01       10   Weekday    0.17316562
## 4 0.1509434 2012-10-01       15   Weekday    0.19790356
## 5 0.0754717 2012-10-01       20   Weekday    0.09895178
## 6 2.0943396 2012-10-01       25   Weekday    1.59035639
```
  
### 2. Plot of the 5-minute interval and the average number of steps taken averaged across all weekday days or weekend days.

```r
xyplot(average_steps ~ interval | wDay_wEnd, data=wDay_wEnd, type="l",
     xlab="Interval", ylab="Average number of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png) 
