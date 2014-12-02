# Assignment Notes

unzip("activity.zip")
activityData <- read.csv("activity.csv")

# variables - steps, date, interval
# steps: Number of steps taking in a 5-minute interval (missing values are 
# coded as NA)
# date: The date on which the measurement was taken in YYYY-MM-DD format
# interval: Identifier for the 5-minute interval in which measurement was taken


# David M. HashmanCOMMUNITY TA· 
# When subsetting data, you also might want to consider complete.cases().

# 1. Make a histogram of the total number of steps taken each day
  # ************ Convert date to posix date *******************
     activityData$posdate <- strptime(activityData$date, format="%Y-%m-%d") # this does not work well with aggregate func
     totalStepsByDay <- with(activityData, aggregate(x=steps, by=list(posdate), FUN='sum'))

   # Hopefully this is correct - may need to use log10
    hist(activityData$steps)
# 2. Calculate and report the mean and median total number of steps taken per day
     meanStepsByDay <- with(activityData, aggregate(x=steps, by=list(date), FUN='mean'))

# What is the average daily activity pattern?
# 1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
aves <- with(activityData, aggregate(steps ~ interval, data=activityDseata, mean)) # seems to be right data
# 2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
maxStepsByInterval <- which.max(aves$steps) # returns the row number, can then use this to find the corresponding interval
aves$interval[maxStepsByInterval] # this returns 835, how to convert to an actual time


