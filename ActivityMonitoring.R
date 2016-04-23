# Course Assingment 1
install.packages("mice")


library(dplyr)
library(ggplot2)
library(mice)



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


activityNA <- activity   %>%
        filter(is.na(steps)) %>%
        group_by(interval)
# http://www.r-bloggers.com/imputing-missing-data-with-r-mice-package/
# will use to impute the NA


temp_activity <- mice(activity, m = 5, maxit = 50, method = 'pmm', seed = 500)
md.pattern(activity)

md.pattern(temp_activity)
temp_activity$imp$steps

complete_activity <- complete(temp_activity, 1)



