### 1 Loading and preprocessing the data

## 1.1 Load the data
steps <- read.csv("activity.csv")

## 1.2 Process/transform the data (if necessary) into a format suitable for your analysis
NAs <- sum(is.na(steps$steps))

# Are the NAs spread out or clustered on certain dates?
naDates <- steps[which(is.na(steps$steps)),]
numNADates <- length(unique(droplevels(naDates)$date))
numNADates

# NAs occur on 8 of the 61 days. In each day there are 24x60mins = 1440mins = 288x5min increments
# 288x8 = 2304 = the number of NAs, so all 8 of those days have *ONLY* NAs
# Therefore we should remove those days completely as they add no value and removing them is neat
newsteps <- steps[which(!is.na(steps$steps)),]

### 2 What is mean total number of steps taken per day?

## 2.1 Calculate the total number of steps taken per day
totalSteps <- aggregate(newsteps[,1], by = list(newsteps$date), sum)
colnames(totalSteps) <- c("date", "steps")

## 2.2 Make a histogram of the total number of steps taken each day
hist(  totalSteps$steps,
       breaks = 25, 
       xlab = "Steps in the Day",
       main = paste("Histogram of Steps (", NAs," NAs removed)", sep=""),
       col = "royalblue1")

## 2.3 Calculate and report the mean and median of the total number of steps taken per day
meanDailySteps <- mean(totalSteps$steps)
medianDailySteps <- median(totalSteps$steps)
meanDailySteps
medianDailySteps

### 3 What is the average daily activity pattern?

## 3.1 Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) 
##     and the average number of steps taken, averaged across all days (y-axis)
intervalMeans <- aggregate(newsteps[,1], by = list(newsteps$interval), mean)
colnames(intervalMeans) <- c("Interval", "AvgSteps")
plot(intervalMeans, main = "Steps per Interval", xlab = "Interval", ylab = "Steps", type="l", col = "royalblue1")

## 3.2 Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
maxInterval <- intervalMeans[which.max(intervalMeans$AvgSteps),]
maxInterval

### 4 Imputing missing values

## 4.1 Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
NAs

## 4.2 Devise a strategy for filling in all of the missing values in the dataset.
##     The strategy does not need to be sophisticated. For example, you could use 
##     the mean/median for that day, or the mean for that 5-minute interval, etc.

# First, add day of week to see if there are weekly patterns
totalSteps$dayOfWeek <- weekdays(as.Date(totalSteps$date))
weekdayMeans <- aggregate(totalSteps[,2], by = list(totalSteps$dayOfWeek), mean)
colnames(weekdayMeans) <- c("dayOfWeek", "steps")
weekdayMeans$dayOfWeek <- as.factor(weekdayMeans$dayOfWeek)
plot(weekdayMeans$dayOfWeek, weekdayMeans$steps)

# The plot shows a significant difference between the days of the week,
# so we will use days as well as intervals to impute the data
intervalDayMeans <- aggregate(newsteps[,1], by = list(dayOfWeek = newsteps$day, interval = newsteps$interval), mean)

## 4.3 Create a new dataset that is equal to the original dataset but with the missing data filled in.

# Add DayOfWeek to the original steps dataframe, then add the mean values for day-interval,
# then combine them taking the means where steps is NA
steps$dayOfWeek <- weekdays(as.Date(steps$date))
stepsImputed <- merge(steps, intervalDayMeans, by.x = c("dayOfWeek", "interval"), by.y = c("dayOfWeek", "interval"))
stepsImputed$steps[is.na(stepsImputed$steps)] <- stepsImputed$x[is.na(stepsImputed$steps)]
stepsImputed$x <- NULL

## 4.4 Make a histogram of the total number of steps taken each day and Calculate 
##     and report the mean and median total number of steps taken per day. 
##     Do these values differ from the estimates from the first part of the assignment? 
##     What is the impact of imputing missing data on the estimates of the total daily number of steps?
totalStepsImp <- aggregate(stepsImputed$steps, by = list(stepsImputed$date), sum)
colnames(totalStepsImp) <- c("date", "steps")

hist(  totalStepsImp$steps,
       breaks = 25, 
       xlab = "Steps in the Day",
       main = paste("Histogram of Steps (", NAs," NAs imputed)", sep=""),
       col = "royalblue4")

# The mean and median daily steps are greater. Given the difference between average steps depending on day of week,
# this suggests that more of the missing data fell on days of the week with an otherwise high mean steps, so that
# when they were imputed, the overall mean (and median) was increased.
meanDailyStepsImp <- mean(totalStepsImp$steps)
medianDailyStepsImp <- median(totalStepsImp$steps)
meanDailyStepsImp
medianDailyStepsImp

# NOTUSED Get the mean for each weekday as a ratio of the mean of all days - to use on the interval means for imputing
# stepsPerDayAvg <- mean(totalSteps$steps)
# weekdayMeans$steps <- weekdayMeans$steps/stepsPerDayAvg

### 5 Are there differences in activity patterns between weekdays and weekends?

## 5.1 Create a new factor variable in the dataset with two levels - "weekday" and "weekend" 
##     indicating whether a given date is a weekday or weekend day.
stepsImputed$Weekend <- "weekday"
stepsImputed$Weekend[stepsImputed$dayOfWeek %in% c("Saturday", "Sunday")] <- "weekend"

## 5.2 Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) 
##     and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 
##     See the README file in the GitHub repository to see an example of what this plot should look like 
#      using simulated data.
intervalMeansImpWeekday <- aggregate(stepsImputed[stepsImputed$Weekend == "weekday","steps"], by = list(stepsImputed[stepsImputed$Weekend == "weekday", "interval"]), mean)
intervalMeansImpWeekend <- aggregate(stepsImputed[stepsImputed$Weekend == "weekend","steps"], by = list(stepsImputed[stepsImputed$Weekend == "weekend", "interval"]), mean)

par(mfrow=c(2,1), mar = c(0, 1, 0, 1), oma=c(3, 3, 2, 2))

plot(intervalMeansImpWeekday, xlab="", ylab="", axes=FALSE, type="l", col = "royalblue1")
title("Weekday", line = -1)
axis(3, at = seq(0,2500, 500), labels=FALSE) 
axis(2, at = seq(0,250, 50), labels=FALSE, line=-1.15)
axis(4, at = seq(0,250, 50))

plot(intervalMeansImpWeekend,  xlab="", ylab="", axes=FALSE, type="l", col = "royalblue1", ylim=c(0,200))
title("Weekend", line = -1)
axis(3, at = seq(0,2500, 500), labels=FALSE, lwd.tick=0) 
axis(2, at = seq(0,250, 50), line=-1.15)
axis(4, at = seq(0,250, 50), labels=FALSE)
axis(1, at = seq(0,2500, 500)) 

mtext('Interval', side = 1, outer = TRUE, line = 2)
mtext('Number of Steps', side = 2, outer = TRUE, line = 0)
