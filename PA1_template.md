# Reproducible Research: Peer Assessment 1
Thinh Nguyen  
May 9, 2017  
## Loading and preprocessing the data

- Load data from file

```r
# load data
data<-read.csv("activity.csv",header = T,na.strings = "NA")
# Reprosessing data
data <- transform(data, date = as.Date(date))
data <- data.table(data)
```

## What is mean total number of steps taken per day?
1. Calculate the total number of steps taken per day (ignore the missing values) then add attribute names.


```r
totalstepsperday <- aggregate(steps ~ date, data = data, FUN = sum, na.rm = T)
names(totalstepsperday) <- c("Date", "Total_steps")
```

2. Plotting a Histogram 

![GitHub Logo](/PA1_template_files/figure-html/Histogram of the total number of steps taken each day-1.png)<!-- -->

3. Calculate mean and medium of steps taken per day


```r
#mean of steps per day
step_mean<-mean(totalstepsperday$Total_steps)
#median of steps per day
step_median<-median(totalstepsperday$Total_steps)
```

**
- The mean of steps taken per day is: 1.0766189\times 10^{4}  
- The median is: 10765
**  

## What is the average daily activity pattern?
1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
#get data average number of steps taken per 5 minutes
data_5m <- aggregate(steps ~ interval, data = data, FUN = mean, na.rm = T)
#plotting
with(data_5m,plot(x = interval, y = steps, type = "l", col = "orange", xlab = "5-minute Intervals", ylab = "Average Steps Taken per Days",main = "Average Daily Activity Pattern"))
```

![](PA1_template_files/figure-html/Line chart-1.png)<!-- -->
- On average across all the days in the dataset, which 5-minute interval contains the maximum number of steps?

```r
index_max<-data_5m[which.max(data_5m$steps),]$interval
```
It is the 835th interval   

## Imputing missing values
1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```r
sum(is.na(data$steps))
```

```
## [1] 2304
```
Total **2304**  rows are missing.  
2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

- Compute the mean steps for each day in dataset.

```r
mean_steps_per_day<-aggregate(data[, 1], list(data$date), mean)
# Print out how many day which mean is NA
sum(is.na(mean_steps_per_day$steps))
```

```
## [1] 8
```
- As we can see that there are **8** days which mean is NA, so we can't choose the mean or medium value of a day to replace NA in dataset. You can see the same thing when compute the meidum steps per day. Hence i use the mean 5-minute interval to replace the NA value and we know that the mean 5-minute interval's computed and stored in data_5m (u can find that above).
- we got 8 day which mean is NA, and 288 interval per day so we have at least 8x288 = 2304 missing row in dataset. Luckily we have exact 2304 missing rows in dataset so we just repeat the steps value in data_5m 8 times and put set it to steps of dataset at the NA rows.
3. Create a new dataset that is equal to the original dataset but with the missing data filled in. 

```r
#create new dataset names data_filled
data_filled<-data
# get index of rows have NA value in dataset
row_index_na<-which(is.na(data$steps))
# fill NA value by mean 5 min interval 
data_filled$steps<-as.double(data_filled$steps)
data_filled[row_index_na,]$steps<-rep(data_5m$steps,8)
sum(is.na(data_filled$steps))
```

```
## [1] 0
```
We can see that all NA value in steps column have been replace with mean 5 min interval.

4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day with data filled in.
- Make a histogram of the total number of steps taken each day

```r
totalstepsperday_filled <- aggregate(steps ~ date, data = data_filled, FUN = sum, na.rm = T)
names(totalstepsperday_filled) <- c("Date", "Total_steps")
hist(totalstepsperday_filled$Total_steps,main="Total Steps per Day with new data filled in",xlab="Number of Steps per Day", ylab = "Interval",col="blue")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

- Calculate mean and medium of steps taken per day with new data


```r
#mean of steps per day
step_mean_filled<-mean(totalstepsperday_filled$Total_steps)
#median of steps per day
step_median_filled<-median(totalstepsperday_filled$Total_steps)
```

**
- The mean of steps taken per day is: 1.0766189\times 10^{4}  
- The median is: 1.0766189\times 10^{4}
**  
- The mean is the same at first part. But the median now equal to mean. It seem to be that after filled NA value of steps by mean of 5 minute interval make the median closer the mean (maybe equal in this case). 
- The impact of imputing missing data on the estimates of the total daily number of steps is it make the total daily number of steps increase which days have missing value (NA).  

## Are there differences in activity patterns between weekdays and weekends?
1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
data_filled$day=ifelse(weekdays(data_filled$date)=="Sunday"|weekdays(data_filled$date)=="Saturday","weekend","weekday")
data_filled$day<-as.factor(data_filled$day)
```

2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.

```r
steps_Interval = aggregate(steps ~ interval + day, data_filled, mean)
library(lattice)
xyplot(steps ~ interval | factor(day), data = steps_Interval, aspect = 1/2, ylab = "Number of steps", xlab="Interval", type = "l")
```

![](PA1_template_files/figure-html/unnamed-chunk-11-1.png)<!-- -->
