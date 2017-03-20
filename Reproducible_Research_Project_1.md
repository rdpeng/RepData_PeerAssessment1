# Reproducible Research: Peer Project 1
Packages needed to run code in this report are knitr, ggplot2, and lattice.


## Intro to Project
This project is for the Reproducible Research course, a Coursera Data Science 
program through John Hopkins University. More information about this program is
available [here](https://www.coursera.org/specializations/jhu-data-science).

The data for our project comes from the data accumulated through a personal 
activity monitoring device collected for a single individual during October and
November 2012. The data includes the number of steps taken in five minute
intervals each day.

## Loading and Preprocessing the Data
* Download the data from the github account.


```r
## Set working directory.
## Then download data.
URL <- "https://github.com/VickieBailey/RepData_PeerAssessment1/blob/master/activity.zip?raw=true"
temp <- tempfile()
download.file(URL, temp)
ActMonitorData <- read.csv("activity.csv")
dateDownloaded <- date()
unlink(temp)
```

* A Little Look Around

Data Structure

```r
str(ActMonitorData)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

Summary of the Variables

```r
summary(ActMonitorData)
```

```
##      steps                date          interval     
##  Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
##  1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
##  Median :  0.00   2012-10-03:  288   Median :1177.5  
##  Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
##  3rd Qu.: 12.00   2012-10-05:  288   3rd Qu.:1766.2  
##  Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
##  NA's   :2304     (Other)   :15840
```

Information on NAs. From summary, we see NAs only occur in steps column.

```r
## How many NAs
NAcount <- sum(is.na(ActMonitorData$steps))
## The percent of NAs as a decimal
evalNA <- mean(is.na(ActMonitorData$steps))
## Convert the decimal to a percent
percentNA <- format(evalNA*100, digits = 3)
```
There are 2304 NAs in the step variable.
This represents a 13.1%.

* Process the data. Make a copy of the raw dataframe to use for processing.

```r
## Create a copy of the raw dataframe.
process1 <- ActMonitorData
process1$date <- as.Date(process1$date, "%Y-%m-%d")
```

## What is the mean total of steps taken per day?

* Calculate the number of steps taken per day.

```r
perday1 <- aggregate(steps ~ date, process1, FUN = sum)
library(knitr)
kable(perday1, caption = "Mean Total Steps Per Day")
```



Table: Mean Total Steps Per Day

date          steps
-----------  ------
2012-10-02      126
2012-10-03    11352
2012-10-04    12116
2012-10-05    13294
2012-10-06    15420
2012-10-07    11015
2012-10-09    12811
2012-10-10     9900
2012-10-11    10304
2012-10-12    17382
2012-10-13    12426
2012-10-14    15098
2012-10-15    10139
2012-10-16    15084
2012-10-17    13452
2012-10-18    10056
2012-10-19    11829
2012-10-20    10395
2012-10-21     8821
2012-10-22    13460
2012-10-23     8918
2012-10-24     8355
2012-10-25     2492
2012-10-26     6778
2012-10-27    10119
2012-10-28    11458
2012-10-29     5018
2012-10-30     9819
2012-10-31    15414
2012-11-02    10600
2012-11-03    10571
2012-11-05    10439
2012-11-06     8334
2012-11-07    12883
2012-11-08     3219
2012-11-11    12608
2012-11-12    10765
2012-11-13     7336
2012-11-15       41
2012-11-16     5441
2012-11-17    14339
2012-11-18    15110
2012-11-19     8841
2012-11-20     4472
2012-11-21    12787
2012-11-22    20427
2012-11-23    21194
2012-11-24    14478
2012-11-25    11834
2012-11-26    11162
2012-11-27    13646
2012-11-28    10183
2012-11-29     7047



* Create a histogram of the total number of steps taken each day.

```r
## Set up and create histogram. Add a rug to show number of actual steps.
par(mar = c(5, 4, 1, 1))
with(perday1, {
 hist(perday1$steps, col = "deepskyblue", 
      main = "Total Steps per Day (excluding NAs)",
      xlab = "Number of Steps", ylab = "Count of Days" , las = 1)
rug(perday1$steps)   
})
```

![](Reproducible_Research_Project_1_files/figure-html/Number of Steps per Day-1.png)<!-- -->

* Find the mean and median number of steps taken each day.

```r
meansteps1 <- mean(perday1$steps)
roundmean1 <- format(round(meansteps1, digits = 2))
mediansteps1 <- median(perday1$steps)
roundmed1 <- format(round(mediansteps1, digits = 2))
```
The mean steps per day without imputing of NAs is 10766.19.
The median steps per day without imputing of NAs is 10765.


## What is the average daily activity pattern?
* Make a time series plot of the 5-minute interval (x-axis) and the average 
number of steps taken, averaged across all days (y-axis).

```r
perinterval1 <- aggregate(steps ~ interval, data = process1, FUN = mean)
library(ggplot2)
par(mar = c(5, 4, 1, 1))
perintplot <- ggplot(perinterval1, aes(interval, steps)) +
    geom_line(color = "purple") +
    labs(x = "Interval", y = "Average Number of Steps",
         title = "Average Steps per Interval")
perintplot
```

![](Reproducible_Research_Project_1_files/figure-html/Time Series Plot 1-1.png)<!-- -->

* Which 5-minute interval, on average across all the days in the dataset, 
contains the maximum number of steps?

```r
## Find the maximum average steps.
MaxSteps <- max(perinterval1$steps)
## Subset the interval and max average steps.
submax <- subset(perinterval1, steps == MaxSteps)
## Pull out the interval.
maxinterval <- submax$interval
```
The 5-minute interval, on average across all days in the dataset, that contains 
the maximum average number of steps is 835.


## Imputing Missing Values
* Information on NAs. From original summary, we see NAs only occur in steps column.

```r
## How many NAs
NAcount1 <- sum(is.na(process1$steps))
## The percent of NAs as a decimal
evalNA1 <- mean(is.na(process1$steps))
## Convert the decimal to a percent
percentNA1 <- format(evalNA1*100, digits = 3)
```
There are 2304 NAs in the step variable.
This represents a 13.1%.

* Impute missing values based on average of steps for the day of week and interval.

```r
## Copy of process1 datafram.
process2 <- process1
## Create variable for day of week.
process2$day <- weekdays(as.Date(process2$date))
## Impute NAs by using average of steps based on interval and day of week.
process2$steps <- with(process2, ave(steps, day, interval,
                           FUN = function(x) replace(x, is.na(x), 
                                                     mean(x, na.rm = TRUE))))
```

* Create a histogram of the total number of steps taken each day.

```r
## Compute number of steps per day.
perday2 <- aggregate(steps ~ date, process2, FUN = sum)
## Set up and create histogram. Add a rug to show number of actual steps.
par(mar = c(5, 4, 1, 1))
with(perday2, {
 hist(perday2$steps, col = "green2", 
      main = "Total Steps per Day with Imputing of NAs", 
      xlab = "Number of Steps", ylab = "Count of Days" , las = 1)
rug(perday2$steps)   
})
```

![](Reproducible_Research_Project_1_files/figure-html/Histogram for Imputed Steps per Day-1.png)<!-- -->

* Find the mean and median number of steps taken each day.

```r
meansteps2 <- mean(perday2$steps)
roundmean2 <- format(round(meansteps2, digits = 2))
mediansteps2 <- median(perday2$steps)
roundmed2 <- format(round(mediansteps2, digits = 2))
```
The mean steps per day with imputing of NAs is 10821.21.
The median steps per day with imputing of NAs is 11015.

* These values do differ from the estimates from the first part of the assignment.

```r
meandif <- meansteps2 - meansteps1
meandif2 <- abs(meandif)
meanresult <- if(meandif > 0) {
    "increased"
}  else if (meandif < 0) {
    "decreased"
}  else {
    "did not change"
}
mediandif <- mediansteps2 - mediansteps1
mediandif2 <- abs(mediandif)
medianresult <- if(mediandif > 0) {
    "increased"
}  else if (mediandif < 0) {
    "decreased"
}  else {
    "did not change"
}
```
By imputing missing data, the estimates of the mean daily number of 
steps increased by 55.0209226.
The estimates for the median daily number of steps increased by 250.


## Are there differences in activity patterns between weekdays and weekends?
* Create a new factor variable in the dataset with two levels - "weekday" and 
"weekend" indicating whether a given date is a weekday day or weekend day.

```r
weekends <- c('Saturday', 'Sunday')
process2$dayorend <- factor((weekdays(process2$date) %in% weekends), 
         levels=c(FALSE, TRUE), labels=c('weekday', 'weekend'))
```

* Make a panel plot containing a time series plot of the 5-minute interval and 
the average number of steps taken, averaged across all weekday days or weekend days.

```r
library(lattice)
par(mar = c(5, 4, 1, 1))
panelplot <- xyplot(steps ~ interval | dayorend, data = process2, 
       layout = c(1,2),
       xlab = "Interval", 
       ylab = "Number of Steps",
       ylim = c(-25, 250),
       panel = function(x, y, ...) {
           panel.average(x, y, type = "l", horizontal = FALSE, col = "blue")
       }
)
panelplot
```

![](Reproducible_Research_Project_1_files/figure-html/Time Series Plot 2-1.png)<!-- -->

