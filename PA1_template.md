# Assignment: Reproducible Research - Week 2 (Markdown & knitr) - Course Project 1
Chua Lin Kiat  

#Introduction

It is now possible to collect a large amount of data about personal movement using activity monitoring devices such as a Fitbit, Nike Fuelband, or Jawbone Up. These type of devices are part of the "quantified self" movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. But these data remain under-utilized both because the raw data are hard to obtain and there is a lack of statistical methods and software for processing and interpreting the data.

This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

The data for this assignment can be downloaded from the course web site:

Dataset: Activity monitoring data [52K]
The variables included in this dataset are:

steps: Number of steps taking in a 5-minute interval (missing values are coded as NA)
date: The date on which the measurement was taken in YYYY-MM-DD format
interval: Identifier for the 5-minute interval in which measurement was taken
The dataset is stored in a comma-separated-value (CSV) file and there are a total of 17,568 observations in this dataset.

#Assignment

This assignment will be described in multiple parts. You will need to write a report that answers the questions detailed below. Ultimately, you will need to complete the entire assignment in a single R markdown document that can be processed by knitr and be transformed into an HTML file.

Throughout your report make sure you always include the code that you used to generate the output you present. When writing code chunks in the R markdown document, always use echo = TRUE so that someone else will be able to read the code. This assignment will be evaluated via peer assessment so it is essential that your peer evaluators be able to review the code for your analysis.

For the plotting aspects of this assignment, feel free to use any plotting system in R (i.e., base, lattice, ggplot2)

Fork/clone the GitHub repository created for this assignment. You will submit this assignment by pushing your completed files into your forked repository on GitHub. The assignment submission will consist of the URL to your GitHub repository and the SHA-1 commit ID for your repository state.

NOTE: The GitHub repository also contains the dataset for the assignment so you do not have to download the data separately.

#Pre-running the script

Please ensure the following:- 

1. The activity.csv file is located in the same directory with the PA1_template.Rmd code

#Loading and preprocessing the data

Show any code that is needed to

1. Load the data (i.e. read.csv())


```r
data <- read.csv("activity.csv", header = TRUE, sep = ",")
```

2. Process/transform the data (if necessary) into a format suitable for your analysis


```r
data$date <- as.Date(data$date)
```


#What is mean total number of steps taken per day?

For this part of the assignment, you can ignore the missing values in the dataset.

1. Calculate the total number of steps taken per day


```r
dailyStepSum <- aggregate(data$steps, list(data$date), FUN=sum,na.rm=TRUE)
dailyStepSum
```

```
##       Group.1     x
## 1  2012-10-01     0
## 2  2012-10-02   126
## 3  2012-10-03 11352
## 4  2012-10-04 12116
## 5  2012-10-05 13294
## 6  2012-10-06 15420
## 7  2012-10-07 11015
## 8  2012-10-08     0
## 9  2012-10-09 12811
## 10 2012-10-10  9900
## 11 2012-10-11 10304
## 12 2012-10-12 17382
## 13 2012-10-13 12426
## 14 2012-10-14 15098
## 15 2012-10-15 10139
## 16 2012-10-16 15084
## 17 2012-10-17 13452
## 18 2012-10-18 10056
## 19 2012-10-19 11829
## 20 2012-10-20 10395
## 21 2012-10-21  8821
## 22 2012-10-22 13460
## 23 2012-10-23  8918
## 24 2012-10-24  8355
## 25 2012-10-25  2492
## 26 2012-10-26  6778
## 27 2012-10-27 10119
## 28 2012-10-28 11458
## 29 2012-10-29  5018
## 30 2012-10-30  9819
## 31 2012-10-31 15414
## 32 2012-11-01     0
## 33 2012-11-02 10600
## 34 2012-11-03 10571
## 35 2012-11-04     0
## 36 2012-11-05 10439
## 37 2012-11-06  8334
## 38 2012-11-07 12883
## 39 2012-11-08  3219
## 40 2012-11-09     0
## 41 2012-11-10     0
## 42 2012-11-11 12608
## 43 2012-11-12 10765
## 44 2012-11-13  7336
## 45 2012-11-14     0
## 46 2012-11-15    41
## 47 2012-11-16  5441
## 48 2012-11-17 14339
## 49 2012-11-18 15110
## 50 2012-11-19  8841
## 51 2012-11-20  4472
## 52 2012-11-21 12787
## 53 2012-11-22 20427
## 54 2012-11-23 21194
## 55 2012-11-24 14478
## 56 2012-11-25 11834
## 57 2012-11-26 11162
## 58 2012-11-27 13646
## 59 2012-11-28 10183
## 60 2012-11-29  7047
## 61 2012-11-30     0
```

2. If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day


```r
library(ggplot2)
names(dailyStepSum) <- c("date","steps")
histplot <- ggplot(dailyStepSum,aes(x = steps)) +
            ggtitle("Histogram of daily total steps") +
            xlab("Steps") +
            geom_histogram(binwidth = 1500)
histplot
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

3. Calculate and report the mean and median of the total number of steps taken per day


```r
mean1 <- mean(dailyStepSum$steps  , na.rm = TRUE)

mean1
```

```
## [1] 9354.23
```

```r
median1 <- median(dailyStepSum$steps , na.rm = TRUE)

