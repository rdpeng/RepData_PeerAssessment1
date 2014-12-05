---
title: 'Reproducible Research: Peer Assessment 1'
output:
  html_document:
    keep_md: true
---



## Loading and preprocessing the data


```r
<<<<<<< HEAD
suppressWarnings(library(data.table))  # need the fread() package
suppressWarnings(library(lubridate)) # useful for manipulating dates and times
=======
library(data.table)  # need the fread() package
library(lubridate) # useful for manipulating dates and times
>>>>>>> d36c76ccf0902fb25a206f73fcbe803f819e1c94
```

```
## Loading required package: methods
## 
## Attaching package: 'lubridate'
## 
## The following objects are masked from 'package:data.table':
## 
##     hour, mday, month, quarter, wday, week, yday, year
```

```r
unzip("./activity.zip")
dat <- fread("./activity.csv", sep = ",", na)  # read the acitivty.csv file
dat <- as.data.frame(dat) # convert class of dat to data frame
dat$date <- ymd(dat$date) # convert date to POSIXct format
```

Let's have a look at the data and the classes of each column:


```r
class(dat[, 1])
```

[1] "integer"

```r
class(dat[, 2])
```

[1] "POSIXct" "POSIXt" 

```r
class(dat[3])
```

[1] "data.frame"

## What is mean total number of steps taken per day?

The histogram of daily steps taken

```r
steps <- tapply(dat$steps, dat$date, sum, na.rm = T)  # daily steps taken

## Using base plotting
hist(steps, breaks = length(steps), col = "red")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

I now calculate the mean and median total number of steps taken per day:

```r
me <- mean(steps, na.rm = T) # calculate mean excluding NA's
md <- median(steps, na.rm = T)
```
The **mean total** and **median total** **steps taken per day** are, respectively, **9354.2295** and **10395**.


## What is the average daily activity pattern?


```r
library(plyr)  # we want to use "ddply" to calculate the mean of steps for a specific interval for all days 
```

```
## 
## Attaching package: 'plyr'
## 
## The following object is masked from 'package:lubridate':
## 
##     here
```

```r
means_interval_5 <- ddply(dat, "interval", summarise, mean(steps, na.rm = T))
names(means_interval_5)[2] <- "means"

plot(type = "l", x = means_interval_5$interval, y = means_interval_5$means, xlab = "5 minute intervals", ylab = "mean of steps per interval per day", main = "Time series of number of steps taken", col = "red", lwd = 1.5)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 

We now find the 5-minute interval that has the maximum number of steps:

```r
max_mean_interval <- means_interval_5[which.max(means_interval_5$means), ]$interval
```
The interval with the maximum (averaged) number of steps is **835**

## Imputing missing values

Let's now try to figure out the number of rows containing NA values.
The easiest way to do this is  to differentiate the number of rows of the original data frame and the new data frame after ommitting the rows containing NA values:

```r
count_na <- nrow(dat) - nrow(na.omit(dat))
```
It turns out that there are **2304 rows containing NA's**.

Another way to check this is using "is.na" and "nrow":
<<<<<<< HEAD

```r
na_bool <- is.na(dat$steps)
count_na_2 <- nrow(dat[na_bool, ])
```
The answer also turns out to be **2304** rows so our previous result is valid.

To account for the missing values I choose to replace all missing values with the mean of the 5-minute interval that each NA belongs to:

```r
# Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
# Create a new dataset that is equal to the original dataset but with the missing data filled in.

# I'm going to calculate the mean of each interval
# I'll then use these values to replace the missing values in the original data 
# frame

impute_mean <- function(x) {return(replace(x, is.na(x), mean(x, na.rm = TRUE)))}

dat <- cbind(dat, id = 1:nrow(dat))

interval_means <- ddply(dat, "interval", summarise, mean(steps, na.rm = T))
names(interval_means)[2] <- c("mean")

# imputed dataset
dat.i <- ddply(dat, ~ interval, transform, steps  = impute_mean(steps))
dat.i<- dat.i[order(dat.i$date), ] # re-ordering by date
dat.i$steps <- round(dat.i$steps, 2) # round steps to the nearst 2 decimals

# ### using impute() from the Hmisc library
# library(Hmisc)
# impute(dat[ndx, 1], dat[ndx, 3] == interval_means[1], )
# impute(dat, replace(x, is.na(x)), interval_means[2], )
```

Next we re-calculate the total of the daily steps and replot the histogram:

```r
# Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

daily_steps.i <- ddply(dat.i, ~ date, summarise, steps = sum(steps))
colnames(daily_steps.i) <- c("date", "steps")

hist(daily_steps.i$steps, col = "red", xlab = "Steps", 
     main = "Histogram of Daily Steps Taken", 
     breaks = length(daily_steps.i$date), bg = "grey")
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 

```r
# library(ggplot2)
# ggplot(daily_steps.i, aes(date, steps, colour = date)) +  # random colors would make the plot catchy
#         geom_point()
# geom_histogram()
# geom_histogram(data = daily_steps.i, aes(date, steps, colour = date))

