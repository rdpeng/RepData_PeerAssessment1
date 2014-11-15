# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
First, set the working directory and create the figures directory.

```r
setwd("~/RepData_PeerAssessment1/")

if (!file.exists("./figures/")){
   dir.create("figures")
}
```
The creating of the figures directory is not actually required here, because the
`png` figures themselves are created in the supplement `code.R` file. It's still
here for completeness.

This part checks whether the file has been downloaded and unzipped, and if not
then it does it.

```r
act.file = "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"

if (!file.exists("activity.zip")){
   download.file(url=act.file,
                 destfile="activity.zip",
                 method="curl")
}

if (!file.exists("activity.csv")){
   unzip("activity.zip")   
}
```

Next, it reads the file to a data frame (`act.df`). Note that the dates are
read in the correct class.


```r
act.df <- read.csv("activity.csv",colClasses=c("numeric","Date","numeric"))
```

## What is mean total number of steps taken per day?

Now a new data frame `tot.step` is created to sum steps per day.


```r
tot.step <- aggregate(steps ~ date,data=act.df,FUN=sum)
```

And the plot:


```r
hist(tot.step$steps,
     breaks="FD",
     main=NULL,
     xlab="Total steps per day")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 

The resulting image:

The mean and the median of the total steps per day are:

```r
list(Mean=mean(tot.step$steps), Median=median(tot.step$steps))
```

```
## $Mean
## [1] 10766
## 
## $Median
## [1] 10765
```

## What is the average daily activity pattern?

The `aggregate()` function for this part is similar to the previous one.

```r
avg.int <- aggregate(steps ~ interval,data=act.df,FUN=mean)
```
The resulting image:

```r
plot(avg.int$interval,
     avg.int$steps,
     type="l",
     xlab="5-minute interval",
     ylab="Mean steps across days")
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

Finding the max value is easy:


```r
max.idx <- which.max(avg.int$steps)
```

Make the interval a little bit prettier, using modulo and integer division:


```r
max.hr <- avg.int[max.idx,]$interval %/% 100
max.mn <- avg.int[max.idx,]$interval %% 100
hr.mn <- paste(max.hr,":",max.mn,sep="")
```
And finally display it all:


```r
data.frame(AvgSteps=avg.int[max.idx,]$steps,
           Interval=avg.int[max.idx,]$interval,
           Time=hr.mn)
```

```
##   AvgSteps Interval Time
## 1    206.2      835 8:35
```

Not that both in the plot and in the data, there is a high peak at around 8:35.
I guess that this is the time the individual walks to work.

## Imputing missing values

The method I used for imputing NAs is to give each interval the average step per
interval calculated before. Note that I `round` the steps because steps can only
be an integer. The code is not trivial, so comments added in the code.


```r
# Create a data frame containing only the NA rows
act.na <- act.df[is.na(act.df$steps),]
# Split this data frame on the date, prerequisite for lapply
act.na.spl <- split(act.na,act.na$date)
# Transform the NA values to the rounded average values
act.na.appl <- lapply(act.na.spl,
                      FUN=transform,
                      steps=round(avg.int$steps))
# Unsplit the data frame
act.na.unspl <- unsplit(act.na.appl,act.na$date)
# Remove the NA rows from the original data frame
act.narm <- act.df[complete.cases(act.df),]
# Combine the NA-stripped and NA-transformed data frames
act.na.merged <- rbind(act.narm,act.na.unspl)
# Order the new data frame so it looks nice
act.df.na <- act.na.merged[order(act.na.merged$date,
                                 act.na.merged$interval),]
```

The next part is similar to the previous section, but with the new NA
transformed data frame.


```r
tot.step.na <- aggregate(steps ~ date,data=act.df.na,FUN=sum)

hist(tot.step.na$steps,
     breaks="FD",
     main=NULL,
     xlab="Total steps per day")
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13.png) 


```r
list(Mean=mean(tot.step.na$steps), Median=median(tot.step.na$steps))
```

```
## $Mean
## [1] 10766
## 
## $Median
## [1] 10762
```

The histogram shows a higher bin at the average value, which makes sense because
these are the values that were added. The mean remains the same. Median changes
only a little bit, showing that the data are skewed.

## Are there differences in activity patterns between weekdays and weekends?

The following chunk checks whether the date is a weekday or a weekend, then
factors it to two levels and combines it with the data frame.

```r
week.day <- factor(ifelse(weekdays(act.df.na$date) %in% c("Saturday","Sunday"),
                          "Weekend","Weekday"))
act.df.fac <- cbind(act.df.na,week.day)
```

Now to subset it according to the factors and calculate the means:


```r
act.wd <- act.df.fac[act.df.fac$week.day=="Weekday",]
act.we <- act.df.fac[act.df.fac$week.day=="Weekend",]
avg.int.wd <- aggregate(steps ~ interval,data=act.wd,FUN=mean)
avg.int.we <- aggregate(steps ~ interval,data=act.we,FUN=mean)
```

And create the plots.


```r
plot(avg.int.wd$interval,
     avg.int.wd$steps,
     type="l",
     xlab="5-minute interval",
     ylab="Mean steps across days",
     main="Weekdays")
```

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-171.png) 

```r
plot(avg.int.we$interval,
     avg.int.we$steps,
     type="l",
     xlab="5-minute interval",
     ylab="Mean steps across days",
     main="Weekends")
```

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-172.png) 

Results:

What can we learn from it? During weekdays, the individual starts walking
immediately at a specified time each day, and then the number of steps
increases again to a very strong peak. This probably means waking up with an
alarm clock, getting ready for work and then walking there. Most of the day is
spent in moderate walking.

During weekends, the "waking up" process is more gradual, and there is no
significant peak but the steps are rather spread roughly equally throughout
the entire day.
