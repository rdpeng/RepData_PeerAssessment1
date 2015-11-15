---
title: "Repdata034_PA2"
author: "Zoltan Kovacs"
date: "2015. november 15."
output: html_document
---


### Loading and preprocessing the data
Load the data

```r
# require package
library(lattice)

# Read and show data
dfActivity <- read.csv("activity.csv", stringsAsFactors=FALSE)
```

```
## Warning in file(file, "rt"): cannot open file 'activity.csv': No such file
## or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

```r
head(dfActivity,3)
```

```
## Error in head(dfActivity, 3): object 'dfActivity' not found
```

Process/transform the data (if necessary) into a format suitable for your analysis. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

```r
# Convert string to date
dfActivity$date <- as.Date(dfActivity$date, "%Y-%m-%d")
```

```
## Error in as.Date(dfActivity$date, "%Y-%m-%d"): object 'dfActivity' not found
```

```r
# Set weekdays and weekends from weekdays
dfActivity$weekday=weekdays(dfActivity$date)
```

```
## Error in weekdays(dfActivity$date): object 'dfActivity' not found
```

```r
# dfActivity$weekday = factor(dfActivity$weekday)
listWeekdays <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
dfActivity$wDay <- factor((dfActivity$weekday %in% listWeekdays),
                          levels=c(FALSE, TRUE), labels=c('weekend', 'weekday'))
```

```
## Error in match(x, table, nomatch = 0L): object 'dfActivity' not found
```

```r
# Clean up data
rm(listWeekdays)

# Show data
head(dfActivity, 3)
```

```
## Error in head(dfActivity, 3): object 'dfActivity' not found
```

### What is mean total number of steps taken per day?
Calculate the total number of steps taken per day

```r
# Aggregate data
TotalSteps <- aggregate(steps ~ date, data = dfActivity, sum, na.rm = TRUE)
```

```
## Error in eval(expr, envir, enclos): object 'dfActivity' not found
```

Make a histogram of the total number of steps taken each day

```r
# Create histogram
hist(TotalSteps$steps, main = "Total steps", xlab = "Day", col = "red")
```

```
## Error in hist(TotalSteps$steps, main = "Total steps", xlab = "Day", col = "red"): object 'TotalSteps' not found
```

Calculate and report the mean and median of the total number of steps taken per day

```r
# Mean of steps
mean(TotalSteps$steps)
```

```
## Error in mean(TotalSteps$steps): object 'TotalSteps' not found
```

```r
# Median of steps
median(TotalSteps$steps)
```

```
## Error in median(TotalSteps$steps): object 'TotalSteps' not found
```

### What is the average daily activity pattern?
Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
MeanSteps <- aggregate(steps ~ interval, data = dfActivity, mean, na.rm = TRUE)
```

```
## Error in eval(expr, envir, enclos): object 'dfActivity' not found
```

```r
plot(MeanSteps$interval, MeanSteps$steps, type="l",  col="blue",
     xlab="Interval",  ylab="Average of steps", 
     main="Time-series of the mean of steps per intervals")
```

```
## Error in plot(MeanSteps$interval, MeanSteps$steps, type = "l", col = "blue", : object 'MeanSteps' not found
```

Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
# Print maximum interval
MeanSteps$interval[which.max(MeanSteps$steps)]
```

```
## Error in eval(expr, envir, enclos): object 'MeanSteps' not found
```

### Imputing missing values
Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```r
# Print number of NAs
sum(is.na(dfActivity))
```

```
## Error in eval(expr, envir, enclos): object 'dfActivity' not found
```

Devise a strategy for filling in all of the missing values in the dataset.

```r
# Create an empty vector for storing (and calculating NA steps) steps
NewNAfreeVector = numeric()
for (i in 1:nrow(dfActivity)) {
    if (is.na(dfActivity[i, "steps"])) {
        ActualStep <- subset(MeanSteps, interval == dfActivity[i, "interval"])$steps
    } else {
        ActualStep <- dfActivity[i, "steps"]
    }
    NewNAfreeVector <- c(NewNAfreeVector, ActualStep)
}
```

```
## Error in nrow(dfActivity): object 'dfActivity' not found
```

Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
# Fill the missing data in a new dataset
dfActivity2 = dfActivity
```

```
## Error in eval(expr, envir, enclos): object 'dfActivity' not found
```

```r
dfActivity2$steps = NewNAfreeVector
```

```
## Error in dfActivity2$steps = NewNAfreeVector: object 'dfActivity2' not found
```

Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.

```r
# Aggregate data
TotalStepsWithoutNA <- aggregate(steps ~ date, data = dfActivity, sum, na.rm = TRUE)
```

```
## Error in eval(expr, envir, enclos): object 'dfActivity' not found
```

```r
# Create histogram
hist(TotalStepsWithoutNA$steps, main = "Total steps (NA filled with means)", xlab = "Day", col = "red")
```

```
## Error in hist(TotalStepsWithoutNA$steps, main = "Total steps (NA filled with means)", : object 'TotalStepsWithoutNA' not found
```

### Are there differences in activity patterns between weekdays and weekends?
Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).

```r
stepsWeekDay <- aggregate(steps ~ interval + wDay, data = dfActivity, mean)
```

```
## Error in eval(expr, envir, enclos): object 'dfActivity' not found
```

```r
xyplot(steps ~ interval | wDay, stepsWeekDay, type = "l", layout = c(1, 2),
       xlab = "Interval", ylab = "Number of steps")
```

```
## Error in eval(substitute(groups), data, environment(x)): object 'stepsWeekDay' not found
```
