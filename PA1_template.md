# Reproducible Research: Peer Assessment 1
Justin Ahlstrom  


## Loading and preprocessing the data
The original instructions and source data for this assignment submission are available on GitHub.

https://github.com/rdpeng/RepData_PeerAssessment1

#### Set working directory
This repo was forked/cloned in Git and the root was set as the working directory in R.


```r
setwd("~/Documents/Coursera/repdata-006/RepData_PeerAssessment1")
```

#### Import data

Unzip the activity data from the repo and save the CSV to the data folder.

```r
unzip("activity.zip", exdir = "data")
```

Load the file to a dataset in R.  Sample data is displayed below.

```r
activity <- read.csv("data/activity.csv")
activity[1000:1005,]
```

```
##      steps       date interval
## 1000     0 2012-10-04     1115
## 1001     0 2012-10-04     1120
## 1002   180 2012-10-04     1125
## 1003    21 2012-10-04     1130
## 1004     0 2012-10-04     1135
## 1005     0 2012-10-04     1140
```

#### Process the data
No initial processing steps are required to start the analysis.

## What is mean total number of steps taken per day?

#### Visualize the distribution
Use the `plyr` package to summarize the total steps by day and create a histogram to visualize the distribution.

```r
library(plyr)
activity_daily <- ddply(activity,~date,summarize,totalsteps=sum(steps))
hist(activity_daily$totalsteps, main = "Histogram of the Total Steps Taken per Day", ylab = "Number of Days", xlab = "Total Steps")
```

![plot of chunk histogram](./PA1_template_files/figure-html/histogram.png) 

#### Calculate the summary stats
Calculate the mean and median of the daily step totals by using the `summarize` function.  The `xtable` package is used to provide a formatted output.

```r
library(xtable)

summary <- summarize(activity_daily, mean = mean(totalsteps, na.rm = TRUE), median = median(totalsteps, na.rm = TRUE))
row.names(summary) <- c("Total Steps per Day")
summary <- format(round(summary,2), nsmall=2, big.mark=",")

xt <- xtable(summary)
print(xt, type = "html")
```

<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Sun Sep 14 17:26:00 2014 -->
<table border=1>
<tr> <th>  </th> <th> mean </th> <th> median </th>  </tr>
  <tr> <td align="right"> Total Steps per Day </td> <td> 10,766.19 </td> <td> 10,765.00 </td> </tr>
   </table>

## What is the average daily activity pattern?

#### Visualize the daily trend
Again, using the `plyr` package, calculate the average number of steps by interval.  Plot this time series data to visualize the daily trend. 


```r
activity_avg <- ddply(activity,~interval,summarize,avgsteps=mean(steps, na.rm = TRUE))
plot(activity_avg$interval,activity_avg$avgsteps, type = "l", main = "Time Series of Average Steps Taken During the Day", ylab = "Number of Steps (per 5 min)", xlab = "Time of Day (Interval Code)")
```

![plot of chunk timeseries](./PA1_template_files/figure-html/timeseries.png) 

#### Identify the interval with the highest average number of steps


```r
maxint <- activity_avg[which.max(activity_avg$avgsteps),1]
maxsteps <- round(activity_avg[which.max(activity_avg$avgsteps),2],1)
```

The **835** interval has the highest average number of steps at **206.2**.

Going further, we can see that the top 5 most active intervals all fall in the same brief window.

```r
activity_avg[order(activity_avg[,"avgsteps"], decreasing = TRUE)[1:5],]
```

```
##     interval avgsteps
## 104      835    206.2
## 105      840    195.9
## 107      850    183.4
## 106      845    179.6
## 103      830    177.3
```

## Imputing missing values

#### Find the number of missing values

```r
missing <- sum(!complete.cases(activity))
total <- nrow(activity)
```

Of the **17,568** rows in the dataset, **2,304** contain missing values.

#### Define the strategy for missing values
To fill in the missing values in the file, substitute that interval's step count with the average step count for that interval.

#### Fill in missing values
Create an copy of the data set and fill in the `NA` values using the logic above.


```r
activity_filled <- activity
activity_filled$steps <- ifelse(is.na(activity_filled$steps), 
                                activity_avg[match(activity_filled$interval, activity_avg$interval), "avgsteps"], 
                                activity_filled$steps)
```

#### Compare filled dataset to original
Use the `plyr` package to summarize the total steps by day and create a histogram to visualize the distribution.


```r
library(plyr)
activity_filled_daily <- ddply(activity_filled,~date,summarize,totalsteps=sum(steps))
hist(activity_filled_daily$totalsteps, main = "Histogram of the Total Steps Taken per Day (Missing Values Filled)", ylab = "Number of Days", xlab = "Total Steps")
```

![plot of chunk histogram2](./PA1_template_files/figure-html/histogram2.png) 

Calculate the mean and median of the daily step totals by using the `summarize` function.  The `xtable` package is used to provide a formatted output.

```r
library(xtable)

summary_filled <- summarize(activity_filled_daily, mean = mean(totalsteps, na.rm = TRUE), median = median(totalsteps, na.rm = TRUE))
row.names(summary_filled) <- c("Total Steps per Day")
summary_filled <- format(round(summary_filled,2), nsmall=2, big.mark=",")

xt2 <- xtable(summary_filled)
print(xt2, type = "html")
```

<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Sun Sep 14 17:26:00 2014 -->
<table border=1>
<tr> <th>  </th> <th> mean </th> <th> median </th>  </tr>
  <tr> <td align="right"> Total Steps per Day </td> <td> 10,766.19 </td> <td> 10,766.19 </td> </tr>
   </table>
No significant differences are observed when we fill in missing values.  Because their were typically full days of data missing, using the average of the interval to fill in the missing values skews the median value to equal the mean.

## Are there differences in activity patterns between weekdays and weekends?
Create a variable to indicate if the date is a weekday or weekend.  Use the `lattice` package to make a panel plot.

```r
library(lattice)
activity$weekday <- ifelse(weekdays(as.Date(activity$date)) %in% c("Saturday", "Sunday"), "Weekend", "Weekday")
activity_avg_days <- ddply(activity,.(interval, weekday), summarize, avgsteps=mean(steps, na.rm = TRUE))

xyplot(avgsteps ~ interval | weekday, data = activity_avg_days, layout = c(1,2), type = "l",
       main = "Time Series of Average Steps Taken During the Day",
       ylab = "Number of Steps (per 5 min)",
       xlab = "Time of Day (Interval Code)")
```

![plot of chunk timeseries2](./PA1_template_files/figure-html/timeseries2.png) 

From the chart, we can see that the peek step totals are not as high on the weekends, but the activity is higher throughout the day.

