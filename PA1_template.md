# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data


```r
getwd()
```

```
## [1] "C:/Users/admin/Documents/GitHub/RepData_PeerAssessment1"
```

```r
setwd("C:\\Users\\admin\\Documents\\GitHub\\RepData_PeerAssessment1")


df1 <- read.csv("activity.csv")
str(df1)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

```r
head(df1)
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
tail(df1)
```

```
##       steps       date interval
## 17563    NA 2012-11-30     2330
## 17564    NA 2012-11-30     2335
## 17565    NA 2012-11-30     2340
## 17566    NA 2012-11-30     2345
## 17567    NA 2012-11-30     2350
## 17568    NA 2012-11-30     2355
```

```r
summary(df1)
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

## What is mean total number of steps taken per day?


```r
library("ggplot2")
library("dplyr")

df2 <- na.omit(df1)
totalStepsPerDay <- df2 %>% group_by(date) %>% summarize_each(funs(sum(steps))) %>% select(date,steps)

head(totalStepsPerDay)
```

```
## Source: local data frame [6 x 2]
## 
##         date steps
##       (fctr) (int)
## 1 2012-10-02   126
## 2 2012-10-03 11352
## 3 2012-10-04 12116
## 4 2012-10-05 13294
## 5 2012-10-06 15420
## 6 2012-10-07 11015
```

```r
tail(totalStepsPerDay)
```

```
## Source: local data frame [6 x 2]
## 
##         date steps
##       (fctr) (int)
## 1 2012-11-24 14478
## 2 2012-11-25 11834
## 3 2012-11-26 11162
## 4 2012-11-27 13646
## 5 2012-11-28 10183
## 6 2012-11-29  7047
```

```r
summary(totalStepsPerDay)
```

```
##          date        steps      
##  2012-10-02: 1   Min.   :   41  
##  2012-10-03: 1   1st Qu.: 8841  
##  2012-10-04: 1   Median :10765  
##  2012-10-05: 1   Mean   :10766  
##  2012-10-06: 1   3rd Qu.:13294  
##  2012-10-07: 1   Max.   :21194  
##  (Other)   :47
```

```r
hist(totalStepsPerDay$steps, main="Hist of total steps per day omitting NA", xlab="No of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

The mean total steps per day is 

```r
mean(totalStepsPerDay$steps)
```

```
## [1] 10766.19
```

The median total steps per day is 

```r
median(totalStepsPerDay$steps)
```

```
## [1] 10765
```



## What is the average daily activity pattern?


```r
totalStepsPerInterval <- df2 %>% group_by(interval) %>% summarize_each(funs(sum(steps))) %>% select(interval,steps)

totalStepsPerInterval <- na.omit(totalStepsPerInterval)
head(totalStepsPerInterval)
```

```
## Source: local data frame [6 x 2]
## 
##   interval steps
##      (int) (int)
## 1        0    91
## 2        5    18
## 3       10     7
## 4       15     8
## 5       20     4
## 6       25   111
```

```r
tail(totalStepsPerInterval)
```

```
## Source: local data frame [6 x 2]
## 
##   interval steps
##      (int) (int)
## 1     2330   138
## 2     2335   249
## 3     2340   175
## 4     2345    34
## 5     2350    12
## 6     2355    57
```

```r
summary(totalStepsPerInterval)
```

```
##     interval          steps        
##  Min.   :   0.0   Min.   :    0.0  
##  1st Qu.: 588.8   1st Qu.:  131.8  
##  Median :1177.5   Median : 1808.0  
##  Mean   :1177.5   Mean   : 1981.3  
##  3rd Qu.:1766.2   3rd Qu.: 2800.2  
##  Max.   :2355.0   Max.   :10927.0
```

```r
plot(totalStepsPerInterval,type="l",main="5 min time series", ylab="Average steps", xlab="5 min intervals")
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png) 

```r
df3 <- totalStepsPerInterval[which.max(totalStepsPerInterval$steps), ]
```

The max happens at the interval

