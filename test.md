---
title: "Reproducible Research Project 1"
author: "Wan-Ling Hsu"
date: "3/31/2018"
output: 
  html_document:
    keep_md: true

---



## Introduction
This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

## Data
The data for this assignment can be downloaded from the course web site:

* Dataset: [Activity monitoring data](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip) [52K]
The variables included in this dataset are:

* **steps**: Number of steps taking in a 5-minute interval (missing values are coded as <span style="color:red">NA</span>)
* **date**: The date on which the measurement was taken in YYYY-MM-DD format
* **interval**: Identifier for the 5-minute interval in which measurement was taken
The dataset is stored in a comma-separated-value (CSV) file and there are a total of 17,568 observations in this dataset.

## Loading and preprocessing the data

```r
library(plyr)
library(ggplot2)
```

1. Load the data (i.e. <span style="color:red">read.csv()</span>)

```r
# Download the file > unzip file to obtain a csv file.
if(!file.exists('activity.csv')){
        temp <- tempfile()
        fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
        download.file(fileUrl, temp, method = "curl")
        unzip(temp, 'activity.csv')
        unlink(temp)
}

activity <- read.csv("activity.csv", header=T, sep =",")
head(activity,3)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
```
2. Process/transform the data (if necessary) into a format suitable for your analysis

```r
str(activity)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

```r
# convert date field from factor to date
activity$date <- as.Date(activity$date, format="%Y-%m-%d")

# remove missing values
# NAactivity <- activity[!is.na(activity$steps),]
# str(rNAactivity)
```

## What is mean total number of steps taken per day?

For this part of the assignment, you can ignore the missing values in the dataset.

1. Calculate the total number of steps taken per day

```r
#sumStepsByDay <- tapply(activity$steps, activity$date, sum, na.rm=TRUE); dim(sumStepsByDay)
#head(sumStepsByDay,3)
sumStepsByDay <- aggregate(steps ~ date, data = activity, FUN = sum, na.rm = TRUE); dim(sumStepsByDay)
```

```
## [1] 53  2
```

```r
head(sumStepsByDay,3)
```

```
##         date steps
## 1 2012-10-02   126
## 2 2012-10-03 11352
## 3 2012-10-04 12116
```

2. If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day
#### *a. Daily step counts on date*

```r
plot(sumStepsByDay$date,sumStepsByDay$steps, type="h", main="Histogram of Daily Steps", xlab="Date", ylab="Steps per Day", col="blue", lwd=8)
abline(h=mean(sumStepsByDay$steps, na.rm=TRUE), col="red", lwd=2)
```

![](test_files/figure-html/type h for plotting histogram-1.png)<!-- -->

#### *b. Day counts on step*

```r
hist(sumStepsByDay$steps, xlab="Steps", ylab = "Days", main = "Total Steps Per Day", breaks=50, col="blue")
```

![](test_files/figure-html/Day counts on step-1.png)<!-- -->

3. Calculate and report the mean and median of the total number of steps taken per day

```r
## mean of total steps per day
meanSteps <- mean(sumStepsByDay$steps, na.rm=TRUE); meanSteps
```

```
## [1] 10766.19
```

```r
## median of total steps per day
medianSteps <- median(sumStepsByDay$steps, na.rm=TRUE); medianSteps
```

```
## [1] 10765
```
##### *Report:* 

```
## [1] "The average number of steps taken each day was 10766.1886792453 steps."
```

```
## [1] "The median number of steps taken each day was 10765 steps."
```

## What is the average daily activity pattern?
1. Make a time series plot (i.e. <span style="color:red">type="1"</span>) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
## Calculate the total number of steps taken per 5-minute, FUN = mean 
Int5min <- aggregate(steps ~ interval, data = activity, FUN = mean, na.rm = TRUE); dim(Int5min)
```

```
## [1] 288   2
```

```r
head(Int5min,3)
```

```
##   interval     steps
## 1        0 1.7169811
## 2        5 0.3396226
## 3       10 0.1320755
```

```r
# make a time series plot and add a red line with mean
plot(x = Int5min$interval, 
    y = Int5min$steps, 
    type = "l", 
    col  = "darkgreen",
    lwd  = 2,
    xlab = "Intervals/5 minutes",
    ylab = "Average Steps Taken per Day",
    main = "Average Number of Steps per 5-minute Interval")
abline(h=mean(Int5min$steps, na.rm=TRUE), col="red", lwd=2)
```

