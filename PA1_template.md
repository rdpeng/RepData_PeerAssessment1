---
title: "RepData - Peer Assesment 1"
author: "Michael Addonisio"
date: "January 10, 2016"
output: 
  html_document: 
    fig_caption: yes
---

### Loading and preprocessing the data
1. Load the data (i.e. read.csv())

```{r}
#required Libraries
library(dplyr)
library(lubridate)
library(ggplot2)

#define activity data set
df = read.csv("activity.csv")
```

### What is mean total number of steps taken per day?
1. Calculate the total number of steps taken per day
```{r}
steps.per.day = df %>% group_by(date) %>% summarise( sum = sum(steps))
```

2. Make a histogram of the total number of steps taken each day
```{r}
hist(steps.per.day$sum)
```


3. Calculate and report the mean and median of the total number of steps taken per day
Summarize data by day. Sum steps for each day
```{r}
mean(steps.per.day$sum, na.rm = TRUE)

median(steps.per.day$sum, na.rm = TRUE)
```

```{r}
steps.per.interval = df %>% na.omit() %>% group_by(interval) %>% summarize(steps = mean(steps))
```

### What is the average daily activity pattern?

1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
```{r}
plot(steps ~ interval, type = "l", data = steps.per.interval)
```
2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
```{r}
steps.per.interval[which.max(steps.per.interval$steps),]
```
### Imputing missing values

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
```{r}
sum(is.na(df$steps))
```

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

```{r}
nas = is.na(df$steps)
steps = steps.per.interval$steps
names(steps) = steps.per.interval$interval
df$steps[nas] = steps[as.character(df$interval[nas])]
```

#check if any nas
```{r}
sum(is.na(df$steps))
```

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.
```{r}
imputed.steps.per.day  = df %>% group_by(date) %>% summarise( sum = sum(steps))
```

4. Make a histogram of the total number of steps taken each day 
```{r}
hist(imputed.steps.per.day$sum)
```


5. Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```{r}
mean(imputed.steps.per.day$sum, na.rm = TRUE)

median(imputed.steps.per.day$sum, na.rm = TRUE)
```

### Are there differences in activity patterns between weekdays and weekends?

1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.
First, I changed date format to make it easier to work with and added weekday column 
```{r}
df$date = ymd(df$date)
df = df %>% mutate(weekday = ifelse(weekdays(df$date) == "Saturday" | weekdays(df$date) == "Sunday", "Weekend", "Weekday"))
```

I'm creating a dataset summarising the steps per interval per weekday factor
```{r}
steps.per.interval.day = df %>% group_by(interval, weekday) %>% summarise(steps = mean(steps))
```

2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.


```{r}
s = ggplot(steps.per.interval.day, aes(x=interval, y=steps, color = weekday)) + geom_line() + facet_wrap(~weekday, ncol = 1,nrow=2)
s
```
