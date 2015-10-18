# Reproducible Research: Peer Assessment 1
Kaushik Pushpavanam  
October 17, 2015  

#Preparation
Installing timeDate package since we need weekend/weekday detection functionality later in this exercise.

```r
install.packages("timeDate", repos="http://cran.rstudio.com/") 
```

```
## Installing package into 'C:/Users/iyer/Documents/R/win-library/3.2'
## (as 'lib' is unspecified)
```

```
## package 'timeDate' successfully unpacked and MD5 sums checked
## 
## The downloaded binary packages are in
## 	C:\Users\iyer\AppData\Local\Temp\RtmpWO2TaM\downloaded_packages
```

```r
library(timeDate)
```

## Q1 - Loading and preprocessing the data
*Q1.1 - Load the data (i.e. read.csv())*

*Q1.2 - Process/transform the data (if necessary) into a format suitable for your analysis*

The data was downloaded from the following URL:
[https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip](Activity ZIP file). I then unzipped the file and the file is called "activty.csv". Let's read the CSV file into 


```r
rawActivity <- read.csv("activity.csv")
summary(rawActivity)
```

```
##      steps                date          interval     
##  Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
##  1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
##  Median :  0.00   2012-10-03:  288   Median :1177.5  
##  Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
##  3rd Qu.: 12.00   2012-10-05:  288   3rd Qu.:1766.2  
##  Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
##  NA's   :2304     (Other)   :15840
```

```r
str(rawActivity)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```
We see 3 variables describing 2 months worth of activity for one individual at 5 minute intervals:

- steps: Number of steps taking in a 5-minute interval (missing values are coded as NA)
- date: The date on which the measurement was taken in YYYY-MM-DD format
- interval: Identifier for the 5-minute interval in which measurement was taken

From the summary, it's clear that there are quite a few missing values as NA. We can clean it up if needed. Also, we see that we have date as a factor already.

## Q2 - What is mean total number of steps taken per day?

*Q2.1 - Calculate the total number of steps taken per day*

*Q2.2 - If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day*

For this part of the assignment, you can ignore the missing values in the dataset.

First, we need to sum up the steps for each day and then, we can arrive at the mean of steps per day for the entire time period

```r
byDay <- aggregate(rawActivity[, 1], list(rawActivity$date), sum, na.rm=TRUE)
hist(byDay$x, xlab="Steps taken per day", main="Histogram of steps taken per day")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 


*Q2.3 -  Calculate and report the mean and median of the total number of steps taken per day*

The mean and median are shown below:

```r
mean(byDay$x, na.rm=TRUE)
```

```
## [1] 9354.23
```

```r
median(byDay$x, na.rm=TRUE)
```

```
## [1] 10395
```

## Q3: What is the average daily activity pattern?

*Q3.1 - Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)*

To understand the daily activity pattern, we need to pivot by the 5-min intervals and plot it

```r
byInterval <- aggregate(rawActivity[, 1], list(rawActivity$interval), mean, na.rm=TRUE)
plot(byInterval$x ~ byInterval$Group.1,
     pch=20,
     xlab="Interval (in minutes)",
     ylab="Steps taken per Interval", 
     main="Plot of steps taken per Interval")
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png) 

*Q3.2 - 2.Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?*


```r
byInterval$Group.1[which.max(byInterval$x)]
```

```
## [1] 835
```

## Imputing missing values

*Q4.1 - Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)*

Following is the number of NA's in each variable

```r
for (i in 1:length(names(rawActivity))) {
  cat(names(rawActivity)[i], 
      "has", 
      length(rawActivity[,i]) -
         length(rawActivity[,i][!is.na(rawActivity[,i])]),
      "NA values\n")
}
```

```
## steps has 2304 NA values
## date has 0 NA values
## interval has 0 NA values
```


*Q4.2 - Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.*

*Q4.3 - Create a new dataset that is equal to the original dataset but with the missing data filled in.*

