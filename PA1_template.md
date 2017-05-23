# activity monitor
C.J. van Eijden  
2/22/2017  



## Activity Monitor: introduction and preparations
It is now possible to collect a large amount of data about personal movement using activity monitoring devices such as a Fitbit, Nike Fuelband, or Jawbone Up. These type of devices are part of the “quantified self” movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. But these data remain under-utilized both because the raw data are hard to obtain and there is a lack of statistical methods and software for processing and interpreting the data.

In this assignment of the course **Reproducible Research** (peer graded assingment Cours Project 1) we make use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

### Preparations before executing this R Markdown document with Knit
Download [Activity Monitor dataset](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip) and unzip the file. Change the working directory of of your IDE (e.g. RStudio) to the directory where the dataset resides.

### Loading libraries, loading data and preprocessing data


```r
library(dplyr)
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
library(ggplot2)

a <- read.csv("activity.csv", sep=",", header=TRUE)
```

See what data we have!


```r
head(a, 20)
```

```
##    steps       date interval
## 1     NA 2012-10-01        0
## 2     NA 2012-10-01        5
## 3     NA 2012-10-01       10
## 4     NA 2012-10-01       15
## 5     NA 2012-10-01       20
## 6     NA 2012-10-01       25
## 7     NA 2012-10-01       30
## 8     NA 2012-10-01       35
## 9     NA 2012-10-01       40
## 10    NA 2012-10-01       45
## 11    NA 2012-10-01       50
## 12    NA 2012-10-01       55
## 13    NA 2012-10-01      100
## 14    NA 2012-10-01      105
## 15    NA 2012-10-01      110
## 16    NA 2012-10-01      115
## 17    NA 2012-10-01      120
## 18    NA 2012-10-01      125
## 19    NA 2012-10-01      130
## 20    NA 2012-10-01      135
```

```r
summary(a)
```

```
##      steps                date          interval     
##  Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
##  1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
##  Median :  0.00   2012-10-03:  288   Median :1177.5  
##  Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
##  3rd Qu.: 12.00   2012-10-05:  288   3rd Qu.:1766.2  
##  Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
##  NA's   :2304     (Other)   :15840
```

We see:

