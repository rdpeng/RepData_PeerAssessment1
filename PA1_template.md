# Reproducible Research: Peer Assessment 1
## Set Working Directory and Load Libraries

```r
# Load necessary libraries
library(data.table)
```

```
## Warning: package 'data.table' was built under R version 3.3.1
```

```r
library(knitr)
```

```
## Warning: package 'knitr' was built under R version 3.3.1
```

```r
library(lattice)

# Set Working Directory
setwd("./GitHub/RepData_PeerAssessment1/")
activity_address <- "./activity/activity.csv"
```


## Loading and preprocessing the data

```r
# Load the CSV
activity_data <- read.csv(activity_address)
# Omit NAs
activity_data_na <- na.omit(activity_data)
```



## What is mean total number of steps taken per day?

```r
# Create data table
dt <- data.table(activity_data_na)

# Create Data frame of total steps
steps <- as.data.frame(dt[,list(total=sum(steps)),by=c("date")])
```

Print Total Steps


```r
# Print total steps
total_steps <- sum(steps$total)
print(total_steps)
```

```
## [1] 570608
```

```r
# 570608 is the total number of steps
```

Plot Histogram of Steps/Day

```r
# Plot Histogram
hist(steps$total,col="blue",main="Histogram of steps/day",xlab="Total Steps/day")
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

Calculate mean and median number of steps

```r
# Calculate the mean number of steps
mean_steps <- mean(steps$total)
print(paste("Mean Steps = ",mean_steps))
```

```
## [1] "Mean Steps =  10766.1886792453"
```

```r
# 10766.19 is the mean number of steps/day

# Calculate the median number of steps
median_steps <- median(steps$total)
print(paste("Median Steps = ",median_steps))
```

```
## [1] "Median Steps =  10765"
```

```r
# 10765 is the median number of steps/day
```


## What is the average daily activity pattern?

Use tapply to get the mean steps and time series


```r
# Use Tapply to get the mean steps and time series
time_series <- tapply(activity_data_na$steps,activity_data_na$interval,mean)
```

Time series plot


```r
# Time series plot
plot(row.names(time_series), time_series, type = "l", 
     xlab = "5-min interval", 
     ylab = "Average across all Days", 
     main = "Average number of steps taken", 
     col = "blue")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

Find the max interval

```r
# Find the max interval
max_interval <- which.max(time_series)
names(max_interval)
```

```
## [1] "835"
```

```r
print(paste("Max interval is ",max_interval))
```

```
## [1] "Max interval is  104"
```

```r
# Interval 835 contains the maximum number of steps
```


## Imputing missing values

Calculate and report the total number of missing values in the dataset

```r
# Calculate the number of entries in the data set and the NA removed dataset
number_entries <- nrow(activity_data)
number_not_na <- nrow(activity_data_na)

# Total NA = Total Entries - Total Not NA
number_na <- number_entries-number_not_na
print(number_na)
```

```
## [1] 2304
```
Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

Strategy: Replace missing value with overall mean steps

Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
  # Create a copy of the activity data
  activity_data_2 <- activity_data
  
  #Calculate the average number of steps per 5 min interval
  average_steps <- aggregate(steps~interval,data=activity_data_2,FUN=mean)  

  # For each entry in the activity data copy
  for(i in 1:nrow(activity_data_2)){
    # Get the current observation
    obs <- activity_data_2[i,]
    # if the observation is missing steps then use the 5 min interval value
    if (is.na(obs$steps)){
      steps <- subset(average_steps,interval==obs$interval)$steps
    }
    # otherwise the steps is the observed value
    else{
      steps <- obs$steps
    }
  }
```

Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
  total_steps_new <- aggregate(steps~date,data = activity_data_2, sum, na.rm = TRUE)
  hist(total_steps_new$steps,main = "Total Steps/Day",xlab="day",col="blue")
```

![](PA1_template_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

Report the mean and median of total steps taken per day. Note: Since NA's were removed in the
original plot there is no difference in the means or medians!

```r
  mean_steps_new <- mean(total_steps_new$steps)
  print(paste("Mean steps =",mean_steps_new))
```

```
## [1] "Mean steps = 10766.1886792453"
```

```r
  median_steps_new <- median(total_steps_new$steps)
  print(paste("Median steps = ",median_steps_new))
```

```
## [1] "Median steps =  10765"
```

```r
  mean_difference <- mean_steps - mean_steps_new
  median_difference <- median_steps - median_steps_new
  

  print(paste("Mean difference: ", mean_difference))
```

```
## [1] "Mean difference:  0"
```

```r
  print(paste("Median difference: ", median_difference))
```

```
## [1] "Median difference:  0"
```
## Are there differences in activity patterns between weekdays and weekends?

Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.


```r
  # Pull date data
  activity_data_2$date <-as.Date(activity_data_2$date,"%Y-%m-%d")
  
  # use the weekdays function to get the day
  day <- weekdays(activity_data_2$date)
  # Create a vector to store the day level (corresponding to each entry in activity_data_2)
  day_level <- vector()
  
  # for each entry in activity data 2
  for (i in 1:nrow(activity_data_2)){
    # If the day is Saturday or Sunday it is a weekend
    if (day[i]=="Saturday"){
      day_level[i] <- "Weekend"
    } 
    else if (day[i] == "Sunday"){
      day_level[i] <- "Weekend"
    } 
    # Otherwise it is a weekday
    else{
      day_level[i] <- "Weekday"    
    }
  }
  # Set factors according to day level for Weekday and Weekend
  activity_data_2$day_level <- day_level
  activity_data_2$day_level <- factor(activity_data_2$day_level)
  
  steps_by_day <- aggregate(steps~interval+day_level,data = activity_data_2, mean)
  names(steps_by_day) <- c("interval","day_level","steps")
```

Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.


```r
  # Create an xyplot for interval and number of steps
  xyplot(steps~interval|day_level,steps_by_day,type="l",layout = c(1,2),
         xlab = "Interval",
         ylab = "Number of Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-15-1.png)<!-- -->
There are differences in activity patterns between weekends and weekdays
