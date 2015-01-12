# Reproducible Research: Peer Assessment 1

## Loading and preprocessing the data

```r
if(!file.exists("activity.csv")){
    unzip("activity.zip") 
}
stepsTakenActivity <- read.csv("activity.csv", header=TRUE)

# Let's take a Peek at our data frame.
head(stepsTakenActivity)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```

```r
# Let's look at the dimensions at our data frame
dim(stepsTakenActivity)
```

```
## [1] 17568     3
```

```r
str(stepsTakenActivity)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

```r
# Variable names
names(stepsTakenActivity)
```

```
## [1] "steps"    "date"     "interval"
```

```r
# Translate date variable from a  string type to a date type of a given format
#stepsTakenActivity <- as.Date(stepsTakenActivity$date, format = '%Y-%m-%d')

# Process our Data Frame by finding the total/complete rows 
totalRows <- nrow(stepsTakenActivity)
totalCompleteRows    <-  nrow(na.omit(stepsTakenActivity))

totalRows
```

```
## [1] 17568
```

```r
totalCompleteRows
```

```
## [1] 15264
```

## What is mean total number of steps taken per day?
We first draw the histogram of the total number of steps taken each day and then,
calculate and report

*  The Mean
*  The Median

of the total of steps taken per day.


```r
# Take steps variable  as a dependant variable while date is an independane variable
stepsPerDay <- aggregate(steps ~ date, stepsTakenActivity, sum)

hist(stepsPerDay$steps, main = "Total Steps Per Day", col="green", xlab="Number of Steps")
```

![](./PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

Mean for the Total number of steps taken per day:

```r
mean(stepsPerDay$steps)
```

```
## [1] 10766.19
```

Median for the Total number of steps taken per day:

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

The maximum 5-minute interval on average across all the days in the dataset that contains the maximum number of steps


```r
# 2. The Maximum 5-minute ininterval
averageInterval$interval[which.max(averageInterval$step)]
```

```
## [1] 835
```

## Imputing missing values

#### 1.  Total number of missing values:

By using the variables calculated above **totalRows** and **totalCompleteRows** we 
can get the rows that are missing values by subtracting *totalCompleteRows* from *totalRows*.
(*totalRows* - *totalCompleteRows*) 

* Total rows:  17568  
* Complete rows:  15264 
* Total Number of missing values: 2304

###### Alternatively using R in-built is.na functionality.


```r
activityNA <- sum(is.na(stepsTakenActivity))
activityNA
```

```
## [1] 2304
```




## Are there differences in activity patterns between weekdays and weekends?


#### http://www.cookbook-r.com/Manipulating_data/Summarizing_data/
#### http://www.r-tutor.com/r-introduction/data-frame/data-frame-row-slice
##### http://rstudio-pubs-static.s3.amazonaws.com/19894_7194e7e62e4b4ad09856d0f1c25b0952.html
##### https://rpubs.com/mgmarques/RR_PA1
##### Meta Data: http://rmarkdown.rstudio.com/
####             http://rmarkdown.rstudio.com/html_document_format.html
