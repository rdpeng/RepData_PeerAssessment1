# Reproducible Research: Peer Assessment 1
### Loading add-on package

```r
library(ggplot2)
```

### Loading the data

```r
#setwd("./RepData_PeerAssessment1")
file_url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(file_url, "activity.zip")
unzip(zipfile = "activity.zip")
raw_data <- read.csv("activity.csv")
```

### Preproccessing the data

```r
omitted_data <- na.omit(raw_data)
```

### What is mean total number of steps taken per day?
####1. Calculate the total number of steps taken per day using omitted data.

```r
stepdata1_O <- aggregate(omitted_data["steps"], by=omitted_data["date"], FUN=sum)
head(stepdata1_O)
```

```
##         date steps
## 1 2012-10-02   126
## 2 2012-10-03 11352
## 3 2012-10-04 12116
## 4 2012-10-05 13294
## 5 2012-10-06 15420
## 6 2012-10-07 11015
```

####2. Make a histogram of the total number of steps taken each day

```r
hist_steps1 <- ggplot(stepdata1_O, aes(x = steps)) 
hist_steps1 + geom_histogram(binwidth = 2500) +
      ggtitle("The total number of steps taken each day")
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)

####3. Calculate and report the mean and median of the total number of steps taken per day
- mean

```r
mean(stepdata1_O$steps)
```

```
## [1] 10766.19
```
- median

```r
median(stepdata1_O$steps)
```

```
## [1] 10765
```



### What is the average daily activity pattern?

####1. Make a time series plot of the 5-minute interval (x-axis) and the average number across all days.

```r
stepdata2_O <- aggregate(omitted_data["steps"], by=omitted_data["interval"], FUN=mean)

plot_steps2 <- ggplot(stepdata2_O, aes(x = interval, y = steps))
plot_steps2 + geom_line() + ggtitle("The average number of steps across all days")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)

####2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
stepdata2_O$interval[stepdata2_O$steps == max(stepdata2_O$steps)]
```

```
## [1] 835
```

### Imputing missing values

####1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```r
sum(is.na(raw_data))
```

```
## [1] 2304
```

####2.Devise a strategy for filling in all of the missing values in the dataset. 

- Create a new dataset that is equal to the original dataset.

```r
filled_data <- raw_data
```
- ...but the missing data must be filled in. I used the mean for that 5-minute interval.

```r
num <- 1:length(raw_data[,1])
for (i in num){
    if(is.na(raw_data[i, 1])){
        filled_data[i, 1] <- stepdata2_O[stepdata2_O$interval == raw_data[i,3], 2]
    }
}
```

####3. Make a histogram of the total number of steps taken each day
We can see only the middle bar is extended, because the NA are filled with mean value.

```r
stepdata3_filled <- aggregate(filled_data["steps"], by=filled_data["date"], FUN=sum)
hist_step3 <- ggplot(stepdata3_filled, aes(x = steps)) 
hist_step3 + geom_histogram(binwidth = 2500) +
      ggtitle("The total number of steps taken each day (filled)")
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)


####4. Calculate and report the mean and median of the total number of steps taken per day.
- mean

```r
mean(stepdata3_filled$steps)
```

```
## [1] 10766.19
```
- median

```r
median(stepdata3_filled$steps)
```

```
## [1] 10766.19
```
* These data are not changed compared to the raw data.


### Are there differences in activity patterns between weekdays and weekends?
####1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend"

```r
filled_data$week <- weekdays(as.Date.factor(filled_data[, 2]))
filled_data$weekday <- ""
num <- 1:length(raw_data[,1])
for (i in num){
    if(filled_data[i, 4] == "Sunday" || filled_data[i, 4] == "Saturday"){
        filled_data[i, "weekday"] <- "Weekends"

    } else {
        filled_data[i, "weekday"] <- "Weekdays"
    }
}
```


####2. Make time seriese graph and compare "weekday" and "weekend".

```r
twolevel <-aggregate(filled_data["steps"], by=filled_data[c("interval", "weekday")], FUN=mean)

g <- ggplot(data = twolevel, aes(x=interval, y=steps, col=weekday))
g + geom_line() + facet_grid(weekday ~.) +
    ggtitle("The average number of steps across all days")
```

![](PA1_template_files/figure-html/unnamed-chunk-17-1.png)
