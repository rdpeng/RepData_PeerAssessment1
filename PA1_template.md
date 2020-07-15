---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---

Firstly, I would turn off the warnings using the global aoptions


```r
knitr::opts_chunk$set(warning=FALSE)
```


## Loading and preprocessing the data
The data was downloaded from the course web site:
 
 * Dataset: [Activity Dataset](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip)
 

```r
if(!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")) {
        temp <- tempfile()
        download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip",temp)
        unzip(temp)
        unlink(temp)
}
```

loading and reading the data. Looking at structure of data using `str()` function


```r
activity <- read.csv("activity.csv", header = TRUE, na.strings = "NA")
str(activity)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : chr  "2012-10-01" "2012-10-01" "2012-10-01" "2012-10-01" ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

Here, date is a charater object, so we have to convert it into date format. Further,
there are lot of `NA` is the steps columns. So, we can subset the data for removing the NAs


```r
activity$date <- as.Date(activity$date)
dat <- subset(activity, !is.na(activity$steps))
str(dat)
```

```
## 'data.frame':	15264 obs. of  3 variables:
##  $ steps   : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ date    : Date, format: "2012-10-02" "2012-10-02" ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```


## What is mean total number of steps taken per day?

For this part of the assignment, you can ignore the missing values in the dataset.

1. Calculate the total number of steps taken per day


```r
total.steps <- with(activity, 
                    aggregate(steps ~ date, FUN = sum, na.rm = TRUE)
                    )
head(total.steps)
```

```
##         date steps
## 1 2012-10-02   126
## 2 2012-10-03 11352
## 3 2012-10-04 12116
## 4 2012-10-05 13294
## 5 2012-10-06 15420
## 6 2012-10-07 11015
```

2. If you do not understand the difference between a histogram and a barplot, 
research the difference between them. Make a histogram of the total number of 
steps taken each day


```r
total.steps <- with(activity, 
                    aggregate(steps ~ date, FUN = sum, na.rm = TRUE)
                    )
with(total.steps, 
     hist(steps, 
          col = "skyblue",
          main = "Mean Total Number of Steps taken per day", 
          xlab = "Total Number of Steps per day",
          ylab = "Frequency")
     )
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

3. Calculate and report the mean and median of the total number of steps taken per day

 * So we can read the meadian and median from the summary as follows:


```r
summary(total.steps)
```

```
##       date                steps      
##  Min.   :2012-10-02   Min.   :   41  
##  1st Qu.:2012-10-16   1st Qu.: 8841  
##  Median :2012-10-29   Median :10765  
##  Mean   :2012-10-30   Mean   :10766  
##  3rd Qu.:2012-11-16   3rd Qu.:13294  
##  Max.   :2012-11-29   Max.   :21194
```

 * Or separately using `mean()` function over steps
 

```r
mean(total.steps$steps)
```

```
## [1] 10766.19
```
 
  * Similarly, meadian can be calculated using `meadian()` function over steps


```r
median(total.steps$steps)
```

```
## [1] 10765
```

So the mean is 10766 steps and the median is 10765 steps.  

## What is the average daily activity pattern?

1. Make a time series plot (i.e. \color{red}{\verb|type = "l"|}type = "l") of 
the 5-minute interval (x-axis) and the average number of steps taken, averaged 
across all days (y-axis)


```r
avg.steps <- with(activity, 
                    aggregate(steps ~ interval, FUN = mean, na.rm = TRUE)
                    )
with(avg.steps,
     plot(steps ~ interval, 
          type = "l", 
          xlab = "5-minute Intervals",
          ylab = "Average Number of Steps taken",
          main = "Steps vs. Interval across all days"))
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

 * Which 5-minute interval, on average across all the days in the dataset, 
 contains the maximum number of steps?


```r
avg.steps[which.max(avg.steps$steps), ]$interval
```

```
## [1] 835
```

So, the interval 835 contains maximum number of steps = 206 

## Imputing missing values

Note that there are a number of days/intervals where there are missing values 
(coded as \color{red}{\verb|NA|}NA). The presence of missing days may introduce 
bias into some calculations or summaries of the data.

 * Calculate and report the total number of missing values in the dataset 
 (i.e. the total number of rows with \color{red}{\verb|NA|}NAs)
 

```r
sum(is.na(activity$steps))
```

```
## [1] 2304
```
 
So, there are 2304 NA values.

 * Devise a strategy for filling in all of the missing values in the dataset. 
 The strategy does not need to be sophisticated. For example, you could use the 
 mean/median for that day, or the mean for that 5-minute interval, etc.
 

```r
mis.val <- activity[is.na(activity$steps),]

notmis.val <- activity[!is.na(activity$steps),]
avg.val <- with(activity, 
                    aggregate(steps ~ interval, FUN = mean, na.rm = TRUE)
                )
mis.val$steps <- avg.val$steps
```
 
 * Create a new dataset that is equal to the original dataset but with the 
 missing data filled in.


