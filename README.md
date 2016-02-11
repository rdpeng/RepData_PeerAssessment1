---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---
## Load packages
library(dplyr)
library(data.table)
library(ggplot2)

## Loading and preprocessing the data
activity <- read.csv("~/ReproducibleData/RepData_PeerAssessment1/activity.csv")
act <- na.omit(activity) #Second dataset with NA removed
View(activity)
View(act)

## What is mean total number of steps taken per day?
steps_daily <- aggregate(steps ~ date, data=act, sum)
mean(steps_daily$steps)

## What is the average daily activity pattern?
#1: Time series plot
plot(act$interval, act$steps, type="l")

#2: Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
av_int <- tbl_df(act)
max(av_int$steps)
av_int$interval[av_int$steps==806]
### Interval #615 contains the maximum number of steps

## Imputing missing values
## This is only partially complete as I was unable to complete
##   parts #2 and #3 for this part
# 1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with `NA`s).
sum(is.na(activity))
## There are 2304 total NA in the dataset

# 4. Make a histogram of the total number of steps
ttl_steps <- with(activity, tapply(steps, date, sum))
hist(ttl_steps, breaks = 10)

## Are there differences in activity patterns between weekdays and weekends?
# 1. Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
my_date <- as.Date(act$date)
weekend <- c("Saturday", "Sunday")
act$wkEnd <- factor((weekdays(my_date) %in% weekend),
levels=c(FALSE, TRUE), labels=c("weekday", "weekend"))

# 2. Make a panel plot containing a time series plot (i.e. `type = "l"`) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 
weeklySteps <- ggplot(act, aes(interval, steps)) + geom_point()
weeklySteps + facet_grid(.~wkEnd)