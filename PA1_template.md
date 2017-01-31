# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data


```r
data <- read.csv("activity.csv")
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.3.2
```

```r
data$date <- as.Date(data$date)
dataclean <- na.omit(data)
```


```r
## What is mean total number of steps taken per day?

### 1. Make a histogram of the total number of steps taken each day

ggplot(dataclean,aes(date,steps)) + geom_bar(stat="identity",colours="blue",fill="blue")+labs(title="Total number of steps taken each day",x="Day",y="Number of Steps per day")
```

```
## Warning: Ignoring unknown parameters: colours
```

![](PA1_template_files/figure-html/histogram-1.png)<!-- -->

```r
### 2. Calculate and report the mean and median total number of steps taken each day

### mean:
dailysteps <- tapply(data$steps,data$date, sum, na.rm=TRUE)
mean1 <- mean(dailysteps)
mean1
```

```
## [1] 9354.23
```

```r
### median:
median1 <- median(dailysteps)
median1
```

```
## [1] 10395
```

## What is the average daily activity pattern?


```r
### 1. Make a time series plot of 5-minute interval and the avg number of steps taken, averaged across all days

averagedaily <- aggregate(dataclean$steps,list(interval=dataclean$interval),sum)

ggplot(averagedaily,aes(interval,x))+geom_line(colour="darkblue",size=1.0)+labs(title="Average Daily Activity Pattern",x="5 minute interval",y="Average number of steps per day")
```

![](PA1_template_files/figure-html/plots-1.png)<!-- -->

```r
### 2. Which 5 minute interval, on average across all the days in the dataset, contains the maximum number of steps

averagedaily[averagedaily$x==max(averagedaily$x),]$interval
```

[1] 835

## Imputing missing values


```r
### using the median for 5 minute interval and create a new dataset
mediandaily <- aggregate(dataclean$steps, list(interval=as.numeric(dataclean$interval)),FUN="median")

dataimpute <- data
for (i in 1:nrow(dataimpute)){
    if(is.na(dataimpute$steps[i])) {
        dataimpute$steps[i] <- mediandaily[which(dataimpute$interval[i]==mediandaily$interval),]$x
    }
}
### Plot the histogram

ggplot(dataimpute,aes(date,steps)) + geom_bar(stat="identity",colours="darkred",fill="darkred")+labs(title="Total number of steps taken each day, imputed",x="Day",y="Number of Steps per day")
```

```
## Warning: Ignoring unknown parameters: colours
```

![](PA1_template_files/figure-html/impute and plot-1.png)<!-- -->

```r
### Calculate the mean and median of newdataset
dailystepsno.na <- tapply(dataimpute$steps,dataimpute$date, sum)

mean2 <- mean(dailystepsno.na)
median2 <- median(dailystepsno.na)
mean1; mean2
```

```
## [1] 9354.23
```

```
## [1] 9503.869
```

```r
median1;median2
```

```
## [1] 10395
```

```
## [1] 10395
```

```r
### The mean of the new dataset is larger than the old dataset, while median is the same in both datasets
```

##Are there differences in activity patterns between weekdays and weekends?


```r
### Create factor variable
dataimpute$weekdays <- factor(format(dataimpute$date, "%A"))
levels(dataimpute$weekdays)
```

```
## [1] "Friday"    "Monday"    "Saturday"  "Sunday"    "Thursday"  "Tuesday"  
## [7] "Wednesday"
```

```r
levels(dataimpute$weekdays) <- list(weekday = c("Monday", "Tuesday",    "Wednesday", "Thursday", "Friday"),

weekend = c("Saturday", "Sunday"))

### Plot the graph

averageimputeday <- aggregate(steps~interval+weekdays,data=dataimpute,mean)

g<- ggplot(averageimputeday,aes(interval,steps))+geom_line(col="darkgrey")+facet_grid(weekdays~.) + labs(title="Number of Steps on Weekday and Weekend",x="Number of Steps per Interval",y= "5 minute Interval")

g
```

![](PA1_template_files/figure-html/weekday and weekend-1.png)<!-- -->
