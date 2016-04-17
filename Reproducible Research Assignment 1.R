
#Load libraries
library("ggplot2")
library("dplyr")

#Load and process data
activity <- read.csv("activity.csv", header = TRUE, sep = ",", colClasses = c("numeric","character","numeric"))
activity$date <- as.Date(activity$date, format = "%m/%d/%Y")

#Mean total # of steps per day
#1. Calc total # of steps per day
#2. Make a histogram of total steps per day
#3. Calc and report mean and median steps per day
DailyActivity <- aggregate(steps ~ date, activity, sum)

#create histogram plot
png('total histogram.png')
ggplot(DailyActivity, aes(steps)) + 
  geom_histogram(color = "red", fill = "red") + 
  ggtitle("Distribution of total steps per day")
dev.off()

StepsMean <- mean(DailyActivity$steps)
StepsMedian <- median(DailyActivity$steps)

#Average daily activity pattern
#1 Time series plot of interval and avg steps taken across all days
#2. Which 5 minute interval, on avg across all days  max?
DailyStepActivity <- aggregate(steps ~ interval, activity, mean)


#create plot
png('Avg Daily Activity Pattern.png')
ggplot(DailyStepActivity, aes(interval, steps)) + 
  geom_line() + 
  ggtitle("Average daily activity pattern")  +
  labs(x = "interval",  y = "steps")
dev.off()

MaxInterval <- which(DailyStepActivity$steps == max(DailyStepActivity$steps))
MaxInt <- DailyStepActivity[MaxInterval, 1]

# missing values
#1. Calc and report total # missing  values  in dataset
#2. Fill in missing values
#3. Create new dataset with missing data filled in
#4. Make a histogram of total # of steps taken per day and calc mean and median of total # steps per day. What is delta to original mean and median?
MissingValues <- sum(is.na(activity$steps))


RevisedActivity <- activity
RevisedActivity <- merge(activity, DailyStepActivity, by = "interval")
RevisedActivity$steps.x[is.na(RevisedActivity$steps.x)] <- RevisedActivity$steps.y
RevisedMissingValues <- sum(is.na(RevisedActivity$steps.x))

RevisedDailyActivity <- aggregate(steps.x ~ date, RevisedActivity, sum)
RevisedStepsMean <- mean(RevisedDailyActivity$steps.x)
RevisedStepsMedian <- median(RevisedDailyActivity$steps.x)

#create histogram plot
png('Revised total histogram.png')
ggplot(RevisedDailyActivity, aes(steps.x)) + 
  geom_histogram(color = "green", fill = "green") + 
  ggtitle("Revised distribution of total steps per day")
dev.off()

##Differences b/t weekdays and weekends
#1. Create new variable with two levels - weekday or weekend
#2. Make a time series plot of avg number steps taken weekday and weekend

WeekActivity <- RevisedActivity %>% 
  mutate(Weekday = weekdays(RevisedActivity$date)) %>%
  mutate(WeekdayClass = "Weekday")

weekend <- WeekActivity$Weekday %in% c("Saturday", "Sunday") 
WeekActivity$WeekdayClass[weekend == TRUE] <- "Weekend"

DailyStepActivityByWeekDayType <- aggregate(steps.x ~ interval + WeekdayClass, WeekActivity, mean)

#create plot
png('Weekpart Avg Daily Activity Pattern.png')
ggplot(DailyStepActivityByWeekDayType, aes(interval, steps.x)) + 
  geom_line() + 
  facet_wrap(~ WeekdayClass, nrow = 2, ncol = 1) +
  labs(x = "interval",  y = "steps")
dev.off()

