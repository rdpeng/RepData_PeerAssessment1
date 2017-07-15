## THis is the data analysis for Coursera Data Science Class5 Week2 Project1
## Charles 07/13/2017

## Set environment and load data
setwd("C:/Study/Coursera/1 Data-Science/2 RStudio/5 Class 5/2 week2/RepData_PeerAssessment1")
dataAct <- read.csv("activity.csv")
str(dataAct)
head(dataAct)
tail(dataAct)
dataAct$steps

## Mean total number of steps taken per day
dataPerDay <- with(dataAct, aggregate(steps, by=list(date), sum))
dataByDate <- aggregate(steps ~ date, dataAct, sum)
head(dataByDate)
library(ggplot2)
g <- ggplot(dataByDate, aes(x=steps))
q <- g + geom_histogram(binwidth = 1000) +
        xlab("Total steps per day") +
        ggtitle("Histogram of the total number of steps taken each day")
plot(q)

mean(dataByDate$steps)
median(dataByDate$steps)

## Average daily activity pattern
dataByInterval <- aggregate(steps ~ interval, dataAct, mean)
head(dataByInterval)
g <- ggplot(dataByInterval, aes(x=interval, y=steps))
q <- g +
        geom_line() +
        xlab("interval") +
        ylab("Number of steps") +
        ggtitle("Time series plot")
plot(q)

dataByInterval[which.max(dataByInterval$steps),1]

## Imputing missing values
sum(is.na(dataAct$steps))

dataAct2 <- dataAct
for (i in 1:length(dataAct$steps)){
        if (is.na(dataAct2$steps[i])){
                dataAct2$steps[i] <- dataByInterval[dataByInterval$interval == dataAct2$interval[i], 2]
        }
}

dataByDate2 <- aggregate(steps ~ date, dataAct2, sum)
head(dataByDate2)
g <- ggplot(dataByDate2, aes(x=steps))
q <- g + geom_histogram(binwidth = 1000) +
        xlab("Total steps per day") +
        ggtitle("Histogram of the total number of steps taken each day")
plot(q)
mean(dataByDate2$steps)
median(dataByDate2$steps)

## Differences in activity between weekdays and weekends
weekdayOrNot <- weekdays(as.Date(dataAct2$date))
for (i in 1:length(weekdayOrNot)){
        if (weekdayOrNot[i] %in% c("Monday","Tuesday","Wednesday","Thursday","Friday")){
                weekdayOrNot[i] <- "Weekday"
        }
        else if (weekdayOrNot[i] %in% c("Saturday","Sunday")){
                weekdayOrNot[i] <- "Weekend"
        }
}

dataAct2 <- cbind(dataAct2, weekdayOrNot)
head(dataAct2)

dataByInterval2 <- aggregate(steps ~ interval + weekdayOrNot, dataAct2, sum)
head(dataByInterval2)
g <- ggplot(dataByInterval2, aes(x=interval,y=steps))
q <- g +
        geom_line() +
        facet_grid(weekdayOrNot ~ .)
plot(q)



































