Assignment 1 Markdown
=====================

Loading data:

    download.file(url = "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip", 
                         destfile = "AMD.zip")
    unzip("AMD.zip")
    activity <- read_csv("activity.csv", col_types = cols(date = col_date(format = "%Y - %m - %d"), interval = col_double(), steps = col_double()))

What is mean total number of steps taken per day?
-------------------------------------------------

### 1. Calculate the total number of steps taken per day

    activity.date <- activity %>%
      group_by(date) %>%
      summarise(total.steps = sum(steps, na.rm = TRUE))

### 2.Make histogram of total number of steps taken each day

    hist(activity.date$total.steps, xlab = "Total Steps", main = "Frequency of Total Steps by Day", col = "purple")

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-3-1.png)

### 3. Calculate and report mean and median of total number of steps taken per day

    activity.date <- activity %>%
      group_by(date) %>%
      summarise (total.steps = sum(steps, na.rm = TRUE), mean.steps = mean(steps, na.rm = TRUE), median.steps = median(steps, na.rm = TRUE))

    ## Warning: package 'bindrcpp' was built under R version 3.4.4

    View(activity.date)

What is the average daily activity pattern
------------------------------------------

### 1. Make time series plot of 5 minute interval and average number of steps taken averaged across all days

    activity.interval <- aggregate(activity$steps, by=list(activity$interval), FUN=mean, na.rm=TRUE)
    activity.interval <- setNames(activity.interval, c("interval", "mean.steps"))
    plot(activity.interval$interval, activity.interval$mean.steps, type = "l", xlab = "Interval", ylab = "Mean Steps")

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-5-1.png)

### 2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

    activity.interval[which.max(activity.interval$mean.steps),]$interval

    ## [1] 835

Imputing Missing Values
-----------------------

### 1. Calculate and report the total number of missing values in the dataset

    sum(is.na(activity$steps))

    ## [1] 2304

### 2. Devise a strategy for filling in all of the missing values in the dataset.

    interval.mean.steps <- activity.interval$mean[match(activity$interval, activity.interval$interval)]

### 3. Create a new dataset that is equal to the original dataset but with missing values filled

    activity.filled <- transform(activity, steps = ifelse(is.na(activity$steps), yes = interval.mean.steps, no = activity$steps))

### 4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day

    activity.filled.date <- activity.filled %>%
      group_by(date) %>%
      summarise(total.steps = sum(steps, na.rm = TRUE))

    hist(activity.filled.date$total.steps, xlab = "Total Steps", main = "Frequency of Total Steps by Day", col = "blue")

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-10-1.png)

    activity.filled.date <- activity.filled %>%
      group_by(date) %>%
      summarise (total.steps = sum(steps, na.rm = TRUE), mean.steps = mean(steps, na.rm = TRUE), median.steps = median(steps, na.rm = TRUE))
    View(activity.filled.date)

They are different.

Are there differences in activity patterns between weekdays and weekends?
-------------------------------------------------------------------------

    activity.filled <- mutate(activity.filled, "weekday" = weekdays(activity.filled$date))

    activity.filled$datetype <- sapply(activity.filled$date, function(x) {
      if (weekdays(x) == "Saturday"|weekdays(x) == "Sunday") 
        y <- "Weekend"
        else 
        y <- "Weekday"
      y
    })

    activity.interval.filled <- aggregate(steps~interval + datetype, activity.filled, FUN=mean, na.rm=TRUE)

    library(ggplot2)
    g <- ggplot(activity.interval.filled, aes(x = interval, y = steps))
    g + geom_line() + facet_wrap(~datetype)

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-11-1.png)
