# RepData_PeerAssessment1
Courtney D. Shelley  
August 16, 2014  



## Introduction

The data set analyzed contains 17,568 observations of a single individual using a movement monitoring device to collect the number of steps taken in 5-minute intervals collected during the months of October-November, 2012.  The mean number of steps taken per day is 10766.19 steps.


```r
## Loading and preprocessing the data
movement<-read.csv("activity.csv", sep=",") 
library(data.table)
nrow(movement)    # Confirm 17568 data values
```

```
## [1] 17568
```

```r
## Mean steps per day
steps<-data.table(na.omit(movement))       # Data table to remove NAs
setkey(steps, date)                        # Set sorting key to date
dateSums<-steps[,sum(steps), by=date]      # Sum steps by date
mean(dateSums$V1) 
```

```
## [1] 10766
```
  
  
  
## Histogram of Total Steps Per Day


```r
hist(dateSums$V1, main = "Histogram of Total Steps Per Day", xlab="Total Steps Per Day")
abline(v=mean(dateSums$V1),col=2,lty=3, cex = 10)
legend("topright", pch = 16, col = "red", legend = "Mean")
```

![plot of chunk dailyHist](./RepData_PeerAssessment1_files/figure-html/dailyHist.png) 



```r
mean <- mean(dateSums$V1)                # Mean and median of steps per day
median <- median(sort(dateSums$V1))
mean(dateSums$V1)
```

```
## [1] 10766
```

```r
median(sort(dateSums$V1)) 
```

```
## [1] 10765
```

> The mean total number of steps is 1.0766 &times; 10<sup>4</sup> and the median number of steps is 10765.  




## Average daily activity pattern.  

A clearer understanding of the subject's daily activity pattern is obtained by averaging each 5-minute time interval over the data range and plotting these as a time series.  This breakdown was achieved using the data.table() command, which can sort by a specified feature, to compute the mean of each time interval.  The 5-minute interval with the highest activity level is 104.  


```r
intervals<-data.table(na.omit(movement))          # Data table to sort by intervals
setkey(intervals, interval)                       # Set sorting key to intervals
intervalMeans<-intervals[,mean(steps), by=interval] # Mean steps by interval

plot.ts(intervalMeans$V1, main = "Time Series Plot of Mean Steps Per Interval", xlab = "Interval",
        ylab = "Mean Steps")
```

![plot of chunk averageDay](./RepData_PeerAssessment1_files/figure-html/averageDay.png) 

```r
intervalMeans$V1==max(intervalMeans$V1)     # Count out to 104, sorry that's ugly
```

```
##   [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [12] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [23] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [34] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [45] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [56] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [67] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [78] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [89] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [100] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
## [111] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [122] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [133] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [144] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [155] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [166] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [177] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [188] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [199] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [210] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [221] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [232] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [243] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [254] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [265] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [276] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [287] FALSE FALSE
```




## Rectifying Missing Values

```r
missingValues<-nrow(movement)-nrow(na.omit(movement))
```

The total number of missing values is 2304.   To rectify missing values, I substitute mean value for the 5-minute interval using the plyr package.  Summary statistics are again calculated, which show that analysis has not changed with imputing missing values.  This is as expected, since missing values were derived from the original data and cannot add anything significant on their own.    



```r
library(plyr)
impute.mean<-function(x) replace(x, is.na(x), mean(x, na.rm = TRUE))
movement2<-ddply(movement, ~ interval, transform, steps = impute.mean(steps))

library(data.table)
steps2<-data.table(movement2)       # Data table to remove NAs
setkey(steps, date)                        # Set sorting key to date
dateSums2<-steps[,sum(steps), by=date]      # Sum steps by date
mean(dateSums2$V1)                  # Confirms mean has not changed
```

```
## [1] 10766
```

```r
hist(dateSums2$V1, main = "Total Steps Per Day (NAs Replaced)", xlab="Total Steps Per Day")
abline(v=mean(dateSums$V1),col=2,lty=3, cex = 10)
legend("topright", pch = 16, col = "red", legend = "Mean")
```

![plot of chunk imputeNAs](./RepData_PeerAssessment1_files/figure-html/imputeNAs.png) 

```r
# Mean and median total number of steps per day.
mean2 <- mean(dateSums2$V1)
median2 <- median(sort(dateSums2$V1))
mean(dateSums2$V1)
```

```
## [1] 10766
```

```r
median(sort(dateSums2$V1)) 
```

```
## [1] 10765
```

The mean total number of steps is 1.0766 &times; 10<sup>4</sup> and the median number of steps is 10765.






## Infering differences between weekday and weekend activity level.  

To determine whether anything can be learned by comparing weekday and weekend average activitiy levels, data is first separated by weekday/weekend.  Interval averages are again taken and plotted as a time series.  


```r
move2Date<-as.character(weekdays(as.Date(movement2$date)))    # Converts date column to day names
move2Date[move2Date == "Monday"] = 0                          # Convert day names to dummy variables
move2Date[move2Date == "Tuesday"] = 0
move2Date[move2Date == "Wednesday"] = 0
move2Date[move2Date == "Thursday"] = 0
move2Date[move2Date == "Friday"] = 0
move2Date[move2Date == "Saturday"] = 1
move2Date[move2Date == "Sunday"] = 1
as.integer(move2Date)

move2Week<-data.table(cbind(movement2$steps, movement2$date, movement2$interval, move2Date)) 
move2Days<-subset(move2Week, move2Date==0)      # Split data into two sets
move2Ends<-subset(move2Week, move2Date==1)
setkey(move2Days, V3)
setkey(move2Ends, V3)

intervalDays<-move2Days[,mean(V1), by=V3]     # Mean steps by interval (Day Set)
intervalEnds<-move2Ends[,mean(V1), by=V3]     # Mean steps by interval (End Set)
```


```r
par(mfrow=c(2,1))
plot.ts(intervalDays$V1, main = "Mean Steps Per Interval (Weekdays)", xlab = "Interval",
        ylab = "Mean Steps")
plot.ts(intervalEnds$V1, main = "Mean Steps Per Interval (Weekends)", xlab = "Interval",
        ylab = "Mean Steps")
```

![plot of chunk dayEndPlot](./RepData_PeerAssessment1_files/figure-html/dayEndPlot.png) 



## Just for fun, let's overlay the plots to better see the difference.

```r
par(mfrow=c(1,1))
plot.ts(intervalDays$V1, main = "Time Series Plot of Mean Steps Per Interval", 
        xlab = "Interval",ylab = "Mean Steps", col = "red")
lines(intervalEnds$V1, col = "blue")
legend("topright", pch = 16, col = c("red", "blue"), 
       legend = c("Weekdays", "Weekends")) 
```

![plot of chunk dayEndCompare](./RepData_PeerAssessment1_files/figure-html/dayEndCompare.png) 
