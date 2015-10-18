# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data

Initially, missing entries will be removed using the complete.cases function


```r
data <- read.csv("activity.csv")

clean <- complete.cases(data)
cleandata <- data[clean,]
```

## What is mean total number of steps taken per day?

The total steps on a given day is produced in a data table as follows, using the clean data (NA removed):


```r
library(data.table)

cleandata.dt <- data.table(cleandata)
totalsteps <- cleandata.dt[,list(total.steps = sum(steps)), by='date']
```

A histogram of the data is shown below:


```r
hist(totalsteps$total.steps, breaks = 20)
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 

The mean and median total number of steps are therefore:


```r
mean(totalsteps$total.steps)
```

```
## [1] 10766.19
```

```r
median(totalsteps$total.steps)
```

```
## [1] 10765
```

## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
