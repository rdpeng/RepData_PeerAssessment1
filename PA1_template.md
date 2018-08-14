---
title: "Reproducible Research - Course Project 1"
author: "Kevin Graebel"
date: "August 13, 2018"
output:
  html_document: 
    keep_md: true
  pdf_document: default
---



## Loading and preprossing the data

The first step is to extract the data from the .cvs file into R, keeping the 
header names.


```r
rawData <- read.csv(file = "activity.csv", header = TRUE)
```

For this analysis, this will be using the dplyr and the lattice packages.


```r
library(dplyr)
library(lattice)
```

## Mean total steps per day

To calculate the mean steps per day, this will first group by date and 
modify the steps column to include a sum of each interval for that day.  It will
then create a histogram of daily steps, and use the "summary" function to 
report the mean and median.  It is clear that the bulk of the days are in the 
10,000 to 15,000 range, with a mean of 10,766 and median of 10,765.


```r
dailyData <- rawData %>% group_by(date) %>% summarize(steps = sum(steps))

hist(dailyData$steps, xlab = "Number of Steps", 
                        main = "Histogram of steps per day")
```

![](PA1_template_files/figure-html/steps-1.png)<!-- -->

```r
summary(dailyData$steps) 
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##      41    8841   10765   10766   13294   21194       8
```

## Average Daily Pattern

The next step is to show the pattern of activity throughout the day.  The first 
step is to review the raw material again, grouping by the interval and this time
taking the mean of steps for each interval.  na.rm = TRUE is critical to skip 
na values in the data.


```r
patternData <- rawData %>% group_by(interval) %>%
                                summarize(steps = mean(steps, na.rm = TRUE))
    
xyplot(steps ~ interval, data = patternData, type = "l")
```

![](PA1_template_files/figure-html/daily-1.png)<!-- -->

To find the maximum, the "which.max" function is used to find the row containing
the highest value, and then that row is referenced.


```r
patternData$steps[which.max(patternData$steps)]
```

```
## [1] 206.1698
```

## Imputing missing values

First, a missing vector is created to show each missing value and the total
number is counted.


```r
missing <- is.na(rawData$steps)
sum(missing)
```

```
## [1] 2304
```

A new data frame is created from the rawData frame.  Next, a for loop is used
to loop through the missing vector.  For each case that the missing vector
is TRUE, the correctedData frame replaces that value with the average value
from that interval from the previous data frame.


```r
correctedData <- rawData

for (i in 1:length(missing))
{
    if(missing[i])
    {
        correctedData$steps[i] <- 
            patternData$steps[match(correctedData$interval[i],patternData$interval)]
    }
}
```

To compare to the original histogram, again group by date and report the sum.


```r
correctedDailyData <- correctedData %>% group_by(date) %>% summarize(steps = sum(steps))

par(mfrow = c(2,1), mar = c(4,4,2,2))

hist(dailyData$steps,
     xlab = "Number of Steps", main = "Histogram of steps per day (Uncorrected)")
     
hist(correctedDailyData$steps,
     xlab = "Number of Steps", main = "Histogram of steps per day (Corrected)")
```

![](PA1_template_files/figure-html/comparing-1.png)<!-- -->

To determine the impact, we can compare the summary of the original data set

```r
summary(dailyData$steps)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##      41    8841   10765   10766   13294   21194       8
```
...compared to the corrected data set

```r
summary(correctedDailyData$steps)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##      41    9819   10766   10766   12811   21194
```
From these, we can see that the mean and median are almost completely unchanged.
The data just tightens up slightly towards the middle, as more of the data points
are defined as the average.

## Are there differences in activity patters between weekdays and weekends?

The first step is to identify the day of the week, and then create a for loop
to go through each value and assign it as a weekday or weekend.


```r
wdays <- weekdays(as.Date(correctedData$date))

for(day in 1:length(wdays))
{
    if(wdays[day]=="Saturday" || wdays[day]=="Sunday")
    { wdays[day] = "Weekend" }
    else
    { wdays[day] = "Weekday" }
}
```

Next, a new matrix is created to bind the wdays vector to the correctedData set. 

```r
weeklyData <- cbind(correctedData, wdays)

weeklyGrouped <- weeklyData %>% group_by(interval, wdays) %>%
    summarize(steps = mean(steps))
```

The data is then summarized by interval and wdays, showing the mean steps at 
each interval by either weekend or weekday.  A lattice plot is then created
with steps and interval data, broken down by weekends and weekdays.

```r
weeklyGrouped <- weeklyData %>% group_by(interval, wdays) %>%
    summarize(steps = mean(steps))

xyplot(steps ~ interval | wdays, data = weeklyGrouped,
       layout = c(1,2), type = "l")
```

![](PA1_template_files/figure-html/weekly-1.png)<!-- -->
