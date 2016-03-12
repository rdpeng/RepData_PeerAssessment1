---
title: "Analysis of Activitiy"
author: "Shan-Chiou Lin"
date: "February 21, 2016"
output: html_document
---

##Introduction
It is now possible to collect a large amount of data about personal movement using activity monitoring devices such as a Fitbit, Nike Fuelband, or Jawbone Up. These type of devices are part of the "quantified self" movement -- a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. But these data remain under-utilized both because the raw data are hard to obtain and there is a lack of statistical methods and software for processing and interpreting the data.

## 1 Loading and preprocessing the data


```r
# First step, setup directory and load data from csv file. 
# Directory
setwd("/Users/Samball/Desktop/examples and practices")

#Getting and loading the data
echo = TRUE

Activity_data <- read.csv('./activity.csv', header = T, sep = ',')
head(Activity_data)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```

## 2 What is mean total number of steps taken a day?


```r
# the total number of steps taken per day

Steps_a_day <- aggregate(steps ~ date, Activity_data, sum)

echo = TRUE
mean_steps <- round(mean(Steps_a_day$steps))
mean_steps
```

```
## [1] 10766
```

```r
median_steps <- round(median(Steps_a_day$steps))
median_steps
```

```
## [1] 10765
```

```r
# Draw a Histogram of number of steps per day
hist(Steps_a_day$steps, main = 'Histogram of number of steps per day', xlab = 'Sum of Steps a day' )
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)

##3 What is the average daily activity pattern?


```r
# Mean & the Median total number of steps taken a day
AvgSteps_Per_interval <- aggregate(steps ~ interval, Activity_data, mean)

# Draw Time series plot of the average number of steps taken
plot(AvgSteps_Per_interval$interval, AvgSteps_Per_interval$steps, type="l", col=1, main = 'Avg Number of steps per interval', xlab = 'Interval', ylab = 'Avg Number of Steps')
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)

```r
# Identify the interval index which has the highest average steps
interval_idx <- which.max(AvgSteps_Per_interval$steps)

# Identify the specific interval and the average steps for that interval
print (paste("The interval with the highest avg steps is ", AvgSteps_Per_interval[interval_idx, ]$interval, " and the no of steps for that interval is ", round(AvgSteps_Per_interval[interval_idx, ]$steps, digits = 1)))
```

```
## [1] "The interval with the highest avg steps is  835  and the no of steps for that interval is  206.2"
```

## 4 Imputing missing values


```r
#Figure out the no of missing values
NA_Activity <- Activity_data[!complete.cases(Activity_data), ]
nrow(NA_Activity)
```

```
## [1] 2304
```

```r
#Subsitute the NA value with Avg_steps by looping way

ImputedData <- Activity_data  # creation of the dataset that will have no more NAs

for(i in 1:nrow(ImputedData)){
  if(is.na(ImputedData$steps[i])){
          interval_value <- ImputedData$interval[i] 
          steps_value <- AvgSteps_Per_interval[AvgSteps_Per_interval$interval == interval_value,] 
          ImputedData$steps[i] <- steps_value$steps
		}
}

# Aggregate the steps per day with the imputed values
Steps_per_day_imputed <- aggregate(steps ~ date, ImputedData, sum)

mean_steps_imputed <- round(mean(Steps_per_day_imputed$steps))
median_steps_imputed <- round(median(Steps_per_day_imputed$steps))

# In order to compare the new values with the “old” values:
echo = TRUE
df_summary <- NULL
Summary <- rbind(df_summary, data.frame(mean = c(mean_steps, mean_steps_imputed), median = c(median_steps, median_steps_imputed)))
rownames(Summary) <- c("with Missing Value", "without Missing Value")
print(Summary)
```

```
##                        mean median
## with Missing Value    10766  10765
## without Missing Value 10766  10766
```

```r
# Draw a histogram of the value 
hist(Steps_per_day_imputed$steps, main = "Histogram of total number of steps per day (IMPUTED)", xlab = "Steps a day")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)


## 5 Are there differences in activity patterns between weekdays and weekends?


```r
# Create a function to determine weekday or weekend

week_day <- function(date_val) {
    wd <- weekdays(as.Date(date_val, '%Y-%m-%d'))
    if  (!(wd == 'Saturday' || wd == 'Sunday')) {
        x <- 'Weekday'
    } else {
        x <- 'Weekend'
    }
    x
}

# Apply the week_day function and add a new column to activity dataset
ImputedData$day_type <- as.factor(sapply(ImputedData$date, week_day))

# Create the aggregated data frame by intervals and day_type
Steps_a_day_imputed <- aggregate(steps ~ interval+day_type, ImputedData, mean)

# Create the plot
library(ggplot2)
plt <- ggplot(Steps_a_day_imputed, aes(interval, steps)) +
    geom_line(stat = "identity", aes(colour = day_type)) +
    theme_gray() +
    facet_grid(day_type ~ ., scales="fixed", space="fixed") +
    labs(x="Interval", y=expression("No of Steps")) +
    ggtitle("No of steps Per Interval by day type")
print(plt)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)

