# Course Assingment 1
# Loading istall packages and libraries
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

#Loading and Preprocessing of Data

#convert csv to dplyr (tbl.df) removing NA's
activity <- tbl_df(activity)
activity_No_NA <- activity %>%
        filter(!is.na(steps)) %>%
        select(steps, Date, interval)

# 2. What is the meand total number of steps taken per day
# Histogram of the total number of steps taken each day

stepsPerDay <- activity_No_NA %>%
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


statsPerDay <- activity_No_NA %>%
        group_by(Date) %>%
        summarise(Steps = sum(steps), meanSteps = mean(steps)) %>%
        select(Date, Steps, meanSteps)



# What is the average daily activity pattern?
# The 5-minute interval that, on average, contains the maximum number of steps

intervalStats <- activity_No_NA %>%
        group_by(interval) %>%
        summarise(sum = sum(steps),
                  mean = mean(steps)) %>%
        arrange(ave = desc(mean))

# Plot using
q <- ggplot (intervalStats, aes(interval, mean))
p  <- q + geom_point(color = "steelblue", size = 4, alpha = 1/2 ) + geom_smooth() + labs(title = "Average daily activity pattern") + labs(x = "5 min Interval", y = "Steps Mean Aggregated Days")


# Code to describe and show a strategy for imputing missing data
# we need to find out if there are a lot of NA that may affect the analysis

library(mice)
# http://www.r-bloggers.com/imputing-missing-data-with-r-mice-package/

md.pattern(activity)

# Data shows that there are 2304 NA affecting Variable = steps
# Imputing base on mean of the data points is probably too conservative and thus
# it will not change the average but it however reduces the variance.
# This could lead to more type error.
View(activity)
summary(activity)

# Find out the % of NA that would affect the Data
# Removing/ dropping categorical 5 minute interval since they will be part of grouping
# and No NA are in there.
missing <- activity[,-c(2,3)]


# Now we have to look for > 5 % that have NA's
# percentMissing

percentMissing <- function(x){
        sum(is.na(x)) /
        length(x) * 100
}

# Apply the above funstion to check for the % of Na that are missing.
apply(activity, 2, percentMissing)

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


