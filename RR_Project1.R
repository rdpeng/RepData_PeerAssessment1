library(dplyr)
library(ggplot2)
library(lubridate)

## Loading raw dataset
filepath <- "./activity.csv"
activityRawData <- read.csv(filepath, header = TRUE, sep = ",")

## Convert format of the column "date"
activityRawData$date <- as.POSIXct(activityRawData$date, format = "%Y-%m-%d")

## Task 1
StepsByDay <- summarise(group_by(activityRawData, date), sum(steps))
hist(StepsByDay$`sum(steps)`, breaks = 20, main = "Histogram of the total number of steps by day", xlab ="Total steps by day")

meanStepsByDay <- mean(StepsByDay$`sum(steps)`, na.rm = TRUE)
medianStepsByDay <- median(StepsByDay$`sum(steps)`, na.rm = TRUE)


## Task 2
StepsByInterval <- summarise(group_by(activityRawData, interval), AverageSteps=mean(steps, na.rm = TRUE))
ggplot(data = StepsByInterval, aes(x = interval, y = AverageSteps)) +
  geom_line() +
  xlab("5-minute interval") +
  ylab("Average number of steps taken")
maxInterval <- filter(StepsByInterval, AverageSteps == max(AverageSteps))


## Task 3
quantNA <- sum(is.na(activityRawData))
activityWithoutNA <- activityRawData 
for (i in 1:nrow(activityWithoutNA)) {
  if (is.na(activityWithoutNA$steps[i])) {
    activityWithoutNA$steps[i] <- StepsByInterval[which(activityWithoutNA$interval[i] == StepsByInterval$interval), ]$AverageSteps
  }
}

StepsByDay_2 <- summarise(group_by(activityWithoutNA, date), sum(steps))
hist(StepsByDay_2$`sum(steps)`, breaks = 20, main = "Histogram of the total number of steps by day", xlab ="Total steps by day")

meanStepsByDay_2 <- mean(StepsByDay_2$`sum(steps)`, na.rm = TRUE)
medianStepsByDay_2 <- median(StepsByDay_2$`sum(steps)`, na.rm = TRUE)

diff_mean <- meanStepsByDay_2 - meanStepsByDay
diffMedian <- medianStepsByDay_2 - medianStepsByDay

## Task 4
activityWithoutNA$day <-  ifelse(as.POSIXlt(activityWithoutNA$date)$wday %in% c(0,6), 'weekend', 'weekday')
table(activityWithoutNA$day)

StepsByInterval_Days <- aggregate(steps ~ interval + day, data = activityWithoutNA, mean)
ggplot(StepsByInterval_Days, aes(interval, steps)) + 
  geom_line() + 
  facet_grid(day ~ .) +
  xlab("5-minute interval") + 
  ylab("Average number of steps taken")

