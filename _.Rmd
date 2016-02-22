---
title: "Analysis of Activitiy"
author: "Shan-Chiou Lin"
date: "February 21, 2016"
output: html_document
---

##Introduction
It is now possible to collect a large amount of data about personal movement using activity monitoring devices such as a Fitbit, Nike Fuelband, or Jawbone Up. These type of devices are part of the "quantified self" movement -- a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. But these data remain under-utilized both because the raw data are hard to obtain and there is a lack of statistical methods and software for processing and interpreting the data.

This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.


## 1 Loading and preprocessing the data
Show any code that is needed to

1. Load the data (i.e. read.csv())

2. Process/transform the data (if necessary) into a format suitable for your analysis

```{r}
# First step, setup directory and load data from csv file. 
# Directory
setwd("/Users/Samball/Desktop/examples and practices")

#Getting and loading the data
echo = TRUE

Activity_data <- read.csv('./activity.csv', header = T, sep = ',')
head(Activity_data)
```

## 2 What is mean total number of steps taken a day?
For this part of the assignment, you can ignore the missing values in the dataset.

1. Make a histogram of the total number of steps taken each day

2. Calculate and report the mean and median total number of steps taken per day

```{r}
# the total number of steps taken per day

Steps_a_day <- aggregate(steps ~ date, Activity_data, sum)

echo = TRUE
mean_steps <- round(mean(Steps_a_day$steps))
mean_steps

median_steps <- round(median(Steps_a_day$steps))
median_steps

# Draw a Histogram of number of steps per day
hist(Steps_a_day$steps, main = 'Histogram of number of steps per day', xlab = 'Sum of Steps a day' )
```

##3 What is the average daily activity pattern?
1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
```{r}
# Mean & the Median total number of steps taken a day
AvgSteps_Per_interval <- aggregate(steps ~ interval, Activity_data, mean)

# Draw Time series plot of the average number of steps taken
plot(AvgSteps_Per_interval$interval, AvgSteps_Per_interval$steps, type="l", col=1, main = 'Avg Number of steps per interval', xlab = 'Interval', ylab = 'Avg Number of Steps')

# Identify the interval index which has the highest average steps
interval_idx <- which.max(AvgSteps_Per_interval$steps)

# Identify the specific interval and the average steps for that interval
print (paste("The interval with the highest avg steps is ", AvgSteps_Per_interval[interval_idx, ]$interval, " and the no of steps for that interval is ", round(AvgSteps_Per_interval[interval_idx, ]$steps, digits = 1)))
```

## 4 Imputing missing values
Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

Create a new dataset that is equal to the original dataset but with the missing data filled in.

Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```{r}
#Figure out the no of missing values
NA_Activity <- Activity_data[!complete.cases(Activity_data), ]
nrow(NA_Activity)

#Subsitute the NA value with Avg_steps by looping way

ImputedData <- Activity_data  # creation of the dataset that will have no more NAs

for(i in 1:nrow(ImputedData)){
  if(is.na(ImputedData$steps[i])){
          interval_value <- ImputedData$interval[i] 
          steps_value <- AvgSteps_Per_interval[AvgSteps_Per_interval$interval == interval_value,] 
          ImputedData$steps[i] <- steps_value$steps
		}
}

# Aggregate the steps per day with the imputed values
Steps_per_day_imputed <- aggregate(steps ~ date, ImputedData, sum)

mean_steps_imputed <- round(mean(Steps_per_day_imputed$steps))
median_steps_imputed <- round(median(Steps_per_day_imputed$steps))

# In order to compare the new values with the “old” values:
echo = TRUE
df_summary <- NULL
Summary <- rbind(df_summary, data.frame(mean = c(mean_steps, mean_steps_imputed), median = c(median_steps, median_steps_imputed)))
rownames(Summary) <- c("with Missing Value", "without Missing Value")
print(Summary)

# Draw a histogram of the value 
hist(Steps_per_day_imputed$steps, main = "Histogram of total number of steps per day (IMPUTED)", xlab = "Steps a day")

```


## 5 Are there differences in activity patterns between weekdays and weekends?
For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

1. Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). The plot should look something like the following, which was created using simulated data:
```{r}
# Create a function to determine weekday or weekend

week_day <- function(date_val) {
    wd <- weekdays(as.Date(date_val, '%Y-%m-%d'))
    if  (!(wd == 'Saturday' || wd == 'Sunday')) {
        x <- 'Weekday'
    } else {
        x <- 'Weekend'
    }
    x
}

# Apply the week_day function and add a new column to activity dataset
ImputedData$day_type <- as.factor(sapply(ImputedData$date, week_day))

# Create the aggregated data frame by intervals and day_type
Steps_a_day_imputed <- aggregate(steps ~ interval+day_type, ImputedData, mean)

# Create the plot
library(ggplot2)
plt <- ggplot(Steps_a_day_imputed, aes(interval, steps)) +
    geom_line(stat = "identity", aes(colour = day_type)) +
    theme_gray() +
    facet_grid(day_type ~ ., scales="fixed", space="fixed") +
    labs(x="Interval", y=expression("No of Steps")) +
    ggtitle("No of steps Per Interval by day type")
print(plt)

```

