# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data

The following code first loads the "dplyr" library for use further along the project. Then, it loads the data into an object named "data".  

No more preprocessing is done at this stage; it will be done in further stages as the need arises.


```r
library("dplyr")  
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
data <- read.csv(unz("activity.zip", "activity.csv"))
```

## What is mean total number of steps taken per day?

The following code stores the sum of steps for each day in an object named DailyData. Then, it plots the data as an histogram.


```r
DailyData <- summarise_each(group_by(data, date), funs(sum))
plot(DailyData$date, DailyData$steps, type="h")
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->


The mean and median of steps throughout the period are found below and saved for use further along the project:

```r
meandaily1 <- mean(DailyData$steps, na.rm=TRUE) 
meandaily1 
```

```
## [1] 10766.19
```

```r
mediandaily1 <- median(DailyData$steps, na.rm=TRUE) 
mediandaily1
```

```
## [1] 10765
```

  
  
## What is the average daily activity pattern?
The code below does three actions:  
1. finds the mean of steps for each interval and stores it in a variable called "IntervalData"  
2. creates a plot with the interval on the X axis and the mean number of steps on the Y axis  
3. finds the interval that has the maximum average number of steps and reports it as a number  


```r
IntervalData <- summarise_each(group_by(data[,c(1,3)], interval), funs(mean(., na.rm = TRUE)))
plot(IntervalData$interval, IntervalData$steps, type="l")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

```r
as.numeric(IntervalData[which.max(IntervalData$steps),1])
```

```
## [1] 835
```
  
    
    
## Imputing missing values
### 1. Calculate and report the total number of missing values in the dataset
The code first counts the rows in a subset that contains only NA values.

```r
nrow(subset(data, is.na(steps)))
```

```
## [1] 2304
```

### 2. Devise a strategy for filling in all of the missing values in the dataset.

The code first creates a function based on an object position that:  
1. for each position in the data, finds its number of steps (Y)  
2. for each position in the data, finds its interval (Z)  
3. if number of steps (Y) is NA, it replaces it for the mean number of steps for that interval, which is found in the IntervalData object  
4. if the number of steps is not NA, it just repeats the number of steps  
  
Then, it applies that function to all rows of data. The result is stored in an object named NAdata.


```r
ChangeNA <- function(X){
  Y <- data[X,1]
  Z <- as.numeric(data[X,3])
  if(is.na(Y)) {as.numeric(IntervalData[IntervalData$interval == Z,2])}
  else as.numeric(Y)
  }

NAdata <- sapply(1:nrow(data), ChangeNA)
```


### 3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

The code creates the data2 object by adding the NAdata column to the original data.


```r
data2 <- cbind(data, NAdata)
```

### 4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.
The following code stores the sum of steps for each day in an object named DailyData2. Then, it plots the data as an histogram.


```r
DailyData2 <- summarise_each(group_by(data2, date), funs(sum))
plot(DailyData2$date, DailyData2$NAdata, type="h")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->


The mean and median of steps throughout the period are found below and saved for use further along the project:

```r
meandaily2 <- mean(DailyData2$NAdata, na.rm=TRUE) 
meandaily2 
```

```
## [1] 10766.19
```

```r
mediandaily2 <- median(DailyData2$NAdata, na.rm=TRUE) 
mediandaily2
```

```
## [1] 10766.19
```

#### 4.1 Do these values differ from the estimates from the first part of the assignment?

The change in mean is:


```r
meandaily2 - meandaily1
```

```
## [1] 0
```

The change in median is:

```r
mediandaily2 - mediandaily1
```

```
## [1] 1.188679
```

#### 4.2 What is the impact of imputing missing data on the estimates of the total daily number of steps?

The missing data fills up periods for which we had no daily data, but it does not significantly change mean and median values.


## Are there differences in activity patterns between weekdays and weekends?
### 1. Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
The code first finds what day of the week is each of the days in the data, and stores it in an object named WeekdayString.

```r
WeekdayString <- sapply(as.Date(data2$date), weekdays)
```

A "TestWeekend" function is created that returns "Weekday" if it is Monday-Friday or "Weekend" if it is not.  
The function compares it to the week of Jan-9 (Monday) to Jan-13 (Friday). I thought this would be clearer than using the names of days in my native language.  

```r
TestWeekend <- function(x){
  if(x %in% 
      c(weekdays(as.Date("09/01/17", format="%d/%m/%y")),
      weekdays(as.Date("10/01/17", format="%d/%m/%y")),
      weekdays(as.Date("11/01/17", format="%d/%m/%y")),
      weekdays(as.Date("12/01/17", format="%d/%m/%y")),
      weekdays(as.Date("13/01/17", format="%d/%m/%y")))
     ){ 
      "Weekday"}
  else "Weekend"
}
```
After the function is defined, it is applied to the WeekdayString object and stored in an object named WeekendCol.   
Then, WeekendCol is added to data2 and stored in an object named data3

```r
WeekendCol <- sapply(WeekdayString, TestWeekend)
data3 <- cbind(data2, WeekendCol)
```

###2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).
The code first subsets the data in two different objects (WeekdayData and WeekendData).  
Then, it finds the interval data for each object and stores it in IntervalDataWeekday and IntervalDataWeekend.

```r
WeekdayData <- subset(data3, WeekdayCol="Weekday")
IntervalDataWeekday <- summarise_each(group_by(WeekdayData[,c(3,4)], interval), funs(mean(., na.rm = TRUE)))
WeekendData <- subset(data3, WeekdayCol="Weekend")
IntervalDataWeekend <- summarise_each(group_by(WeekendData[,c(3,4)], interval), funs(mean(., na.rm = TRUE)))
```

Now it plots first the data for weekdays, then for weekends.

```r
plot(IntervalDataWeekday$interval, IntervalDataWeekday$NAdata, type="l")
```

![](PA1_template_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

```r
plot(IntervalDataWeekend$interval, IntervalDataWeekend$NAdata, type="l")
```

![](PA1_template_files/figure-html/unnamed-chunk-16-2.png)<!-- -->