```r
df3$interval
```

```
## [1] 835
```


## Imputing missing values

### Working on steps columns with missing values  

```r
sum(is.na(df1$steps))
```

```
## [1] 2304
```

```r
df1$steps[is.na(df1$steps)] = mean(df1$steps, na.rm=TRUE)
sum(is.na(df1$steps))
```

```
## [1] 0
```

### Working on interval columns with missing values  

```r
sum(is.na(df1$interval))
```

```
## [1] 0
```

```r
df1$interval[is.na(df1$interval)] = mean(df1$interval, na.rm=TRUE)
sum(is.na(df1$interval))
```

```
## [1] 0
```

```r
df4 <- df1
sum(is.na(df4))
```

```
## [1] 0
```

###Histogram and summary with new dataframe df4

```r
totalStepsPerDay <- df4 %>% group_by(date) %>% summarize_each(funs(sum(steps))) %>% select(date,steps)

head(totalStepsPerDay)
```

```
## Source: local data frame [6 x 2]
## 
##         date    steps
##       (fctr)    (dbl)
## 1 2012-10-01 10766.19
## 2 2012-10-02   126.00
## 3 2012-10-03 11352.00
## 4 2012-10-04 12116.00
## 5 2012-10-05 13294.00
## 6 2012-10-06 15420.00
```

```r
tail(totalStepsPerDay)
```

```
## Source: local data frame [6 x 2]
## 
##         date    steps
##       (fctr)    (dbl)
## 1 2012-11-25 11834.00
## 2 2012-11-26 11162.00
## 3 2012-11-27 13646.00
## 4 2012-11-28 10183.00
## 5 2012-11-29  7047.00
## 6 2012-11-30 10766.19
```

```r
summary(totalStepsPerDay)
```

```
##          date        steps      
##  2012-10-01: 1   Min.   :   41  
##  2012-10-02: 1   1st Qu.: 9819  
##  2012-10-03: 1   Median :10766  
##  2012-10-04: 1   Mean   :10766  
##  2012-10-05: 1   3rd Qu.:12811  
##  2012-10-06: 1   Max.   :21194  
##  (Other)   :55
```

```r
hist(totalStepsPerDay$steps, main="Hist of total steps per day AFTER impute", xlab="No of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-9-1.png) 

The mean total steps per day is 

```r
mean(totalStepsPerDay$steps)
```

```
## [1] 10766.19
```

The median total steps per day is 

```r
median(totalStepsPerDay$steps)
```

```
## [1] 10766.19
```

###After imputing the median has changed. It is now same as mean (10766.19).


## Are there differences in activity patterns between weekdays and weekends?

###Weekdays

```r
df4$date <- as.Date(df4$date)
df4 <- df4 %>% mutate(weekdayOrWeekend=weekdays(date))
head(df4)
```

```
##     steps       date interval weekdayOrWeekend
## 1 37.3826 2012-10-01        0           Monday
## 2 37.3826 2012-10-01        5           Monday
## 3 37.3826 2012-10-01       10           Monday
## 4 37.3826 2012-10-01       15           Monday
## 5 37.3826 2012-10-01       20           Monday
## 6 37.3826 2012-10-01       25           Monday
```

```r
tail(df4)
```

```
##         steps       date interval weekdayOrWeekend
## 17563 37.3826 2012-11-30     2330           Friday
## 17564 37.3826 2012-11-30     2335           Friday
## 17565 37.3826 2012-11-30     2340           Friday
## 17566 37.3826 2012-11-30     2345           Friday
## 17567 37.3826 2012-11-30     2350           Friday
## 17568 37.3826 2012-11-30     2355           Friday
```

```r
df5 <- df4 %>% filter(weekdayOrWeekend !="Saturday" & weekdayOrWeekend != "Sunday")

totalStepsPerIntervalWeekdays <- df5 %>% group_by(interval) %>% summarize_each(funs(sum(steps))) %>% select(interval,steps)


