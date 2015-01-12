# Reproducible Research: Peer Assessment 1

## Loading and preprocessing the data

```r
if(!file.exists("activity.csv")){
    unzip("activity.zip") 
}

stepsTakenActivity <- read.csv("activity.csv", header=TRUE)

# Let's look at the dimensions at our data frame
dim(stepsTakenActivity)
```

```
## [1] 17568     3
```

```r
# Take steps variable  as a dependant variable while date is an independane variable
stepsPerDay <- aggregate(steps ~ date, stepsTakenActivity, sum)

# Translate date variable from a  string type to a date type of a given format
# stepsTakenActivity <- as.Date(stepsTakenActivity$date, format = '%Y-%m-%d')

# Process our Data Frame by finding the total rows 
TotalRows <- nrow(stepsTakenActivity)
omitNA    <-  na.omit(stepsTakenActivity)
```

## What is mean total number of steps taken per day?
We first draw the histogram of the total number of steps taken each day and then,
calculate and report

*  The Mean
*  The Median

of the total of steps taken per day.


```r
hist(stepsPerDay$steps, main = "Total Steps Per Day", col="green", xlab="Number of Steps")
```

![](./PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

####  Mean for the Total number of steps taken per day:

```r
mean(stepsPerDay$steps)
```

```
## [1] 10766.19
```

####  Median for the Total number of steps taken per day:

```r
median(stepsPerDay$steps)
```

```
## [1] 10765
```

## What is the average daily activity pattern?
Draw a time series plot of the 5-minute interval and the average number of steps taken, averaged across all days


```r
averageInterval <- aggregate(steps ~ interval, stepsTakenActivity, mean, na.rm=TRUE)

# 1.  time series plot (i.e. type = "l")
plot(averageInterval, type = "l", xlab="Intervals", ylab="Average Steps Taken", main="Average Daily Acitivity Pattern")
```

![](./PA1_template_files/figure-html/unnamed-chunk-5-1.png) 

#### The maximum 5-minute interval on average across all the days in the dataset that contains the maximum number of steps


```r
# 2. The Maximum 5-minute ininterval
averageInterval$interval[which.max(averageInterval$step)]
```

```
## [1] 835
```

## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?


#### http://www.cookbook-r.com/Manipulating_data/Summarizing_data/
#### http://www.r-tutor.com/r-introduction/data-frame/data-frame-row-slice
##### http://rstudio-pubs-static.s3.amazonaws.com/19894_7194e7e62e4b4ad09856d0f1c25b0952.html
##### https://rpubs.com/mgmarques/RR_PA1
