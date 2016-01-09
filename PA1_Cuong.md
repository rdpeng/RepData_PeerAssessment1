# PA1_Cuong
Cuong  
January 9, 2016  


**Loading and preprocessing the data**

Load the data (i.e. read.csv())


```r
data <- read.csv("activity.csv")
```

**What is mean total number of steps taken per day?**

For this part of the assignment, you can ignore the missing values in the dataset.

Calculate the total number of steps taken per day



```r
stepsperdaydata <- aggregate(data$steps, by=list(Category=data$date), FUN=sum)
```

If you do not understand the difference between a histogram and a barplot, research the difference between them. 

Make a histogram of the total number of steps taken each day


```r
hist(stepsperdaydata$x,main = " histogram of the total number of steps taken each day",xlab="number of steps",col = "blue")
```

![](PA1_Cuong_files/figure-html/unnamed-chunk-3-1.png)\
Make barplot of the total number of steps taken each day


```r
row.names(stepsperdaydata)<-stepsperdaydata[,1]
stepsperdaydata[,1]<-NULL
barplot(t(as.matrix(stepsperdaydata)))
```

![](PA1_Cuong_files/figure-html/unnamed-chunk-4-1.png)\

Calculate and report the mean and median of the total number of steps taken per day

Mean:


```r
mean(stepsperdaydata$x,na.rm=TRUE)
```

```
## [1] 10766.19
```

Median:


```r
median(stepsperdaydata$x,na.rm=TRUE)
```

```
## [1] 10765
```

**What is the average daily activity pattern?**

Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
averageNumber <- tapply(data$steps, data$interval, mean, na.rm = TRUE)
plot(row.names(averageNumber), averageNumber, type = "l", xlab = "5-min interval", 
    ylab = "Averaged across all Days", main = "Average number of steps taken", 
    col = "blue")
```

![](PA1_Cuong_files/figure-html/unnamed-chunk-7-1.png)\
Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
names(which.max(averageNumber))
```

```
## [1] "835"
```

**Imputing missing values**

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)


```r
number_of_missing_values <- sum(is.na(data))
number_of_missing_values
```

```
## [1] 2304
```

Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.


```r
average_steps <- aggregate(steps ~ interval, data = data, FUN = mean)
missing_values_filling <- numeric()
for (i in 1:nrow(data)) {
    obs <- data[i, ]
    if (is.na(obs$steps)) {
        steps <- subset(average_steps, interval == obs$interval)$steps
    } else {
        steps <- obs$steps
    }
    missing_values_filling <- c(missing_values_filling, steps)
}
```
Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
new_data <- data
new_data$steps <- missing_values_filling
```

Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
new_stepsperdaydata <- aggregate(steps ~ date, data = new_data, sum, na.rm = TRUE)
```
Histogram:


```r
hist(new_stepsperdaydata$steps, main = "Total steps by day", xlab = "day", col = "blue")
```

![](PA1_Cuong_files/figure-html/unnamed-chunk-13-1.png)\

New mean:


```r
mean(new_stepsperdaydata$steps)
```

```
## [1] 10766.19
```

New median:



```r
median(new_stepsperdaydata$steps)
```

```
## [1] 10766.19
```
**Are there differences in activity patterns between weekdays and weekends?**

For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.


```r
library(lattice)
days <- weekdays(as.Date(data$date,"%Y-%m-%d"))
level_day <- vector()
for (i in 1:nrow(data)) {
    if (days[i] == "Saturday") {
        level_day[i] <- "Weekend"
    } else if (days[i] == "Sunday") {
        level_day[i] <- "Weekend"
    } else {
        level_day[i] <- "Weekday"
    }
}

data$level_day <- level_day
data$level_day <- factor(data$level_day)

stepsPerDay <- aggregate(steps ~ interval + level_day, data = data, mean)
names(stepsPerDay) <- c("interval", "level_day", "steps")
```
Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.


```r
xyplot(steps ~ interval | level_day, stepsPerDay, type = "l", layout = c(1, 2), 
    xlab = "Interval", ylab = "Number of steps")
```

![](PA1_Cuong_files/figure-html/unnamed-chunk-17-1.png)\
