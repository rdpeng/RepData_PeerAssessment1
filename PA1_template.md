# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data

Initially, missing entries will be removed using the complete.cases function


```r
data <- read.csv("activity.csv")

clean <- complete.cases(data)
cleandata <- data[clean,]
```

## What is mean total number of steps taken per day?



## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
