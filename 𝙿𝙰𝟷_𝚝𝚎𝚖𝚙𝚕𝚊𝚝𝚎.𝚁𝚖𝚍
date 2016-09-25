R markdown - Reproducible Research
==================

Load the data into R
======================

```{r}
setwd("/Users/rodolfomonfilierperes/Desktop/coursera_data_science/Reproducible_research/week2")
library(dplyr)
library(lubridate)
library(ggplot2)
activity <- read.csv("activity.csv", header = TRUE)
head(activity)
```
Part I
=======

What is mean total number of steps taken per day?  

1 - Calculate the total number of steps taken per day

```{r}
total_number_steps <- tapply(activity$steps, activity$date, FUN=sum, na.rm= TRUE)
```

2 - Make a histogram of the total number of steps taken each day
```{r}
histogram <- hist(total_number_steps)
```

3 - Calculate and report the mean and median of the total number of steps taken per day
```{r}
mean_steps <- mean(total_number_steps)
median(total_number_steps)
```

Part II
=======

What is the average daily activity pattern?

1 - Make a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```{r}
five_minutes_average <- aggregate(steps~interval, data = activity, FUN=mean, na.rm=TRUE)
head(five_minutes_average)
plot(five_minutes_average$interval, five_minutes_average$steps, xlab= "5-minute interval", ylab= "number of steps taken", main= "Steps taken per 5-minute interval",type="l")
```

2 - Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```{r}

max_number_steps <- five_minutes_average %>%
                       select(interval, steps) %>%
                          filter(steps == max(steps))
as.data.frame(max_number_steps) 
```

Part III
========

Imputing missing values

1 - Calculate and report the total number of missing values in the dataset

```{r}
 sum(is.na(activity$steps))
```
 
 2 - Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
 
3 - Create a new dataset that is equal to the original dataset but with the missing data filled in.

 
```{r}
new_activity <- activity %>%
                  group_by(interval) %>%
                       mutate(steps = ifelse(is.na(steps), mean(steps, na.rm=TRUE), steps))
summary(new_activity)
```

4 - Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```{r}
new_total_number_steps <- tapply(new_activity$steps, new_activity$date, FUN=sum, na.rm= TRUE)
histogram <- hist(new_total_number_steps)
```

Yes, these values differ from those first estimated. The frequency has changed, principally for the 0-5,000 and 10,000-15,000 number of steps interval.

Part IV
=======

Are there differences in activity patterns between weekdays and weekends?

1 - Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```{r}
new_activity2 <- new_activity %>%
                              mutate(week_day_type = as.factor(ifelse(wday(date, label = TRUE, abbr = FALSE) %in% c("Sunday", "Saturday"), "weekend", "weekday")))

head(new_activity2)
```

2 - Make a panel plot containing a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 

```{r}
five_minutes_average2 <- aggregate(new_activity2$steps, by = list(new_activity2$week_day_type, new_activity2$interval), mean)
names(five_minutes_average2) <- c("week_day_type", "interval", "mean")
head(five_minutes_average2)

ggplot(five_minutes_average2, aes(interval, mean)) + geom_line() +facet_wrap(~week_day_type, ncol = 2)
```



