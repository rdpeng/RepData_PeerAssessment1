# Reproducible Research: Peer Assessment 1

```r
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
library(ggplot2)
library(lubridate)
```

```
## 
## Attaching package: 'lubridate'
```

```
## The following object is masked from 'package:base':
## 
##     date
```


## Loading and preprocessing the data


```r
filepath <- "./activity.csv"
activityRawData <- read.csv(filepath, header = TRUE, sep = ",")

activityRawData$date <- as.POSIXct(activityRawData$date, format = "%Y-%m-%d") 
```

## What is mean total number of steps taken per day?


```r
library(dplyr)
StepsByDay <- summarise(group_by(activityRawData, date), sum(steps))
hist(StepsByDay$`sum(steps)`, breaks = 20, col = "blue", main = "Histogram of the total number of steps by day", xlab ="Total steps by day")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->


## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
