## 1. Code for reading in the dataset and/or processing the data
library('dplyr');
library('lattice')

URL <- 'https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip';
zipFile <- 'repdata_data_factivity.zip';
csvFile <- 'activity.csv'

download.file(URL, zipFile, method = 'curl')
unzip(zipFile)

AMD <- read.csv(csvFile, sep = ',', header = TRUE, stringsAsFactors = FALSE)
AMD$date <- as.Date(AMD$date)



## What is mean total number of steps taken per day?
## For this part of the assignment, you can ignore the missing values in the dataset.

## 1. Calculate the total number of steps taken per day
stepsPerDay <- AMD %>%
                filter(!is.na(steps)) %>%
                group_by(date) %>%
                summarize(total = sum(steps))


## 2. Make a histogram of the total number of steps taken each day
png("Figure1.png", width = 480, height = 480)
hist(stepsPerDay$total, main = 'Total Steps per Day', xlab = 'Number of Steps')
dev.off()

## 3. Calculate and report the mean and median of the total number of steps taken per day
## Mean
round(mean(stepsPerDay$total))

##Median
median(stepsPerDay$total)



## What is the average daily activity pattern?

## 1. Make a time series plot (i.e. 𝚝𝚢𝚙𝚎 = "𝚕") of the 5-minute interval (x-axis) and
##    the average number of steps taken, averaged across all days (y-axis)
stepsPerInterval <- aggregate(steps ~ interval, data = AMD, FUN = mean)

png("Figure2.png", width = 480, height = 480)
plot(x = stepsPerInterval$interval, y = stepsPerInterval$steps, type = 'l',
     main = 'Avg Number of Steps Across All Days', xlab = 'Steps', ylab = 'Interval')
dev.off()

## 2. Which 5-minute interval, on average across all the days in the dataset, 
##    contains the maximum number of steps?
stepsPerInterval[which.max(stepsPerInterval$steps), ]



## Imputing missing values
## Note that there are a number of days/intervals where there are missing values (coded as 𝙽𝙰)
## The presence of missing days may introduce bias into some calculations or summaries of the data.

## 1. Calculate and report the total number of missing values in the dataset (i.e. the total number 
##    of rows with 𝙽𝙰s)
sum(is.na(AMD$steps))

## 2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does 
##    not need to be sophisticated. For example, you could use the mean/median for that day, or the mean 
##    for that 5-minute interval, etc.

## For the outputs in the steps column that were NAs I chose to use the mean number of steps for the
## 5 minute interval
IntervalAvg <- aggregate(steps ~ interval, FUN = mean, data = AMD)

## 3. Create a new dataset that is equal to the original dataset but with the missing data filled in
AMD_Adj <- merge(x = AMD, y = IntervalAvg, by = 'interval')
AMD_Adj$stepsAdj <- ifelse(is.na(AMD_Adj$steps.x), AMD_Adj$steps.y, AMD_Adj$steps.x) 
AMD_Adj <- AMD_Adj[c('interval', 'date', 'stepsAdj')]  
        
## 4. Make a histogram of the total number of steps taken each day and Calculate and report the mean 
##    and median total number of steps taken per day. Do these values differ from the estimates from 
##    the first part of the assignment? What is the impact of imputing missing data on the estimates 
##    of the total daily number of steps?
stepsPerDay_Adj <- AMD_Adj %>%
                        group_by(date) %>%
                        summarize(total = sum(stepsAdj))

png("Figure3.png", width = 480, height = 480)
hist(stepsPerDay_Adj$total, main = expression('Total Steps per Day'[Adj]), xlab = 'Number of Steps')
dev.off()

## Means the same.  Minor difference in medians.
round(mean(stepsPerDay_Adj$total))
round(median(stepsPerDay_Adj$total))



## Are there differences in activity patterns between weekdays and weekends?

## For this part the 𝚠𝚎𝚎𝚔𝚍𝚊𝚢𝚜() function may be of some help here. Use the dataset
## with the filled-in missing values for this part.

## 1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” 
##    indicating whether a given date is a weekday or weekend day.
AMD_Adj$weekdays <- as.factor(ifelse(weekdays(AMD_Adj$date) %in% 
                                c('Saturday', 'Sunday'), 'weekend', 'weekday'))


## 2. Make a panel plot containing a time series plot (i.e. type = 'l') of the 5-minute interval 
##    (x-axis) and the avg number of steps taken, across all weekend days (y-axis). See the README 
##    file in the GitHub repository to see an example of what this plot should look like using 
##    simulated data.
AMD_Weekday <- aggregate(stepsAdj ~ interval + weekdays, AMD_Adj, mean)

png("Figure4.png", width = 480, height = 480)
xyplot(stepsAdj ~ interval | weekdays, AMD_Weekday, type = 'l', layout = c(1, 2), 
       xlab = "Interval", ylab = "Number of steps")
dev.off()

