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


