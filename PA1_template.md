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



## Loading and preprocessing the data

```r
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
hist(dailySteps$steps)
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

```r
mean(dailySteps$steps)
```

```
## [1] 10766.19
```

```r
median(dailySteps$steps)
```

```
## [1] 10765
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
Because there are a number of NA (missing data) occurances in our sataset, we will impute the missing values by taking the average for 5-minute interval across all days, and insert that as the imputed value.  Then we will determine if the results change significantly.


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
intervalMeans <- aggregate(steps ~ interval, origData, mean)   # Calculate step means by interval
                                                               
imputedData$substitute <- rep(intervalMeans$steps)             # Replicate for each day and add
                                                               # col of substitute data
# Loop through data, substituting imputed value for each NA

for (i in 1:length(imputedData$steps)){                        # Loop through all intervals
    if (is.na(imputedData$steps[i])) 
         imputedData$steps[i] <- imputedData$substitute[i]     # Substituting when NA occurs
}

imputedDailySteps<-aggregate(steps~date,data=imputedData,sum,na.rm=TRUE)
hist(imputedDailySteps$steps)
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png) 

```r
mean(imputedDailySteps$steps)
```

```
## [1] 10766.19
```

```r
median(imputedDailySteps$steps)
```

```
## [1] 10766.19
```



## Are there differences in activity patterns between weekdays and weekends?
