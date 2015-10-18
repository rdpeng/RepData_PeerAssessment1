# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data

Initially, missing entries will be removed using the complete.cases function


```r
data <- read.csv("activity.csv")

clean <- complete.cases(data)
cleandata <- data[clean,]
```

## What is mean total number of steps taken per day?

The total steps on a given day is produced in a data table as follows, using the clean data (NA removed):


```r
library(data.table)

cleandata.dt <- data.table(cleandata)
totalsteps <- cleandata.dt[,list(total.steps = sum(steps)), by='date']
```

A histogram of the data is shown below:


```r
hist(totalsteps$total.steps, breaks = 20)
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 

The mean and median total number of steps are therefore:


```r
mean(totalsteps$total.steps)
```

```
## [1] 10766.19
```

```r
median(totalsteps$total.steps)
```

```
## [1] 10765
```

## What is the average daily activity pattern?

The average steps with respect to time interval is computed as follows:


```r
avgsteps <- cleandata.dt[,list(avg.steps = mean(steps)), by='interval']
```

The average daily activity pattern is therefore plotted as follows:


```r
int <- avgsteps$interval
av.st <- avgsteps$avg.steps

plot(int,av.st, type = "l")
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png) 

Per the plot, the maximum daily activity occurs at the following interval:


```r
maxint <- avgsteps[which(avgsteps$avg.steps == max(avgsteps$avg.steps)),]
maxint
```

```
##    interval avg.steps
## 1:      835  206.1698
```

## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
