# Course project 1 in Reproducible Research
Prepare for the data process, load the packages


```r
library(knitr)
library(ggplot2)
library(dplyr)
```


```r
opts_chunk$set(echo=T)
```

## Loading and preprocessing the data


```r
dataF <- read.table("/Users/QianWang/Documents/Coursera_reproducible/week2/activity.csv", header=TRUE, sep=",")
```

## What is mean total number of steps taken per day?
1. Calculate the total number of steps taken per day

```r
df <- tbl_df(dataF)
df1 <- df %>%
      filter(!is.na(steps)) %>%
      group_by(date) %>%
      summarise(steps_day = sum(steps))
df1
```

```
## # A tibble: 53 × 2
##          date steps_day
##        <fctr>     <int>
## 1  2012-10-02       126
## 2  2012-10-03     11352
## 3  2012-10-04     12116
## 4  2012-10-05     13294
## 5  2012-10-06     15420
## 6  2012-10-07     11015
## 7  2012-10-09     12811
## 8  2012-10-10      9900
## 9  2012-10-11     10304
## 10 2012-10-12     17382
## # ... with 43 more rows
```

2. Make a histogram of the total number of steps taken each day


```r
qplot(df1$steps_day,main = "Histogram of steps per day", xlab = "steps per day", ylab = "frequency",binwidth=500)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)

```r
stat_bin(bins = 30)
```

```
## geom_bar: na.rm = FALSE
## stat_bin: binwidth = NULL, bins = 30, center = NULL, boundary = NULL, closed = c("right", "left"), pad = FALSE, na.rm = FALSE
## position_stack
```

3. Calculate and report the mean and median of the total number of steps taken per day

The mean is:

```r
mean(df1$steps_day)
```

```
## [1] 10766.19
```
The median is:

```r
median(df1$steps_day)
```

```
## [1] 10765
```

## What is the average daily activity pattern?

1. Make a time series plot (i.e. 𝚝𝚢𝚙𝚎 = "𝚕") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
df2<- df%>%
      filter(!is.na(steps)) %>%
      group_by(interval) %>%
      summarise(steps=mean(steps))
g<- ggplot(data = df2, aes(interval,steps)) 
g + geom_line()
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png)

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
df2$interval[which(df2$steps==max(df2$steps))]
```

```
## [1] 835
```
The 835 inteval has the maximum number of steps.

## Imputing missing values
1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with 𝙽𝙰s)


```r
sum(is.na(df))
```

```
## [1] 2304
```
The total number of NA is 2304.

2. Devise a strategy for filling in all of the missing values in the dataset.
3. Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
dff<-df
na <- is.na(dff$steps)
df3<- tapply(dff$steps,dff$interval,mean,na.rm=T)
dff$steps[na] <- df3[as.character(dff$interval[na])]
```

4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.
Do these values differ from the estimates from the first part of the assignment? 
What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
df3 <- dff %>%
      group_by(date) %>%
      summarise(steps_day = sum(steps))
qplot(df3$steps_day,main = "Histogram of steps per day", xlab = "steps per day", ylab = "frequency")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png)
The mean of number of steps per day is:

```r
mean(df3$steps_day)
```

```
## [1] 10766.19
```
The median of number of steps per day is:

```r
median(df3$steps_day)
```

```
## [1] 10766.19
```

The "mean" value did not change; the "median" value slight changed from 10765 to 10766.19 (0.01%).

## Are there differences in activity patterns between weekdays and weekends?

1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.


```r
dff$date <- as.Date(dff$date)
df4 <- dff %>%
      mutate(wkds=ifelse(weekdays(dff$date)=="Saturday" | weekdays(dff$date)=="Sunday","weekend","weekday"))
df4$wkds <- as.factor(df4$wkds)
df4
```

```
## # A tibble: 17,568 × 4
##        steps       date interval    wkds
##        <dbl>     <date>    <int>  <fctr>
## 1  1.7169811 2012-10-01        0 weekday
## 2  0.3396226 2012-10-01        5 weekday
## 3  0.1320755 2012-10-01       10 weekday
## 4  0.1509434 2012-10-01       15 weekday
## 5  0.0754717 2012-10-01       20 weekday
## 6  2.0943396 2012-10-01       25 weekday
## 7  0.5283019 2012-10-01       30 weekday
## 8  0.8679245 2012-10-01       35 weekday
## 9  0.0000000 2012-10-01       40 weekday
## 10 1.4716981 2012-10-01       45 weekday
## # ... with 17,558 more rows
```

2. Make a panel plot containing a time series plot (i.e. 𝚝𝚢𝚙𝚎 = "𝚕") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).


```r
df5 <- df4 %>%
      group_by(interval,wkds) %>%
      summarise(steps_perday=mean(steps))

gg <- ggplot(data= df5, aes(x=interval, y=steps_perday, color=wkds))
gg + geom_line() + facet_wrap(~wkds, ncol = 1, nrow=2) + ggtitle("Comparison of average steps between weekdays and weekends")
```

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16-1.png)










