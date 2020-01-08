library(dplyr)
library(ggplot2)


dataUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"

zipfile_data = "repdata_data_activity.zip"

if(!file.exists(zipfile_data))
{
  checkUrl <- file(dataUrl,"r")
  if (!isOpen(checkUrl)) {
    stop(paste("Error happened! =>", geterrmessage()))
  }
  download.file(dataUrl,destfile=zipfile_data)
  #download.file(dataUrl,zipfile_data)
  unzip(zipfile="repdata_data_activity.zip")
}

path_rf <- file.path("repdata_data_activity")
files <- list.files(path_rf, recursive=TRUE)

## This first line will likely take a few seconds. Be patient!
activities <- read.csv("activity.csv")

complete_activities <- activities[complete.cases(activities), ]
all_steps <- complete_activities$steps
steps <- unlist(all_steps)
steps <- as.numeric(steps)
date <- as.Date(complete_activities$date)

# Calculate the total number of steps taken per day.
steps_per_day <- complete_activities %>% 
  group_by(date) %>%
  summarise(total=sum(steps))

# Histogram of the total number of steps taken each day.
steps_per_day <- unlist(steps_per_day)

#avg <- mean(as.numeric(steps_per_day))

#med <- median(as.numeric(steps_per_day))

#steps <- as.data.frame(steps)

    #ggplot(data = new_activities, aes(x=steps, y=avg))+
    #  geom_line(color = "#00AFBB", size = 2)