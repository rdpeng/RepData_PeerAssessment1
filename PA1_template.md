# First R Markdown Project
Dawid J Duvenhage  
July 29, 2017  

#Reproducible Research - Week 1
##Peer-graded Assignment: Course Project 1

##______________________________________________________
##Set working directory and work data path.

```r
setwd("C:\\Users\\Dawid J Duvenhage\\Desktop\\Coursera Courses\\Data Scientist Specialization\\5_Reproducible Research\\Week 2 Lectures_RR\\Project 1")
```

##Important:
####Set correct file path below, before the "\\Project1"

```r
filepath <- "C:\\Users\\Dawid J Duvenhage\\Desktop\\Coursera Courses\\Data Scientist Specialization\\5_Reproducible Research\\Week 2 Lectures_RR\\Project 1\\Project1"
```
####Create work folder to extract and write data to.

```r
if(!file.exists("./Project1")){dir.create("./Project1")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
```
##Download and Read raw data files:
###Process/transform the data (if necessary) into a format suitable for your analysis.
####Download raw data zip file for "personal movement using activity monitoring devices" from original folder position.

```r
        download.file(fileUrl,destfile="./Project1/Dataset.zip")
```
####Unzip raw dataSet to /Project1 directory

```r
        unzip(zipfile="./Project1/Dataset.zip",exdir="./Project1")
```
####Read the raw data .csv files 

```r
        activity <- read.csv("./Project1/activity.csv")
```
##______________________________________________________
##Exploratory Data Analysis of Raw Data File
###Look through data to assess the size, structure, and format of data.
####(Remove the ### in front of the R-code below, to run the code)

        ###object.size(activity)
        ###dim(activity)
        ###class(activity)
        ###summary(activity)
        ###head(activity)
        ###tail(activity)
        ###sapply(activity)
        ###with(activity, plot(steps~date))
      
##______________________________________________________
##What is mean total number of steps taken per day?
####For this part of the assignment, you can ignore the missing values in the dataset.
####Calculate the total number of steps taken per day

```r
        step_sum <- aggregate(activity$steps, activity["date"], sum)
        attr(step_sum, "names") <- c("date", "steps")
```
##Make a histogram of the total number of steps taken each day

```r
        hist(step_sum$steps, breaks= 50, main = "Total steps per day", xlab = "totals steps", col="green")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

##Calculate and report the mean and median of the total number of steps taken per day

```r
        step_mean <- mean(step_sum$steps, na.rm=TRUE)
        step_mean
```

```
## [1] 10766.19
```

```r
        step_median <- median(step_sum$steps, na.rm=TRUE)
        step_median
```

```
## [1] 10765
```
##What is the average daily activity pattern?
####Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
        interval <- aggregate(steps~interval, activity, mean)
        head(interval)
```

```
##   interval     steps
## 1        0 1.7169811
## 2        5 0.3396226
## 3       10 0.1320755
## 4       15 0.1509434
## 5       20 0.0754717
## 6       25 2.0943396
```

```r
        with(interval, plot(interval, steps, type="n", ylab="Average Steps per Day") )
        lines(interval$interval, interval$steps, type="l", col="orange")
        title("Average Daily Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

###Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
        max_interval <- interval[which.max(interval$steps),]
        max_interval
```

```
##     interval    steps
## 104      835 206.1698
```
##______________________________________________________
##Imputing missing values
####Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

####Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```r
        count_nas <- sum(is.na(activity$steps))
        count_nas
```

```
## [1] 2304
```
####Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

####Create new data file as to preserve the original

```r
        activity2 <- activity
```
####Create NAs table with "TRUE" and "FALSE" for NAs values

```r
        activity2_nas <- is.na(activity2$steps)
```
####tapply function is useful when there is a need to break up a vector into groups defined by some classifying factor, compute a function on the subsets, and return the results in a convenient form. Hence, here the missing step values are calculated, based on the means from data that exist at the same intervals of other day, sexcluding the missing values(NAs).

```r
        averages <- tapply(activity2$steps, activity2$interval, mean, na.rm=TRUE, simplify = TRUE)
