# Reproducible Research: Peer Assessment 1
## Introduction
This pproject explores data from a personal monitor using the nuber of steps taken in 5 minute intervals during October and November of 2012.

## Data
The data for this assignment is contained within the git repo.

The variables included in this dataset are:

    -steps: Number of steps taking in a 5-minute interval (missing values are coded as NA)  
    -date: The date on which the measurement was taken in YYYY-MM-DD format  
    -interval: Identifier for the 5-minute interval in which measurement was taken  

The dataset is stored in a comma-separated-value (CSV) file and there are a total of 17,568 observations in this dataset.

###  Assignment
The code and results, along with explanation, are contained within this document.  All code can be run and should exactly reproduce the results shown.



## Loading and preprocessing the data and loading libraries

```r
library("lattice")
unzip("activity.zip")
origData <-
    read.csv(
        "activity.csv",header = TRUE, colClasses = c("integer", "Date", "integer")
    )
```



## What is mean total number of steps taken per day?

We aggregate the daily data, ouput a histogram and the mean and median of the daily steps.


```r
dailySteps<-aggregate(steps~date,data=origData,sum,na.rm=TRUE)
hist(dailySteps$steps,
     xaxt = "n",
     main = "Histogram of daily steps",
     xlab = "Bins for step ranges")
axis(side=1,
     at=axTicks(1),
     labels=formatC(axTicks(1),
     format="d",
     big.mark=','))
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

```r
sprintf("The mean of daily steps is %.0f, and the median is %.0f.",
        mean(dailySteps$steps),median(dailySteps$steps))
```

```
## [1] "The mean of daily steps is 10766, and the median is 10765."
```

## What is the average daily activity pattern?

Now we aggregate the data by the 5-minute intervals and plot the averages per each interval.  

```r
stepsInterval<-aggregate(steps~interval,data=origData,mean,na.rm=TRUE)


plot(steps~interval,data=stepsInterval,type="l")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 
  
And we determine which 5 minute interval contains the maximum number of steps.  

```r
stepsInterval[which.max(stepsInterval$steps),]$interval
```

```
## [1] 835
```



## Imputing missing values
Because there are a number of NA (missing data) occurances in our dataset, we will impute the missing values by taking the median for that 5-minute interval across all days, and insert it as the imputed value.  Then we will determine if the results change significantly.


```r
missingData <- sum(is.na(origData$steps))

#--------------------- look below for output sprintf --------
sprintf("Number of missing points is %i, %3.1f%% of total.",
        missingData,missingData/length(origData$steps)*100)
```

```
## [1] "Number of missing points is 2304, 13.1% of total."
```


```r
# ---------------------- begin imputed value processing -----
imputedData <- origData                                        #Make a copy of the original data
intervalMedians <- aggregate(steps ~ interval, origData, median)   # Calculate step median by interval
                                                               
imputedData$substitute <- rep(intervalMedians$steps)             # Replicate for each day and add
                                                               # col of substitute data
# Loop through data, substituting imputed value for each NA

for (i in 1:length(imputedData$steps)){                        # Loop through all intervals
    if (is.na(imputedData$steps[i])) 
         imputedData$steps[i] <- imputedData$substitute[i]     # Substituting when NA occurs
}

imputedDailySteps<-aggregate(steps~date,data=imputedData,sum,na.rm=TRUE)
hist(imputedDailySteps$steps,
     xaxt = "n",
     main = "Histogram of daily steps (imputed)",
     xlab = "Bins for step ranges")
axis(side=1,
     at=axTicks(1),
     labels=formatC(axTicks(1),
     format="d",
     big.mark=','))
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png) 

```r
sprintf("The mean of daily steps (with imputation) is %.1f, and the median is %.1f.",
mean(imputedDailySteps$steps),
median(imputedDailySteps$steps))
```

```
## [1] "The mean of daily steps (with imputation) is 9503.9, and the median is 10395.0."
```

```r
sprintf("Imputing cause a change of %.1f%% in mean and %.1f%% in median",
(mean(dailySteps$steps)-mean(imputedDailySteps$steps))/mean(dailySteps$steps)*100,
(median(dailySteps$steps)-median(imputedDailySteps$steps))/median(dailySteps$steps)*100)
```

```
## [1] "Imputing cause a change of 11.7% in mean and 3.4% in median"
```

Imputing median values does not make much difference in the totals although it does move the median.  
## Are there differences in activity patterns between weekdays and weekends?

Lastly we investigate if there is any significant changes on weekends.

First we create factors for Weekend and Weekday and place them in imputedData$dayClass  
Then we aggregate by weekend and weekday and mean steps per interval  
Lastely plot two panels, one for weekdays and one for weekends.


```r
imputedData$dayClass <- as.factor(ifelse ((substr(weekdays(imputedData$date),1,1) == "S"),
                                "Weekend" ,"Weekday"))

stepsDayClass <- aggregate(steps ~ interval + dayClass, data = imputedData, mean)

xyplot(steps ~ interval | dayClass, stepsDayClass, type = "l", layout = c(1, 2),
       xlab = "Interval", ylab = "Number of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png) 


