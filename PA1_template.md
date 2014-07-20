---
title: "PAmardown1105"
author: "Sandra Kilpatrick"
date: "Sunday, July 20, 2014"
output: html_document
---

#Reproducible Research
#Peer Assessment 1

##Load and preprocessing the data
```{r echo=TRUE}
library(stats)
setwd("C:/Users/Sandra/DataScience/ReproducibleResearch")
fitdata=read.csv("/Users/Sandra/DataScience/ReproducibleResearch/activity.csv",header=TRUE)
fitdata$date=as.Date(fitdata$date,"%Y-%m-%d")
```
```
##What is mean total number of steps taken per day?
###For this part of the assignment, you can ignore the missing values in the dataset.
###Sum the total steps for each date.
```{r echo=TRUE}
stepsbyday<-aggregate(steps~date,data=fitdata,sum)
```
###1. Make a histogram of the totl number of steps taken each day
```{r echo=TRUE}
hist(stepsbyday$steps,xlab="total Steps",main="Total Steps")
```
###2. Calculate and report the mean and median for total steps taken per day.
```{r echo=TRUE}
meansteps<-mean(stepsbyday$steps,na.rm=TRUE)
mediansteps<-median(stepsbyday$steps,na.rm=TRUE)
```
##What is the average daily activity pattern?
##The mean number of steps taken per day is
```{r echo=TRUE}
meansteps
```
#and the median number of steps taken per day is
```{r echo=TRUE}
mediansteps
```
##What is the average daily activity pattern?
###Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
```{r echo=TRUE}
library(ggplot2)
avgsteps = data.frame(xtabs(steps ~ interval, aggregate(steps ~ interval, fitdata,mean)))
qplot(interval, Freq, data = avgsteps, ylab = "Average Steps", xlab = "5-minute Daily Interval") + 
    labs(title = "Average Number of Steps Taken by 5-Minute Interval")
```
##Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
```{r echo=TRUE}
maxinterval = which.max(avgsteps$Freq)
maxsteps = max(avgsteps$Freq)
```
##Interval
```{r echo=TRUE}
maxinterval
```
##contains the maximum number of steps on average of 
```{r echo=TRUE}
maxsteps
```
##Inputing missing values
###Note that there are a number of days/intervals where there are missing values coded as (NA)). The presence of missing days may introduce bias into some calculations or summaries of the data.
```{r echo=TRUE}
totalrecords = length(fitdata$steps)
completerecords = length(na.omit(fitdata$steps))
missingrecords = totalrecords - completerecords
```
###2. Devise a strategy for filling in all of the missing values in the dataset.
###The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
```{r echo=TRUE}
fitdata$steps2=fitdata$steps
for (i in 1:length(fitdata$steps)) if (is.na(fitdata$steps[i])) {
  fitdata$steps2[i] = mean(fitdata$steps,na.rm=TRUE)
}
```
###3. Create a new dataset that is equal to the original dataset but with the missing data filled in.
```{r echo=TRUE}
fitdata2=data.frame(steps=fitdata$steps2,date=fitdata$date,interval=fitdata
$interval)
```
###4. Make a historgram of the total number of steps taken each day and calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? 
###What is the impact of inputing missing data on the estimates of the total daily number of steps?
```{r echo=TRUE}
stepsbyday2=aggregate(steps~date,data=fitdata2,sum)
hist(stepsbyday2$steps)
mean(stepsbyday2$steps,na.rm=TRUE)
median(stepsbyday2$steps,na.rm=TRUE)
```
##Are there differences in the activity patterns between weekdays and weekends?
###For this part of the (weekdays()) function may be of some help here.
###Use the dataset with the filled-in missing values for this part.
```{r echo=TRUE}
day=weekdays(fitdata2$date)
daytype=vector()
for (item in day) {
  if (item=="Saturday"|| item=="Sunday"){
      daytype=append(daytype,"weekend")
    } else {
      daytype=append(daytype,"weekday")
    }
}
fitdata2$daytype=factor(daytype)
```
###2. Make a panel plot containing a time series plot (i.e. (type="l")) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days(y-axis).
```{r echo=TRUE}
avgsteps2=data.frame(xtabs(steps~interval+daytype,aggregate(steps~interval
+daytype,fitdata2,mean)))
qplot(interval,Freq,data=avgsteps2,facets=daytype~.)
```
