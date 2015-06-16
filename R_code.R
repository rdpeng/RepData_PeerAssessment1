#### Reproducible Research Peer Assessment 1

library("ggplot2")
library("dplyr")

#### part 1 - loading and processing the data
fileUrl1 = "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(fileUrl1,destfile="./repdata%2Fdata%2Factivity.zip",method="curl")
unzip(zipfile="./repdata%2Fdata%2Factivity.zip",exdir="./")

activity <- read.csv("activity.csv")
activity$date <- as.POSIXct(activity$date,format = "%Y-%m-%d")

#### part 2 - What is mean total number of steps taken per day?

# Calculate the total number of steps taken per day
data_sum <- aggregate(steps~date, data=activity, FUN=sum)

# Make a histogram of the total number of steps taken each day
png("plot1.png", width=480, height=480)
graph1 <- qplot(data_sum$steps,geom="histogram",main ="Histogram of total number of steps per day",xlab = "Total number of steps per day")
print(graph1)
dev.off()

# Calculate and report the mean and median of the total number of steps taken per day
mean_steps <- mean(data_sum$steps)
median_steps <- median(data_sum$steps)

#### part 3 - What is the average daily activity pattern?

# Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average 
# number of steps taken, averaged across all days (y-axis)

data_mean_interval <- aggregate(steps~interval, data=activity, FUN=mean)
png("plot2.png", width=480, height=480)
graph2 <- qplot(interval, steps, data = data_mean_interval, geom=c("line"), type = 'l',main ="Plot of time series", xlab = "Interval", ylab = "Number of steps")
print(graph2)
dev.off()

# Which 5-minute interval, on average across all the days in the dataset, 
# contains the maximum number of steps?

data_max_interval <- which.max(data_mean_interval$steps)

#### part 4 - Imputing missing values

# Calculate and report the total number of missing values in the dataset (i.e. 
# the total number of rows with NAs)

num_na <- sum(is.na(activity$steps))

# Devise a strategy for filling in all of the missing values in the dataset. The strategy does 
# not need to be sophisticated. For example, you could use the mean/median for that day, or the 
# mean for that 5-minute interval, etc.
# Create a new dataset that is equal to the original dataset but with the missing data filled in.

data_no_nas <- activity %>% 
  group_by(interval) %>% 
  mutate(steps= ifelse(is.na(steps), mean(steps, na.rm=TRUE), steps))

# Make a histogram of the total number of steps taken each day and Calculate and report the mean 
# and median total number of steps taken per day. Do these values differ from the estimates from 
# the first part of the assignment? What is the impact of imputing missing data on the estimates 
# of the total daily number of steps?

data_sum_no_nas <- aggregate(steps~date, data=data_no_nas, FUN=sum)

png("plot3.png", width=480, height=480)
graph3 <- qplot(data_sum_no_nas$steps,geom="histogram", main ="Histogram of total number of steps per day (NAs removed)", xlab = "Total number of steps per day")
print(graph3)
dev.off()

mean_steps_no_nas <- mean(data_sum_no_nas$steps)
median_steps_no_nas <- median(data_sum_no_nas$steps)

#### part 5 - Are there differences in activity patterns between weekdays and weekends?

# Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating 
# whether a given date is a weekday or weekend day.

data_no_nas$weekdaylabel <- ifelse(weekdays(data_no_nas$date) %in% c("Saturday", "Sunday"), "weekend", "weekday")

# Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) 
# and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See 
# the README file in the GitHub repository to see an example of what this plot should look like using 
# simulated data.

data_sum_no_nas_mean <- aggregate(steps~interval+weekdaylabel, data_no_nas, mean)

png("plot4.png", width=480, height=480)
graph4 <- qplot(interval, steps, data = data_sum_no_nas_mean, geom=c("line"), type = 'l',main ="Plot of time series for weekday and weekend", xlab = "Interval", ylab = "Number of steps") +
  facet_wrap(~weekdaylabel, ncol = 1)
print(graph4)
dev.off()

#### finished