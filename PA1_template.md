Loading and preprocessing the data
==================================

checking the structure of variables and converting them after
-------------------------------------------------------------

    activity<-read.csv("activity.csv")
    head(activity)

    ##   steps       date interval
    ## 1    NA 2012-10-01        0
    ## 2    NA 2012-10-01        5
    ## 3    NA 2012-10-01       10
    ## 4    NA 2012-10-01       15
    ## 5    NA 2012-10-01       20
    ## 6    NA 2012-10-01       25

    str(activity)

    ## 'data.frame':    17568 obs. of  3 variables:
    ##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...

    activity<-read.csv("activity.csv",colClasses = c("numeric","Date","numeric"))

mean total number of steps taken per day
========================================

histogram plot
--------------

    totalsteps_by_date<-tapply(activity$steps,activity$date,sum,na.rm=T)
    hist(totalsteps_by_date,main = "Total steps by date",xlab="total steps by date",breaks = 10,col="red")

![](PA_template_files/figure-markdown_strict/unnamed-chunk-2-1.png)
\#\#mean and median

    mean(totalsteps_by_date)

    ## [1] 9354.23

    median(totalsteps_by_date)

    ## [1] 10395

average daily activity pattern
==============================

    interval_mean<-tapply(activity$steps,activity$interval,mean,na.rm=T)
    plot(interval_mean,type="l",xlab="time(min)",ylab="avgerage total steps",main="average total steps")

![](PA_template_files/figure-markdown_strict/unnamed-chunk-4-1.png)

    max_steps<-max(interval_mean)
    interval_mean[max_steps==interval_mean]

    ##      835 
    ## 206.1698

Imputing missing values
=======================

number of missing value rows
----------------------------

    sum(is.na(activity))

    ## [1] 2304

    activity_nomiss<- transform(activity, steps = ifelse(is.na(steps), round(mean(steps, na.rm=TRUE)), steps))
    sum(is.na(activity_nomiss))

    ## [1] 0

replacing missing value by means and plotting histogram
-------------------------------------------------------

    new_steps_by_date<-tapply(activity_nomiss$steps,activity_nomiss$date,sum)
    hist(new_steps_by_date,main = "Total steps by date(no missing value",xlab="total steps by date",breaks = 10,col="red")

![](PA_template_files/figure-markdown_strict/unnamed-chunk-6-1.png)

mean and median of total sets(no missing values)
------------------------------------------------

    mean(new_steps_by_date)

    ## [1] 10751.74

    median(new_steps_by_date)

    ## [1] 10656

differences in activity patterns between weekdays and weekends
==============================================================

assigning weekdays and weekend level
------------------------------------

    activity_nomiss$days <- weekdays(activity_nomiss$date)
    library(plyr)
    activity_nomiss$days <- revalue(activity_nomiss$days,c("Monday"="weekday","Tuesday"="weekday","Wednesday"="weekday","Thursday"="weekday","Friday"="weekday"))
    activity_nomiss$days <- revalue(activity_nomiss$days,c("Saturday"="weekend","Sunday"="weekend"))

panel plot containing a time series plot of the 5-minute intervaland the average number of steps taken, averaged across all weekday days or weekend days.
---------------------------------------------------------------------------------------------------------------------------------------------------------

    library(lattice)
    activity_mean <- aggregate(steps ~ days+interval, data=activity_nomiss , FUN=mean)
    xyplot(steps ~ interval | factor(days),data=activity_mean,type="l")

![](PA_template_files/figure-markdown_strict/unnamed-chunk-9-1.png)
