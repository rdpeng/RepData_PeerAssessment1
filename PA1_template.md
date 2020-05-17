# Reproducible Research:  Assessment 1

## Loading and preprocessing the data  

```r
url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
zipFile <- "Nike.zip"
if (!file.exists(zipFile)) {download.file(url, zipFile, mode = "wb")}
dataPath <- "Nike"
if (!file.exists(dataPath)) {unzip(zipFile)}
a <- read.csv("activity.csv",header=TRUE)
```

## What is mean total number of steps taken per day?  

```r
total_steps <- tapply(a$steps, a$date, FUN=sum, na.rm=TRUE)
hist(total_steps, breaks=20, xlab = "Total daily Steps",main="Histogram of Total Steps by day")
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)

```r
mean(total_steps, na.rm=TRUE)
```

```
## [1] 9354.23
```

```r
median(total_steps, na.rm=TRUE)
```

```
## [1] 10395
```


## What is the average daily activity pattern?  

```r
library(ggplot2)
averages <- aggregate(x=list(steps=a$steps), by=list(interval=a$interval),
                      FUN=mean, na.rm=TRUE)
plot(averages,type="l",col="red",main="Steps over interval",xlab="Interval",ylab="Steps")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)
  
On average across all the days in the dataset, the 5-minute interval contains
the maximum number of steps?  

```r
averages[which(averages$steps== max(averages$steps)),]
```

```
##     interval    steps
## 104      835 206.1698
```


## Imputing missing values    

There are many days/intervals where there are missing values (coded as `NA`). The presence of missing days may introduce bias into some calculations or summaries of the data.  


```r
sum(is.na(a))
```

```
## [1] 2304
```
All of the missing values are filled in with mean value for that 5-minute
interval.  

```r
replacemean <- function(x) replace(x, is.na(x), mean(x, na.rm = TRUE))
data_new <- a
data_new$steps <- replacemean(data_new$steps)
stepsByDayImputed <- tapply(data_new$steps, data_new$date, sum)
```

Now, using the filled data set, let's make a histogram of the total number of steps taken each day and calculate the mean and median total number of steps.  


```r
hist(stepsByDayImputed, xlab='Total steps per day (Imputed)', ylab='Frequency using binwith 500', breaks=20)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png)

```r
mean(stepsByDayImputed)
```

```
## [1] 10766.19
```

```r
median(stepsByDayImputed)
```

```
## [1] 10766.19
```
Mean and median values are higher after imputing missing data. The reason is
that in the original data, there are some days with `steps` values `NA` for 
any `interval`. The total number of steps taken in such days are set to 0s by
default. However, after replacing missing `steps` values with the mean `steps`
of associated `interval` value, these 0 values are removed from the histogram
of total number of steps taken each day.
  
  

## Are there differences in activity patterns between weekdays and weekends?  

First, let's find the day of the week for each measurement in the dataset. In
this part, we use the dataset with the filled-in values.  


```r
new_data_week <- a
week <- function (x){if(x=="Saturday" || x=="Sunday"){"weekend"}else{"weekday"}}
new_data_week$dateType <- ifelse(as.POSIXlt(new_data_week$date)$wday %in% c(0,6), 'weekend', 'weekday')
```

Now, let's make a panel plot containing plots of average number of steps taken
on weekdays and weekends.  


```r
grp <- aggregate(steps ~ interval + dateType, data=new_data_week, mean)
hist(grp$step,col="red",xlab="Total number of steps each day",ylab="count",main="Average Steps after imutation")
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png)




