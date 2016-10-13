---
title: 'Reproducible Research: Project 1'
author: "Daragh O'Sullivan"
date: "09/23/2016"
output: html_document
---



The Dataset was downloaded from "https://www.coursera.org/learn/reproducible-res
earch/peer/gYyPt/course-project-1" at 17:29 23/09/2016

1: To begin the assignment lets load the data contained in the "activity.csv" file

```r
fit <- read.csv("/home/daragh/Downloads/activity.csv")
```





2: We first need to transform the data into a format suitable for our analysis..

```r
steps_per_day <- aggregate(list(steps= fit[,1]), by=list(Date=fit[,2]),FUN=sum )

steps_per_day$Date <- as.Date(steps_per_day$Date)
```

Now because I don't know of any more efficient way, I'm going filter out all days
where the total number of steps equals 'NA'. Then create a vector of
the individual dates replicated by the total number of steps taken


```r
steps_per_day <- filter(steps_per_day, steps_per_day[,2]!= "NA")

Dates <- rep(steps_per_day$Date, steps_per_day$steps)
```

3: To plot a histogram of the total number of steps taken each day, include
   parameters that are necessary when dealing with values of class 'Date'


```r
hist(Dates, breaks=53, xlab=deparse(substitute(Dates)), plot=TRUE, freq=TRUE,
     start.on.monday=TRUE, format, right=TRUE,col='darkblue', main="Total Steps 
     taken Each Day", ylab='Steps')
```

<img src="PA1_template_files/figure-html/unnamed-chunk-5-1.png" width="672" />

4: Before calculating the mean and median of the total number of steps taken per day,
create a vector containing the totals for each day

```r
Totals <- c(steps_per_day[,2])
Totals <- Totals[is.na(Totals)==FALSE]
mean(Totals)
```

```
## [1] 10766.19
```

```r
median(Totals)
```

```
## [1] 10765
```
So a person generally takes 10760 or so steps a day.


5: Now, to make a time-series plot of the 5-minute interval and the average number of
steps taken:

```r
fit2 <- filter(fit, fit[,1]!= "NA")
interval <-  aggregate(list(steps= fit2[,1]), by=list(interval=fit2[,3]),FUN=mean) 

ggplot(interval,aes(interval,steps)) +geom_line() + xlab("Interval") + ylab(" Average Steps")
```

<img src="PA1_template_files/figure-html/unnamed-chunk-7-1.png" width="672" />

6 :Which 5-minute interval, on average across all days, contains the maximum number
of steps?

```r
max <- max(interval[,2])
filter(interval, steps==max)
```

```
##   interval    steps
## 1      835 206.1698
```


7: Calculate the the total number of missing values in the dataset

```r
 sum(is.na(fit[,1]==TRUE))
```

```
## [1] 2304
```


8: We now need to fill in all the missing values in the dataset

First check what days consist of only NA. That is do they occur only in day-long
blocks, or do they occur alongside valid step-data for that day?

```r
NA_ <- filter(fit, is.na(steps)==TRUE)
Unique <- unique(as.Date(NA_$date))

notNA_ <- filter(fit, is.na(steps)==FALSE)
notUnique <- unique(as.Date(notNA_$date))
notUnique %in% Unique
```

```
##  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [13] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [25] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [37] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [49] FALSE FALSE FALSE FALSE FALSE
```
This result shows us that no NA values were recorded outside of the 8 days where
there were only NA values.

This means that to fill in the missing values, we _cannot_ use the daily mean, as
this is incalculable without any valid data. We have to fill in the missing data
using the _mean_ for the respective 5-minute intervals

9: We do this by first joining the averages for every interval to the 'fit' dataset:

```r
filled_data <- left_join(fit, interval, by='interval')
```
We then replace all NA values wih the corresponding mean for that specific interval

```r
filled_data$steps.x[is.na(filled_data$steps.x)] <- filled_data$steps.y
```

```
## Warning in filled_data$steps.x[is.na(filled_data$steps.x)] <- filled_data
## $steps.y: number of items to replace is not a multiple of replacement length
```

```r
filled_data <- select(filled_data, steps.x,date,interval)
```
10: make a histogram of the total number of steps taken each day

```r
Dates2 <- rep(filled_data$date, filled_data$steps.x)
Dates2 <- as.Date(Dates2)

hist(Dates2, breaks=53, xlab=deparse(substitute(Dates2)), plot=TRUE,
     freq=TRUE,start.on.monday=TRUE, format, right=TRUE,col='darkblue', main="Total Steps 
     taken Each Day", ylab='Steps')
```

<img src="PA1_template_files/figure-html/unnamed-chunk-13-1.png" width="672" />

10(part 2): now report the mean and median total number of steps taken per day

```r
filled_stepsperday <- aggregate(list(steps= filled_data[,1]), by=list(Date=filled_data[,2]),FUN=sum)
filled_stepsperday$Date <- as.Date(filled_stepsperday$Date)
mean(filled_stepsperday[,2])     
```

```
## [1] 10766.19
```

```r
mean(Totals)
```

```
## [1] 10766.19
```

So we can see that the mean of total number of steps taken per day in the 'filled'
dataset and the original dataset are the same.

```r
median(filled_stepsperday[,2])
```

```
## [1] 10766.19
```

```r
median(Totals)
```

```
## [1] 10765
```
while the median of total number of steps taken per day in the 'filled'
dataset and the original dataset are only slightly different.

This shows that the impact of inputting missing data on the estimates of daily
number of steps is miniscule.

11: create a new factor variable in the dataset with two levels, "Weekday", "Weekend"


```r
filled_data[,2] <- as.Date(filled_data[,2])

filled_data <- mutate(filled_data, Day = weekdays(date))

Days <- unique(filled_data$Day)
Weekdays <- Days[1:5]

filled_data <- mutate(filled_data, Weekday = Day %in% Weekdays)

filled_data$Weekday[filled_data$Weekday == "TRUE"] <- "Weekday"
filled_data$Weekday[filled_data$Weekday == "FALSE"] <- "Weekend"
```

12: Create a panel plot containing a time series plot of the 5-minute interval and
the average number of steps taken, averaged across all weekdays and weekend-days

First we need to create 2 separate datasets that contain the average number of 
steps taken, averaged across all 1: weekdays, and 2: weekend days

```r
weekday <- filter(filled_data, Weekday=="Weekday")
intervalweekday <-  aggregate(list(steps= weekday$steps.x), by=list(interval
=weekday$interval),FUN=mean)

intervalweekday <- mutate(intervalweekday, Day="Weekday" )

weekendday <- filter(filled_data, Weekday=="Weekend")
intervalweekendday <-  aggregate(list(steps= weekendday$steps.x), by=list(interval
=weekendday$interval),FUN=mean) 

intervalweekendday <- mutate(intervalweekendday, Day="Weekend" )
intervalall <- rbind(intervalweekday, intervalweekendday )

a <- ggplot(intervalall, aes(interval, steps))
a + facet_grid(Day~.) + geom_line(color="red")
```

<img src="PA1_template_files/figure-html/unnamed-chunk-17-1.png" width="672" />


Thanks for reading! This script should adequately read in, explore and analyse the dataset as outlined in the assignment requirements