head(totalStepsPerIntervalWeekdays)
```

```
## Source: local data frame [6 x 2]
## 
##   interval    steps
##      (dbl)    (dbl)
## 1        0 315.2956
## 2        5 242.2956
## 3       10 231.2956
## 4       15 232.2956
## 5       20 228.2956
## 6       25 283.2956
```

```r
tail(totalStepsPerIntervalWeekdays)
```

```
## Source: local data frame [6 x 2]
## 
##   interval    steps
##      (dbl)    (dbl)
## 1     2330 345.2956
## 2     2335 297.2956
## 3     2340 305.2956
## 4     2345 232.2956
## 5     2350 236.2956
## 6     2355 281.2956
```

```r
summary(totalStepsPerIntervalWeekdays)
```

```
##     interval          steps       
##  Min.   :   0.0   Min.   : 224.3  
##  1st Qu.: 588.8   1st Qu.: 310.8  
##  Median :1177.5   Median :1159.3  
##  Mean   :1177.5   Mean   :1602.5  
##  3rd Qu.:1766.2   3rd Qu.:2247.3  
##  Max.   :2355.0   Max.   :9354.3
```

###Weekends

```r
df4$date <- as.Date(df4$date)
df4 <- df4 %>% mutate(weekdayOrWeekend=weekdays(date))
head(df4)
```

```
##     steps       date interval weekdayOrWeekend
## 1 37.3826 2012-10-01        0           Monday
## 2 37.3826 2012-10-01        5           Monday
## 3 37.3826 2012-10-01       10           Monday
## 4 37.3826 2012-10-01       15           Monday
## 5 37.3826 2012-10-01       20           Monday
## 6 37.3826 2012-10-01       25           Monday
```

```r
tail(df4)
```

```
##         steps       date interval weekdayOrWeekend
## 17563 37.3826 2012-11-30     2330           Friday
## 17564 37.3826 2012-11-30     2335           Friday
## 17565 37.3826 2012-11-30     2340           Friday
## 17566 37.3826 2012-11-30     2345           Friday
## 17567 37.3826 2012-11-30     2350           Friday
## 17568 37.3826 2012-11-30     2355           Friday
```

```r
df5 <- df4 %>% filter(weekdayOrWeekend =="Saturday" | weekdayOrWeekend == "Sunday")

totalStepsPerIntervalWeekends <- df5 %>% group_by(interval) %>% summarize_each(funs(sum(steps))) %>% select(interval,steps)


head(totalStepsPerIntervalWeekends)
```

```
## Source: local data frame [6 x 2]
## 
##   interval    steps
##      (dbl)    (dbl)
## 1        0  74.7652
## 2        5  74.7652
## 3       10  74.7652
## 4       15  74.7652
## 5       20  74.7652
## 6       25 126.7652
```

```r
tail(totalStepsPerIntervalWeekends)
```

```
## Source: local data frame [6 x 2]
## 
##   interval    steps
##      (dbl)    (dbl)
## 1     2330  91.7652
## 2     2335 250.7652
## 3     2340 168.7652
## 4     2345 100.7652
## 5     2350  74.7652
## 6     2355  74.7652
```

```r
summary(totalStepsPerIntervalWeekends)
```

```
##     interval          steps        
##  Min.   :   0.0   Min.   :  74.77  
##  1st Qu.: 588.8   1st Qu.:  90.27  
##  Median :1177.5   Median : 523.27  
##  Mean   :1177.5   Mean   : 677.86  
##  3rd Qu.:1766.2   3rd Qu.:1132.77  
##  Max.   :2355.0   Max.   :2524.77
```

###Plot panel

```r
par(mfrow=c(2,1)) 

plot(totalStepsPerIntervalWeekdays,type="l",main="5 min time series  weekdays", ylab="Average steps", xlab="5 min intervals ")

plot(totalStepsPerIntervalWeekends,type="l",main="5 min time series  weekends", ylab="Average steps", xlab="5 min intervals ")
```

![](PA1_template_files/figure-html/unnamed-chunk-14-1.png) 
