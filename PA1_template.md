# Reproducible Research: Peer Assessment 1
## Introduction

It is now possible to collect a large amount of data about personal
movement using activity monitoring devices such as a
[Fitbit](http://www.fitbit.com), [Nike
Fuelband](http://www.nike.com/us/en_us/c/nikeplus-fuelband), or
[Jawbone Up](https://jawbone.com/up). These type of devices are part of
the "quantified self" movement -- a group of enthusiasts who take
measurements about themselves regularly to improve their health, to
find patterns in their behavior, or because they are tech geeks. But
these data remain under-utilized both because the raw data are hard to
obtain and there is a lack of statistical methods and software for
processing and interpreting the data.

This assignment makes use of data from a personal activity monitoring
device. This device collects data at 5 minute intervals through out the
day. The data consists of two months of data from an anonymous
individual collected during the months of October and November, 2012
and include the number of steps taken in 5 minute intervals each day.

## Data

The data for this assignment can be downloaded from the course web
site:

* Dataset: [Activity monitoring data](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip) [52K]

The variables included in this dataset are:

* **steps**: Number of steps taking in a 5-minute interval (missing
    values are coded as `NA`)

* **date**: The date on which the measurement was taken in YYYY-MM-DD
    format

* **interval**: Identifier for the 5-minute interval in which
    measurement was taken




The dataset is stored in a comma-separated-value (CSV) file and there
are a total of 17,568 observations in this
dataset.



## Loading and preprocessing the data
Unzip the downloaded file activity.zip and read the csv into variable activity
unzip("activity.zip")

```r
activity <- read.csv("activity.csv")
```


## What is mean total number of steps taken per day?

Subset the data removing incomplete cases (NA's) and do not create a row.names column
aggregate will write column names as Group.1 and x respectively - set meaningful column names as date and total.steps
Show the frequency of total steps in a day
The histogram shows the ranges for the number of daily steps for this participant's data - we can quickly see this individual typically walks between 10000 and 15000 steps in a day.


```r
activityCompleteCases <- data.frame(activity[complete.cases(activity),], row.names=NULL)
totalStepsByDay <- with(activityCompleteCases, aggregate(x=steps, by=list(date), FUN='sum'))
names(totalStepsByDay2) <- c("date", "total.steps")
hist(totalStepsByDay2$total.steps, main="Histogram of Daily Steps", xlab="Number of Steps in a Day")
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

```r
meanDailySteps <- mean(totalStepsByDay2$total.steps)
medianDailySteps <- median(totalStepsByDay2$total.steps)
mean(totalStepsByDay2$total.steps)
```

```
## [1] 10766.19
```

```r
median(totalStepsByDay2$total.steps)
```

```
## [1] 10765
```

### What is the average daily activity pattern?

1. Make a time series plot (i.e. `type = "l"`) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
aveStepsByTimeInterval = with(activityCompleteCases, aggregate(x=steps, by=list(interval), FUN='mean') )
names(aveStepsByTimeInterval) <- c("interval", "mean.steps")
with(aveStepsByTimeInterval, plot(x=interval, y=mean.steps))
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 
   
2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

Get the row index of the maximum average number of steps from mean.steps and use the row index to retrieve the corresponding time interval



```r
maxStepsIndx <-  which.max(aveStepsByTimeInterval$mean.steps)
```

The 5 minute interval that on average across all days contains the maximum number of steps is ```{ aveStepsByTimeInterval$interval[maxStepsIndx] } ```


## Imputing missing values
Note that there are a number of days/intervals where there are missing
values (coded as `NA`). The presence of missing days may introduce
bias into some calculations or summaries of the data.

### 1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with `NA`s)


```r
activityIncompleteCases <- data.frame(activity[!complete.cases(activity),], row.names=NULL) 
```

The number of missing rows is 

```r
nrow(activityIncompleteCases) 
```

```
## [1] 2304
```

### 2. Devise a strategy for filling in all of the missing values in the dataset. 
To account for missing values the mean for the corresponding 5 minute interval will be used.

### 3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

Convert steps to integer

```r
class(aveStepsByTimeInterval$steps)
```

```
## [1] "NULL"
```

```r
aveStepsByTimeInterval$mean.steps <- as.integer(aveStepsByTimeInterval$mean.steps)

class(incompleteCases$steps)
```

```
## [1] "integer"
```

```r
incompleteCases$steps <- as.integer(incompleteCases$steps)
```

# Check that they have been converted to integer
class(aveStepsByTimeInterval$steps)
class(incompleteCases$steps)

Drop the steps column and then rename the mean.steps column to steps
Move the columns ie. col3 to 1 and col1 to 3
Use rbind to append rows


```r
mergedIncompleteCases <- merge(incompleteCases, aveStepsByTimeInterval) 

mergedIncompleteCases$steps <- NULL

colnames(mergedIncompleteCases) <- c("interval", "date", "steps")


incompleteCases <- NULL
incompleteCases <- with(mergedIncompleteCases,(data.frame(steps,date,interval)))


allCases <- rbind(activityCompleteCases, incompleteCases)

orderAllCases <- allCases[with(allCases, order(date, interval)), ]
head(orderAllCases)  
```

```
##       steps       date interval
## 15265     1 2012-10-01        0
## 15274     0 2012-10-01        5
## 15281     0 2012-10-01       10
## 15293     0 2012-10-01       15
## 15297     0 2012-10-01       20
## 15309     2 2012-10-01       25
```

## Are there differences in activity patterns between weekdays and weekends?


## 4. Make a histogram of the total number of steps taken each day and Calculate and report the **mean** and **median** total number of steps taken per day. 
Do these values differ from the estimates from the first part of the assignment? 
What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
totalStepsAllCases <- with(orderAllCases, aggregate(x=steps, by=list(date), FUN='sum'))
names(totalStepsAllCases) <- c("date", "total.steps")

hist(totalStepsAllCases$total.steps, main="Histogram of Daily Steps (All Cases)", xlab="Number of Steps in a Day")
```

![](PA1_template_files/figure-html/unnamed-chunk-9-1.png) 

```r
meanDailyStepsAllCases <- mean(totalStepsAllCases$total.steps)
meanDailyStepsAllCases
```

```
## [1] 10749.77
```

```r
medianDailyStepsAllCases <- median(totalStepsAllCases$total.steps)
medianDailyStepsAllCases
```

```
## [1] 10641
```

The mean values differ but the median does not


## Are there differences in activity patterns between weekdays and weekends?

1. Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
days <- weekdays(as.POSIXlt(orderAllCases$date))
rowIndx <- 0
dayType <- function(val){
   rowIndx <<- rowIndx + 1
  if(val=="Saturday" | val== "Sunday"){
        val = "Weekend"
        
  } else {
        val = "Weekday"
  }
  days[[rowIndx]] <<- val
}
tmpVar <- vapply(days, FUN=dayType, FUN.VALUE="val")

factor(days, levels=c("Weekday", "Weekend"), labels=c("Weekday", "Weekend"))
```

```
##     [1] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##     [9] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##    [17] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##    [25] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##    [33] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##    [41] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##    [49] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##    [57] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##    [65] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##    [73] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##    [81] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##    [89] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##    [97] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [537] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [545] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [553] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [561] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [569] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [577] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [585] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [593] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [601] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [609] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [617] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [625] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [633] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [641] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [649] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [657] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [665] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [673] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [681] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [689] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [697] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [705] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [713] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [721] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [729] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [737] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [745] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [753] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [761] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [769] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [777] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [785] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [793] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [801] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [809] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [817] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [825] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [833] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [841] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [849] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [857] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [865] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [873] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [881] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [889] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [897] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [905] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [913] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [921] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [929] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [937] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [945] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [953] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [961] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [969] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [977] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [985] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##   [993] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1001] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1009] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1017] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1025] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1033] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1041] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [1441] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1449] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1457] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1465] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1473] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1481] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1489] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1497] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1505] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1513] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1521] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1529] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1537] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1545] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1553] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1561] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1569] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1577] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1585] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1593] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1601] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1609] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1617] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1625] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1633] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1641] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1649] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1657] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1665] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1673] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1681] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1689] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1697] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1705] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1713] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1721] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1729] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1737] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1745] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1753] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1761] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1769] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1777] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1785] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1793] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1801] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1809] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1817] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1825] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1833] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1841] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1849] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1857] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1865] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1873] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1881] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1889] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1897] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1905] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1913] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1921] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1929] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1937] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1945] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1953] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1961] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1969] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1977] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1985] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [1993] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [2001] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [2009] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [2017] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2025] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2033] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2041] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2537] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2545] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2553] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2561] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2569] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2577] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2585] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2593] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2601] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2609] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2617] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2625] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2633] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2641] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2649] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2657] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2665] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2673] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2681] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2689] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2697] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2705] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2713] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2721] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2729] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2737] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2745] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2753] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2761] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2769] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2777] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2785] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2793] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2801] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2809] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2817] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2825] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2833] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2841] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2849] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2857] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2865] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2873] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2881] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2889] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2897] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2905] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2913] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2921] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2929] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2937] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2945] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2953] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2961] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2969] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2977] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2985] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [2993] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3001] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3009] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3017] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3025] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3033] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3041] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [3457] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3465] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3473] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3481] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3489] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3497] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3505] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3513] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3521] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3529] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3537] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3545] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3553] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3561] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3569] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3577] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3585] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3593] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3601] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3609] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3617] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3625] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3633] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3641] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3649] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3657] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3665] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3673] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3681] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3689] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3697] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3705] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3713] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3721] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3729] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3737] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3745] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3753] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3761] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3769] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3777] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3785] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3793] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3801] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3809] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3817] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3825] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3833] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3841] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3849] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3857] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3865] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3873] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3881] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3889] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3897] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3905] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3913] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3921] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3929] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3937] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3945] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3953] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3961] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3969] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3977] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3985] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [3993] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [4001] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [4009] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [4017] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [4025] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [4033] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4041] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4537] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4545] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4553] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4561] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4569] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4577] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4585] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4593] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4601] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4609] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4617] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4625] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4633] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4641] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4649] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4657] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4665] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4673] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4681] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4689] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4697] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4705] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4713] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4721] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4729] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4737] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4745] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4753] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4761] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4769] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4777] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4785] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4793] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4801] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4809] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4817] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4825] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4833] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4841] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4849] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4857] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4865] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4873] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4881] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4889] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4897] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4905] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4913] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4921] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4929] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4937] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4945] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4953] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4961] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4969] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4977] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4985] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [4993] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5001] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5009] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5017] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5025] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5033] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5041] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [5473] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5481] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5489] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5497] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5505] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5513] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5521] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5529] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5537] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5545] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5553] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5561] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5569] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5577] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5585] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5593] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5601] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5609] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5617] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5625] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5633] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5641] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5649] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5657] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5665] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5673] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5681] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5689] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5697] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5705] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5713] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5721] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5729] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5737] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5745] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5753] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5761] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5769] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5777] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5785] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5793] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5801] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5809] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5817] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5825] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5833] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5841] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5849] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5857] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5865] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5873] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5881] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5889] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5897] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5905] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5913] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5921] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5929] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5937] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5945] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5953] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5961] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5969] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5977] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5985] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [5993] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [6001] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [6009] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [6017] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [6025] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [6033] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [6041] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [6049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6537] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6545] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6553] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6561] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6569] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6577] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6585] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6593] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6601] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6609] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6617] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6625] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6633] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6641] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6649] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6657] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6665] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6673] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6681] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6689] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6697] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6705] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6713] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6721] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6729] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6737] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6745] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6753] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6761] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6769] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6777] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6785] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6793] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6801] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6809] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6817] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6825] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6833] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6841] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6849] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6857] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6865] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6873] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6881] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6889] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6897] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6905] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6913] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6921] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6929] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6937] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6945] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6953] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6961] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6969] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6977] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6985] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [6993] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7001] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7009] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7017] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7025] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7033] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7041] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [7489] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7497] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7505] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7513] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7521] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7529] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7537] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7545] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7553] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7561] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7569] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7577] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7585] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7593] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7601] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7609] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7617] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7625] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7633] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7641] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7649] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7657] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7665] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7673] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7681] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7689] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7697] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7705] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7713] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7721] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7729] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7737] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7745] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7753] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7761] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7769] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7777] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7785] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7793] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7801] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7809] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7817] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7825] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7833] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7841] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7849] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7857] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7865] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7873] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7881] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7889] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7897] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7905] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7913] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7921] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7929] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7937] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7945] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7953] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7961] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7969] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7977] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7985] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [7993] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [8001] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [8009] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [8017] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [8025] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [8033] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [8041] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [8049] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [8057] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [8065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8537] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8545] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8553] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8561] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8569] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8577] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8585] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8593] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8601] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8609] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8617] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8625] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8633] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8641] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8649] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8657] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8665] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8673] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8681] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8689] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8697] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8705] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8713] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8721] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8729] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8737] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8745] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8753] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8761] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8769] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8777] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8785] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8793] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8801] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8809] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8817] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8825] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8833] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8841] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8849] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8857] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8865] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8873] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8881] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8889] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8897] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8905] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8913] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8921] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8929] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8937] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8945] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8953] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8961] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8969] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8977] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8985] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [8993] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9001] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9009] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9017] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9025] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9033] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9041] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
##  [9505] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9513] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9521] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9529] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9537] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9545] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9553] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9561] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9569] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9577] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9585] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9593] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9601] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9609] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9617] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9625] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9633] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9641] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9649] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9657] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9665] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9673] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9681] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9689] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9697] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9705] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9713] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9721] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9729] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9737] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9745] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9753] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9761] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9769] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9777] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9785] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9793] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9801] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9809] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9817] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9825] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9833] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9841] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9849] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9857] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9865] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9873] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9881] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9889] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9897] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9905] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9913] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9921] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9929] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9937] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9945] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9953] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9961] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9969] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9977] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9985] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
##  [9993] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [10001] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [10009] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [10017] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [10025] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [10033] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [10041] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [10049] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [10057] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [10065] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [10073] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [10081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10537] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10545] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10553] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10561] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10569] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10577] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10585] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10593] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10601] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10609] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10617] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10625] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10633] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10641] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10649] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10657] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10665] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10673] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10681] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10689] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10697] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10705] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10713] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10721] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10729] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10737] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10745] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10753] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10761] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10769] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10777] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10785] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10793] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10801] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10809] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10817] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10825] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10833] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10841] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10849] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10857] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10865] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10873] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10881] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10889] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10897] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10905] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10913] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10921] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10929] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10937] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10945] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10953] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10961] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10969] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10977] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10985] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [10993] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11001] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11009] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11017] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11025] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11033] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11041] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [11521] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11529] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11537] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11545] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11553] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11561] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11569] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11577] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11585] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11593] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11601] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11609] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11617] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11625] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11633] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11641] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11649] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11657] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11665] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11673] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11681] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11689] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11697] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11705] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11713] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11721] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11729] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11737] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11745] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11753] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11761] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11769] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11777] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11785] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11793] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11801] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11809] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11817] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11825] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11833] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11841] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11849] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11857] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11865] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11873] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11881] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11889] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11897] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11905] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11913] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11921] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11929] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11937] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11945] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11953] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11961] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11969] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11977] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11985] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [11993] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12001] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12009] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12017] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12025] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12033] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12041] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12049] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12057] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12065] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12073] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12081] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12089] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [12097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12537] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12545] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12553] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12561] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12569] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12577] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12585] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12593] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12601] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12609] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12617] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12625] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12633] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12641] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12649] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12657] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12665] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12673] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12681] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12689] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12697] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12705] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12713] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12721] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12729] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12737] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12745] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12753] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12761] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12769] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12777] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12785] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12793] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12801] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12809] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12817] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12825] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12833] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12841] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12849] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12857] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12865] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12873] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12881] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12889] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12897] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12905] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12913] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12921] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12929] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12937] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12945] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12953] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12961] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12969] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12977] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12985] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [12993] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13001] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13009] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13017] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13025] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13033] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13041] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [13537] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13545] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13553] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13561] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13569] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13577] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13585] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13593] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13601] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13609] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13617] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13625] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13633] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13641] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13649] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13657] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13665] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13673] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13681] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13689] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13697] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13705] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13713] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13721] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13729] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13737] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13745] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13753] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13761] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13769] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13777] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13785] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13793] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13801] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13809] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13817] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13825] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13833] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13841] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13849] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13857] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13865] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13873] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13881] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13889] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13897] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13905] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13913] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13921] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13929] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13937] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13945] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13953] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13961] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13969] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13977] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13985] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [13993] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14001] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14009] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14017] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14025] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14033] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14041] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14049] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14057] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14065] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14073] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14081] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14089] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14097] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14105] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [14113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14537] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14545] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14553] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14561] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14569] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14577] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14585] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14593] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14601] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14609] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14617] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14625] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14633] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14641] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14649] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14657] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14665] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14673] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14681] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14689] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14697] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14705] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14713] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14721] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14729] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14737] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14745] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14753] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14761] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14769] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14777] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14785] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14793] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14801] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14809] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14817] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14825] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14833] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14841] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14849] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14857] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14865] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14873] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14881] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14889] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14897] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14905] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14913] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14921] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14929] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14937] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14945] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14953] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14961] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14969] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14977] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14985] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [14993] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15001] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15009] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15017] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15025] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15033] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15041] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15537] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15545] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [15553] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15561] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15569] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15577] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15585] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15593] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15601] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15609] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15617] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15625] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15633] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15641] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15649] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15657] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15665] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15673] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15681] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15689] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15697] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15705] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15713] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15721] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15729] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15737] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15745] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15753] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15761] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15769] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15777] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15785] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15793] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15801] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15809] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15817] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15825] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15833] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15841] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15849] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15857] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15865] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15873] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15881] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15889] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15897] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15905] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15913] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15921] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15929] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15937] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15945] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15953] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15961] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15969] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15977] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15985] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [15993] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16001] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16009] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16017] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16025] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16033] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16041] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16049] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16057] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16065] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16073] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16081] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16089] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16097] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16105] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16113] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16121] Weekend Weekend Weekend Weekend Weekend Weekend Weekend Weekend
## [16129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16537] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16545] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16553] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16561] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16569] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16577] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16585] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16593] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16601] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16609] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16617] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16625] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16633] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16641] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16649] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16657] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16665] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16673] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16681] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16689] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16697] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16705] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16713] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16721] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16729] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16737] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16745] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16753] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16761] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16769] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16777] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16785] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16793] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16801] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16809] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16817] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16825] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16833] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16841] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16849] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16857] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16865] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16873] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16881] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16889] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16897] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16905] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16913] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16921] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16929] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16937] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16945] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16953] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16961] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16969] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16977] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16985] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [16993] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17001] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17009] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17017] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17025] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17033] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17041] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17049] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17057] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17065] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17073] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17081] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17089] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17097] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17105] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17113] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17121] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17129] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17137] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17145] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17153] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17161] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17169] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17177] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17185] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17193] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17201] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17209] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17217] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17225] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17233] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17241] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17249] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17257] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17265] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17273] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17281] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17289] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17297] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17305] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17313] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17321] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17329] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17337] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17345] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17353] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17361] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17369] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17377] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17385] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17393] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17401] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17409] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17417] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17425] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17433] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17441] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17449] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17457] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17465] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17473] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17481] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17489] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17497] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17505] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17513] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17521] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17529] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17537] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17545] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17553] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## [17561] Weekday Weekday Weekday Weekday Weekday Weekday Weekday Weekday
## Levels: Weekday Weekend
```

```r
orderAllCases$day.type <- as.vector(days)
```

1. Make a panel plot containing a time series plot (i.e. `type = "l"`) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 

Returns 576 observations ie. 288 for weekday, 299 for weekend
averageByDayType <- with(orderAllCases, aggregate(x=steps, by=list(interval, day.type), FUN='mean'))
Sanity check: Get the first 6 rows of data and the data frames dimensions


```r
        head(averageByDayType) 
```

```
##   interval day.type    average
## 1        0  Weekday 2.15555556
## 2        5  Weekday 0.40000000
## 3       10  Weekday 0.15555556
## 4       15  Weekday 0.17777778
## 5       20  Weekday 0.08888889
## 6       25  Weekday 1.57777778
```

```r
        dim(averageByDayType)
```

```
## [1] 576   3
```

```r
        names(averageByDayType) <- c("interval", "day.type", "average")

        averageByDayTypeList <- split(x=averageByDayType, f=averageByDayType$day.type)
        weekdays = data.frame(averageByDayTypeList[[1]])
        weekends = data.frame(averageByDayTypeList[[2]])
```


Plot average for weekdays and weekends

```r
par(mfcol=c(2,1))


with(weekdays, plot(interval, average, type="l",
     main="Average steps / interval across all weekdays", 
     xlab="Interval", ylab="Average Steps", 
     lwd=2, col="blue"))
with(weekends, plot(interval, average, type="l",
     main="Average steps / interval across all weekends", 
     xlab="Interval", ylab="Average Steps", 
     lwd=2, col="blue"))
```

![](PA1_template_files/figure-html/unnamed-chunk-12-1.png) 