- The variable _interval_ needs some inspection: how are the values of _interval_ coded?
- _Date_ is of class **character**. _Date_ will be converted to **POSIXct**.
- There are a lot of missing values (NA's) in variable _steps_. Is there a pattern?

To start with the first question. In the listing of `head(a, 20)` we see increments of 5 but at 55 there is a jump to 100. The last to digits are minutes and, if there are more digits, those in front stand for hours. We convert the value to minutes.


```r
a <- mutate(a, interval = (floor(a$interval/100)*60) + (a$interval%%100))

a <- mutate(a, date = as.POSIXct(date))
summary(a)
```

```
##      steps             date                        interval     
##  Min.   :  0.00   Min.   :2012-10-01 00:00:00   Min.   :   0.0  
##  1st Qu.:  0.00   1st Qu.:2012-10-16 00:00:00   1st Qu.: 358.8  
##  Median :  0.00   Median :2012-10-31 00:00:00   Median : 717.5  
##  Mean   : 37.38   Mean   :2012-10-30 23:32:27   Mean   : 717.5  
##  3rd Qu.: 12.00   3rd Qu.:2012-11-15 00:00:00   3rd Qu.:1076.2  
##  Max.   :806.00   Max.   :2012-11-30 00:00:00   Max.   :1435.0  
##  NA's   :2304
```

Now we investigate the missing values in _steps_. We want to see on which days they occur.


```r
missing_values <- filter(a, is.na(a$steps))
missing_values <- mutate(missing_values, steps_na = 1) #now we can count missing values
summary_missing_values <- summarize(group_by(missing_values, date), sum(steps_na))
summary_missing_values <- mutate(summary_missing_values, weekday = weekdays(date))
head(summary_missing_values, 10)
```

```
## # A tibble: 8 × 3
##         date `sum(steps_na)`   weekday
##       <dttm>           <dbl>     <chr>
## 1 2012-10-01             288    Monday
## 2 2012-10-08             288    Monday
## 3 2012-11-01             288  Thursday
## 4 2012-11-04             288    Sunday
## 5 2012-11-09             288    Friday
## 6 2012-11-10             288  Saturday
## 7 2012-11-14             288 Wednesday
## 8 2012-11-30             288    Friday
```

We see that on eight days there were no recordings at all. All other days have no missing value at all. The non-recording days are fairly spread over the week: not one or two specific days, not all workdays or during the weekend. For the time being we can savely ignore (meaning na.rm=TRUE) the rows with NA's. As we are instructed to do! The days with only NA's wille show up as days with no activity at all.


```r
activity <- a
```


## What is mean total number of steps taken per day?

We calculate the total number of steps for each day. Those totals will be averaged across the whole period and also the mean will be calculated.
Next we draw a histogram with bins of 500 steps.


```r
day_total <- summarize(group_by(activity, date), steps= sum(steps, na.rm= TRUE))

period_mean  = mean(day_total$steps, na.rm=TRUE)
period_median = median(day_total$steps, na.rm=TRUE)
print(paste("Average steps a day over the two months period is", as.character(round(period_mean)), "and the median is", as.character(round(period_median))))
```

```
## [1] "Average steps a day over the two months period is 9354 and the median is 10395"
```


```r
qplot(x= day_total$steps, main= "Mean total number of steps taken per day", geom="blank") +
    geom_histogram(breaks= seq(0, 24000, 500), color="black", fill="white") +
    scale_x_continuous(name = "Number of steps taken per day", breaks = seq(0, 25000, 5000), limits=c(0, 25000)) +
    scale_y_continuous(name="Number of days", breaks=seq(0, 12, 2), limits=c(0,12)) +
    geom_vline(mapping=aes(xintercept=c(period_mean, period_median), linetype=factor(c("mean", "median"))), show.legend=TRUE) +
    scale_linetype_manual(values=c(2,3)) +
    labs(linetype="Legend")
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

The person wearing this device walked approximately 7 kilometers a day during the recording period. The average stepsize is of a human is 0.7 meter. The 8 days with no recordings show up at the left as days with no activity. But there are still two days with very little activity. Illness? 

## What is the average daily activity pattern?

Across all intervalls we calculate the mean number of steps. Also the mean and median across the whole period is determined. A times series plot will show the average daily activity pattern


```r
activity_mean <- summarize(group_by(activity, interval), steps= mean(steps, na.rm= TRUE))

day_mean <- mean(activity_mean$steps)
day_median <- median(activity_mean$steps)


qplot(x=activity_mean$interval/60, y=activity_mean$steps, geom="line", main = "Average daily activity pattern") +
    scale_x_continuous(name="5-minutes intervals (ticks are hours)", breaks=seq(0,24,2), limits=c(0,24)) +
    scale_y_continuous(name= "Average number of steps per interval", breaks = seq(0,250,50), limits=c(0,250)) +
    geom_hline(mapping=aes(yintercept=c(day_mean, day_median), linetype=factor(c("mean", "median"))), show.legend=TRUE) +
    scale_linetype_manual(values=c(2,3)) +
    labs(linetype="Legend")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

From the plot we can see that the maximum activity is around 8 o'clock in the morning. Showering, breakfast, the kids to scholl, etc. At lunch and dinner time we also see increased activity levels. We will compute the exact interval with the maximum number of steps computed across all days

```r
max_interval <- filter(activity_mean, steps == max(steps))

print(paste("The 5-minute interval with the maximum number of steps starts at", as.character(floor(max_interval$interval/60)), "h", as.character(max_interval$interval%%60), "min and has", as.character(round(max_interval$steps)), "steps")
)
```

```
## [1] "The 5-minute interval with the maximum number of steps starts at 8 h 35 min and has 206 steps"
```

## Imputing missing values
In the raw dataset there were quite a few rows with missing data. We have already seen that on eight days there were no values at all. All other days had complete recordings.

In stead of ignoring the NA's we are going to impute the NA's with reasonable estimates for those missing values. We choose to impute the missing data with the average of the corresponding interval. First, we calculate those impute values and then impute the estimates.

```r
impute_values <- summarize(group_by(activity, interval),  steps=mean(steps, na.rm=TRUE))
summary(impute_values)
```

```
##     interval          steps        
##  Min.   :   0.0   Min.   :  0.000  
##  1st Qu.: 358.8   1st Qu.:  2.486  
##  Median : 717.5   Median : 34.113  
##  Mean   : 717.5   Mean   : 37.383  
##  3rd Qu.:1076.2   3rd Qu.: 52.835  
##  Max.   :1435.0   Max.   :206.170
```

```r
n <- 0
for (i in 1:nrow(activity)) {
    if (is.na(activity$steps[i])) {
        for (j in 1:nrow(impute_values)) {
            if (impute_values$interval[j] == activity$interval[i]) {
                activity$steps[i] = impute_values$steps[j]
                n <- n+1
            }
        }
    }
}
print(paste("Number of imputations:", as.character(n)))
```

```
## [1] "Number of imputations: 2304"
```


```r
summary(activity)
```

```
##      steps             date                        interval     
##  Min.   :  0.00   Min.   :2012-10-01 00:00:00   Min.   :   0.0  
##  1st Qu.:  0.00   1st Qu.:2012-10-16 00:00:00   1st Qu.: 358.8  
##  Median :  0.00   Median :2012-10-31 00:00:00   Median : 717.5  
##  Mean   : 37.38   Mean   :2012-10-30 23:32:27   Mean   : 717.5  
##  3rd Qu.: 27.00   3rd Qu.:2012-11-15 00:00:00   3rd Qu.:1076.2  
##  Max.   :806.00   Max.   :2012-11-30 00:00:00   Max.   :1435.0
```

The NA's are gone.
Now we calculate the new mean and median and draw a new plot (histogram)


```r
day_total <- summarize(group_by(activity, date), steps= sum(steps, na.rm= TRUE))

period_mean = mean(day_total$steps)
period_median = median(day_total$steps)
print(paste("Average steps a day over the two months period is", as.character(round(period_mean)), "and the median is", as.character(round(period_median))))
```

```
## [1] "Average steps a day over the two months period is 10766 and the median is 10766"
```

As espected the mean has gone up, because the days with missing values where previously considered as days with zero steps for all intervals. All imputations have contributeted to a higher mean. The median has gone up less, because lots of intervals have stayed on the lower side of the mean after imputations. We can not explain why the mean and median have the same value. 


```r
qplot(x= day_total$steps, main= "Mean total number of steps per day", geom="blank") +
    geom_histogram(breaks= seq(0, 24000, 500), color="black", fill="white") +
    scale_x_continuous(name = "Number of steps taken per day",
                           breaks = seq(0, 24000, 4000),
                           limits=c(0, 24000)) +
    scale_y_continuous(name="Number of days", breaks=seq(0, 12, 2), limits=c(0,12)) +
    geom_vline(mapping=aes(xintercept=c(period_mean, period_median), linetype=factor(c("mean", "median"))), show.legend=TRUE) +
    scale_linetype_manual(values=c(2,3)) +
    labs(linetype="Legend")
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

## Are there differences in activity patterns between weekdays and weekends?

First we add two variables to dataset _activity_: _weekday_ (sun, mon, etc) and _daytype_ (weekday or weekend)

```r
activity <- mutate(activity, day_type = "weekday", weekday= weekdays(date))
for (i in 1:nrow(activity)) { 
    if (activity[i, "weekday"] == "Saturday") { activity[i, "day_type"] = "weekend"}
    if (activity[i, "weekday"] == "Sunday") { activity[i, "day_type"] = "weekend"}
}
```



```r
activity_pattern <- group_by(activity, interval, day_type) %>% summarize(steps= mean(steps, na.rm=TRUE))
summary(activity_pattern)
```

```
##     interval        day_type             steps        
##  Min.   :   0.0   Length:576         Min.   :  0.000  
##  1st Qu.: 358.8   Class :character   1st Qu.:  2.047  
##  Median : 717.5   Mode  :character   Median : 28.133  
##  Mean   : 717.5                      Mean   : 38.988  
##  3rd Qu.:1076.2                      3rd Qu.: 61.263  
##  Max.   :1435.0                      Max.   :230.378
```

 


```r
activity_pattern <- mutate(activity_pattern, day_type = factor(day_type))
summary(activity_pattern)
```

```
##     interval         day_type       steps        
##  Min.   :   0.0   weekday:288   Min.   :  0.000  
##  1st Qu.: 358.8   weekend:288   1st Qu.:  2.047  
##  Median : 717.5                 Median : 28.133  
##  Mean   : 717.5                 Mean   : 38.988  
##  3rd Qu.:1076.2                 3rd Qu.: 61.263  
##  Max.   :1435.0                 Max.   :230.378
```

```r
ggplot(data= activity_pattern, aes(x=interval/60, y = steps), main = "Average daily activity pattern") +
          geom_line() +
   scale_x_continuous(name="5-minutes interval (ticks are hours)", breaks=seq(0, 24, 4), limits=c(0, 24)) +
    scale_y_continuous(name= "Average number of steps per interval", breaks = seq(0,240,50), limits=c(0,240)) +
    facet_grid(. ~ day_type)
```

![](PA1_template_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

The panel plot shows clearly different activity patterns for normal weekdays and weekends. In the weeken the person wakes up a little later and has more activities in the aftenoon.


```r
max_interval <- summarize(group_by(activity_pattern, day_type), steps = max(steps))

max_steps_weekend <- max_interval$steps[max_interval$day_type == "weekend"]
max_interval_weekend <- activity_pattern$interval[activity_pattern$steps == max_steps_weekend]
print(paste("Maximum weekend day activity of", format(max_steps_weekend, digits=0), "steps",
            "at", format(floor(max_interval_weekend/60), digits=0), "hours", format(max_interval_weekend%%60), "min"))
```

```
## [1] "Maximum weekend day activity of 167 steps at 9 hours 15 min"
```

```r
max_steps_weekday <- max_interval$steps[max_interval$day_type == "weekday"]
max_interval_weekday <- activity_pattern$interval[activity_pattern$steps == max_steps_weekday]
print(paste("Maximum weekday activity of", format(max_steps_weekday, digits=0), "steps",
            "at", format(floor(max_interval_weekday/60), digits=0), "hours", format(max_interval_weekday%%60), "min"))
```

```
## [1] "Maximum weekday activity of 230 steps at 8 hours 35 min"
```
