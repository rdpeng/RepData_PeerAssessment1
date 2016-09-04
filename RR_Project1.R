library(dplyr)

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
StepsByInterval <- summarise(group_by(activityRawData, interval), mean(steps, na.rm = TRUE))

