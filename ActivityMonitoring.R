# Course Assingment 1
library(dplyr)

#load csv file
activity <- read.csv( "activity.csv")
activity$Date <- as.POSIXct(activity$date)


# check null/NA values.
stepsNull <- sum(is.na(activity$steps))
dateNull <- sum(is.na(activity$date))


#convert csv to dplyr (tbl.df)
activity <- tbl_df(activity)
activity <- activity %>%
        filter(!is.na(steps)) %>%
        select(steps, Date, interval)


stepsPerday <- activity %>%
        group_by(Date) %>%
        summarise(Steps = sum(steps)) %>%
        select(Date, Steps)

hist(stepsPerday$Steps, breaks = 10,
          xlab = "Total number of steps per day",
          main = "Distribution of total steps per day",
          col = "lightblue",
          type = "count")

