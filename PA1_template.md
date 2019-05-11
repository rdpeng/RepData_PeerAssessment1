# Reproducible Research: Peer Assessment 1
### Alvinne Asejo

### May 11, 2019

## Loading and preprocessing the data
## Code for reading in the dataset and/or processing the data

Load data into R Studio.

activity <- read.csv("activity.csv")


What is mean total number of steps taken per day?
Determine the total number of steps per day by grouping the data by date.

library(dplyr)
library(ggplot2)
by_day <- group_by(activity, date)
perday <- summarise(by_day, total_steps = sum(steps))


Histogram of the total number of steps taken each day

Show the total number of steps per day through histogram

ggplot(perday, aes(total_steps))+
  geom_histogram(binwidth=1000)+
  labs(x="Total Steps")+
  labs(y="Frequency")+
  labs(title="Total number of steps per day")
## Warning: Removed 8 rows containing non-finite values (stat_bin).



Mean and median number of steps taken each day

Remove NA Values to acquire the mean and median number of steps taken each day.

perday <- (na.omit(perday))
mean(perday$total_steps)
## [1] 10766.19
median(perday$total_steps)
## [1] 10765


What is the average daily activity pattern?
Time series plot of the average number of steps taken

by_int <- group_by(activity, interval)
by_int <- (na.omit(by_int))
average <- summarise(by_int,
                        meansteps = mean(steps))


plot(average$interval, average$meansteps, type = "l", 
     ylab = "Average number of steps", xlab = "Interval", main = "Average number of steps taken")

Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

maxint <- average[average$meansteps == max(average$meansteps),]
maxint
## # A tibble: 1 x 2
##   interval meansteps
##      <int>     <dbl>
## 1      835      206.


Imputing missing values
Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

nas <- nrow(activity[is.na(activity$steps),])
nas
## [1] 2304


Devise a strategy for filling in all of the missing values in the dataset.

Create a new dataset that is equal to the original dataset but with the missing data filled in.

Merge the data (original and average per interval) and replace all NA values with their corresponding average steps. The new data frame is called “combined”.

combined <- merge(activity, average, by = "interval")

for(i in 1:nrow(combined))
{
  if(is.na(combined$steps[i]==TRUE))
  {
    combined$steps[i] = combined$meansteps[i]
  }
  else
  {
    combined$steps[i] = combined$steps[i]
  }
}


Make a histogram of the total number of steps taken each day

by_day2 <- group_by(combined, date)
perday2 <- summarise(by_day2, 
                     tsteps = sum(steps))

ggplot(perday2, aes(tsteps))+
  geom_histogram(binwidth=1000)+
  labs(x="Total Steps")+
  labs(y="Frequency")+
  labs(title="Total number of steps per day (without NAs)")

Calculate and report the mean and median total number of steps taken per day.

mean2 <- mean(perday2$tsteps)
mean2
## [1] 10766.19
median2 <- median(perday2$tsteps)
median2
## [1] 10766.19


Do these values differ from the estimates from the first part of the assignment?

mean1 <- mean(perday$total_steps)
mean1
## [1] 10766.19
median1 <- median(perday$total_steps)
median1
## [1] 10765


What is the impact of imputing missing data on the estimates of the total daily number of steps?

As you can see, the old and new mean are exactly the same. The only change that happened was for the median, from 10765 to 10766.19.



Are there differences in activity patterns between weekdays and weekends?
Create a new factor variable in the dataset with two levels - “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

combined$day <- weekdays(as.Date(combined$date))

for(i in 1:nrow(combined))
{
  if(combined$day[i] == "Saturday")
  {
    combined$week[i] = "Weekend"
  }
  else if (combined$day[i] == "Sunday")
  {
    combined$week[i] = "Weekend"
  }
  else
  {
    combined$week[i] = "Weekday"
  }
}


Make a panel plot containing a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).

library(lattice)
by_int3 <- group_by(combined, interval)
by_int3 <- (na.omit(by_int3))
average2 <- summarise(by_int3,
                        meansteps = mean(steps))


xyplot(average2$meansteps ~ average2$interval | by_int3$week, type = "l", layout = c(1,2),
     ylab = "Number of steps", xlab = "Interval", main = "Average number of steps taken ")