median1
```

```
## [1] 10395
```

```r
histplot <- histplot + geom_vline(aes(xintercept=mean1), color="#80F28A", size = 1, linetype = "solid", alpha=1)

histplot <- histplot + geom_vline(aes(xintercept=median1), color="#E293C0", size = 1, linetype = "dotted", alpha=1)

histplot <- histplot+geom_text(aes(mean1,0,label = "mean =" , hjust=2.5, vjust = -13))
histplot <- histplot+geom_text(aes(mean1,0,label = round(mean1), hjust=1.5, vjust = -13))
histplot <- histplot+geom_text(aes(median1,0,label = median1, hjust=-2.5, vjust = -13))
histplot <- histplot+geom_text(aes(median1,0,label = "median1 = ", hjust=-0.5, vjust = -13))


histplot
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->




#What is the average daily activity pattern?

1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
AverageSteps  <- aggregate(x = data$steps , by = list(data$interval), FUN = mean ,na.rm=TRUE)
names(AverageSteps) <- c("interval","steps")

GraphAverageSteps <- ggplot(AverageSteps,aes(interval,steps)) +
                 ggtitle("Average Steps by time interval") +
                 geom_line()
GraphAverageSteps 
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
AverageSteps[which.max(AverageSteps$steps),c("interval")]
```

```
## [1] 835
```

#Imputing missing values

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)


```r
nrow(data[is.na(data$steps),])
```

```
## [1] 2304
```

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.


```r
dataClean <- merge(x = data, y = AverageSteps, by = "interval", all.x = TRUE)
dataClean[is.na(dataClean$steps.x),c("steps.x")] <- dataClean[is.na(dataClean$steps.x),c("steps.y")]


dataClean$date <- as.Date(dataClean$date)
dataClean$date.x <- NULL
dataClean$Group.1 <- NULL
dataClean$steps <- dataClean$steps.x
dataClean$steps.x <- NULL
dataClean$steps.y <- NULL
```


3. Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
head(dataClean)
```

```
##   interval       date    steps
## 1        0 2012-10-01 1.716981
## 2        0 2012-11-23 0.000000
## 3        0 2012-10-28 0.000000
## 4        0 2012-11-06 0.000000
## 5        0 2012-11-24 0.000000
## 6        0 2012-11-15 0.000000
```

4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
dailyStepSumClean <- aggregate(dataClean$steps, list(dataClean$date), FUN=sum)
names(dailyStepSumClean) <- c("date","steps")
histplotClean <- ggplot(dailyStepSumClean,aes(x = steps)) +
            ggtitle("Histogram of daily total steps based on Clean Data") +
            xlab("Steps") +
            geom_histogram(binwidth = 1500)

mean1Clean <- mean(dailyStepSumClean$steps  , na.rm = TRUE)

mean1Clean
```

```
## [1] 10766.19
```

```r
median1Clean <- median(dailyStepSumClean$steps , na.rm = TRUE)

median1Clean
```

```
## [1] 10766.19
```

```r
histplotClean <- histplotClean + geom_vline(aes(xintercept=mean1Clean), color="#80F28A", size = 1, linetype = "solid", alpha=1)

histplotClean <- histplotClean + geom_vline(aes(xintercept=median1Clean), color="#E293C0", size = 1, linetype = "dotted", alpha=1)

histplotClean <- histplotClean+geom_text(aes(mean1Clean,0,label = "mean =" , hjust=2.5, vjust = -13))
histplotClean <- histplotClean+geom_text(aes(mean1Clean,0,label = round(mean1Clean), hjust=1.5, vjust = -13))
histplotClean <- histplotClean+geom_text(aes(median1Clean,0,label = round(median1Clean), hjust=-2.5, vjust = -13))
histplotClean <- histplotClean+geom_text(aes(median1Clean,0,label = "median1 = ", hjust=-0.5, vjust = -13))


histplotClean
```

![](PA1_template_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

1st part result

Mean= 9354.23

Median = 10395

2nd part result(after clean the data)

Mean = 10766

Median = 10766

Question No 1: Do these values differ from the estimates from the first part of the assignment?

Answer No 1: The value differs from the 1st part of the result for both mean and median. 

Question No 2: What is the impact of imputing missing data on the estimates of the total daily number of steps?

Answer No 2: Inputing null values causes the calculation for mean and median to be different because there are more data which causes the base count bigger.


#Are there differences in activity patterns between weekdays and weekends?

For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.


```r
dataClean$weekday <- as.factor(ifelse(weekdays(dataClean$date) %in% c("Saturday","Sunday"), "Weekend", "Weekday")) 
```

2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.


```r
AverageStepsWeekdayWeekend  <- aggregate(x = dataClean$steps , 
                                                    by = list(dataClean$interval,dataClean$weekday), FUN = mean ,na.rm=TRUE)
names(AverageStepsWeekdayWeekend) <- c("interval","weekday","steps")

GraphAverageWeek <- ggplot(AverageStepsWeekdayWeekend,aes(interval,steps)) +
                 ggtitle("Time Series Plot of Average Steps by Interval after Imputation") +
                 facet_grid(. ~ weekday) +
                 geom_line(size = 1)
GraphAverageWeek  
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

Answer: Based on the graph, there a differences between activity pattern between Weekday and Weekend. They are more active early on the day (interval < 1000) during the weekday compare to the weekend.




---------------------------------- END ----------------------------------
