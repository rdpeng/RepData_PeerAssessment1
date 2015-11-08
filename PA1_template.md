# Reproducible Research: Peer Assessment 1

## Libraries
library(dplyr)
library(tidyr)
library(ggplot2)


## Loading and preprocessing the data
data <- read.csv(unzip('activity.zip'))


## What is mean total number of steps taken per day?

(function(d) { ## get mean total
  d %>% 
    group_by(date) %>%
    select(steps) %>%
    summarise(stepsperday = sum(steps, na.rm = TRUE)) %>%
    summarise(mean(stepsperday, rm.na = TRUE))
})(data)

(function(d) { ## generate histogram
  perday <- d %>% 
    group_by(date) %>%
    select(steps) %>%
    summarise(stepsperday = sum(steps, na.rm = TRUE))

  qplot(perday$stepsperday, geom="histogram")
})(data)


## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