![](test_files/figure-html/5-minute interval-1.png)<!-- -->

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
maxSteps <- Int5min$interval[which.max(Int5min$steps)]; maxSteps
```

```
## [1] 835
```

```r
maxIntSteps <- max(Int5min$steps); maxIntSteps
```

```
## [1] 206.1698
```
##### *Report:* 

```
## [1] "The maximum number of steps taken per 5-minute Interval was 835 steps."
```

```
## [1] "The maximum 5-minute interval mean of steps taken was 206.169811320755 steps."
```

## Imputing missing values
Note that there are a number of days/intervals where there are missing values (coded as <span style="color:red">NA</span>). The presence of missing days may introduce bias into some calculations or summaries of the data.

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with <span style="color:red">NA</span>s)

```r
## sum of all missing values (NA) in data
sumNA <- sum(is.na(activity$steps)); sumNA
```

```
## [1] 2304
```
##### *Report:* 

```
## [1] "The total number of missing values in the dataset is 2304"
```

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.


```
## [1] "Replace NA with the mean of 5-minute interval"
```

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
# Create a new dataset impute"
impute <- activity
naIndex <- which(is.na(impute$steps)); length(naIndex)
```

```
## [1] 2304
```

```r
# Replace NA with the mean of 5-minute interval
mean5minInt <- tapply(impute$steps, impute$interval, mean, na.rm=TRUE, simplify = TRUE)
impute$steps[naIndex] <- mean5minInt[as.character(impute$interval[naIndex])]
head(impute,3)
```

```
##       steps       date interval
## 1 1.7169811 2012-10-01        0
## 2 0.3396226 2012-10-01        5
## 3 0.1320755 2012-10-01       10
```

```r
#check is any NA in impute dataset
sumNAImpute<- sum(is.na(impute$steps)) 

paste("There is", sumNAImpute, "NA in dataset impute")
```

```
## [1] "There is 0 NA in dataset impute"
```

4. Make a histogram of the total number of steps taken each day and Calculate and report the **mean** and **median** total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
sumStepsByDayImpute <- aggregate(steps ~ date, data = impute, FUN = sum, na.rm = TRUE); dim(sumStepsByDayImpute)
```

```
## [1] 61  2
```

```r
head(sumStepsByDayImpute,3)
```

```
##         date    steps
## 1 2012-10-01 10766.19
## 2 2012-10-02   126.00
## 3 2012-10-03 11352.00
```
#### *a. Daily step counts on date*

```r
plot(sumStepsByDayImpute$date, sumStepsByDayImpute$steps, type="h", main="Histogram of Daily Steps (without missing values)", xlab="Date", ylab="Steps per Day", col="purple", lwd=8)
abline(h=mean(sumStepsByDay$steps, na.rm=TRUE), col="red", lwd=2)
```

![](test_files/figure-html/type h for plotting histogram for imputed data-1.png)<!-- -->

#### *b. Day counts on step*

```r
hist(sumStepsByDayImpute$steps, xlab="Steps", ylab = "Days", main = "Total Steps Per Day (without missing values)", breaks=50, col="purple")
```

![](test_files/figure-html/Day counts on step for impute-1.png)<!-- -->

#### *Data with missing values, NA:*

```r
summary(sumStepsByDay)
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

#### *Data without missing values, NA:*

```r
summary(sumStepsByDayImpute)
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
#### *Report*

```
## [1] "Mean and median values are almost identical, but 1st and 3rd quantiles are significantly different."
```

## Are there differences in activity patterns between weekdays and weekends?
For this part the <span style="color:red">weekdays()</span> function may be of some help here. Use the dataset with the filled-in missing values for this part.

1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

```r
impute$day <- ifelse(weekdays(as.Date(impute$date)) == "Saturday" | weekdays(as.Date(impute$date)) == "Sunday", "weekend", "weekday")
head(impute)
```

```
##       steps       date interval     day
## 1 1.7169811 2012-10-01        0 weekday
## 2 0.3396226 2012-10-01        5 weekday
## 3 0.1320755 2012-10-01       10 weekday
## 4 0.1509434 2012-10-01       15 weekday
## 5 0.0754717 2012-10-01       20 weekday
## 6 2.0943396 2012-10-01       25 weekday
```

```r
table(impute$day)
```

```
## 
## weekday weekend 
##   12960    4608
```


2. Make a panel plot containing a time series plot (i.e. <span style="color:red">type="1"</span>) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.

```r
imputeInt5min <- ddply(impute, .(interval, day), summarize, meanIntStep = mean(steps))
head(imputeInt5min,3)
```

```
##   interval     day meanIntStep
## 1        0 weekday   2.2511530
## 2        0 weekend   0.2146226
## 3        5 weekday   0.4452830
```


```r
ggplot(imputeInt5min, aes(x =interval , y=meanIntStep, color=day)) +
       geom_line() +
       labs(title = "Average Daily Steps: weekday vs weekend", x = "Interval", y = "Total Number of Steps") +
       scale_color_manual(values = c("blue", "red")) +
       facet_wrap(~ day, ncol = 1, nrow=2) +
       theme_bw()+
       theme(plot.title = element_text(hjust = 0.5)) +
       theme(strip.background =element_rect(fill="yellow")) +
       theme(strip.text = element_text(colour = 'black'))
```
![](Coursera_DataScience_5_ReproducibleResearch/instructions_fig/sample_panelplot.png)<!-- -->
![](test_files/figure-html/weekday vs weekend-1.png)<!-- -->


