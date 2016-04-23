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
activity_ <- activity %>%
        filter(!is.na(steps)) %>%
        select(steps, Date, interval)

# 2. Histogram of the total number of steps taken each day

stepsPerDay <- activity_ %>%
                group_by(Date) %>%
                summarise(Steps = sum(steps)) %>%
                select(Date, Steps)



<<<<<<< HEAD

=======
>>>>>>> 7dd5d2fb47276170158c557d2ae003efc1e60743
hist(stepsPerDay$Steps , breaks = 10,
        xlab = "Number of steps per day",
        freq = TRUE,
        main = "Bell Shape distribution (Steps per Day)",
        axes = TRUE,
        col = "red",
        labels = TRUE,
        type = "count")

