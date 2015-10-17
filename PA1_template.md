---
title: "Reproducible Research: Peer Assessment 1"
output: 
html_document: true
keep_md: true
---

## Loading and preprocessing the data
data <- read.csv("activity.csv")

clean <- complete.cases(data)
cleandata <- data[clean,]


## What is mean total number of steps taken per day?
library(data.table)

cleandata.dt <- data.table(cleandata)
totalsteps <- cleandata.dt[,list(total.steps = sum(steps)), by='date']

#### ref 1: http://stackoverflow.com/questions/11782030/sum-by-distinct-column-value-in-r

hist(totalsteps$steps, breaks = 20)

mean(totalsteps$steps)
median(totalsteps$steps)

### returns: mean of 10766.19, median of 10765


## What is the average daily activity pattern?
avgsteps <- cleandata.dt[,list(avg.steps = mean(steps)), by='interval']

x <- avgsteps$interval
y <- avgsteps$avg.steps

plot(x,y, type = "l")

maxint <- avgsteps[which(avgsteps$avg.steps == max(avgsteps$avg.steps)),]

### average max of 206.17 steps occurs at interval 835


## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
