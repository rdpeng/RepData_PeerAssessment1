---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---


## Loading and preprocessing the data

```r
library(readr)
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

```r
activity <- read_csv("./activity.zip")
```

```
## Parsed with column specification:
## cols(
##   steps = col_double(),
##   date = col_date(format = ""),
##   interval = col_double()
## )
```

```r
steps_by_day <- group_by(activity, date) %>% summarize(sum(steps))
```


## What is mean total number of steps taken per day?

```r
library(ggplot2)
ggplot(steps_by_day, aes(x = date, y = steps_by_day$`sum(steps)`)) + 
        geom_col() +
        theme_light() +
        labs(x = "Date", y = "Steps", title = "Steps by day")
```

```
## Warning: Use of `steps_by_day$`sum(steps)`` is discouraged. Use `sum(steps)`
## instead.
```

```
## Warning: Removed 8 rows containing missing values (position_stack).
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

```r
summary(steps_by_day$`sum(steps)`)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##      41    8841   10765   10766   13294   21194       8
```

mean = 10766
median = 10765


## What is the average daily activity pattern?

```r
steps_by_interval <- group_by(activity, interval) %>% summarize(mean(steps, na.rm = TRUE))
```

Time period that contains maximum number of steps on average is 835

```r
steps_by_interval[which.max(steps_by_interval$`mean(steps, na.rm = TRUE)`),]
```

```
## # A tibble: 1 x 2
##   interval `mean(steps, na.rm = TRUE)`
##      <dbl>                       <dbl>
## 1      835                        206.
```


library(ggplot2)
ggplot(steps_by_interval, aes(x = interval, y = steps_by_interval$`mean(steps, na.rm = TRUE)`)) +
        geom_line() +
        labs(title = "Steps by interval") +
        ylab("Steps") +
        theme_bw()
````


## Imputing missing values


```r
sum(is.na(activity$steps))
```

```
## [1] 2304
```
NAs are 2304

Imputating NAs with the mean of each interval


```r
listmean <- as.list(steps_by_interval$`mean(steps, na.rm = TRUE)`)

db_no_NA <- activity %>% mutate(steps_mean = ifelse(is.na(steps), listmean, steps))
db_no_NA <- transform(db_no_NA, steps_mean = as.numeric(steps_mean))

ggplot(db_no_NA, aes(date, steps_mean)) +
        geom_col() +
        theme_light() +
        labs(x = "date", y = "steps by day", title = "steps by day (no NAs)")
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

## Are there differences in activity patterns between weekdays and weekends?


```r
db_wd <- db_no_NA %>% mutate(weekday = ifelse(weekdays(date) == 
        "Sabato" | weekdays(date) == "Domenica", yes = "Weekend", no = "Weekday"))


ggplot(db_wd, aes(interval, steps)) +
        geom_line() +
        facet_grid(.~weekday) +
        labs()
```

```
## Warning: Removed 1 row(s) containing missing values (geom_path).
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

The plot shows that there is a difference in pattern between weekday and weekend



