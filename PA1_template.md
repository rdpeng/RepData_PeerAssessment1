##Reproducible Research -- Peer Assessment 1:  Activity Monitoring

Input file:  activity.csv file
output: html_document

This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

###Loading packages

library(ggplot2)
library(lattice)

###Mean Total Number of Steps Taken Per Day

In this section, the following information will be calculate and plotted.  The missing values in the dataset will be ignored.
1.  The total number of steps taken per day 
2.  A historgram of the total number of steps taken each day 
3.  The mean and median of the total number of steps taken per day

####Read activity.csv file
d <- read.csv(file="activity.csv", header=TRUE, sep=",", 
              colClasses = c('numeric', 'Date', 'numeric'))
summary(d)
remove na with the na.omit command
d1 <- na.omit(d)
summary(d1)

####1.  The total number of steps taken per day

aggregate(steps ~ date, d1, sum)

####2.  A historgram of the total number of steps taken each day 

d2 <- aggregate(steps ~ date, d1, sum)
g <- ggplot(d2, aes(date, steps))
g <- g + geom_bar(stat="identity", position="dodge", color="yellow") +
        ggtitle(expression('The Total Number of Steps Taken Each Day')) + 
        labs(x="Date") +
        labs(y="Total Number of Steps") +
        geom_text(aes(label = steps, position="center"), stat = "identity", position = "identity", size = 0.5)
print(g)

####3. The mean and median of the total number of steps taken per day

d2mean <- mean(d2$steps)
d2median <- median(d2$steps)

mean is 10766.19 and median is 10765.

###The Average Daily Activity Pattern

This section will have the following two information:

1.  Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

2.  Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

####1. Time Series Plot

d3 <- aggregate(steps ~ interval, d1, mean)
plot(d3$interval, d3$steps, type = "l", xlab = "5-min Interval", 
     ylab = "Averaged Across All Days", main = "Average Number of Steps Taken", col = "purple")

####2.  Maximum Number of Steps

maxstep <- max(d3$steps)
d4 <- d3[d3$steps==maxstep,]
d4

The maximum number of steps is 206.1698 and is happened at interval 835.

###Imputing Missing Values

In this section, the missing values in the dataset will be filled with the mean for that data to create a new dataset.  A historgram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day will be created to see if those values differ from the estimates from the first part of the assignment and the impact of imputing missing data on the estimates of the total daily number of steps is.

####1.  Calculate and report the total number of missing values

nanrow = nrow(d)-nrow(d1)
cat(sprintf("The total number of missing values are: %s.\n", nanrow))

The total number of missing values are: 2304.

####2 and 3.  Replace na with the mean for that 5-minute interval to create a new dataset

impData <- d
for (i in 1:nrow(impData)) {
        if (is.na(impData$steps[i])) {
                impData$steps[i] <- d3[which(impData$interval[i] == d3$interval), ]$steps
        }
}


####4.  Make a histogram of the total number of steps taken each day

impPlot <- ggplot(impData, aes(date, steps))
impPlot <- impPlot + geom_bar(stat="identity") +
        ggtitle(expression('The Total Number of Steps Taken Each Day (Imputed Data)')) + 
        labs(x="Date") +
        labs(y="Total Number of Steps")
print(impPlot)

####5. The mean and median of the total number of steps taken per day from the impData dataset

impData2 <- aggregate(steps ~ date, impData, sum)
impData2mean <- mean(impData2$steps)
impData2median <- median(impData2$steps)
cat(sprintf("The mean of the total number of steps taken per day from the imputted dataset is: %.2f\n", impData2mean))
cat(sprintf("The median of the total number of steps taken per day from the imputted dataset is: %.2f\n", impData2median))
cat(sprintf("The difference between the mean of the total number of steps taken per day from the non-imputted and imputted dataset is: %s\n", d2mean-impData2mean))
cat(sprintf("The difference between the median of the total number of steps taken per day from the non-imputted and imputted dataset is: %.2f\n", d2median-impData2median))

#####The mean for non-imputted and imputted datasets are the same.
#####The imputted dataset median is 1.19 grater than the non-imputted dataset median.

###Differences in Activity Patterns between Weekdays and Weekends

In this section, the differences in activity patterns between weekdays and weekends will be calculated and plotted based on the filled-in missing values or the impData dataset.

1.  Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

2.  Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.

####1.  Create a new variable 'day' to indicate whether a given date is a weekday or weekend day

impData$date <- as.Date(impData$date)
wkdays <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
impData$day <- factor((weekdays(impData$date) %in% wkdays),
                       levels=c(TRUE, FALSE), labels=c('weekday', 'weekend'))
table(impData$day)

There are 12960 weekday and 4608 weekend.

####2.  Make a panel plot 

impData3 <- aggregate(impData$steps,list(interval = as.numeric(as.character(impData$interval)),day = impData$day), FUN="mean")
names(impData3)[3] <-"meanSteps"
dayPlot <-xyplot(impData3$meanSteps ~ impData3$interval | impData3$day,
                 layout = c(1, 2), type = "l", xlab = "interval",
                 ylab = "Number of steps")
print(dayPlot)

