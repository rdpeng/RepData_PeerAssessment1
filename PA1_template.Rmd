---
output: html_document
---
Reproducible Research: Peer Assessment 1
==========================================
Created on April 18, 2015

## Setting
```{r echo = TRUE, options(scipen = 1)}

rm(list=ls());
clc <- function() { 
        cat("\014");
}
# Clear R Studio Console
clc();

# Load library
library(ggplot2);
````

## Loading and preprocessing the data
Show any code that is needed to

1. Load the data (i.e. <span style = 'color:red'>read.csv()</span>)
2. Process/transform the data (if necessary) into a format suitable for your analysis

```{r echo = FALSE}
# Set default folder and filename
setwd('D:/Coursera/Johns Hopkins/Data Science/05 - Reproducible Research/GitHub/RepData_PeerAssessment1/');
filename <- './Data/activity.csv';
```

```{r}
# Load file
project.data <- read.table(filename, header = TRUE, sep = ',', na.strings = 'NA',
                           colClasses = c('numeric', 'character', 'numeric'));
# Change date
project.data$date <- as.Date(project.data$date);
```

Here is the sample data.
```{r echo = FALSE}

project.data[1:10,];
```


## What is mean total number of steps taken per day?
For this part of the assignment, you can ignore the missing values in the dataset.

1. Calculate the total number of steps taken per day

2. If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day

```{r}
project.steps_per_day <- aggregate(steps ~ date, data = project.data, FUN = sum);

ggplot(project.steps_per_day, aes(date, steps)) + 
        geom_bar(stat = 'identity', colour = 'steelblue', fill = 'steelblue', width = 0.75) + 
        xlab('Date') + ylab('# of Steps') + ggtitle('Number of Steps Taken Each Day');
```

3. Calculate and report the mean and median of the total number of steps taken per day

```{r}
steps.mean <- mean(project.steps_per_day$steps);
steps.median <- median(project.steps_per_day$steps);
```

The **mean** is <span style = 'color:steelblue'>**`r format(steps.mean, digits = 8)`**</span> and 
**median** is <span style = 'color:steelblue'>**`r format(steps.median, digits = 8)`**</span>.


## What is the average daily activity pattern?

1. Make a time series plot (i.e. <span style = 'color:red'>type = "l"</span>) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
```{r}
project.steps_mean_interval <- aggregate(steps ~ interval, data = project.data, FUN = mean);

ggplot(project.steps_mean_interval, aes(interval, steps)) + 
        geom_line(stat = 'identity', colour = 'steelblue', fill = 'steelblue', width = 1.0) + 
        xlab('Date') + ylab('# of Steps') + ggtitle('Average Daily Activity Pattern');
```

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
```{r}
steps.max_interval <- project.steps_mean_interval[which.max(project.steps_mean_interval$steps),];
```
The interval labeled <span style = 'color:steelblue'>**`r steps.max_interval$interval`**</span> contains the maximum number of <span style = 'color:steelblue'>**`r format(steps.max_interval$steps, digits = 8)`**</span> steps.

## Imputing missing values
Note that there are a number of days/intervals where there are missing values (coded as <span style = 'color:red'>NA</span>). The presence of missing days may introduce bias into some calculations or summaries of the data.

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with <span style = 'color:red'>NA</span>s)
```{r}
steps.number_na <- sum(is.na(project.data));
```
The total number of missing values in the dataset is  <span style = 'color:steelblue'>**`r steps.number_na `**</span>.

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```{r}
# Use the mean of the 5-minute intervals to fill the missing values.

project.new_data <- project.data;

for (i in 1:nrow(project.new_data)) {
        if (is.na(project.new_data$steps[i]))
                project.new_data$steps[i] <- project.steps_mean_interval[which(project.new_data$interval[i] == project.steps_mean_interval$interval),]$steps;
}

project.new_steps_per_day <- aggregate(steps ~ date, data = project.new_data, FUN = sum);

ggplot(project.new_steps_per_day, aes(date, steps)) + 
        geom_bar(stat = "identity", colour = "steelblue", fill = "steelblue", width = 0.7) +
        xlab('Date') + ylab('# of Steps') + ggtitle('Number of Steps Taken Each Day');


new_steps.mean <- mean(project.new_steps_per_day$steps);
new_steps.median <- median(project.new_steps_per_day$steps);
```

The **new mean** is <span style = 'color:steelblue'>**`r format(new_steps.mean, digits = 8)`**</span> and 
**new median** is <span style = 'color:steelblue'>**`r format(new_steps.median, digits = 8)`**</span>.

The new values are slightly different from first part.  The **new mean** and **new median** are the same.

## Are there differences in activity patterns between weekdays and weekends?

For this part the <span style = 'color:red'>weekdays()</span> function may be of some help here. Use the dataset with the filled-in missing values for this part.

1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```{r}
# This function return 'Weekend' or 'Weekday' given date input.
WeekdayOrWeekend <- function(dt) {
        if(weekdays(as.Date(dt)) %in% c('Saturday', 'Sunday')) {
                return('Weekend');
        } else {
                return('Weekday');
        }

}

# Add new column to store Weekend or Weekday data.
project.new_data$weekday_or_weekend <- as.factor(sapply(project.new_data$date, FUN = WeekdayOrWeekend));

project.weekday_or_weekend  <- aggregate(steps ~ interval + weekday_or_weekend, data = project.new_data, FUN = mean);
```

2. Make a panel plot containing a time series plot (i.e. <span style = 'color:red'>type = "l"</span>) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.

```{r}
library(lattice);

xyplot(project.weekday_or_weekend$steps ~ project.weekday_or_weekend$interval | project.weekday_or_weekend$weekday_or_weekend, 
       layout = c(1, 2), type = 'l', xlab = 'Interval', ylab = 'Number of steps');
```