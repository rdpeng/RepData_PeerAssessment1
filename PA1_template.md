---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---
This is my submission for Reproducible Research Course Project 1 by [Coursera](https://www.coursera.org/), sponsored by [MDEC](https://mdec.my/).

## Initial Setting
**Setting global option to turn warnings off and local time to English**

```r
knitr::opts_chunk$set(warning=FALSE)
Sys.setlocale("LC_TIME", "English")
```

```
## Warning in Sys.setlocale("LC_TIME", "English"): OS reports request to set locale
## to "English" cannot be honored
```

```
## [1] ""
```

## Include/Import required library

```r
library(ggplot2)
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
***
## Loading and preprocessing the data
### Assumptions
1. Data set is ready and located in the same folder of this *Rmd* file
2. The file name is *activity.csv*, accessible and readable by the code specified in this document
3. Process starts with reading the data set and load into memory
### Loading and preprocessing the data

```r
activity <- read.csv("activity.csv", stringsAsFactors=FALSE)

activity$date <- as.POSIXct(activity$date, "%Y-%m-%d")
weekday <- weekdays(activity$date)
activity <- cbind(activity,weekday)
```
### View the content of the data including missing data

```r
# list first 6 data
head(activity)
```

```
##   steps       date interval weekday
## 1    NA 2012-10-01        0  Monday
## 2    NA 2012-10-01        5  Monday
## 3    NA 2012-10-01       10  Monday
## 4    NA 2012-10-01       15  Monday
## 5    NA 2012-10-01       20  Monday
## 6    NA 2012-10-01       25  Monday
```

```r
# view summary of data
summary(activity)
```

```
##      steps             date               interval        weekday         
##  Min.   :  0.00   Min.   :2012-10-01   Min.   :   0.0   Length:17568      
##  1st Qu.:  0.00   1st Qu.:2012-10-16   1st Qu.: 588.8   Class :character  
##  Median :  0.00   Median :2012-10-31   Median :1177.5   Mode  :character  
##  Mean   : 37.38   Mean   :2012-10-31   Mean   :1177.5                     
##  3rd Qu.: 12.00   3rd Qu.:2012-11-15   3rd Qu.:1766.2                     
##  Max.   :806.00   Max.   :2012-11-30   Max.   :2355.0                     
##  NA's   :2304
```

```r
# view the data structure
dim(activity)
```

```
## [1] 17568     4
```

```r
# show the columns name
names(activity)
```

```
## [1] "steps"    "date"     "interval" "weekday"
```

```r
# show the data structure info
str(activity)
```

```
## 'data.frame':	17568 obs. of  4 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : POSIXct, format: "2012-10-01" "2012-10-01" ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
##  $ weekday : chr  "Monday" "Monday" "Monday" "Monday" ...
```

```r
# total number of missing data
sum(is.na(activity$steps))/dim(activity)[[1]]
```

```
## [1] 0.1311475
```

```r
# see the available date
length(unique(activity$date))
```

```
## [1] 61
```

There are 3 original parameters and 1 derived parameters:  
*Original Parameter*  
1. steps: Number of steps taking in a 5-minute interval (missing values are coded as NA)  
2. date: The date on which the measurement was taken in YYYY-MM-DD format  
3. interval: Identifier for the 5-minute interval in which measurement was taken  
*Derived Parameter*  
1. weekday: Specify the weekday of the activity  

*Looking at the relationship between the parameter*

```r
activityNoWeekDay <- select (activity,-c(weekday))
pairs(activityNoWeekDay)
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

Next steps is to perform data analysis to response to the question given  

---  

## What is mean total number of steps taken per day?  
*For this purpose, all missing values is ignored*     
1. Calculate the total number of steps taken per day  

```r
activity_total_steps_daily <- with(activity, aggregate(steps, by = list(date), FUN = sum, na.rm = TRUE))
names(activity_total_steps_daily) <- c("date", "steps")
# view first few rows
head(activity_total_steps_daily)
```

```
##         date steps
## 1 2012-10-01     0
## 2 2012-10-02   126
## 3 2012-10-03 11352
## 4 2012-10-04 12116
## 5 2012-10-05 13294
## 6 2012-10-06 15420
```

2. Make a histogram of the total number of steps taken each day  

```r
hist(activity_total_steps_daily$steps, main = "Total number of steps taken daily", xlab = "Total steps taken daily", col = "lightyellow", ylim = c(0,20), breaks = seq(0,25000, by=2500))
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

3. Calculate and report the mean and median of the total number of steps taken per day  

```r
# calculate the mean
mean(activity_total_steps_daily$steps, na.rm=TRUE)
```

```
## [1] 9354.23
```

```r
# calculate the median
median(activity_total_steps_daily$steps, na.rm=TRUE)
```

```
## [1] 10395
```

## What is the average daily activity pattern?
1. Make a time series plot (i.e. \color{red}{\verb|type = "l"|}type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)  

```r
# get the average activity
average_daily_activity <- aggregate(activity$steps, by=list(activity$interval), FUN=mean, na.rm=TRUE)
# formating the column
names(average_daily_activity) <- c("interval", "mean")
# plot the chart
plot(average_daily_activity$interval, average_daily_activity$mean, type = "l", col="red", lwd = 2, xlab="Interval", ylab="Average number of steps", main="Average number of steps per intervals")
```

![](PA1_template_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
# calculate the mean
average_daily_activity[which.max(average_daily_activity$mean), ]$interval
```

```
## [1] 835
```

---

## Imputing missing values  
**Note** that there are a number of days/intervals where there are missing values (coded as \color{red}{\verb|NA|}NA). The presence of missing days may introduce bias into some calculations or summaries of the data.  

1. Calculate and report the total number of missing values in the data set (i.e. the total number of rows with \color{red}{\verb|NA|}NAs)  

```r
total_activity_novalue <- sum(is.na(activity$steps))
print(paste("Number of missing values in dataset: ",total_activity_novalue))
```

```
## [1] "Number of missing values in dataset:  2304"
```

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.  
**The missing values in the data set will be replace by the mean number of steps per interval**

```r
# getting the mean number of steps per interval
mean_steps <- mean(average_daily_activity$mean)
```

3. Create a new data set that is equal to the original data set but with the missing data filled in. 

```r
# Imputing missing values
print(paste("Replace missing value with : ",mean_steps))
```

```
## [1] "Replace missing value with :  37.3825995807128"
```

```r
# creating new data set
activity_new_set <- transform(activity, steps = ifelse(is.na(activity$steps), yes = mean_steps, no = activity$steps))
total_steps_updated <- aggregate(steps ~ date, activity_new_set, sum)
names(total_steps_updated) <- c("Date", "Steps")
# view few rows of the new data set
head(total_steps_updated, n=10)
```

```
##          Date    Steps
## 1  2012-10-01 10766.19
## 2  2012-10-02   126.00
## 3  2012-10-03 11352.00
## 4  2012-10-04 12116.00
## 5  2012-10-05 13294.00
## 6  2012-10-06 15420.00
## 7  2012-10-07 11015.00
## 8  2012-10-08 10766.19
## 9  2012-10-09 12811.00
## 10 2012-10-10  9900.00
```

4. Make a histogram of the total number of steps taken each day and Calculate and report the **mean** and **median** total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
# draw the histogram
g <- ggplot(total_steps_updated, aes(Steps))
g+geom_histogram(boundary = 0, binwidth = 2500, col = "darkgreen", fill = "lightgreen") + ggtitle("Total of steps per day") + xlab("Steps") + ylab("Frequency") + theme(plot.title = element_text(face = "bold", size = 12) ) + scale_x_continuous (breaks = seq(0, 25000, 2500) ) + scale_y_continuous ( breaks = seq (0, 26, 2) )
```

![](PA1_template_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

**Mean of total number of steps taken per day after replacing missing values**

```r
mean(total_steps_updated$Steps)
```

```
## [1] 10766.19
```

**Median of total number of steps taken per day after replacing missing values**

```r
median(total_steps_updated$Steps)
```

```
## [1] 10766.19
```

*Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?*  
To answer this question, we need to compare the data between the two result. For this purpose, the easier way is to perform simple deduction from the first result to see if there are significant differences.

```r
diff_mean <- ((mean(total_steps_updated$Steps)) - (mean(activity_total_steps_daily$steps, na.rm=TRUE))) / (mean(activity_total_steps_daily$steps, na.rm=TRUE))
diff_mean
```

```
## [1] 0.1509434
```

```r
diff_median <- ((median(total_steps_updated$Steps)) - (median(activity_total_steps_daily$steps, na.rm=TRUE))) / (median(activity_total_steps_daily$steps, na.rm=TRUE))
diff_median
```

```
## [1] 0.03570839
```
**Conclusion**  
Based on the result shown, imputing missing data do have a significant impact on the mean and the median of the total daily number of steps, despite the median changes is relatively small. There are few bin changed with the most significant is bin for the interval between 10000 and 12500 steps, whereby it grown from a frequency of 18 to a frequency of 26. It is understood that, different methods for replace missing values may produce different result, thus may derive different conclusion.

---  

## Are there differences in activity patterns between weekdays and weekends?  
1. Create a new factor variable in the data set with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.  
*Assumptions:* Original data set is used

```r
activity$date <- as.Date(strptime(activity$date, format="%Y-%m-%d"))
activity$datetype <- sapply(activity$date, function(x) {
        if (weekdays(x) == "Saturday" | weekdays(x) =="Sunday") 
                {y <- "Weekend"} else 
                {y <- "Weekday"}
                y
        })
head(activity, n=10)
```

```
##    steps       date interval weekday datetype
## 1     NA 2012-10-01        0  Monday  Weekday
## 2     NA 2012-10-01        5  Monday  Weekday
## 3     NA 2012-10-01       10  Monday  Weekday
## 4     NA 2012-10-01       15  Monday  Weekday
## 5     NA 2012-10-01       20  Monday  Weekday
## 6     NA 2012-10-01       25  Monday  Weekday
## 7     NA 2012-10-01       30  Monday  Weekday
## 8     NA 2012-10-01       35  Monday  Weekday
## 9     NA 2012-10-01       40  Monday  Weekday
## 10    NA 2012-10-01       45  Monday  Weekday
```

2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).

```r
activity_by_date <- aggregate(steps~interval + datetype, activity, mean, na.rm = TRUE)
plot<- ggplot(activity_by_date, aes(x = interval , y = steps, color = datetype)) +
       geom_line() +
       labs(title = "Average daily steps by type of date", x = "Interval", y = "Average number of steps") +
       facet_wrap(~datetype, ncol = 1, nrow=2)
print(plot)
```

![](PA1_template_files/figure-html/unnamed-chunk-19-1.png)<!-- -->

