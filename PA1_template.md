# Reproducible Research: Peer Assessment 1
## Loading and preprocessing the data

```r
library(dplyr)
library(ggplot2)
library(lubridate)
```

```r
filepath <- "./activity.csv"
activityRawData <- read.csv(filepath, header = TRUE, sep = ",", colClasses = c("numeric","POSIXct","numeric"))
```

## What is mean total number of steps taken per day?

In this case we are ignoring missing values. 


```r
StepsByDay <- summarise(group_by(activityRawData, date), sum(steps))
hist(StepsByDay$`sum(steps)`, breaks = 20, col = "green", main = "Histogram of the total number of steps by day", xlab ="Total steps by day")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

```r
meanStepsByDay <- mean(StepsByDay$`sum(steps)`, na.rm = TRUE)
medianStepsByDay <- median(StepsByDay$`sum(steps)`, na.rm = TRUE)
```
* The mean value is **1.0766189\times 10^{4}**
* The value of median is **1.0765\times 10^{4}**

## What is the average daily activity pattern?

In this case we are ignoring missing values. 


```r
StepsByInterval <- summarise(group_by(activityRawData, interval), AverageSteps=mean(steps, na.rm = TRUE))
ggplot(data = StepsByInterval, aes(x = interval, y = AverageSteps)) +
  geom_line() +
  xlab("5-minute interval") +
  ylab("Average number of steps taken")
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

```r
maxInterval <- filter(StepsByInterval, AverageSteps == max(AverageSteps))
```
* 5-minute interval with the maximum number of steps on average across all the days in the dataset: **835**
* The number of steps for this interval: **206.1698113**

## Imputing missing values

In this case i will change missing values to normal values.

The first step: calculating a total number of missing values in the raw dataset.

```r
quantNA <- sum(is.na(activityRawData))
```
Total number of rows with missing data is **2304**.

The second step: changing values from missing to normal.
I used average values of steps for the each 5-minute interval for filling missing values in raw dataset.


```r
activityWithoutNA <- activityRawData 
for (i in 1:nrow(activityWithoutNA)) {
  if (is.na(activityWithoutNA$steps[i])) {
    activityWithoutNA$steps[i] <- StepsByInterval[which(activityWithoutNA$interval[i] == StepsByInterval$interval), ]$AverageSteps
  }
}
```

The result of imputing missing values.

```r
StepsByDay_2 <- summarise(group_by(activityWithoutNA, date), sum(steps))
hist(StepsByDay_2$`sum(steps)`, breaks = 20, main = "Histogram of the total number of steps by day", xlab ="Total steps by day", col = "green")
```

![](PA1_template_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

```r
meanStepsByDay_2 <- mean(StepsByDay_2$`sum(steps)`, na.rm = TRUE)
medianStepsByDay_2 <- median(StepsByDay_2$`sum(steps)`, na.rm = TRUE)

diff_mean <- meanStepsByDay_2 - meanStepsByDay
diffMedian <- medianStepsByDay_2 - medianStepsByDay
```

For the dataset without missing values:

* The mean value is **1.0766189\times 10^{4}**
* The median value is **1.0766189\times 10^{4}**

The difference between values for datasets with and without missing values:

* For mean values is **0**
* For median values is **1.1886792**

After analysing of results we can see that mean value is the same for datasets with and without missing values.
Value of median for the dataset without missing values is bigger. But the difference is insignificant and does not have significant impact on the estimates of the total daily number of steps.  

## Are there differences in activity patterns between weekdays and weekends

In this case we are working with the dataset without missing values. 

For resolving this task I added column "day" (with values "workday" or "weekend") for the dataset.
I defined values for this column based on the values in the column "date".

Below you can see the graph with comparing of average number of steps for workdays and weekends.


```r
activityWithoutNA$day <-  ifelse(as.POSIXlt(activityWithoutNA$date)$wday %in% c(0,6), 'weekend', 'weekday')

StepsByInterval_Days <- aggregate(steps ~ interval + day, data = activityWithoutNA, mean)
ggplot(StepsByInterval_Days, aes(interval, steps)) + 
  geom_line() + 
  facet_grid(day ~ .) +
  xlab("5-minute interval") + 
  ylab("Average number of steps taken")
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

