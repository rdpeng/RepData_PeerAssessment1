# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
if(!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")) {
        temp <- tempfile()
        download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip",temp)
        unzip(temp)
        unlink(temp)
}

data <- read.csv("activity.csv")


## What is mean total number of steps taken per day?

stepsperday <- aggregate(steps ~ date, data, sum)
hist(stepsperday$steps, main = paste("Steps/Day"), col="green", xlab="# Steps")
rmean <- mean(stepsperday$steps)
## 10766.19 average steps

## What is the average daily activity pattern?

steppattern <- aggregate(steps ~ interval, data, mean)

plot(steppattern$interval,steppattern$steps, type="l", xlab="Interval", ylab="Number of Steps",main="Steps per Day at Interval")

stepinterval <- steppattern[which.max(steppattern$steps),1]


## Imputing missing values
missing <- sum(!complete.cases(data))
imputed_data <- transform(data, steps = ifelse(is.na(data$steps), steppattern$steps[match(data$interval, steppattern$interval)], data$steps))


## Are there differences in activity patterns between weekdays and weekends?
weekdays <- c("Monday", "Tuesday", "Wednesday", "Thursday", 
              "Friday")
imputed_data$dow = as.factor(ifelse(is.element(weekdays(as.Date(imputed_data$date)),weekdays), "Weekday", "Weekend"))

steppattern2 <- aggregate(steps ~ interval + dow, imputed_data, mean)

library(lattice)

xyplot(steppattern2$steps ~ steppattern2$interval|steppattern2$dow, main="Steps per Day at each Interval",xlab="Interval", ylab="Steps", type="l")
