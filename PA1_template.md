# PeerAssignment1

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

#Assignment

Loading and preprocessing the data

Show any code that is needed to

1) Load the data (i.e. read.csv())

2) Process/transform the data (if necessary) into a format suitable for your analysis


```r
library(timeDate)
```

```
## Warning: package 'timeDate' was built under R version 3.2.2
```

```r
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.2.2
```

```r
library(scales)
library(Hmisc)
```

```
## Warning: package 'Hmisc' was built under R version 3.2.2
```

```
## Loading required package: grid
## Loading required package: lattice
## Loading required package: survival
## Loading required package: Formula
```

```
## Warning: package 'Formula' was built under R version 3.2.2
```

```
## 
## Attaching package: 'Hmisc'
## 
## The following objects are masked from 'package:base':
## 
##     format.pval, round.POSIXt, trunc.POSIXt, units
```

```r
assign1data <- read.csv("activity.csv")
```

##Question 1
What is mean total number of steps taken per day?

For this part of the assignment, you can ignore the missing values in the dataset.

Calculate the total number of steps taken per day

If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day


Calculate and report the mean and median of the total number of steps taken per day

Using aggregate function, sum, mean and median per day and per interval are computed

Overall mean and median are also computed


```r
smstpsaggdata <- aggregate(steps ~ date, assign1data, sum)

mnstpsaggdata <- aggregate(steps ~ date, assign1data, mean)

mdstpsaggdata <- aggregate(steps ~ date, assign1data, median)

smstpsaggdataint <- aggregate(steps ~ interval, assign1data, sum)

mnstpsaggdataint <- aggregate(steps ~ interval, assign1data, mean)

mdstpsaggdataint <- aggregate(steps ~ interval, assign1data, median)

mnstpsperday <- mean(assign1data$steps, na.rm = T)

mdstpsperday <- median(assign1data$steps, na.rm = T)

qplot(data = smstpsaggdata, x = date, y = steps, geom ="histogram", stat = "identity")
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

##Question 2

What is the average daily activity pattern?

Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?



```r
ggplot(data=mnstpsaggdataint, aes(x=interval, y=steps)) +
  geom_line() +
  xlab("5-minute interval") +
  ylab("mean of number of steps taken")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 

```r
maxstpint <- mnstpsaggdataint[which.max(mnstpsaggdataint$steps),1]
```

835 is the interval when max average steps occur

##Question 3

Imputing missing values

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

Create a new dataset that is equal to the original dataset but with the missing data filled in.

Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

Filling is done with mean number of steps in that interval


```r
no_of_NAs <- sum(!complete.cases(assign1data$steps))

filleddata <- transform(assign1data, steps = ifelse(is.na(assign1data$steps), 
                                                smstpsaggdataint$steps[match(assign1data$interval, smstpsaggdataint$interval)], assign1data$steps))

smstpsaggdatafill <- aggregate(steps ~ date, filleddata, sum)

mnstpsaggdatafill <- aggregate(steps ~ date, filleddata, mean)

mdstpsaggdatafill <- aggregate(steps ~ date, filleddata, median)

smstpsaggdataintfill <- aggregate(steps ~ interval, filleddata, sum)

mnstpsaggdataintfill <- aggregate(steps ~ interval, filleddata, mean)

mdstpsaggdataintfill <- aggregate(steps ~ interval, filleddata, median)

mnstpsperdayfill <- mean(filleddata$steps, na.rm = T)

mdstpsperdayfill <- median(filleddata$steps, na.rm = T)

qplot(data = smstpsaggdatafill, x = date, y = steps, geom ="histogram", stat = "identity")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 

After filling, the mean changes in a big way. But median remains at 0

*Results after execution*

> mnstpsperday
[1] 37.3826
> mdstpsperday
[1] 0
> mnstpsperdayfill
[1] 292.3197
> mdstpsperdayfill
[1] 0

##Question 4

Are there differences in activity patterns between weekdays and weekends?

For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data

*isWeekday function is to find out the weekdays*

The top half of the plot is for Weekend days(FALSE) and the bottom half is for weekdays(TRUE)


```r
filleddata$IsWeekDay <- isWeekday(as.Date(filleddata$date))

mnstpsaggdataintfillWkday <- aggregate(steps ~ interval + IsWeekDay, filleddata, mean)

ggplot(data=mnstpsaggdataintfillWkday, aes(x=interval, y=steps)) +
  geom_line() +  facet_grid(IsWeekDay ~ .) +
  xlab("5-minute interval") +
  ylab("mean of number of steps taken")
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png) 



