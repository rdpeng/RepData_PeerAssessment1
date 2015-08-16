
#Peer Asignment 1 - Reproducible Data

library(downloader)
library(ggplot2)
library(lubridate)
library(plyr)
library(dplyr)


fileUrl = "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"

# Downloading file, creating and setting a working directory

if (!file.exists("peerAsgn1")) {
        dir.create("peerAsgn1")
        setwd("peerAsgn1")
        download.file(fileUrl, destfile = "./activity.zip", method = "curl")
        download.date = date()
        list.files() 
}


# Processing Data

unzip("activity.zip", exdir = "./", unzip = "internal")

activM = read.csv("activity.csv", sep = ",")
head(activM, n = 3)
dim(activM)
summary(activM)
str(activM)

# Mean of total number of steps taken per day

## Calculate the total number of steps per day - getting mean, median and showing histogram:

totalSteps = tapply(activM$steps, activM$date, FUN = sum, na.rm = T)

mean(totalSteps)
median(totalSteps)


## Calculate the number of steps taken per day
steper = activM %>%
        filter(!is.na(steps)) %>%
        group_by(date) %>%
        summarize(steps = sum(steps)) %>%
        print
        

## Histogram of number of steps taken each day

ggplot(steper, aes(x = date, y = steps)) + geom_histogram(stat = "identity") + xlab("Dates") + ylab("Steps") + labs(title = "Total Number of Steps per Day")


## Average daily activity pattern

activP = activM %>%
        filter(!is.na(steps)) %>%
        group_by(interval) %>%
        summarize(steps = mean(steps)) %>%
        print

plot(activP$interval, activP$steps, type = "l", xlab = "Interval", ylab = "Steps", main = "Average Number of Steps Taken Across All Days", col = "magenta")

## Maximum number of steps
activP[which.max(activP$steps), ]$interval

## Calculate the total missing values in the dataset
totalNAs = sum(is.na(activM))
totalNAs


## New "cloned" dataset with missing data filled in
activM2 = activM %>%
        group_by(interval) %>%
        mutate(steps = ifelse(is.na(steps), mean(steps, na.rm = T), steps))
summary(activM2)

## Histogram of total number of steps per day

activM2Group = activM2 %>%
        group_by(date) %>%
        summarize(steps = sum(steps)) %>%
        print

ggplot(activM2Group, aes(x = date, y = steps)) + geom_histogram(stat = "identity") + xlab("Dates") + ylab("Steps") + labs(title = "Total Number of Steps per Day")

## Mean and median of total number of steps taken per day.
sumSteps = tapply(activM2$steps, activM2$date, FUN = sum, na.rm = T)
mean(sumSteps)
median(sumSteps)

## Do values differ?
mean(totalSteps) == mean(sumSteps)

median(totalSteps) == median(sumSteps)

summary(totalSteps)

summary(sumSteps)


## Impact of missing data on the estimates of the total daily number of steps. 
## Estimates are increased by 41, 3041, 370, 1416, 0, 0.

summary(sumSteps) - summary(totalSteps)


par(mfrow = c(2, 1))
hist(sumSteps, col = "magenta")
hist(totalSteps, col = "green")


## Differences in activity patterns between weekdays and weekends

dayWeek = function(date) {
        if (weekdays(as.Date(date)) %in% c("Saturday", "Sunday")) {
                "weekend"
        } 
        else {
                "weekday"
        }
}

activM2$dayType = as.factor(sapply(activM2$date, dayWeek))

## Panel plot containing time series
par(mfrow = c(2, 1))
for (type in c("weekend", "weekday")) {
        stepsType = aggregate(steps ~ interval, data = activM2, subset = activM2$dayType == type, FUN = mean)
        plot(stepsType, type = "l", main = type)
}


sessionInfo()
