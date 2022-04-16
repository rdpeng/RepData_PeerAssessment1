---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---


### Loading and preprocessing the data

```r
# unzip("activity.zip", exdir = "./Data/")
dataset <- read.csv('./Data/activity.csv', header = TRUE)
# Let us have a look at the data dimensions, variables 
names(dataset)
```

```
## [1] "steps"    "date"     "interval"
```
### Process/transform the data (if necessary) into a format suitable for your analysis

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
### Calculate the total number of steps taken per day

```r
# New aggregate dataframe 
walks_complete_sum <- aggregate(dataset["steps"], by=dataset["date"], FUN=sum)
```
### Make a histogram of the total number of steps taken each day

```r
library("ggplot2")
h <- ggplot(walks_complete_sum, aes(x=steps))
h + geom_histogram(binwidth = 1700, fill="white", colour="black", orgin=35)
```

```
## Warning: Ignoring unknown parameters: orgin
```

```
## Warning: Removed 8 rows containing non-finite values (stat_bin).
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->
### Calculate and report the mean and median of the total number of steps taken per day

```r
# Average, median
mean(walks_complete_sum$steps, na.rm=T)
```

```
## [1] 10766.19
```

```r
median(walks_complete_sum$steps, na.rm=T)
```

```
## [1] 10765
```
### What is the average daily activity pattern?

```r
ave_step <-ave(dataset$steps, dataset$interval, FUN = function(x) mean(x, na.rm=TRUE))

plot(dataset$interval[1:288], ave_step[1:288], type='l',col='darkred',
     xlab='Intervals',lwd=1,
     ylab='AVG # of steps',
     main ='AVG # of steps taken in 5-min interval, averaged across all days')
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

## Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
library(lubridate)
```

```
## 
## Attaching package: 'lubridate'
```

```
## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union
```

```r
# Convert Interval format
temp <- dataset$interval
temp2 <- mapply(function(x, y) paste0(rep(x, y), collapse = ""), 0, 4 - nchar(temp))
temp <- paste0(temp2, temp)
dataset$time_interval <- temp

# Convert to time
dataset$time_interval <- format(strptime(dataset$time_interval, format="%H%M"), format = "%H:%M:%S")

fmin <- aggregate(data=dataset, steps ~ time_interval, mean, na.rm=TRUE)
maxt <- fmin$time_interval[which.max(fmin$steps)]

cat('The maximum number of steps occurs at',maxt,'AM')
```

```
## The maximum number of steps occurs at 08:35:00 AM
```
### Imputing missing values
Note that there are a number of days/intervals where there are missing values (coded as \color{red}{\verb|NA|}NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

#### Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with \color{red}{\verb|NA|}NAs)

```r
summary(dataset)
```

```
##      steps            date              interval           hour      
##  Min.   :  0.00   Length:17568       Min.   :   0.0   Min.   : 0.00  
##  1st Qu.:  0.00   Class :character   1st Qu.: 588.8   1st Qu.: 5.75  
##  Median :  0.00   Mode  :character   Median :1177.5   Median :11.50  
##  Mean   : 37.38                      Mean   :1177.5   Mean   :11.50  
##  3rd Qu.: 12.00                      3rd Qu.:1766.2   3rd Qu.:17.25  
##  Max.   :806.00                      Max.   :2355.0   Max.   :23.00  
##  NA's   :2304                                                        
##      minute      time_interval     
##  Min.   : 0.00   Length:17568      
##  1st Qu.:13.75   Class :character  
##  Median :27.50   Mode  :character  
##  Mean   :27.50                     
##  3rd Qu.:41.25                     
##  Max.   :55.00                     
## 
```

```r
sapply(dataset, function(df) {
  sum(is.na(df)==TRUE) / length(df)
})
```

```
##         steps          date      interval          hour        minute 
##     0.1311475     0.0000000     0.0000000     0.0000000     0.0000000 
## time_interval 
##     0.0000000
```

13.1% (2304) is missing.

#### Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

#### Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
# New Dataframe 
agg_df <- cbind.data.frame(dataset$steps, dataset$date, dataset$interval)
colnames(agg_df) <- c("steps", "date", "interval") 

agg_df$steps <- ifelse(is.na(agg_df$steps), ave_step, agg_df$steps)
agg_df$steps <- as.integer(agg_df$steps)
summary(agg_df$steps)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    0.00    0.00    0.00   37.33   27.00  806.00
```
#### Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
agg_df_sum <- aggregate(agg_df["steps"], by=agg_df["date"], FUN=sum, na.rm=T)

h <- ggplot(agg_df_sum, aes(x=steps))
h + geom_histogram(binwidth = 1700, fill="white", colour="black", orgin=35)
```

```
## Warning: Ignoring unknown parameters: orgin
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

```r
# Average, median
mean(agg_df_sum$steps, na.rm=T)
```

```
## [1] 10749.77
```

```r
median(agg_df_sum$steps, na.rm=T)
```

```
## [1] 10641
```
### Are there differences in activity patterns between weekdays and weekends?

```r
#library('weekdays')
agg_df$date <- as.Date(agg_df$date)
agg_df$weekday <- weekdays(agg_df$date)

agg_df %>%
  mutate(wday = wday(date, label = TRUE)) %>%
  ggplot(aes(x = wday)) + geom_bar()
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->


### Create a new factor variable in the dataset with two levels - “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

```r
agg_df$week_split <- ifelse(weekdays(agg_df$date) %in% c("Saturday", "Sunday"), "Weekend", "Weekday")
agg_df$week_split <- as.factor(agg_df$week_split )
head(agg_df)
```

```
##   steps       date interval weekday week_split
## 1     1 2012-10-01        0  Monday    Weekday
## 2     0 2012-10-01        5  Monday    Weekday
## 3     0 2012-10-01       10  Monday    Weekday
## 4     0 2012-10-01       15  Monday    Weekday
## 5     0 2012-10-01       20  Monday    Weekday
## 6     2 2012-10-01       25  Monday    Weekday
```
### Make a panel plot containing a time series plot (i.e. type = “l”) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis)

```r
ggplot(agg_df, aes(x=interval, y=steps, group=week_split)) +
  geom_line() +
  ggtitle("Week Split") +
  xlab("Intervals") + 
  ylab("Steps") +
  facet_wrap(~ week_split)
```

![](PA1_template_files/figure-html/unnamed-chunk-12-1.png)<!-- -->
