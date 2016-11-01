

```r
---
title: "Reproducible_research_markdown"
output: html_document
---
```

```
## Error: <text>:6:0: unexpected end of input
## 4: ---
## 5: 
##   ^
```

```r
knitr::opts_chunk$set(echo = TRUE)
```

install the basic packages

```r
library(ggplot2)
library(plyr)
```

get data

```r
activity_raw <- read.csv("activity.csv")

str(activity_raw)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```
*get data ready:
*change date to date


```r
activity_raw$date2 <- as.Date(activity_raw$date)
```

**What is total number of steps taken per day?

For this part of the assignment, you can ignore the missing values in the dataset.
Calculate the total number of steps taken per day
Make a histogram of the total number of steps taken each day
Calculate and report the mean and median of the total number of steps taken per day
    

```r
stepsByDay <- tapply(activity_raw$steps, activity_raw$date, sum, na.rm=TRUE)

qplot(stepsByDay, xlab='Count of days', ylab='Total # steps per day', bins=10)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)

```r
stepsByDayMean <- mean(stepsByDay)
stepsByDayMedian <- median(stepsByDay)
```
Mean: 

```r
stepsByDayMean 
```

```
## [1] 9354.23
```
Median:

```r
print(stepsByDayMean)
```

```
## [1] 9354.23
```

**What is the average daily activity pattern?

Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?




```r
activity_noNA <-na.omit(activity_raw)
avg_steps_per_interval <-ddply(activity_noNA, .(interval), summarize, avg_steps=mean(steps))

plot(x=avg_steps_per_interval$interval, y=avg_steps_per_interval$avg_steps, type="l", xlab="Interval", ylab="Avg # steps", col="blue")
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png)

```r
max_avg_step_data <-avg_steps_per_interval[which.max(avg_steps_per_interval$avg_steps),]
```

Maximum Avg Steps occurs at : 

```r
print(max_avg_step_data)
```

```
##     interval avg_steps
## 104      835  206.1698
```

**Imputing missing values


Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
Devise a strategy for filling in all of the missing values in the dataset. 
Make a histogram of the total number of steps taken each day 
Calculate and report the mean and median total number of steps taken per day. 
Do these values differ from the estimates from the first part of the assignment? 
What is the impact of imputing missing data on the estimates of the total daily number of steps?

* the number of NAs in steps


```r
total_missing=sum(is.na(activity_raw))
```

Rows with NAs: 'r print(total_missing)'


*to replace the NAs in steps
* 1 get the NAs and create a logical vector
* 2 calculate the means at every interval without the NAs
* 3 replace each missing step with the mean as calculated above


```r
step_nas <- is.na(activity_raw$steps)
avg_interval_imputed <- tapply(activity_raw$steps, activity_raw$interval, mean, na.rm=TRUE, simplify=TRUE)
activity_raw$steps[step_nas] <- avg_interval_imputed[as.character(activity_raw$interval[step_nas])]
```

*histogram - number of steps per day


```r
avg_stepsimputedna_per_day <-tapply(activity_raw$steps, activity_raw$date, sum)

qplot(avg_stepsimputedna_per_day, xlab='Count of days', ylab='Total # steps per day (imputing NAs by mean)', bins=10)
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png)

```r
stepsByDayMean_imputed <- mean(avg_stepsimputedna_per_day)
stepsByDayMedian_imputed <- median(avg_stepsimputedna_per_day)

print(stepsByDayMean_imputed)
```

```
## [1] 10766.19
```

```r
print(stepsByDayMedian_imputed)
```

```
## [1] 10766.19
```
Mean with Imputed NAs:  

```r
print(stepsByDayMean_imputed)
```

```
## [1] 10766.19
```
Median with Imputed NAs: 

```r
print(stepsByDayMedian_imputed)
```

```
## [1] 10766.19
```
Mean removing NAs: 

```r
print(stepsByDayMean)
```

```
## [1] 9354.23
```
Median removing NAs : 

```r
print(stepsByDayMedian)
```

```
## [1] 10395
```

* calculate the change in mean and median when imputation is used


```r
difference_in_mean <-stepsByDayMean_imputed - stepsByDayMean
difference_in_median <-stepsByDayMedian_imputed - stepsByDayMedian
```

Imputation has caused the mean to increase by : 

```r
print(difference_in_mean)
```

```
## [1] 1411.959
```
Imputation has caused the median to increase by : 

```r
print(difference_in_median)
```

```
## [1] 371.1887
```


**Are there differences in activity patterns between weekdays and weekends?

For this part the weekdays() function may be of some help here. 
Use the dataset with the filled-in missing values for this part.

Create a new factor variable in the dataset with two levels - "weekday" and "weekend".
Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 

*create a new variable that categorises the day as weekday or weekend


```r
activity_raw2 <- mutate(activity_raw, weektype = ifelse(weekdays(activity_raw$date2) == "Saturday" | weekdays(activity_raw$date2) == "Sunday", "weekend", "weekday"))
activity_raw2$weektype <- as.factor(activity_raw2$weektype)
```

*make a panel plot

```r
aggregated_activity <- aggregate(steps ~ interval+weektype, data=activity_raw2, FUN=mean)

ggplot(aggregated_activity, aes(x=interval, y=steps, color=weektype))+ geom_line() + facet_wrap(~weektype, ncol=1, nrow=2)
```

![plot of chunk unnamed-chunk-21](figure/unnamed-chunk-21-1.png)
```
```

