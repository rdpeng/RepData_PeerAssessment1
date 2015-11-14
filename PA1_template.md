---
title: 'Coursera Reproducible Research: Peer Assessment 1'
author: "by Cocu23"
output: html_document
---

## Loading and preprocessing the data   
 1. Load the data (i.e. read.csv())   

```r
# First load the necessary libraries
library(ggplot2)
library (lattice)
library(knitr)

# Load data from csv file
repdata<-read.csv("activity.csv", header=T, sep=",")
```
 2. Process/transform the data (if necessary) into a format suitable for your analysis   

```r
# First preview
head(repdata)
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

```r
# Change date to dd-mm-yyyy format
repdata$date<-strftime(repdata$date,"%d-%m-%Y")

# Preview changes 
head(repdata)
```

```
##   steps       date interval
## 1    NA 01-10-2012        0
## 2    NA 01-10-2012        5
## 3    NA 01-10-2012       10
## 4    NA 01-10-2012       15
## 5    NA 01-10-2012       20
## 6    NA 01-10-2012       25
```

## What is mean total number of steps taken per day?
>For this part of the assignment, you can ignore the missing values in the dataset.   

1. Calculate the total number of steps taken per day   

```r
total_steps =aggregate(steps ~ date, data = repdata, sum, na.rm = TRUE)
```
2. Histogram of the total number of steps taken each day   

```r
hist(total_steps$steps, main="Total Steps per Day", xlab="day", ylab="total number of steps",  col = "green")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

3. Calculate and report the mean and median of the total number of steps taken per day   

```r
mean(total_steps$steps) 
```

```
## [1] 10766.19
```

```r
median(total_steps$steps)
```

```
## [1] 10765
```

## What is the average daily activity pattern?   
1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)   

```r
time_series =tapply(repdata$steps, repdata$interval, mean, na.rm = TRUE)
plot(row.names(time_series), time_series, type = "l", xlab = "5-min interval", 
     ylab = "Average across all Days", main = "Average number of steps taken", 
     col = "red")
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png) 

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?   

```r
max_interval =which.max(time_series)
names(max_interval) 
```

```
## [1] "835"
```

## Imputing missing values
>Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.   

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)   

```r
# 1. Calculate and report the total number of missing values in the dataset
missing_values =sum(is.na(repdata)) 
missing_values 
```

```
## [1] 2304
```
2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.  

```r
 # Goal: Create new dataset in which the NA step values are replaced by the step mean of its respective day  

# First create a temporary dateset replacing NAs by zero
tempdata=repdata
tempdata$steps[is.na(tempdata$steps)]=0

# calculate the daily mean ignorigin NA values
mean_steps =aggregate(steps ~ date, data = tempdata, mean, na.rm = TRUE)

# merge the original data with the daily mean in a new temporary dataset
newData_temp=merge(repdata, mean_steps, "date")

# replace NA values of column steps.x with the values of the daily mean from column steps.y
newData_temp$steps.x[is.na(newData_temp$steps.x)] =as.numeric(newData_temp$steps.y[is.na(newData_temp$steps.x)])

# QC if there still exist NA values- we wish zero rows
nrow(subset(newData_temp, is.na(newData_temp$steps.x)==TRUE))
```

```
## [1] 0
```

```r
# look at the temp data frame
head(newData_temp)
```

```
##         date steps.x interval steps.y
## 1 01-10-2012       0        0       0
## 2 01-10-2012       0        5       0
## 3 01-10-2012       0       10       0
## 4 01-10-2012       0       15       0
## 5 01-10-2012       0       20       0
## 6 01-10-2012       0       25       0
```

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.   


```r
# create the new data set as a subset of the temporary data frame
newData=newData_temp[, 1:3]

# rename columns
colnames(newData) =c( "date","steps", "interval")

# re-order the columns as in original dataset
newData =newData[c("steps","date","interval")]

# preview the new dataset
head(newData)
```

```
##   steps       date interval
## 1     0 01-10-2012        0
## 2     0 01-10-2012        5
## 3     0 01-10-2012       10
## 4     0 01-10-2012       15
## 5     0 01-10-2012       20
## 6     0 01-10-2012       25
```
4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?   
 


```r
total_steps_new =aggregate(steps ~ date, data = newData, sum, na.rm = TRUE)
hist(total_steps_new$steps, main="Total Steps per Day", xlab="day", ylab="total number of steps",  col = "green")
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png) 
The histogramm slighty shifted its weights to the left, due to the replacement of NA values by zero.

```r
# Calculating the mean and the medium of the new dataset
mean(total_steps_new$steps)
```

```
## [1] 9354.23
```

```r
median(total_steps_new$steps)
```

```
## [1] 10395
```
It appears that due to the replacment of NA values by the daily mean, which was mostly zero, the mean and median were lowered. Before the replacement strategy these value were not taken into account. Due to its nature the mean was influenced stronger than the median.

## Are there differences in activity patterns between weekdays and weekends?   

For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.   
1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.   

```r
# creates new variable, which shall be called "weekend" in case of Saturday and Sunday and else it shall be called "weekday"
day=weekdays(as.Date(repdata$date))
head(day)
```

```
## [1] "Samstag" "Samstag" "Samstag" "Samstag" "Samstag" "Samstag"
```

```r
day_type =vector()
for (i in 1:nrow(repdata)) {
    if (day[i] == "Samstag" ) {
        day_type[i] <- "Weekend"
    } 
  if (day[i] == "Sonntag") {
       day_type[i] <- "Weekend"
  }
        else {
        day_type[i] ="Weekday"
    }
}
# how the hell can i change the language to english?
repdata$day_type =day_type
repdata$day_type =factor(repdata$day_type)

steps_per_day =aggregate(steps ~ interval + day_type, data = repdata, mean)
names(steps_per_day) =c("interval", "day_type", "steps")


head(repdata$day_type)
```

```
## [1] Weekday Weekday Weekday Weekday Weekday Weekday
## Levels: Weekday Weekend
```
2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.  

```r
xyplot(steps ~ interval | day_type, steps_per_day, type = "l", layout = c(1, 2), 
       xlab = "Interval", ylab = "Number of steps")
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14-1.png) 

