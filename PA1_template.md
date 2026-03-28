---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---



## Loading and preprocessing the data

In this first section, I load the data and process the variable date to get a correct format of date.


``` r
# read data
activity <- read.csv("activity.csv")
activity$date <- as.Date(activity$date)
```

## What is mean total number of steps taken per day?

I aggregate the data to determine the total number of steps taken each day. The dplyr package is necessary for this.


``` r
# manage data (aggregate per day)
act_day <- activity %>% 
  group_by(date)%>% 
  summarise(all_steps = sum(steps))
```

### Histogram

I use the previous data to plot the histogram of the total number of steps taken each day.


``` r
hist(act_day$all_steps, breaks = 10,
     main = "Histogram of the total number of steps taken each day", 
     xlab = "Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

### Mean and median of the total number of steps taken per day

Also, I use the previous data to obtain the mean and median of the total number of steps taken per day.


``` r
paste("Mean:", round(mean(act_day$all_steps, na.rm = TRUE), 2))
```

```
## [1] "Mean: 10766.19"
```

``` r
paste("Median:", median(act_day$all_steps, na.rm = TRUE))
```

```
## [1] "Median: 10765"
```

## What is the average daily activity pattern?

First, I obtain the mean of number of steps taken per interval. I ommit the NA values.


``` r
act_interval <- activity %>% 
  group_by(interval)%>% 
  summarise(mean_steps = mean(steps, na.rm = T ))
```

Now, I can plot the time series.


``` r
plot(act_interval$interval, act_interval$mean_steps, type = "l", 
     main = "Mean of number of steps per interval", xlab = "Interval", ylab = "Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

Finally, I find the maximum number of steps and the interval that contains this maximum.

***Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?***

The maximum number of steps (average across all the days in the dataset) is 206.17 and it is taken in the interval 835.


``` r
max_act <- max(act_interval$mean_steps)
act_interval[act_interval$mean_steps == max_act, ]
```

```
## # A tibble: 1 × 2
##   interval mean_steps
##      <int>      <dbl>
## 1      835       206.
```

## Imputing missing values

I obtain the total of NAs in the dataset.


``` r
paste("Total of NAs in the dataset:", sum(is.na(activity$steps)))
```

```
## [1] "Total of NAs in the dataset: 2304"
```

To impute the missing values in the dataset, I use the mean of the intervals obtained in the previous section, and then assign this mean to each NA value. Then I get the new dataset without NAs.


``` r
data_NA <- merge(activity[is.na(activity$steps),], act_interval, by = "interval")
data_NA$steps <-data_NA$mean_steps
data_NA <- data_NA[,1:3]

data_NA <- rbind(data_NA,activity[!is.na(activity$steps),] )
```

Now, I obtain the same aggregation for the histogram and the mean and median of the dataset.


``` r
# manage data (aggregate per day)
act_day_NA <- data_NA %>% 
  group_by(date)%>% 
  summarise(all_steps = sum(steps))
```

### Histogram without NAs


``` r
hist(act_day_NA$all_steps, breaks = 10,
     main = "Histogram of the total number of steps taken each day \n (without NAs)")
```

![](PA1_template_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

### Mean and median of the total number of steps taken per day (without NAs)


``` r
paste("Mean (without NAs) :", round(mean(act_day_NA$all_steps, na.rm = TRUE), 2))
```

```
## [1] "Mean (without NAs) : 10766.19"
```

``` r
paste("Median (without NAs):", median(act_day_NA$all_steps, na.rm = TRUE))
```

```
## [1] "Median (without NAs): 10766.1886792453"
```

***Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?***

The mean is the same, but the median differs a little. The mean doesn't differ because the number missing values are the same in all the intervals and days, if we fill them with the mean of each interval, nether the mean of interval and the mean of day change.

## Are there differences in activity patterns between weekdays and weekends?

I calculate the new factor variable ("weekday" and "weekend"),


``` r
data_NA$weekday_s <- weekdays(data_NA$date)
data_NA$weekday <- ifelse(data_NA$weekday_s == "Sunday" | data_NA$weekday_s == "Saturday", "Weekend", "Weekday" )
data_NA$weekday <- as.factor(data_NA$weekday)
```

I aggregate the data by interval.


``` r
# manage data (aggregate per interval-weekday factor)
act_day_weekday <- data_NA %>% 
  group_by(weekday,interval)%>% 
  summarise(mean_steps = mean(steps),.groups = "drop")
```

Finnaly, I plot the number of steps taken by interval differencing between weekdays and weekends


``` r
ggplot(act_day_weekday, aes(x = interval, y = mean_steps)) +
  geom_line() +
  facet_wrap(~ weekday, ncol = 1) +
  theme_minimal() +
  labs(title = "Total number of steps taken each interval",
       x = "Interval", y = "Steps") +
  theme( plot.title = element_text(hjust = 0.5) )
```

![](PA1_template_files/figure-html/unnamed-chunk-15-1.png)<!-- -->
