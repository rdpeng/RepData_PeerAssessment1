#Reproducible Research : Peer Assignment 1
========================================================

##setting the current working directory 


```r
setwd("C:\\Users\\ravitejaj\\Desktop\\")
getwd()
```

```
## [1] "C:/Users/ravitejaj/Desktop"
```


1.Loading and preprocessing the data
##Loading the data using read.csv() function and converting it to a dataframe


```r
data = read.csv("activity.csv")
data = as.data.frame(data)
```



1.What is mean total number of steps taken per day?

2.Calculate and report the mean and median total number of steps taken per day

### For calculation of mean firstly sum should be calculated so aggregate function is used


```r
l <- aggregate(steps ~ date, data = data, FUN = sum)
plot(l$steps, xlab = "", ylab = "Total number of Steps", main = "Total No of Steps per day", 
    col = "Green")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

```r
mean(l$steps)
```

```
## [1] 10766
```

```r
median(l$steps)
```

```
## [1] 10765
```


##What is the average daily activity pattern?

1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

2.Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

### calculating the maximum mean value using max function


```r
y <- aggregate(steps ~ interval, data = data, FUN = mean)
plot(y$interval, y$steps, xlab = "Intervals", ylab = "Average Steps", type = "l")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 

```r
z = y[y$steps == max(y$steps), ]
z[1]  #it prints the interval is 835
```

```
##     interval
## 104      835
```


## Imputing missing values

## Calculating the no of NA's using the complete.cases


```r
nrow(data[!complete.cases(data), ])
```

```
## [1] 2304
```

```r

```


###Strategy:
###I will replace the NA values with 5 min interval means that is the dataset 'y'

##3. Create a new dataset that is equal to the original dataset but with the missing data filled in.



```r
data <- merge(data, y, by = "interval", suffixes = c("", ".y"))
nas <- is.na(data$steps)
data$steps[nas] <- data$steps.y[nas]
data <- data[, c(1:3)]
l1 <- aggregate(steps ~ date, data = data, FUN = sum)
plot(l1$steps, xlab = "", ylab = "Total number of Steps", main = "Total No of Steps per day", 
    col = "Green")
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 

```r
mean(l1$steps)
```

```
## [1] 10766
```

```r
median(l1$steps)
```

```
## [1] 10766
```


##There is slight difference in the things mean and median

## Are there differences in activity patterns between weekdays and weekends?

## Converting the dates to weektypes that is weekend r weekday



```r
weektype <- function(date) {
    if (weekdays(as.Date(date)) %in% c("Saturday", "Sunday")) {
        "weekend"
    } else {
        "weekday"
    }
}
data$day <- as.factor(sapply(data$date, weektype))
```



## Panel Plot


```r
par(mfrow = c(2, 1))
{
    for (type in c("weekend", "weekday")) {
        x <- aggregate(steps ~ interval, data = data, subset = data$day == type, 
            FUN = mean)
        plot(x, type = "l", main = type, col = "blue")
    }
}
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

