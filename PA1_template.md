---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---


## Loading and preprocessing the data

```{r simulatedata,echo=TRUE}
fileUrl<-"https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(fileUrl,destfile="./data1/Dataset.zip")
unzip(zipfile="./data1/Dataset.zip",exdir="./data1")
path_rf <- file.path("./data1" , "data1.csv")
files<-list.files(path_rf, recursive=TRUE)
act<-read.csv("./data1/activity.csv")
```


## What is mean total number of steps taken per day?
```{r}
stepperday<-tapply(act$steps,act$date,sum,na.rm=T)
hist(stepperday, xlab = "number of steps",
     main = "the total number of steps taken each day")
```


## What is the average daily activity pattern?
```{r}
mean_interval <- tapply(act$steps, act$interval, mean, na.rm = T)

plot(mean_interval, type = "l", main = "time series plot", xlab = "the 5-minute interval", ylab = "the average number of steps")
```


## Imputing missing values
```{r}
stepsNA <- sum(is.na(act$steps))
dateNA <- sum(is.na(act$date))
intervalNA <- sum(is.na(act$interval))
```
```{r}
numMissingValues <- length(which(is.na(act$steps)))
numMissingValues
```
###set a function to impute the NA
```{r}
impute <- function(x, x.impute){ifelse(is.na(x),x.impute,x)}
act2 <- act
act2$steps <- impute(act$steps, mean(act$steps))
```
###Make a histogram of the total number of steps taken each day
```{r}
act2step <- tapply(act2$steps, act2$date, sum,na.rm=TRUE)
hist(act2step, xlab='Total steps per day (Imputed)',bins=50)
```

## Are there differences in activity patterns between weekdays and weekends?
##make a new vector to describe weekday and weekend
```{r}
act2$dateType <-  ifelse(as.POSIXlt(act2$date)$wday %in% c(0,6), 'weekend', 'weekday')
```
##make the plot
```{r scatterplot,fig.height=4}
library(ggplot2)
avgAct2 <- aggregate(steps ~ interval + dateType, data=act2, mean)
ggplot(avgAct2, aes(interval, steps)) + 
  geom_line() + 
  facet_grid(dateType ~ .) +
  xlab("5-minute interval") + 
  ylab("avarage number of steps")
```