```
####Create a new dataset substituting the missing values with corresponding data from the averages data frame.

```r
        activity2$steps[activity2_nas] <- averages[as.character(activity2$interval[activity2_nas])]
```
####Check the data set

```r
        sum(is.na(activity2))
```

```
## [1] 0
```

```r
        head(activity2)
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
###Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.

####Calculate the number of steps per day

```r
        step_sum2 <- aggregate(activity2$steps, activity2["date"], sum)
        attr(step_sum2, "names") <- c("date", "steps")
```
####Make a histogram of the total number of steps taken each day

```r
        hist(step_sum2$steps, breaks= 50, main = "Total steps per day, adjusted for missing data.", xlab = "totals steps", col="yellow")
```

![](PA1_template_files/figure-html/unnamed-chunk-19-1.png)<!-- -->

###Calculate and report the mean and median of the total number of steps taken per day

```r
        step_mean2 <- mean(step_sum2$steps, na.rm=TRUE)
        step_mean2
```

```
## [1] 10766.19
```

```r
        step_median2 <- median(step_sum2$steps, na.rm=TRUE)
        step_median2
```

```
## [1] 10766.19
```
###Do these values differ from the estimates from the first part of the assignment? 
####What is the impact of imputing missing data on the estimates of the total daily number of steps?   

```r
        summary(step_sum)
```

```
##          date        steps      
##  2012-10-01: 1   Min.   :   41  
##  2012-10-02: 1   1st Qu.: 8841  
##  2012-10-03: 1   Median :10765  
##  2012-10-04: 1   Mean   :10766  
##  2012-10-05: 1   3rd Qu.:13294  
##  2012-10-06: 1   Max.   :21194  
##  (Other)   :55   NA's   :8
```

```r
        summary(step_sum2)
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
##"Result:" 
###         "The step mean and step median numbers are the same when the missing numbers are filled in"
##______________________________________________________

##Are there differences in activity patterns between weekdays and weekends?
####For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.
####Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
####Create new data file as to preserve the original

```r
        activity3 <- activity2
```
####Add dayofweek to data file

```r
        activity3$dayofweek <- weekdays(as.Date(activity2$date))
```
####Convert date to a usable POSIXct format

```r
        activity3$datetime<- as.POSIXct(activity2$date, format="%Y-%m-%d")   
```
####Determine and Add Weekday category, weekday or weekend, to the data file

```r
        activity3$daycategory <- ifelse(activity3$dayofweek%in% c("Saturday", "Sunday"), "Weekend", "Weekday")
        head(activity3, 10)
```

```
##        steps       date interval dayofweek   datetime daycategory
## 1  1.7169811 2012-10-01        0    Monday 2012-10-01     Weekday
## 2  0.3396226 2012-10-01        5    Monday 2012-10-01     Weekday
## 3  0.1320755 2012-10-01       10    Monday 2012-10-01     Weekday
## 4  0.1509434 2012-10-01       15    Monday 2012-10-01     Weekday
## 5  0.0754717 2012-10-01       20    Monday 2012-10-01     Weekday
## 6  2.0943396 2012-10-01       25    Monday 2012-10-01     Weekday
## 7  0.5283019 2012-10-01       30    Monday 2012-10-01     Weekday
## 8  0.8679245 2012-10-01       35    Monday 2012-10-01     Weekday
## 9  0.0000000 2012-10-01       40    Monday 2012-10-01     Weekday
## 10 1.4716981 2012-10-01       45    Monday 2012-10-01     Weekday
```
###Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).    

####Obtain the mean steps as a function of the interval and daycategory.

```r
        avg_step_sum3 <- aggregate(steps~interval + daycategory ,activity3, mean)
```
####Construct the panel plot

```r
        library(lattice) 
        xyplot(steps~interval|daycategory, avg_step_sum3, type="l",  layout = c(1,2),
               main="Average Steps per Interval Based on Day of the Week Category",
               ylab="Average Number of Steps", 
               xlab="Interval")
```

![](PA1_template_files/figure-html/unnamed-chunk-27-1.png)<!-- -->

####Close the screen device

```r
        dev.off()
```

```
## null device 
##           1
```