We know from above, that steps is the only columns with missing values. Given that an entire day's steps may be NA, it's probably better to fill NAs with mean of that interval. We will call the new dataset cleanedActivity (the raw one was called rawActivity)


```r
cleanedActivity = rawActivity #let's first copy everything and then just fix NAs
for (i in 1:length(rawActivity$steps)) {
  if (is.na(rawActivity$steps[i])) {
    cleanedActivity$steps[i] = byInterval$x[match(rawActivity$interval[i],byInterval$Group.1)]
  }
}
```

*Q4.4 - Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?*


```r
byDayCleaned <- aggregate(cleanedActivity[, 1], list(cleanedActivity$date), sum, na.rm=TRUE)
hist(byDayCleaned$x, xlab="Steps taken per day", main="Histogram of steps taken per day (Cleaned)")
```

![](PA1_template_files/figure-html/unnamed-chunk-9-1.png) 

```r
#The mean and median are shown below:
mean(byDayCleaned$x)
```

```
## [1] 10766.19
```

```r
median(byDayCleaned$x)
```

```
## [1] 10766.19
```

Difference in mean and median between raw and cleaned data are shown below


```r
mean(byDayCleaned$x) - mean(byDay$x, na.rm=TRUE)
```

```
## [1] 1411.959
```

```r
median(byDayCleaned$x) - median(byDay$x, na.rm=TRUE)
```

```
## [1] 371.1887
```

```r
mean(byDayCleaned$x) / mean(byDay$x, na.rm=TRUE)
```

```
## [1] 1.150943
```

```r
median(byDayCleaned$x) / median(byDay$x, na.rm=TRUE)
```

```
## [1] 1.035708
```

Clearly, the mean and median have both moved higher. This is because we added steps in places where there were NAs. Mean seems to have moved up by about 15% which is inline with the percentage of rows with missing values.

## Q5 - Are there differences in activity patterns between weekdays and weekends?

* Q5.1 - Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.*


```r
cleanedActivity$partOfWeek <- factor(isWeekday(cleanedActivity$date))
levels(cleanedActivity$partOfWeek)[levels(cleanedActivity$partOfWeek)=="TRUE"] <- "weekday"
levels(cleanedActivity$partOfWeek)[levels(cleanedActivity$partOfWeek)=="FALSE"] <- "weekend"
summary(cleanedActivity)  
```

```
##      steps                date          interval        partOfWeek   
##  Min.   :  0.00   2012-10-01:  288   Min.   :   0.0   weekend: 4608  
##  1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8   weekday:12960  
##  Median :  0.00   2012-10-03:  288   Median :1177.5                  
##  Mean   : 37.38   2012-10-04:  288   Mean   :1177.5                  
##  3rd Qu.: 27.00   2012-10-05:  288   3rd Qu.:1766.2                  
##  Max.   :806.00   2012-10-06:  288   Max.   :2355.0                  
##                   (Other)   :15840
```

* Q5.2 - Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.*


```r
arr1 <- split(cleanedActivity, cleanedActivity$partOfWeek)$weekday
byIntervalWeekDay <- aggregate(arr1[, 1], list(arr1$interval), mean, na.rm=TRUE)
arr2 <- split(cleanedActivity, cleanedActivity$partOfWeek)$weekend
byIntervalWeekEnd <- aggregate(arr2[, 1], list(arr2$interval), mean, na.rm=TRUE)
```

Now plotting charts

```r
par(mfrow = c(2,1), pch=20)
plot(byIntervalWeekDay$x ~ byIntervalWeekDay$Group.1,
     xlab="Interval (in minutes)",
     ylab="Steps taken per Interval", 
     main="Plot of steps taken per Interval (WeekDay)")
plot(byIntervalWeekEnd$x ~ byIntervalWeekEnd$Group.1,
     xlab="Interval (in minutes)",
     ylab="Steps taken per Interval", 
     main="Plot of steps taken per Interval (WeekEnd)")
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png) 

