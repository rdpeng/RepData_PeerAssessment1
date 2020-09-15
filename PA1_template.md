---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---

Introduction

It is now possible to collect a large amount of data about personal movement using activity monitoring devices such as a Fitbit, Nike Fuelband, or Jawbone Up. These type of devices are part of the “quantified self” movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. But these data remain under-utilized both because the raw data are hard to obtain and there is a lack of statistical methods and software for processing and interpreting the data.

This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

The data for this assignment can be downloaded from the course web site:

Dataset: Activity monitoring data [52K]
The variables included in this dataset are:

steps: Number of steps taking in a 5-minute interval (missing values are coded as 
date: The date on which the measurement was taken in YYYY-MM-DD format
interval: Identifier for the 5-minute interval in which measurement was taken

The dataset is stored in a comma-separated-value (CSV) file and there are a total of 17,568 observations in this dataset.

We will first load the libraries needed.


```r
#Load Libraries
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

## Loading and preprocessing the data

We can check whether the files needed are already downloaded, and if not, download them, unzip them, and read the contents of the csv file into a data frame object.


```r
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(fileUrl,destfile="./data/activity.zip")

unzip(zipfile="./data/activity.zip",exdir="./data")
activityData <- read.csv("./data/activity.csv")
activityData$date <- as.Date(activityData$date)
```

## What is mean total number of steps taken per day?

Using the dplyr package we can group by the date with each day being a group and then taking the sum of each group. It should be noted that NA's are ignored for this portion.


```r
stepsPerDay <- activityData %>%
        group_by(date) %>%
        summarise(steptotal = sum(steps, na.rm = TRUE)) 
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
head(stepsPerDay)
```

```
## # A tibble: 6 x 2
##   date       steptotal
##   <date>         <int>
## 1 2012-10-01         0
## 2 2012-10-02       126
## 3 2012-10-03     11352
## 4 2012-10-04     12116
## 5 2012-10-05     13294
## 6 2012-10-06     15420
```

The following code will make a histogram for the total daily steps.


```r
hist(stepsPerDay$steptotal, main = "Histogram of Daily Steps", 
     xlab="Steps", ylim = c(0,30))
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

We can now calculate the mean and median of the total steps taken per day.


```r
meanBeforeNA <- round(mean(stepsPerDay$steptotal),digits = 2)
medianBeforeNA <- round(median(stepsPerDay$steptotal),digits = 2)

print(paste("The mean of the total daily steps is: ", meanBeforeNA))
```

```
## [1] "The mean of the total daily steps is:  9354.23"
```

```r
print(paste("The median of the total daily steps is: ", medianBeforeNA))
```

```
## [1] "The median of the total daily steps is:  10395"
```


## What is the average daily activity pattern?


```r
stepsPerInterval <- activityData %>%
        group_by(interval) %>%
        summarise(meansteps = mean(steps, na.rm = TRUE)) 
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
head(stepsPerInterval)
```

```
## # A tibble: 6 x 2
##   interval meansteps
##      <int>     <dbl>
## 1        0    1.72  
## 2        5    0.340 
## 3       10    0.132 
## 4       15    0.151 
## 5       20    0.0755
## 6       25    2.09
```

We would like to make a time series plot (i.e. type = “l”|) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis).


```r
plot(stepsPerInterval$meansteps ~ stepsPerInterval$interval,
     type="l", xlab = "5 Minute Intervals", ylab = "Average Number of Steps",
     main = "Steps By Time Interval")
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

We want to determine which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps.


```r
print(paste("Interval containing the most steps on average: ",stepsPerInterval$interval[which.max(stepsPerInterval$meansteps)]))
```

```
## [1] "Interval containing the most steps on average:  835"
```

```r
print(paste("Average steps for that interval: ",round(max(stepsPerInterval$meansteps),digits=2)))
```

```
## [1] "Average steps for that interval:  206.17"
```

## Imputing missing values

We would like to calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs).


```r
print(paste("The total number of rows with NA is: ",sum(is.na(activityData$steps))))
```

```
## [1] "The total number of rows with NA is:  2304"
```


```r
head(activityData)
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

We would like to devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

Using a for loop, we will be imputing missing values with the mean of the steps calculated earlier for all days at that particular time interval.


