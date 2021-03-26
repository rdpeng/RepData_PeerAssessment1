---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---

I will first read in the data and show a summary of the information.  

```r
library(data.table)
data <- read.table("./activity.csv", header = T, sep = ",")
data$date <- as.Date(data$date, format = "%Y-%m-%d")
summary(data)
```

```
##      steps             date               interval     
##  Min.   :  0.00   Min.   :2012-10-01   Min.   :   0.0  
##  1st Qu.:  0.00   1st Qu.:2012-10-16   1st Qu.: 588.8  
##  Median :  0.00   Median :2012-10-31   Median :1177.5  
##  Mean   : 37.38   Mean   :2012-10-31   Mean   :1177.5  
##  3rd Qu.: 12.00   3rd Qu.:2012-11-15   3rd Qu.:1766.2  
##  Max.   :806.00   Max.   :2012-11-30   Max.   :2355.0  
##  NA's   :2304
```

Making a histogram of the total number of steps taken each day

```r
library(ggplot2)
library(plyr)
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:plyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
```

```
## The following objects are masked from 'package:data.table':
## 
##     between, first, last
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
total <- data[,1:2]
total <- total %>% group_by(date) %>% summarise(sum = sum(steps, na.rm = T))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
g <- ggplot(total, aes(sum))
g + geom_histogram()
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->



9354.2295082 and 10395 is the mean and median, respectively, steps taken each day.  

This is the average number of steps taken for each interval across all days. 


```r
average <- data[,c(1,3)]
average <- average %>% group_by(interval) %>% summarise(mean = mean(steps, na.rm = T))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
g2 <- ggplot(average, aes(interval, mean))
g2 + geom_line()
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->


This interval with the maximum number of steps on average is 835. 

We are now inputting the mean steps for each interval into observations so that have missing values. 

```r
new <- data
for (i in average$interval) {
  new[new$interval == i & is.na(new$steps), ]$steps <- average$mean[average$interval == i]
}

summary(new)
```

```
##      steps             date               interval     
##  Min.   :  0.00   Min.   :2012-10-01   Min.   :   0.0  
##  1st Qu.:  0.00   1st Qu.:2012-10-16   1st Qu.: 588.8  
##  Median :  0.00   Median :2012-10-31   Median :1177.5  
##  Mean   : 37.38   Mean   :2012-10-31   Mean   :1177.5  
##  3rd Qu.: 27.00   3rd Qu.:2012-11-15   3rd Qu.:1766.2  
##  Max.   :806.00   Max.   :2012-11-30   Max.   :2355.0
```

We can make an updated historgram now that the missing values are filled in. 

```r
total2 <- new [,1:2]
total2 <- total2 %>% group_by(date) %>% summarise(sum = sum(steps, na.rm = T))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
g3 <- ggplot(total2, aes(sum))
g3 + geom_histogram()
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

Now, we will subset the data into two datasets, a weekday data set and a weekend data set. We will then create plots to showcase the mean number of steps taken between Monday and Friday for each interval and the mean number of steps taken on Saturday and Sunday for each interval. 

```r
weekday <- new[wday(new$date) %in% 1:5,]
weekends <- new[wday(new$date) %in% 6:7,]

averageweekday <- weekday[,c(1,3)]
averageweekday <- averageweekday %>% group_by(interval) %>% summarise(mean = mean(steps, na.rm = T))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
averageweekends <- weekends[,c(1,3)]
averageweekends <- averageweekends %>% group_by(interval) %>% summarise(mean = mean(steps, na.rm = T))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
par(mfrow = c(2,1), mar = c(2,2,2,2))
with(averageweekday, plot(interval, mean, type = "l", main = "Weekday"))
with(averageweekends, plot(interval, mean, type = "l", main = "Weekend"))
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->
