### REPRODUCIBLE RESEARCH - PEER ASSESSMENT 1
## Author: Eric Jardon Chao
wdir <- "C:/Users/ericj/Documents/DataScience/Foundations with R - Specialization/Reproducible Research/RR Course Project 1/RepResearch-CourseProject1"
setwd(wdir)

library(data.table)
library(dplyr)
library(ggplot2)
zipFile <- "activity.zip"
if (file.exists(zipFile)){unzip(zipFile)} else {print("No zip file found")}

rawData <- read.csv("activity.csv")
rawData$date <- as.Date(rawData$date)

missingdates <- unique(subset(rawData, ))

cleanData <- subset(rawData, !is.na(steps)) # remove NA values
data <- as_tibble(cleanData)    # convert to tibble for use with dplyr

# NA dates: october 01, 08; november 01, 04, 09, 10, 14, 30

# Get the total number of steps taken per day
daily.steps <- data %>%
  group_by(date) %>%
  summarise(daily_steps = sum(steps), .groups="keep")

#  Calculate and report the Mean and Median
stepsmean <- mean(daily.steps$daily_steps)
stepsmedian <- median(daily.steps$daily_steps)

# Make the histogram for this data

plot.dailysteps <- ggplot(daily.steps, aes(x=daily_steps)) + 
  geom_histogram(binwidth=1000, fill="steelblue", color="navyblue") +
  labs(title="Histogram for Daily Total Steps",
       x="Daily number of steps", y="Frequency") +
  geom_vline(xintercept=stepsmean,
             color="red") +
  geom_vline(xintercept = stepsmedian,
             linetype="dashed",
             color="green")
windows()
plot.dailysteps


##T TIME SERIES PLOT OF INTERVAL ID (x-axis) vs AVERAGE STEPS TAKEN ACROSS ALL 61 DAYS (y-axis)
# prepare the data
interval.steps <- data %>%
  group_by(interval) %>%
  summarise(avg_steps = mean(steps), .groups="keep") %>%
  mutate(interval_f = sprintf("%04d", interval)) %>%
  mutate(interval_f = paste(substring(interval_f, 1, 2), substring(interval_f, 3, 4), sep=":"))

maxSteps = max(interval.steps$avg_steps)
interval.maxsteps = interval.steps[which(interval.steps$avg_steps == maxSteps),]
interval.maxsteps

# Plot
#with(interval.steps, plot(interval,avg_steps, type="l", lty=1))
plot.intervalsteps <- ggplot(interval.steps, aes(x=interval, y=avg_steps)) + 
                      geom_line(color="orange") +
                      labs(title="Average Steps per 5-min intervals during the Day",
                           x="Time of day", y="Average steps") +
                      geom_vline(xintercept = interval.maxsteps$interval, color="darkred",
                                 linetype="dashed")

windows()
plot.intervalsteps


## IMPUTING MISSING VALS
# How many NAs do we have?
navals <- sum(is.na(rawData$steps))
naRows <- which(is.na(rawData$steps))
imputedData <- full_join(rawData, interval.steps, by="interval")
imputedData[naRows,1] <- imputedData[naRows,4]  # impute values of step in NA rows

# Create a histogram of daily steps with the new dataframe
imp.daily.steps <- imputedData %>%
  group_by(date) %>%
  summarise(daily_steps = sum(steps), .groups="keep")

imp_mean <- mean(imp.daily.steps$daily_steps)
imp_median <- median(imp.daily.steps$daily_steps)


plot.impdailysteps <- ggplot(imp.daily.steps, aes(x=daily_steps)) + 
  geom_histogram(binwidth=1000, fill="darkturquoise", color="darkslategray") +
  labs(title="Histogram for Daily Steps (Imputed NA values)",
       x="Daily number of steps", y="Frequency") +
  geom_vline(xintercept=imp_mean,
             color="red") +
  geom_vline(xintercept = imp_median,
             linetype="dashed",
             color="green")
windows()
plot.impdailysteps


## ANALYZING PATTERNS FOR WEEKENDS AND WEEKDAYS
# Use the imputed dataset
dayData <- mutate(imputedData, day.type = fifelse(weekdays(imputedData$date)%in%c("Saturday", "Sunday"), "Weekend", "Weekday"))
dayData <- dayData[, -c(4,5)]

# Prepare data
day.interval.steps <- dayData %>%
  group_by(interval, day.type) %>%
  summarise(avg_steps = mean(steps), .groups="keep")

plot.weekdaysteps <- ggplot(day.interval.steps, aes(x=interval, y=avg_steps)) +
  geom_line(aes(color=day.type)) +
  facet_grid(day.type~.) +
  labs(title="Average Steps taken at 5-min intervals, Weekday vs Weekends", x="Interval", 
       y="Average steps")
windows()
plot.weekdaysteps
  