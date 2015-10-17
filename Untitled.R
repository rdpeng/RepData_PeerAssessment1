
data <- read.table(unz("activity.zip", "activity.csv"), header=T, sep=",", na.strings = "NA")

stepsPerDay<-aggregate(cbind(steps) ~ date, data = data, FUN = sum, na.rm = TRUE)
hist(stepsPerDay$steps,
     main="Histogram of total number of steps per day",
     ylab="Frequency",
     xlab="Steps",
     col="coral"
     )
library(xtable)
meanStepsPerDay<-aggregate(cbind(steps) ~ date, data = data, FUN = mean, na.rm = TRUE)
medianStepsPerDay<-aggregate(cbind(steps) ~ date, data = data, FUN = median, na.rm = TRUE)
meanMedian<- data.frame(meanStepsPerDay$date,meanStepsPerDay$steps,medianStepsPerDay$steps)
names(meanMedian)<-c("date","meansteps","mediansteps")
meanMedian<-xtable(meanMedian[1:3])

avgStepsPerInt<-aggregate(cbind(steps) ~ interval, data = data, FUN = mean, na.rm = TRUE)
high<-which.max(avgStepsPerInt$steps)
highInt<-avgStepsPerInt[high,]$interval
plot(avgStepsPerInt$interval, avgStepsPerInt$steps, type="l", xlab="Time Interval", ylab="Number of Steps",xaxt="n")
     title ("Average Steps per Time Interval")
     axis(1, at = seq(0, 2600, by = 50), las=2)
length(which(is.na(data)))

mergedData<-merge(data, avgStepsPerInt, by="interval")
NARows <- is.na(mergedData$steps.x)
mergedData$steps.x[NARows] <- mergedData$steps.y[NARows]




mergedData <- mergedData[order(mergedData$date, mergedData$interval),]




sortIdx<-order(as.Date(mergedData$date,"%y-%m-%d"), mergedData$interval)
mergedData<-mergedData[sortIdx,]
head(mergedData)

# part 4. 
stepsPerDay<-aggregate(cbind(steps) ~ date, data = data, FUN = sum, na.rm = TRUE)
stepsPerDay2<-aggregate(cbind(steps.x) ~ date, data = mergedData, FUN = sum, na.rm = TRUE)

hist(stepsPerDay2$steps.x,
     main="Histogram of total number of steps per day (with NAs substituted)",
     ylab="Frequency",
     xlab="Steps",
     col="coral")

# part 5. 
# --- Convert date variable to date format
suppressPackageStartupMessages(library(timeDate))
mergedData$date <- as.POSIXct(strptime(mergedData$date, "%Y-%m-%d",tz = "GMT"))

# --- add new column signifying weekday(TRUE) or weekend(FALSE)
mergedData["weekday"]<- isWeekday(mergedData$date)

# --- Calc average per interval/day type (weekday/weekend)
avgStepsPerInt<-aggregate(cbind(steps.x) ~ weekday+interval, data = mergedData, FUN = mean, na.rm = TRUE)
weekDayData<-subset(avgStepsPerInt,avgStepsPerInt$weekday==TRUE)
weekEndData<-subset(avgStepsPerInt,avgStepsPerInt$weekday==FALSE)

# --- Plot the difference between weekday and weekend steps
par(mfrow=c(2,2))
plot(weekDayData$interval, weekDayData$steps, type="l", xlab="Time Interval", ylab="Number of Steps",xaxt="n")
title ("Average Steps per Time Interval on Week Days")
axis(1, at = seq(0, 2600, by = 50), las=2)
plot(weekEndData$interval, weekEndData$steps, type="l", xlab="Time Interval", ylab="Number of Steps",xaxt="n")
title ("Average Steps per Time Interval on Weekends")
axis(1, at = seq(0, 2600, by = 50), las=2)



    