```r
activityDataWithoutNAs <- activityData  
for (i in 1:nrow(activityData)){
        if(is.na(activityData$steps[i])){
                activityDataWithoutNAs$steps[i]<- stepsPerInterval$meansteps[activityDataWithoutNAs$interval[i] == stepsPerInterval$interval]
        }
}

head(activityDataWithoutNAs)
```

```
##       steps       date interval
## 1 1.7169811 2012-10-01        0
## 2 0.3396226 2012-10-01        5
## 3 0.1320755 2012-10-01       10
## 4 0.1509434 2012-10-01       15
## 5 0.0754717 2012-10-01       20
## 6 2.0943396 2012-10-01       25
```

Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
stepsPerDay <- activityDataWithoutNAs %>%
        group_by(date) %>%
        summarise(steptotal = sum(steps, na.rm = TRUE)) 
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
head(stepsPerDay)
```

```
## # A tibble: 6 x 2
##   date       steptotal
##   <date>         <dbl>
## 1 2012-10-01    10766.
## 2 2012-10-02      126 
## 3 2012-10-03    11352 
## 4 2012-10-04    12116 
## 5 2012-10-05    13294 
## 6 2012-10-06    15420
```

Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
hist(stepsPerDay$steptotal, main = "Histogram of Daily Steps", 
     xlab="Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)<!-- -->


```r
meanAfterNA <- round(mean(stepsPerDay$steptotal), digits = 2)
medianAfterNA <- round(median(stepsPerDay$steptotal), digits = 2)

print(paste("The mean after imputing is: ", mean(meanAfterNA)))
```

```
## [1] "The mean after imputing is:  10766.19"
```

```r
print(paste("The median after imputing is: ", median(medianAfterNA)))
```

```
## [1] "The median after imputing is:  10766.19"
```


```r
NACompare <- data.frame(mean = c(meanBeforeNA,meanAfterNA),median = c(medianBeforeNA,medianAfterNA))
rownames(NACompare) <- c("Pre NA Transformation", "Post NA Transformation")
print(NACompare)
```

```
##                            mean   median
## Pre NA Transformation   9354.23 10395.00
## Post NA Transformation 10766.19 10766.19
```

We can see that after imputing the NA values, both the mean and the median have increased.

## Are there differences in activity patterns between weekdays and weekends?

Create a new factor variable in the dataset with two levels - “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.


```r
activityDataDoW <- activityDataWithoutNAs
activityDataDoW$date <- as.Date(activityDataDoW$date)
activityDataDoW$day <- ifelse(weekdays(activityDataDoW$date) %in% c("Saturday", "Sunday"), "weekend", "weekday")
activityDataDoW$day <- as.factor(activityDataDoW$day)
```

Make a panel plot containing a time series plot (i.e. type=“l”) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).


```r
activityDataWeekday <- filter(activityDataDoW, activityDataDoW$day == "weekday")
activityDataWeekend <- filter(activityDataDoW, activityDataDoW$day == "weekend")

activityDataWeekday <- activityDataWeekday %>%
        group_by(interval) %>%
        summarise(steps = mean(steps)) 
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
activityDataWeekday$day <- "Weekdays"

activityDataWeekend <- activityDataWeekend %>%
        group_by(interval) %>%
        summarise(steps = mean(steps)) 
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
activityDataWeekend$day <- "Weekend"

wkdayWkend <- rbind(activityDataWeekday, activityDataWeekend)
wkdayWkend$day <- as.factor(wkdayWkend$day)


g <- ggplot (wkdayWkend, aes (interval, steps))
g + geom_line() + facet_grid (day~.) + 
        theme(axis.text = element_text(size = 12),axis.title = element_text(size = 14)) + 
        labs(y = "Number of Steps") + labs(x = "Interval") + 
        ggtitle("Average Number of Steps - Weekdays vs. Weekend") + 
        theme(plot.title = element_text(hjust = 0.5))
```

![](PA1_template_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

We can see some differences in activity between the weekdays and weekend, namely a larger spike in the morning during weekdays which could be due to the work week activities around that time. Additionally, activity during the middle of the day is higher on average on weekends which could be attributed to leisurely activities or running errands. It could be that this individual is primarily at a desk during the work week as well.
