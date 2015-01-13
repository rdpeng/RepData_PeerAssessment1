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

#### 2.  Filling in all of the missing values in the dataset
Devising a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, we could use the mean/median whichever we think that might work or meet our needs better.

From our results above the median and the mean do not differ or deviate a lot, therefore for the purposes of this report we shall use the mean(**mean imputation**). NA is replaced by mean in the corresponding 5 min interval

```r
fillNA <- numeric()

for (i in 1:nrow(stepsTakenActivity)) {
    obs <- stepsTakenActivity[i, ]
    
    if (is.na(obs$steps)) {
                steps <- subset(averageInterval, interval == obs$interval)$steps
    } 
    else {
                steps <- obs$steps
    }
        fillNA <- c(fillNA, steps)
}
```

#### 3. Creating a new dataset that is equal to the original dataset and with the missing data filled in.


```r
# equate newStepsActivity to our old  stepsTakenActivity data frame still with NA
newStepsActivity <- stepsTakenActivity

# Replace the Steps column with our newly contructed filled with the corresponding 5 interval mean 
newStepsActivity$steps <- fillNA

head(newStepsActivity)
```

```
##       steps       date interval
## 1 1.7169811 2012-10-01        0
## 2 0.3396226 2012-10-01        5
## 3 0.1320755 2012-10-01       10
## 4 0.1509434 2012-10-01       15
## 5 0.0754717 2012-10-01       20
## 6 2.0943396 2012-10-01       25
```

```r
nrow(newStepsActivity)
```

```
## [1] 17568
```

#### 4. Create histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day


```r
newStepsPerDay <- aggregate(steps ~ date, data = newStepsActivity, sum, na.rm = TRUE)

hist(newStepsPerDay$steps, main = "Total steps by day", xlab = "day", col = "red")
```

![](./PA1_template_files/figure-html/unnamed-chunk-10-1.png) 

And the mean and median is:


```r
mean(newStepsPerDay$steps)
```

```
## [1] 10766.19
```


```r
median(newStepsPerDay$steps)
```

```
## [1] 10766.19
```

These values do not differ significantly from the values from the first part of the assignment. This in fact tells us that imputing missing data on the estimates of the daily number of steps does not statistically skew our data

## Are there differences in activity patterns between weekdays and weekends?

```r
library(lattice)

# Translate date variable from a  string type to a date type of a given format
newStepsActivity$date<-as.Date(newStepsActivity$date, format = '%Y-%m-%d')
newStepsActivity$dateType <- ifelse(weekdays(newStepsActivity$date) %in% c("Saturday", "Sunday"),'weekend','weekday')

head(newStepsActivity)
```

```
##       steps       date interval dateType
## 1 1.7169811 2012-10-01        0  weekday
## 2 0.3396226 2012-10-01        5  weekday
## 3 0.1320755 2012-10-01       10  weekday
## 4 0.1509434 2012-10-01       15  weekday
## 5 0.0754717 2012-10-01       20  weekday
## 6 2.0943396 2012-10-01       25  weekday
```

```r
stepsByDay <- aggregate(steps ~ interval + dateType, data = newStepsActivity, mean)

xyplot(steps ~ interval | dateType, stepsByDay, type = "l",layout = c(1, 2), xlab = "Interval", ylab = "Number of steps", main = "Weekend Vs Weekday Activity")
```

![](./PA1_template_files/figure-html/unnamed-chunk-13-1.png) 

From the plots above, We can conclude that the weekdays had the greatest peak between the 500 and 1000 intervals from all the steps intervals. But, genrally the weekends activities had more peaks over a hundred than weekday.
In conclusion there is a more evenly or better steps activity distribution of effort along the time over the weekend than over the weekdays.