```r
activity.new <- rbind(mis.val, notmis.val)
activity.new$date <- as.Date(activity.new$date)
str(activity.new)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : num  1.717 0.3396 0.1321 0.1509 0.0755 ...
##  $ date    : Date, format: "2012-10-01" "2012-10-01" ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

 * Make a histogram of the total number of steps taken each day and 


```r
total.steps.new <- with(activity.new, 
                      aggregate(steps ~ date, FUN = sum, na.rm = TRUE)
                      )
with(total.steps.new, 
     hist(steps,
          col = "steelblue",
          main = "Total Number of Steps taken per day (Imputed NAs)", 
          xlab = "Total Number of Steps per day",
          ylab = "Frequency"))
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)<!-- -->
 
 * Calculate and report the mean and median total number of steps taken per day. 
 

```r
summary(total.steps.new)
```

```
##       date                steps      
##  Min.   :2012-10-01   Min.   :   41  
##  1st Qu.:2012-10-16   1st Qu.: 9819  
##  Median :2012-10-31   Median :10766  
##  Mean   :2012-10-31   Mean   :10766  
##  3rd Qu.:2012-11-15   3rd Qu.:12811  
##  Max.   :2012-11-30   Max.   :21194
```

 * Or separately using `mean()` function over steps
 

```r
mean(total.steps.new$steps)
```

```
## [1] 10766.19
```
 
  * Similarly, meadian can be calculated using `meadian()` function over steps


```r
median(total.steps.new$steps)
```

```
## [1] 10766.19
```
 
 * Do these values differ from the estimates from the first part of the assignment? 
 

```r
mean(total.steps$steps) - mean(total.steps.new$steps)
```

```
## [1] 0
```

```r
median(total.steps$steps) - median(total.steps.new$steps)
```

```
## [1] -1.188679
```

```r
(median(total.steps$steps) - median(total.steps.new$steps))/median(total.steps$steps)*100
```

```
## [1] -0.01104207
```
 
So, mean of the data did not changed, whereas median has decreased negligibly to 
0.01% of the earlier estimate.  

 * What is the impact of imputing missing data on the estimates of the total 
 daily number of steps?


```r
summary(total.steps)
```

```
##       date                steps      
##  Min.   :2012-10-02   Min.   :   41  
##  1st Qu.:2012-10-16   1st Qu.: 8841  
##  Median :2012-10-29   Median :10765  
##  Mean   :2012-10-30   Mean   :10766  
##  3rd Qu.:2012-11-16   3rd Qu.:13294  
##  Max.   :2012-11-29   Max.   :21194
```

```r
summary(total.steps.new)
```

```
##       date                steps      
##  Min.   :2012-10-01   Min.   :   41  
##  1st Qu.:2012-10-16   1st Qu.: 9819  
##  Median :2012-10-31   Median :10766  
##  Mean   :2012-10-31   Mean   :10766  
##  3rd Qu.:2012-11-15   3rd Qu.:12811  
##  Max.   :2012-11-30   Max.   :21194
```

So, there are no considerable impacts of imputing missing data on the 
estimates of the total daily number of steps, except that the frequency has 
increased and median slighly decreased.

## Are there differences in activity patterns between weekdays and weekends?

For this part the \color{red}{\verb|weekdays()|}weekdays() function may be of 
some help here. Use the dataset with the filled-in missing values for this part.

 * Create a new factor variable in the dataset with two levels - "weekday" and 
 "weekend" indicating whether a given date is a weekday or weekend day.
 

```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
activity$date <- as.Date(activity$date)
activity.week <- activity %>% 
                 mutate(dayType = ifelse(weekdays(activity$date) =="Saturday" | 
                                          weekdays(activity$date)=="Sunday", 
                                         "Weekend", "Weekday")
                        )
head(activity.week)
```

```
##   steps       date interval dayType
## 1    NA 2012-10-01        0 Weekday
## 2    NA 2012-10-01        5 Weekday
## 3    NA 2012-10-01       10 Weekday
## 4    NA 2012-10-01       15 Weekday
## 5    NA 2012-10-01       20 Weekday
## 6    NA 2012-10-01       25 Weekday
```
 
 * Make a panel plot containing a time series plot 
 (i.e. \color{red}{\verb|type = "l"|}type = "l") of the 5-minute interval (x-axis) 
 and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 
 

```r
avg.steps.day <- with(activity.week,
                      aggregate(steps ~ interval + dayType, FUN = mean, na.rm = TRUE))
library(lattice)
xyplot(steps ~ interval | dayType, 
       data = avg.steps.day,
       type = "l", 
       layout = c(1, 2),
       xlab = "5-minute Interval", 
       ylab = "Average Number of Steps taken")
```

![](PA1_template_files/figure-html/unnamed-chunk-20-1.png)<!-- -->
 
 
 See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.
