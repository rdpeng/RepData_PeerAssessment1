# Course Assingment 1
library(dplyr)
library(ggplot2)

#load csv file
activity <- read.csv( "activity.csv")
activity$Date <- as.POSIXct(activity$date)


# check null/NA values.
stepsNull <- sum(is.na(activity$steps))
dateNull <- sum(is.na(activity$date))


#convert csv to dplyr (tbl.df)
activity <- tbl_df(activity)
activity_ <- activity %>%
        filter(!is.na(steps)) %>%
        select(steps, Date, interval)

# 2. Histogram of the total number of steps taken each day

stepsPerDay <- activity_ %>%
                group_by(Date) %>%
                summarise(Steps = sum(steps)) %>%
                select(Date, Steps)


hist(stepsPerDay$Steps , breaks = 10,
        xlab = "Number of steps per day",
        freq = TRUE,
        main = "Bell Shape distribution (Steps per Day)",
        axes = TRUE,
        col = "red",
        labels = TRUE,
        type = "count")

statsPerDay <- activity_ %>%
        group_by(Date) %>%
        summarise(Steps = sum(steps), meanSteps = mean(steps),
                  medianSteps = median(steps)) %>%
        select(Date, Steps, meanSteps, medianSteps)

# Do plot for:Time series plot of the average number of steps taken using
# above "statsPerDay

# The 5-minute interval that, on average, contains the maximum number of steps

intervalStats <- activity_ %>%
        group_by(interval) %>%
        summarise(sum = sum(steps),
                  mean = mean(steps)) %>%
        arrange(ave = desc(mean))

# Code to describe and show a strategy for imputing missing data






