# Reproducible Research: Peer Assessment 1
## Loading and preprocessing the data


```r
 activityunzip <- unz("activity.zip","activity.csv")
 activity <- read.table(file = activityunzip,header = TRUE,sep = ",")
```
Convert the columns in their correct class to allow their analysis.


```r
  activity$date<-as.Date( activity$date, format = "%Y-%m-%d")
  activity$interval <- factor(activity$interval )  
```
Load the libraries


```r
library(ggplot2)
```

## What is mean total number of steps taken per day?


```r
Total_steps_day <- aggregate(steps ~ date, activity,sum, na.rm=TRUE)
hist1 <- ggplot(Total_steps_day,aes(x=date,y=steps)) + 
  geom_bar(stat="identity") + 
  ggtitle("Total number of steps per day ")  
print(hist1)
```

![](RepData_PeerAssessment1_files/figure-html/unnamed-chunk-4-1.png)




