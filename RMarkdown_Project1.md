---
title: "RMarkdown_Project1"
author: "kks_git"
date: "2023-12-22"
output: html_document
---



A. Loading and preprocessing the data

1.  Load the Data


```r
data<-".\\activity.csv"
dataP1<-read.csv(data, header=TRUE)
```

2.  Process/transform the Data


```r
dataP1$date<-as.Date(x=dataP1$date, format="%Y-%m-%d")
```

B. What is mean total number of steps taken per day?

1.  Calculate the total number of steps taken per day


```r
dailySteps<-aggregate(steps~date, data=dataP1, FUN=sum)
```

2.  Make a histogram of the total number of steps taken each day


```r
steps_hist<-ggplot(data = dailySteps, aes(x=steps)) +geom_histogram(fill="red", binwidth=500)+labs(title="Steps per Day", x="steps",y="frequency")+theme(plot.title = element_text(hjust=0.5))
steps_hist
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)

3.  Calculate and report the mean and median of the total number of steps taken per day


```r
stepsMean<-mean(dailySteps$steps, na.rm=TRUE)
stepsMean
```

```
## [1] 10766.19
```

```r
stepsMedian<-median(dailySteps$steps, na.rm=TRUE)
stepsMedian
```

```
## [1] 10765
```

C. What is the average daily activity pattern?

1. Make a time series plot (i.e. 
type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
stepsInterval<-aggregate(steps~interval, data = dataP1, FUN = mean)
timeSeries_plot<-ggplot(stepsInterval, aes(x=interval, y=steps)) +geom_line(color="blue", linewidth=1)+labs(title="Steps per Interval", x="interval", y="average steps") +theme(plot.title = element_text(hjust=0.5, vjust = 2))
timeSeries_plot
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png)

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
maxInterval<-stepsInterval[which.max(stepsInterval$steps),]
maxInterval
```

D. Imputing missing values

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NA NAs)

```r
totalNAs<-sum(is.na(dataP1$steps))
totalNAs
```

```
## [1] 2304
```

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy is to fill all NAs with the average of 5-minute interval.

```r
meanInterval<-aggregate(steps~interval, data=dataP1, FUN=mean, na.rm=TRUE)
```

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
fill_data<-dataP1
steps_NAs<-is.na(dataP1$steps)
NAs<-na.omit(subset(meanInterval,interval==dataP1$interval[steps_NAs]))
fill_data$steps[steps_NAs]<-NAs[,2]
fill_stepsNA<-sum(is.na(fill_data))
fill_stepsNA
```

```
## [1] 0
```

4A. Make a histogram of the total number of steps taken each day 

```r
dailySteps_filled<-aggregate(steps~date, data=fill_data, FUN=sum,na.rm=TRUE)
steps_filled_hist<-ggplot(data = dailySteps_filled, aes(x=steps)) +geom_histogram(fill="green", binwidth=500)+labs(title="Steps per Day with no NAs", x="steps",y="frequency")+theme(plot.title = element_text(hjust=0.5))
steps_filled_hist
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png)

4B. Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
steps_filledMean<-mean(dailySteps_filled$steps, na.rm=TRUE)
steps_filledMean
```

```
## [1] 10766.19
```

```r
steps_filledMedian<-median(dailySteps_filled$steps, na.rm=TRUE)
steps_filledMedian
```

```
## [1] 10766.19
```

4C.Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
"The mean values are same for both cases, but the median was higher for data with NAs. However, the mean and median become equal after filling NAs."
```

```
## [1] "The mean values are same for both cases, but the median was higher for data with NAs. However, the mean and median become equal after filling NAs."
```

E. Are there differences in activity patterns between weekdays and weekends?

1.Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
fill_data$date<-as.Date(fill_data$date)
wday=c("Monday", "Tuesday","Wednesday", "Thursday","Friday")
fill_data$day<-factor(ifelse(weekdays(fill_data$date) %in% wday,'weekday','weekend'))
```

2. Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
meanSteps_days<-aggregate(steps~interval+day, data = fill_data, FUN = mean, na.rm=TRUE)
timeSeries_daySteps<-ggplot(meanSteps_days, aes(x=interval, y=steps,color=day)) +geom_line()+facet_grid(day~.)+labs(title="Steps by Days", x="interval", y="average steps") +theme(plot.title = element_text(hjust=0.5, vjust = 2))
timeSeries_daySteps
```

![plot of chunk unnamed-chunk-15](figure/unnamed-chunk-15-1.png)

