---
title: "Reproducible Research: Peer Assessment 1"
 
---

## Loading and preprocessing the data


Load the data 

```r
library(lattice)
df = read.csv("C:/Users/Alexandre/Documents/Coursera/activity.csv")
```

Process/transform the data into a format suitable for your analysis and
Calculate the total number of steps taken per day

```r
df.graph = aggregate(steps ~ date, df, sum)
```

## What is mean total number of steps taken per day?

Make a histogram of the total number of steps taken each day

```r
hist(df.graph$steps, main = "Total number of steps by day", 
     xlab = "Number of steps", ylab = "Frequency", col = "green")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

Calculate and report the mean and median of the total number of steps taken per day

```r
estat = summary(df.graph$steps)
estat[3]
```

```
## Median 
##  10765
```

```r
estat[4]
```

```
##     Mean 
## 10766.19
```

## What is the average daily activity pattern?

Make a time series plot (i.e. \color{red}{\verb|type = "l"|}type = "l") of the
5-minute interval (x-axis) and the average number of steps taken, averaged 
across all days (y-axis)

```r
df.graph = aggregate(steps ~ interval, df, mean)
plot(df.graph$interval, df.graph$steps, type = "l", xlab = "Interval",
     main = "Average number of steps taken", ylab = "Average Numbers of steps",
     col = "red")
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

Which 5-minute interval, on average across all the days in the dataset, contains
the maximum number of steps?

```r
interval.max = df.graph[df.graph$steps == max(df.graph$steps),1]
interval.max
```

```
## [1] 835
```


## Imputing missing values

Calculate and report the total number of missing values in the dataset

```r
estat.df = summary(df)
estat.df[7]
```

```
## [1] "NA's   :2304  "
```

Devise a strategy for filling in all of the missing values in the dataset.

```r
insert.value = aggregate(steps ~ interval, df, mean)
```
Create a new dataset that is equal to the original dataset but with the missing 
data filled in.

```r
df.novo = df
for (i in 1:nrow(df)) {
    
    if (is.na(df[i,1])) {
        
        df.novo[i,1] = insert.value[insert.value$interval == df[i,3],2]
    }
}
```
Make a histogram of the total number of steps taken each day and Calculate and
report the mean and median total number of steps taken per day

```r
df.graph = aggregate(steps ~ date, df.novo, sum)
hist(df.graph$steps, main = "Total number of steps by day", 
     xlab = "Number of steps", ylab = "Frequency", col = "green")
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

```r
estat = summary(df.graph$steps)
estat[3]
```

```
##   Median 
## 10766.19
```

```r
estat[4]
```

```
##     Mean 
## 10766.19
```

## Are there differences in activity patterns between weekdays and weekends?

Create a new factor variable in the dataset with two levels – “weekday” and
“weekend” indicating whether a given date is a weekday or weekend day.

```r
df.novi = df
df.novi$date = as.Date(df.novi$date)
df.novi$typeday = ""
df.novi[!(weekdays(df.novi$date) == "Saturday") | 
            !(weekdays(df.novi$date)) == "Sunday",]$typeday = "Weekday"
df.novi[weekdays(df.novi$date) == "Saturday" | 
        weekdays(df.novi$date) == "Sunday",]$typeday = "Weekend"
df.novi$typeday = factor(df.novi$typeday)
```

Make a panel plot containing a time series plot  of the 5-minute interval 
(x-axis) and the average number of steps taken, averaged across all weekday days
or weekend days (y-axis)

```r
df.graph = aggregate(steps ~ interval + typeday, df.novi, mean)
xyplot(steps ~ interval | typeday, data = df.graph, type = "l",
       main = "Average number of steps by Weekdays or Weekend",
       xlab = "Interval", ylab = "Average number of steps",
       layout = c(1,2))
```

![](PA1_template_files/figure-html/unnamed-chunk-12-1.png)<!-- -->
