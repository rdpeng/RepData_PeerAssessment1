R Markdown
----------

This is an R Markdown document. Markdown is a simple formatting syntax
for authoring HTML, PDF, and MS Word documents. For more details on
using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that
includes both content as well as the output of any embedded R code
chunks within the document. You can embed an R code chunk like this:

### Loading and preprocessing the data

    activity <- read.csv("activity.csv", colClasses=c("numeric","Date","numeric"))
    str(activity)

    ## 'data.frame':    17568 obs. of  3 variables:
    ##  $ steps   : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ date    : Date, format: "2012-10-01" "2012-10-01" ...
    ##  $ interval: num  0 5 10 15 20 25 30 35 40 45 ...

`{ r} library(dplyr)`

### What is mean total number of steps taken per day?

1.  Calculate the total number of steps taken per day

<!-- -->

    steps_per_day <- aggregate(steps ~ date, data = activity, sum, na.rm = TRUE)
    head(steps_per_day)

    ##         date steps
    ## 1 2012-10-02   126
    ## 2 2012-10-03 11352
    ## 3 2012-10-04 12116
    ## 4 2012-10-05 13294
    ## 5 2012-10-06 15420
    ## 6 2012-10-07 11015

1.  If you do not understand the difference between a histogram and a
    barplot, research the difference between them. Make a histogram of
    the total number of steps taken each day

Difference: a histogram is used to see the distribution of a data. The
barplot is used to summarize the categorical data

histogram of the total number of steps taken each day

    hist(steps_per_day$steps, main = "Total steps taken per day", 
        xlab = "Steps", breaks = 16, col = "mediumpurple1")

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-2-1.png)

1.  Calculate and report the mean and median of the total number of
    steps taken per day

<!-- -->

    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    mean_median_steps_per_day <- group_by(activity, date) %>%
        summarise(mean = mean(steps, na.rm = TRUE),
                  median = median(steps, na.rm = TRUE))
    head(mean_median_steps_per_day)

    ## # A tibble: 6 x 3
    ##         date     mean median
    ##       <date>    <dbl>  <dbl>
    ## 1 2012-10-01      NaN     NA
    ## 2 2012-10-02  0.43750      0
    ## 3 2012-10-03 39.41667      0
    ## 4 2012-10-04 42.06944      0
    ## 5 2012-10-05 46.15972      0
    ## 6 2012-10-06 53.54167      0

### What is the average daily activity pattern

1.  Make a time series plot (i.e. type = "l") of the 5-minute
    interval (x-axis) and the average number of steps taken, averaged
    across all days (y-axis)

<!-- -->

    interval_steps <- group_by(activity, interval) %>%
                      summarise(mean = mean(steps, na.rm = TRUE))
    with(interval_steps, 
         plot(interval, mean, 
              type = "l", 
              xlab = "5-minute interval",
              ylab = "Average number of steps taken", lwd= 1.8, col = "dodgerblue"))

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-4-1.png)

1.  Which 5-minute interval, on average across all the days in the
    dataset, contains the maximum number of steps

<!-- -->

    max_steps_interval <- interval_steps$interval[which.max(interval_steps$mean)]
    max_steps_interval

    ## [1] 835

### Imputing missing values

Note that there are a number of days/intervals where there are missing
values (coded as NA). The presence of missing days may introduce bias
into some calculations or summaries of the data

1.  Calculate and report the total number of missing values in the
    dataset (i.e. the total number of rows with NAs)

<!-- -->

    sum(is.na(activity$steps))

    ## [1] 2304

The total number of rows of missing values is 2304

1.  Devise a strategy for filling in all of the missing values in
    the dataset. The strategy does not need to be sophisticated. For
    example, you could use the mean/median for that day, or the mean for
    that 5-minute interval, etc

I am going to substitue the missing values(NA's) with mean

1.  Create a new dataset that is equal to the original dataset but with
    the missing data filled in

I have created a new dataframe activity2 with the missing data filled in
with activity$steps

    activity2 <- activity
    activity2$steps[is.na(activity2$steps)] <- mean(na.omit(activity$steps))
    str(activity2)

    ## 'data.frame':    17568 obs. of  3 variables:
    ##  $ steps   : num  37.4 37.4 37.4 37.4 37.4 ...
    ##  $ date    : Date, format: "2012-10-01" "2012-10-01" ...
    ##  $ interval: num  0 5 10 15 20 25 30 35 40 45 ...

1.  Make a histogram of the total number of steps taken each day and
    Calculate and report the mean and median total number of steps taken
    per day. Do these values differ from the estimates from the first
    part of the assignment? What is the impact of imputing missing data
    on the estimates of the total daily number of steps

<!-- -->

    total_mean_median_day <- group_by(activity2, date) %>%
        summarise(total_steps = sum(steps),
                  mean_steps = mean(steps),
                  median_steps = median(steps))
    head(total_mean_median_day)

    ## # A tibble: 6 x 4
    ##         date total_steps mean_steps median_steps
    ##       <date>       <dbl>      <dbl>        <dbl>
    ## 1 2012-10-01    10766.19   37.38260      37.3826
    ## 2 2012-10-02      126.00    0.43750       0.0000
    ## 3 2012-10-03    11352.00   39.41667       0.0000
    ## 4 2012-10-04    12116.00   42.06944       0.0000
    ## 5 2012-10-05    13294.00   46.15972       0.0000
    ## 6 2012-10-06    15420.00   53.54167       0.0000

plot histograms of the total steps taken per day BEFORE and AFTER the
filling of missing data

    par(mfcol = c(2,1))

    hist(steps_per_day$steps, main = "Total steps per day BEFORE missing data filling", 
         xlab = "Steps", breaks = 16, col = "darkorchid", ylim = c(0,15))

    hist(total_mean_median_day$total_steps, main = "Total steps per day AFTER missing data filling", 
         xlab = "Steps", breaks = 16, col = "mediumorchid3")

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-9-1.png)

### Are there differences in activity patterns between weekdays and weekends

1.  Create a new factor variable in the dataset with two levels -
    "weekday" and "weekend" indicating whether a given date is a weekday
    or weekend day

<!-- -->

    weeks <- ifelse(weekdays(activity2$date) %in% c("Saturday", "Sunday"), "weekend", "weekday")
    weeks <- as.factor(weeks)
    activity2$weeks <- weeks
    str(activity2)

    ## 'data.frame':    17568 obs. of  4 variables:
    ##  $ steps   : num  37.4 37.4 37.4 37.4 37.4 ...
    ##  $ date    : Date, format: "2012-10-01" "2012-10-01" ...
    ##  $ interval: num  0 5 10 15 20 25 30 35 40 45 ...
    ##  $ weeks   : Factor w/ 2 levels "weekday","weekend": 1 1 1 1 1 1 1 1 1 1 ...

1.  Make a panel plot containing a time series plot (i.e. type = 'l') of
    the 5-minute interval (x-axis) and the average number of steps
    taken, averaged across all weekday days or weekend days (y-axis).
    See the README file in the GitHub repository to see an example of
    what this plot should look like using simulated data

<!-- -->

    average_steps_weeks <- group_by(activity2, weeks, interval) %>%
                         summarise(average_steps = mean(steps))

load lattice

    library(lattice)

plot histogram weekdays vs weekend

    xyplot(average_steps ~ interval | weeks, data = average_steps_weeks, type = "l", layout = c(1,2), 
                      xlab = "Interval", ylab = "Number of steps")

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-13-1.png)
