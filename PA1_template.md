---
title: "Repreducable Research - Project 1"
author: "Charlie Becker"
date: "5/21/2018"
output: 
  html_document: 
    keep_md: yes
---


#### This is a basic RMarkdown file that will be used to demostrate it ability to to create documents with embedded code and figures.  It will center around a fitbit-like dataset that counts the number of steps taken over a two month period.

First we'll load the data and convert the dates intoa computer readable format.


```r
d <- read.csv("/Users/charlesbecker/Downloads/activity.csv")
d$date <- as.Date(strptime(d$date, "%Y-%m-%d"))
```
## Visualization 

We'll sum the steps taken grouped by daily time interval, produce a histogram and find the interval with the highest mean step count.


```r
steps_per_day <- tapply(d$steps,d$date,sum)

hist(steps_per_day, breaks = 15, col = 'Dark Green', xlab = 'Steps per day')
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

```r
summary(steps_per_day)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##      41    8841   10765   10766   13294   21194       8
```

Here's a time series plot of average steps per daily interval and it's summary statistics.


```r
steps_per_interval <- tapply(d$steps,d$interval,mean, na.rm=T)

plot(unique(d$interval),steps_per_interval, type = 'l', lwd = 2, col = 'blue',
     xlab = 'Daily Interval Period',
     ylab = 'Steps per Interval')
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

```r
names(steps_per_interval)[which.max(steps_per_interval)]
```

```
## [1] "835"
```
Above, you can see the maximium mean step interval is 835.

## Imputing missing Values

Here we'll sum the NA values, impute the mean step count of the interval, and display another histogram and it's summary stats.


```r
sum(is.na(d$steps))
```

```
## [1] 2304
```

```r
df <- data.frame(as.numeric(names(steps_per_interval)),steps_per_interval)

index <- which(is.na(d))

for (i in index) {
    d[i,1] <- as.numeric(df[which(df[,1]==d[i,3]),2])
}

steps_per_day <- tapply(d$steps,d$date,sum)
summary(steps_per_day)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##      41    9819   10766   10766   12811   21194
```

```r
hist(steps_per_day, breaks = 15, col = 'Dark Red', xlab = 'Steps per day')
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

Not much changed by imputing onto the NA values.  The first and third quartile shifted quite a bit, but the median only increased by 1 and the mean remained the same.

## Seperate by day of the week

Create a column of day of the week, create new binary column of 'weekday' or 'weekend', and create a panel plot comparing mean steps per interval separated by weekday/weekend.


```r
d$weekday <- sapply(d$date,weekdays)

wkend <- function(x) {
    if (x == 'Saturday' | x == 'Sunday') {y <- 'Weekend'}
    else (y <- 'Weekday')
        }

d$weekend <- sapply(d$weekday, wkend)

mean_steps_day <- tapply(d$steps,list(d$interval,d$weekend),mean)


par(mfrow = c(2,1))
plot(unique(d$interval),mean_steps_day[,1], type = 'l',
     xlab = "", ylab = 'Mean steps per day', main = 'Weekday')
plot(unique(d$interval),mean_steps_day[,2], type = 'l',
     xlab = "Daily interval", ylab = 'Mean steps per day', main = 'Weekend')
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->
