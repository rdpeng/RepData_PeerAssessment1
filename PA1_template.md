---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---


## Loading and preprocessing the data
For this example, it is assumed that  ***activity.zip*** or  ***activity.csv***  is located in the working directory. In case that the CSV file wasn´t unzipped, the code will load it from the zip file. 

One additional improvement for this code would be to include a logic statement to check if  the **activity.zip** file is in the directory, if not the code could download it from the repository.


```r
if(file.exists("activity.csv")){
    data <- read.csv("activity.csv")
} else {
    data <- read.csv(unz("activity.zip", "activity.csv"))
}

# Remove the NA values
dataClean <- data[!(is.na(data$steps)),]
```

## What is mean total number of steps taken per day?
Load the libraries needed for the project.


```r
library(dplyr)
```

Now there are two datasets, one with the original data and the other one skipping missing values. For this case the dplyr library is used to group the data by day. 


```r
a <- dataClean %>% group_by(date) %>% summarise(TotalSum = sum(steps), Mean = mean(steps), Median = median(steps))
barplot(a$TotalSum , names.arg = a$date , xlab = "Day" , ylab = "Total number of steps per day")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

```r
MeanStepsPerDay <- mean(a$Mean , na.rm = TRUE)
MedianStepsPerDay <- median(a$Median , na.rm = TRUE)
```

The mean number of steps per day are 37.3825996 and the median number of steps per day 0

## What is the average daily activity pattern?
As first step, the clean data will be summarize by interval calculating the mean, total sum and the median for each interval for all the days. 

Afterwards the time series for the average step for all days in each interval is plotted. There is a clear trend with initial interval with low number of steps then around interval 500 minutes, the average number steps increases until the maximum values.

The code that generates the graph is : 


```r
b <- dataClean %>% group_by(interval) %>% summarise(TotalSum = sum(steps), Mean = mean(steps), Median = median(steps))

plot(b$interval, b$TotalSum , type = "l", xlab = "Interval" , ylab = "Average Steps per day")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

```r
Interval <- b$interval[grep(max(b$TotalSum),b$TotalSum)]
ValueMax <- max(b$TotalSum)
```

The interval with higher average steps in the day is 835 with an average value of 10927 steps in that interval.

## Imputing missing values

- The calculation of the total number of missing value can be calculated in one line of code using the ***is.na()*** function to check if the value ***NA***

```r
 nrow(data[(is.na(data$steps)),]) 
```

```
## [1] 2304
```

- Replace the missing values with the average number of steps for all days for the giving interval. Lets look the existing data from the first 5 row 


```r
head(data ,5 ) # See the errors in the first 5 line. 
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
```

```r
head(b , 5) # mean values for the first 5 intervals
```

```
## Source: local data frame [5 x 4]
## 
##   interval TotalSum      Mean Median
## 1        0       91 1.7169811      0
## 2        5       18 0.3396226      0
## 3       10        7 0.1320755      0
## 4       15        8 0.1509434      0
## 5       20        4 0.0754717      0
```

- From the previous question, there is a dataset with the mean steps values per interval, therefore it is possible to look for the NA values in steps and replace those values with the *appropiate mean value of steps for all days in the define interval that appear in the data entry.* For this purpose, the functions ***mutate()*** , ***ifelse*** and ***rownumber()*** are used : 



```r
DataReplace <- mutate(data, steps = ifelse(is.na(steps), b$Mean[b$interval == data$interval[row_number()]], steps)) # mutate goes row by row, replace by the appropiate value in case of step value is NA

head(DataReplace, 5 )
```

```
##       steps       date interval
## 1 1.7169811 2012-10-01        0
## 2 0.3396226 2012-10-01        5
## 3 0.1320755 2012-10-01       10
## 4 0.1509434 2012-10-01       15
## 5 0.0754717 2012-10-01       20
```

Now that the missing values has been filled, it is possible to compute the mean and median number of steps per day and compare them with the values calculated in the other section. 


```r
a2 <- DataReplace %>% group_by(date) %>% summarise(TotalSum = sum(steps), Mean = mean(steps), Median = median(steps))
barplot(a2$TotalSum , names.arg = a2$date , xlab = "Day" , ylab = "Total number of steps per day")
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png) 

```r
MeanStepsPerDay2 <- mean(a2$Mean , na.rm = TRUE)
MedianStepsPerDay2 <- median(a2$Median , na.rm = TRUE)
```

 -  Mean37.3825996 and Median 0 *** without*** the missing values
 - Mean37.3825996 and Median 0 *** replacing*** the missing values



## Are there differences in activity patterns between weekdays and weekends?
