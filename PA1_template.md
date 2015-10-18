# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data

Loading and preprocessing the data using code below. Change the default type of column 'date' to Date type (your working directory could be different).

```r
setwd ("C:/Github/RepData_PeerAssessment1")
data <- read.csv (unzip ("activity.zip"))
data$date <- as.Date (data$date, "%Y-%m-%d")
```
Change system locale to English.

```r
Sys.setlocale("LC_ALL", 'English')
```

## What is mean total number of steps taken per day?

Using package 'dplyr' for calculating total number of steps taken per day

```r
library (dplyr)
totalSteps <- data %>% 
              group_by (date) %>%
              summarize (sum = sum (steps, na.rm = T))
```

Make histogram of total number of steps per day

```r
hist (totalSteps$sum, main = "Total steps distribution", xlab = 'steps, qty')
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 


```r
stepsMean   = round (mean (totalSteps$sum), 2)
stepsMedian = median (totalSteps$sum)
```

The mean of total steps per day is equal 9354.23 and the median is equal 10395.

## What is the average daily activity pattern?
Let`s calculate the average daily activity pattern across all the days in the dataset.

```r
meanSteps <- data %>% 
             group_by (interval) %>%
             summarize (mean = mean (steps, na.rm = T))
plot (meanSteps, type = "l", ylab = "Average steps, qty", xlab = "Time, hours", xaxt = 'n')
axis (1, seq (0, 2400, by = 100), 0:24)
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png) 

## Imputing missing values

```r
totalNA <- sum (is.na (data$steps))
```
The total NA values in dataset is equal 2304. Imputing missing values using mean value in interval.

```r
datawoNA <- data
for (i in unique (data$interval))
    datawoNA [with (data, which (is.na (steps) & interval == i)), "steps"] <- 
        meanSteps [which (meanSteps$interval == i), "mean"]
```
Let`s look at new dataset without NA values

```r
head (datawoNA)
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
Now we calculate a new total number of steps per day and compare it with the previous results.

```r
totalStepswoNA <- datawoNA %>% 
                  group_by (date) %>%
                  summarize (sum = sum (steps))
par (mfrow = c(1,2))
hist (totalSteps$sum, main = "Total steps distribution w/ NA", xlab = 'steps, qty', ylim = c(0,35))
hist (totalStepswoNA$sum, main = "Total steps distribution w/o NA", xlab = 'steps, qty', ylim = c(0,35))
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png) 

As we can see, the left side of two histograms look different. The distribution without NA values look more symmetric and small ranges "flows"" to the center.

```r
stepsMeanwoNA   = mean (totalStepswoNA$sum)
stepsMedianwoNA = median (totalStepswoNA$sum)
```
The mean of total steps per day with replaced missing data by mean is equal 1.0766189\times 10^{4} and the median is equal 1.0766189\times 10^{4}. The mean and median are equal.

```r
stepsMeanwoNA == stepsMedianwoNA
```

```
## [1] TRUE
```
## Are there differences in activity patterns between weekdays and weekends?
Add a new column to data with imputed values, indicating whether a given date is a weekday or weekend day 

```r
datawoNA <- datawoNA %>% 
            mutate (weekdays = ifelse (weekdays (datawoNA$date) == "Saturday" | 
                    weekdays (datawoNA$date) == "Sunday", "weekend", "weekday")) %>%
            mutate (weekdays = as.factor (weekdays))
```

Calculate the average daily activity pattern across weeday and weekend in the dataset.

```r
meanStepsWD <- datawoNA %>% 
               group_by (interval, weekdays) %>%
               summarize (mean = mean (steps))
```
And plot it using 'lattice' package for panel plot.

```r
library (lattice)
xyplot (mean ~ interval | weekdays, meanStepsWD, layout = c(1,2), 
        ylab = "Number of steps", type = "l")
```

![](PA1_template_files/figure-html/unnamed-chunk-15-1.png) 

The weekdays have a morning peak between 8 AM and 10 AM, when most peeple go to work.
Decreasing activity at working day, and evening activity, when most people go to home.
The weekends have a different pattern, with no explicit behaviour.  
