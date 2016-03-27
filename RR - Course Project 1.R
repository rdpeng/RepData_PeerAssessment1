############################################
## Reproducible Research Course Project 1 ##
############################################

## As I am french, I need to change the R setting in order to get
## the weekdays in english
curr_locale <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME","en_US.UTF-8")
## To come back to local setting
## Sys.setlocale("LC_TIME",curr_locale)

## Set working directory
setwd("~/Coursera/Reproducible Research/Week1/Course Project 1")

## Set libraries
library(plyr)
library(ggplot2)
library("RColorBrewer")
library("lattice")

###########################################
## 1. Loading and preprocessing the data ##
###########################################

## Creates a "data" directory
if (!file.exists("data")){
        dir.create("data")
}

## No need to unzip the file which is already a csv file     
## unzip ("./data/data.zip", exdir = "./data/")

## Creates data table with the read.csv function
data <- data.table(read.csv("./data/activity.csv", sep = ",",stringsAsFactors=FALSE))

str(data)
## Classes ‘data.table’ and 'data.frame':	17568 obs. of  3 variables:
## $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
## $ date    : chr  "2012-10-01" "2012-10-01" "2012-10-01" "2012-10-01" ...
## $ interval: int  0 5 10 15 20 25 30 35 40 45 ...

## Transforms the "date" variable into Date format
data$date <- as.Date(data$date) 

str(data)
## Classes ‘data.table’ and 'data.frame':	17568 obs. of  3 variables:
## $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
## $ date    : Date, format: "2012-10-01" "2012-10-01" "2012-10-01" ...
## $ interval: int  0 5 10 15 20 25 30 35 40 45 ...

## Creates a data ignoring missing data NA
noNAdata <- na.omit(data) 

str(data)
## Classes ‘data.table’ and 'data.frame':	15264 obs. of  3 variables


##########################################################
## 2. What is mean total number of steps taken per day? ##
##########################################################

## Calculate the total number of steps taken per day
StepsByDay <- tapply(noNAdata$steps, data$date, sum)

## Makes a histogram of the total number of steps taken each day
hist(StepsByDay, 
     main="Number of steps taken per day",
     breaks=10,
     xlab="Number of steps",
     col = brewer.pal(n=9,name = "Oranges"),
     xlim = c(0,25000),
     ylim = c(0,20))

## Mean of the total number of steps taken per day
mean(StepsByDay)
## [1] 10766.19

## Median of the total number of steps taken per day
median(StepsByDay)
## [1] 10765

##########################################################
## 3. What is mean total number of steps taken per day? ##
##########################################################

## Calculate average steps for each of 5-minute interval during a 24-hour period
IntervalMean <- ddply(noNAdata,~interval, summarise, mean=mean(steps))

## Plots the 5-minute interval and the average number of steps taken,
## averaged across all days
graph <- ggplot(data=IntervalMean, aes(x=interval, y=mean)) +
        geom_line(color = "blue") +
        xlab("5-minute interval") +
        ylab("average number of steps taken") +
        ggtitle("Average number of steps taken by 5 minutes interval")
print(graph)

## Which 5-minute interval contains the maximum number of steps ?
IntervalMean[which.max(IntervalMean$mean), ]
##      interval     mean
##  104      835 206.1698
## The person's daily activity peaks around 8:35am at a mean of 206 steps.

################################
## 4. Imputing missing values ##
################################

## Calculates number of rows in activity data set with NA rows
sum(is.na(data$steps))
## [1] 2304

## Strategy : replace NAs with the mean for the particular interval number.
## Creates a new new data set ("mergeddata") with imputed NA values as stated in strategy

## Merge activity data set with stepsPerInt data set
mergeddata = merge(data, IntervalMean, by="interval")

# Get list of indexes where steps value = NA
NAindex <- which(is.na(mergeddata$steps))

# Replace NA values in "steps" variable with value from "mean" variable
mergeddata$steps[NAindex] <- mergeddata$mean[NAindex]

## Calculate the total number of steps taken per day
NewStepsByDay <- tapply(mergeddata$steps, mergeddata$date, sum)

## Makes a histogram of the total number of steps taken each day
hist(NewStepsByDay, 
     main="Number of steps taken per day",
     breaks=10,
     xlab="Number of steps",
     col = brewer.pal(n=9,name = "Oranges"),
     xlim = c(0,25000),
     ylim = c(0,25))

## Mean of the total number of steps taken per day
mean(NewStepsByDay)
## [1] 10766.19

## Median of the total number of steps taken per day
median(NewStepsByDay)
## [1] 10766.19


##################################################################################
## 5. Are there differences in activity patterns between weekdays and weekends? ##
##################################################################################

## As I am french, I need to change the R setting in order to get
## the weekdays in english
curr_locale <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME","en_US.UTF-8")
## To come back to local setting
## Sys.setlocale("LC_TIME",curr_locale)

## Creates a factor variable weektime with two levels (weekday, weekend).
weektime <- as.factor(ifelse(weekdays(mergeddata$date) %in% 
                                        c("Saturday","Sunday"),"weekend", "weekday"))

## Creates a new column with weekend or weekday depending on weektime factor
mergeddata$daytype[weektime == "weekend"] <- "weekend"
mergeddata$daytype[weektime == "weekday"] <- "weekday"

## Computes the average number of steps taken, averaged for each 5-minute interval
## and for weekdays and weekends
meansteps <- aggregate(steps ~ interval + daytype, mergeddata, mean)

## Makes a panel plot containing a time series plot of the 5-minute interval
## and the average number of steps taken, 
## averaged across all weekday days or weekend days.

library("lattice")
p <- xyplot(steps ~ interval | daytype, data=meansteps,
            layout=c(1,2),
            type = 'l',
            main="Average Number of Steps, Weekdays vs. Weekend",
            xlab="5-Minute Interval (military time)",
            ylab="Average Number of Steps")
print (p)    

