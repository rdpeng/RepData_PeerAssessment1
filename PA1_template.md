---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---





## Loading and Preprocessing the data
### Read the .csv File


```r
if(!file.exists('activity.csv'))
{
  unzip('activity.zip')
}

actvData <- read.csv('activity.csv')
head(actvData)
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

## What is Mean of Total Number of steps taken per day ?

```r
step_per_Day <- tapply(actvData$steps, actvData$date, sum, na.rm=TRUE)
```

## 1. Make a histogram of the total number of steps taken each day

```r
hist(step_per_Day,xlab="Total Steps Per Day", main ="Histogram of Total Steps by day", col="darkmagenta",breaks=20,)
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

##### 2. Calculate and Report the Mean and Median of Total number of Steps taken per day

```r
steps_per_Day_Mean <- mean(step_per_Day)
steps_per_Day_Median <- median(step_per_Day)
```
###### Results :- 
* Mean: 9354.2295082
* Median:  10395

## 3.What is the Average Daily Activity Pattern?

```r
avg<-aggregate(x=list(MEAN_STEPS=actvData$steps),by=list(interval=actvData$interval),FUN=mean,na.rm=TRUE)
```

##### 4. Make a time series plot

```r
ggplot(data=avg, aes(x=interval, y=MEAN_STEPS)) +
    geom_line() +
    xlab("5-minute interval") +
    ylab("average number of steps taken") 
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

##### 5. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
max_steps<- which.max(avg$MEAN_STEPS)
Most_Steps<-gsub("([0-9]{1,2})([0-9]{2})" ,"\\1:\\2", avg[max_steps,'interval'])
```
* Most Steps at: 8:35

#---------------------------------------------------------------------------------------------

## Imputing missing values
##### 1. Calculate and report the total number of missing values in the dataset 

```r
num_mis_val<- length(which(is.na(actvData$steps)))
```

* Number of missing values: 2304

##### 2. Devise a strategy for filling in all of the missing values in the dataset.
##### 3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
library(magrittr)
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:Hmisc':
## 
##     src, summarize
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
replacewithmean <- function(x) replace(x, is.na(x), mean(x, na.rm = TRUE))
updated_data <- actvData%>% group_by(interval) %>% mutate(steps= replacewithmean(steps))
head(updated_data)
```

```
## # A tibble: 6 x 3
## # Groups:   interval [6]
##    steps date       interval
##    <dbl> <fct>         <int>
## 1 1.72   2012-10-01        0
## 2 0.340  2012-10-01        5
## 3 0.132  2012-10-01       10
## 4 0.151  2012-10-01       15
## 5 0.0755 2012-10-01       20
## 6 2.09   2012-10-01       25
```



##### 4. Make a histogram of the total number of steps taken each day 

```r
steps_PerDay_Imputed <- tapply(updated_data$steps, updated_data$date, sum)
qplot(steps_PerDay_Imputed, xlab='Total steps per day (Imputed)', ylab='Frequency using binwith 500', binwidth=500)
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

#### 5. Calculate and report the mean and median total number of steps taken per day. 

```r
steps_PerDay_MeanImputed <- mean(steps_PerDay_Imputed)
steps_PerDay_MedianImputed <- median(steps_PerDay_Imputed)
```
* Mean (Imputed): 1.0766189\times 10^{4}
* Median (Imputed):  1.0766189\times 10^{4}


#-------------------------------------------------------------------------------------------------------

# Are there differences in activity patterns between weekdays and weekends?

##### 1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.


```r
updated_data$dateType <- ifelse(as.POSIXlt(updated_data$date)$wday %in% c(0,6), 'weekend', 'weekday')
```

##### 2. Make a panel plot containing a time series plot


```r
avg_actvdata_Imputed <- aggregate(steps ~ interval + dateType, data=updated_data, mean)
ggplot(avg_actvdata_Imputed, aes(interval, steps)) + 
    geom_line() + 
    facet_grid(dateType ~ .) +
    xlab("5-minute interval") + 
    ylab("avarage number of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

