Peer Assessment
===============

# Loading and preprocessing the data


```r
library(knitr)
opts_chunk$set(echo = TRUE)
library(lubridate)
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:lubridate':
## 
##     intersect, setdiff, union
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

```r
library(ggplot2)
```

```r
data <- read.csv("activity.csv", header = TRUE, sep = ',')
data$date <- ymd(data$date)
```

# What is the mean total number of steps per day

1. Calculate total steps per day.

```r
steps <- data %>%
  filter(!is.na(steps)) %>%
  group_by(date) %>%
  summarize(steps = sum(steps))
```

2. Plot histogram.

```r
ggplot(steps, aes(x = steps)) +
  geom_histogram(fill = "blue", binwidth = 1000) +
  labs(title = "Histogram of Steps per day", x = "Steps per day", y = "Frequency")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)

3. Mean and median


```r
mean_steps <- mean(steps$steps, na.rm = TRUE)
median_steps <- median(steps$steps, na.rm = TRUE)
```

```r
mean_steps
```

```
## [1] 10766.19
```

```r
median_steps
```

```
## [1] 10765
```

# What is the average daily activity pattern?

1. Calculate interval average 

```r
interval <- data %>%
    filter(!is.na(steps)) %>%
    group_by(interval) %>%
    summarize(steps = mean(steps))
```

```r
ggplot(interval, aes(x=interval, y=steps)) +
 geom_line(color = "blue")
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png)

2. Interval with max

```r
interval[which.max(interval$steps),]
```

```
## # A tibble: 1 x 2
##   interval    steps
##      <int>    <dbl>
## 1      835 206.1698
```

# Inputing missing values
1. Total number of NAs

```r
sum(is.na(data$steps))
```

```
## [1] 2304
```

2. The approach with the mean is taken to fill the NAs

3. Fill NAs

```r
data_full <- data
nas <- is.na(data_full$steps)
avg_interval <- tapply(data_full$steps, data_full$interval, mean, na.rm=TRUE, simplify=TRUE)
data_full$steps[nas] <- avg_interval[as.character(data_full$interval[nas])]
```

4. Calculate interval average, plot histogram and calculate mean and median

```r
steps_full <- data_full %>%
  filter(!is.na(steps)) %>%
  group_by(date) %>%
  summarize(steps = sum(steps))

ggplot(steps_full, aes(x = steps)) +
  geom_histogram(fill = "blue", binwidth = 1000) +
  labs(title = "Histogram of Steps per day, including missing values", x = "Steps per day", y = "Frequency")
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png)

```r
mean_steps_full <- mean(steps_full$steps, na.rm = TRUE)
median_steps_full <- median(steps_full$steps, na.rm = TRUE)
```

```r
mean_steps_full
```

```
## [1] 10766.19
```

```r
median_steps_full
```

```
## [1] 10766.19
```

Mean and Median are now the same.

# Are there differences in activity patterns between weekdays and weekends?

1. Add column

```r
data_full <- mutate(data_full, wd_we = ifelse(weekdays(data_full$date) == "Samstag" | weekdays(data_full$date) == "Sonntag", "weekend", "weekday"))
data_full$wd_we <- as.factor(data_full$wd_we)
```

2. Plot weekday/weekend interval averages

```r
interval_full <- data_full %>%
  group_by(interval, wd_we) %>%
  summarise(steps = mean(steps))
s <- ggplot(interval_full, aes(x=interval, y=steps, color = wd_we)) +
  geom_line() +
  facet_wrap(~wd_we, ncol = 1, nrow=2)
print(s)
```

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16-1.png)