# plot(type = "h", x = dat.i$steps, col = "red")
```

As for new mean and median (of the imputed data) they are:

```r
=======

```r
na_bool <- is.na(dat$steps)
count_na_2 <- nrow(dat[na_bool, ])
```
The answer also turns out to be **2304** rows so our previous result is valid.

To account for the missing values I choose to replace all missing values with the mean of the 5-minute interval that each NA belongs to:

```r
# Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
# Create a new dataset that is equal to the original dataset but with the missing data filled in.

# I'm going to calculate the mean of each interval
# I'll then use these values to replace the missing values in the original data 
# frame

impute_mean <- function(x) {return(replace(x, is.na(x), mean(x, na.rm = TRUE)))}

dat <- cbind(dat, id = 1:nrow(dat))

interval_means <- ddply(dat, "interval", summarise, mean(steps, na.rm = T))
names(interval_means)[2] <- c("mean")

# imputed dataset
dat.i <- ddply(dat, ~ interval, transform, steps  = impute_mean(steps))
dat.i<- dat.i[order(dat.i$date), ] # re-ordering by date
dat.i$steps <- round(dat.i$steps, 2) # round steps to the nearst 2 decimals

# ### using impute() from the Hmisc library
# library(Hmisc)
# impute(dat[ndx, 1], dat[ndx, 3] == interval_means[1], )
# impute(dat, replace(x, is.na(x)), interval_means[2], )
```

Next we re-calculate the total of the daily steps and replot the histogram:

```r
# Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

daily_steps.i <- ddply(dat.i, ~ date, summarise, steps = sum(steps))
colnames(daily_steps.i) <- c("date", "steps")

hist(daily_steps.i$steps, col = "red", xlab = "Steps", 
     main = "Histogram of Daily Steps Taken", 
     breaks = length(daily_steps.i$date), bg = "grey")
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 

```r
# library(ggplot2)
# ggplot(daily_steps.i, aes(date, steps, colour = date)) +  # random colors would make the plot catchy
#         geom_point()
# geom_histogram()
# geom_histogram(data = daily_steps.i, aes(date, steps, colour = date))

# plot(type = "h", x = dat.i$steps, col = "red")
```

As for new mean and median (of the imputed data) they are:

```r
>>>>>>> d36c76ccf0902fb25a206f73fcbe803f819e1c94
me.i <- mean(daily_steps.i$steps)
md.i <- median(daily_steps.i$steps)

# make a table of the original and imputed means & medians
me_md_table <- rbind(original = c(mean = me, median = md), imputed = c(me.i, md.i))
```
**10766** and **10766 ** respectively compared to **9354** and **10395**.

## Are there differences in activity patterns between weekdays and weekends?
Now let's check if there are any differences in activity patterns between weekdays and weekends.
To do this we need to split the data into steps taken on weekdays and others taken on weeends, assign them tags and recombine them into one dataset:

```r
<<<<<<< HEAD
# use suppressWarnings

=======
>>>>>>> d36c76ccf0902fb25a206f73fcbe803f819e1c94
dat.i$day <- weekdays(dat.i$date, abbreviate = T)

wkends <- dat.i[dat.i$day == c("Sat", "Sun"), ] # subset weekends
wkdays <- dat.i[dat.i$day == c("Mon", "Tue", "Wed", "Thu", "Fri"), ] # subset weekdays
```

```
## Warning: longer object length is not a multiple of shorter object length
```

```r
wkends$type <- "wkend" # assign tag "we" for weekends
wkdays$type <- "wkday" # assign tag "wd" for weekdays

dat.type <- rbind(wkends, wkdays)  # recombine the two sets
dat.type <- dat.type[order(dat.type$date), ] # order the set by date
```

Great, now let's calculuate the sum for each day again and do the the time series plot for each:

```r
means_type <- ddply(dat.type, ~ interval + type, summarise, mean = mean(steps))

# source: http://stackoverflow.com/a/25826949
library(reshape2)
melted <- melt(means_type, c("interval", "type")) # melting the data set by interval and type

library(ggplot2)
ggplot(melted, aes(interval, value, col = "red")) +
        facet_grid(type ~ ., ) + # faceting by type
        geom_line() + 
        labs(y = "mean of steps taken", title = "Time series of steps taken on weekdays and weekends")
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13.png) 

```r
# # another way is to plot both on the same graph.
# #source: http://r.789695.n4.nabble.com/Plotting-from-different-data-sources-on-the-same-plot-with-ggplot2-td835473.html
# ggplot(melted, aes(interval, value)) +
#         facet_grid(type ~ .) + 
#         geom_line(data = wkdays_t, col = "red") + 
#         geom_line(data = wkends_t, col = "green") + 
#         labs(y = "mean of steps taken", title = "Time series of steps taken on weekdays and weekends")
```

So we can see that activity over the weekend increases quite noticeably.
