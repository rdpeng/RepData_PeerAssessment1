## Load libraries
library("dplyr")
library("lattice")

## Download and unzip the data from the url:
fileDirectory <- getwd()
zipedDataFile <- "repdata-data-activity.zip"
dataFile <- "activity.csv"
if (!file.exists(zipedDataFile)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
  download.file(fileURL, zipedDataFile, method="curl")
}

## Check if downloaded zipped file has been unzipped. If not, the file is unzipped
if (!file.exists(dataFile)){ 
  unzip(zipedDataFile) 
}

## Get Activity Data information and load data into data frame
filePath <- paste0(fileDirectory,"/",dataFile)
activityData <- read.csv(filePath)
activityData <- tbl_df(activityData)
head(activityData)

## Question 1: What is mean total number of steps taken per day?
## 1.1: Calculation of Total Number of Steps Per Day
activityWithoutNullSteps <- filter(activityData,!is.na(steps))
totalStepsPerDay <- aggregate(activityWithoutNullSteps$steps, by=list(activityWithoutNullSteps$date), FUN = sum)
names(totalStepsPerDay) <- c("date", "totalSteps")

## 1.2: Plot the Histogram of the "Total Number of Steps" recorded per day with NA values removed
barplot(height=totalStepsPerDay$totalSteps, names.arg=totalStepsPerDay$date, ylim=c(0, 25000), xlab="Date", ylab="Total Steps Per Day")

## 1.3: Calculate and report the mean and median of the total number of steps taken per day
meanStepsPerDay <- mean(totalStepsPerDay$totalSteps)       ## Mean of Total Number of Steps per Day
medianStepsPerDay <- median(totalStepsPerDay$totalSteps)   ## Median of Total Number of Steps per Day

meanSteps <- (paste0("Mean of Total Number of Steps per Day = ",meanStepsPerDay))
medianSteps <- (paste0("Median of Total Number of Steps per Day = ",medianStepsPerDay))
meanSteps
medianSteps


## Question 2: What is the Average Daily Activity Pattern?
## 2.1: Make a time series plot (i.e. 𝚝𝚢𝚙𝚎 = "𝚕") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
meanIntervalPerDay <- aggregate(activityWithoutNullSteps$steps, by=list(activityWithoutNullSteps$interval), FUN = mean)
names(meanIntervalPerDay) <- c("interval", "mean")
plot(meanIntervalPerDay$interval, meanIntervalPerDay$mean, type="l", col="brown", lwd=2, xlab="Interval (Minutes)", ylab="Average Number of Steps", 
     main="Time-Series of the Average Number of Steps per Intervals")

## 2.2: Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
avgIntervalWithMaxSteps <- meanIntervalPerDay$interval[which.max(meanIntervalPerDay$mean)]
intervalWithMaximumSteps <- paste0("The 5-minute interval that contains the maximum of steps, on average across all days, is ", avgIntervalWithMaxSteps)
intervalWithMaximumSteps

## Question 3: Imputing Missing Values
## 3.1: Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
totalRowsWithMissingValues <- nrow(activityData) - nrow(activityWithoutNullSteps)
totalNumMissingVals <- paste0("The total number of missing values in the dataset is ",totalRowsWithMissingValues)
totalNumMissingVals

## 3.2: Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be
##      sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc
##      The strategy selected by me to replace missing values in the dataset is to replace NAs with the Mean Number of Steps
##      per Day

## 3.3: Create a new dataset that is equal to the original dataset but with the missing data filled in.
rowsWithNAs <- which(is.na(activityData$steps))                                        ## locate row positions with NA values
vectorOfMeanSteps <- rep(mean(activityData$steps, na.rm=TRUE), times=length(rowsWithNAs))   ## Create a vector of means
activityData[rowsWithNAs, "steps"] <- vectorOfMeanSteps
newActivityData <- select(activityData,steps,date,interval)
head(newActivityData)

## 3.4: Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number
##      of stepken per day. Do these values differ from the estimates from the first part of the assignment? What is the
##      impact of imputing missing data on the estimates of the total daily number of steps?

newTotalStepsPerDay <- aggregate(newActivityData$steps, by=list(newActivityData$date), FUN = sum)
names(newTotalStepsPerDay) <- c("date", "totalSteps")
barplot(height=newTotalStepsPerDay$totalSteps, names.arg=newTotalStepsPerDay$date, ylim=c(0, 25000), xlab="Date", ylab="Total Steps Per Day")
newMeanStepsPerDay <- mean(newTotalStepsPerDay$totalSteps)       ## New Mean of Total Number of Steps per Day
newMedianStepsPerDay <- median(newTotalStepsPerDay$totalSteps)   ## New Median of Total Number of Steps per Day
newMean <- (paste0("New Mean of Total Number of Steps per Day = ",newMeanStepsPerDay))
newMedian <- (paste0("New Median of Total Number of Steps per Day = ",newMedianStepsPerDay))
newMean
newMedian

## These values did not differ greatly from the estimates from the first part of the assignment.
## There is not a significant impact of imputing the missing values.

## Question 4: Are there differences in activity patterns between weekdays and weekends?

## 4.1: Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given
##      date is a weekday or weekend day.
newActivityData <- mutate(newActivityData, dayofweek = weekdays(as.Date(date)))
newActivityData <- mutate(newActivityData,daytype =ifelse(dayofweek %in% c("Saturday","Sunday"), "Weekend", ifelse(dayofweek %in% c("Monday","Tuesday","Wednesday","Thursday","Friday"), "Weekday", NA)))
head(newActivityData)

## 4.2: Make a panel plot containing a time series plot (i.e. 𝚝𝚢𝚙𝚎 = "𝚕") of the 5-minute interval (x-axis) and the average
##      number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the
##      GitHub repository to see an example of what this plot should look like using simulated dat
newStepsIntervalMean <- aggregate(steps ~ interval + daytype, newActivityData, mean)
panelPlotByDayType <- xyplot(steps ~ interval | daytype, data = newStepsIntervalMean, layout=c(2,1), type='l', xlab="Interval", ylab="Avg Number of Steps")
print(panelPlotByDayType)

## There are differences in the patterns observed between Weekdays and Weekends 