---
title: "Reproducible Research: Peer Assessment 1"
author: "Aneta"
date: "Saturday, May 16, 2015"
output: html_document
---

# Introduction
The goal of this assignment to practice skills needed for reproducible research. Specifically this assignment use R markdown to write a report that answers the questions detailed in the sections below. In the process, the single R markdown document will be processed by knitr and be transformed into an HTML file.

Start this assignment with fork/clone the GitHub repository created for this assignment. When finish, submit this assignment by pushing your completed files into your forked repository on GitHub. The assignment submission will consist of the URL to your GitHub repository and the SHA-1 commit ID for your repository state.

#Loading and preprocessing

Load input data from a zip file from the current R working directory.

```r
library(knitr)
opts_chunk$set(echo = TRUE, results = 'hold')
library(data.table)
library(ggplot2)
library(lattice)
setwd("C:/Users/VAIO/Documents/R/Markdown")
activity <- read.csv("activity.csv", colClasses = c("numeric", "character", 
    "numeric"))
head(activity)
names(activity)

activity$date <- as.Date(activity$date, "%Y-%m-%d")
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
## [1] "steps"    "date"     "interval"
```



#What is mean total number of steps taken per day?
We ignore the missing values(a valid assumption).
We proceed by calculating the total steps per day.


```r
StepsTotal <- aggregate(steps ~ date, data = activity, sum, na.rm = TRUE)
```

histogram of the total number of steps taken per day, plotted with appropriate bin interval.


```r
hist(StepsTotal$steps, main = "Total steps by day", xlab = "day", col = "green")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 


mean and median of the number of steps taken per day.


```r
mean(StepsTotal$steps)
median(StepsTotal$steps)
```

```
## [1] 10766.19
## [1] 10765
```

#What is the average daily activity pattern?

Make a time series plot (i.e. type = “l”) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

Now I get mean of steps and time series plot


```r
time_series <- tapply(activity$steps, activity$interval, mean, na.rm = TRUE)
plot(row.names(time_series), time_series, type = "l", xlab = "5-min interval", 
    ylab = "Average across all Days", main = "Average number of steps taken", 
    col = "black")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 

```r
max_interval <- which.max(time_series)
names(max_interval)
```

```
## [1] "835"
```


#Imputing missing values

Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)


```r
activity_NA <- sum(is.na(activity))
activity_NA
```

```
## [1] 2304
```

Fist Na replaced by mean in 5 min interval


```r
StepsAverage <- aggregate(steps ~ interval, data = activity, FUN = mean)
fillNA <- numeric()
for (i in 1:nrow(activity)) {
    obs <- activity[i, ]
    if (is.na(obs$steps)) {
        steps <- subset(StepsAverage, interval == obs$interval)$steps
    } else {
        steps <- obs$steps
    }
    fillNA <- c(fillNA, steps)
}
```

Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
new_activity <- activity
new_activity$steps <- fillNA
```

Histogram


```r
StepsTotal2 <- aggregate(steps ~ date, data = new_activity, sum, na.rm = TRUE)
hist(StepsTotal2$steps, main = "Total steps by day", xlab = "day", col = "blue")
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png) 

mean and median


```r
mean(StepsTotal2$steps)
median(StepsTotal2$steps)
```

```
## [1] 10766.19
## [1] 10766.19
```


