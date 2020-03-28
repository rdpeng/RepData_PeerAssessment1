---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---
# Introduction
In this analysis, we will inspect step count data, gathered in 5-minute chunks across a period of two months from a personal step-measuring device.  We will inspect and graph the individual's walking counts each day, and their average daily activity pattern.  Then, we will impute missing values in the dataset to see how this alters these graphs, and compare their weekend to weekday walking habits.

Notice that I have deviated from the Coursera instructions.pdf slightly, as they were more specific than the instructions on the Coursera project description, which I used to guide my analysis.  Rather than creating a factor variable to represent weekdays vs. weekends for instance, I track the day of the in numeric form from 1-7, 1 being Sunday and 7 being Saturday.  Any deviations are purely cosmetic, however.

### Analysis Dependencies
This analysis only depends upon the "lubridate" package for easily discerning which days, many years ago, were weekdays and which were weekends.  You would want to execute the following code to set up your envrionment to follow along, with the following line (uncommented of course).

```r
#install.packages("lubridate")
#library(lubridate)
```


### Loading the Data
Here we have unzipped the compressed folder "activity.zip" in to the folder "activity" which contains our CSV data in "activity.csv".  Taking a look at the data, you can see we have a series of step counts (often NA) as well as the date and a timestamp refering to the start of the 5 minute interval the device was measuring.


```r
stepdata<-read.csv(file = "activity/activity.csv")
head(stepdata)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```

We are extract more useful time and date information from these last two columns.  In particular, we will transmute the Date column into the R Date datatype and subtract away the first date count so we can track the number of days since the study began.  We will also record the day of the week that day is using lubridate's "wday" function, and ignore the time measurements given to instead track how many hours into the day the measurement period was taken, for easier interpretation.  

```r
stepdata[,2]<-as.Date(stepdata[,2])
firstday<-stepdata[1,2]
daycounts<-stepdata[,2]-firstday

stepdata<-cbind(stepdata, as.numeric(daycounts), wday(stepdata[,2]), 0:287*5/60)

names(stepdata)[4] <- "daycount"; names(stepdata)[5]<-"weekday"; names(stepdata)[6]<-"hour"
tail(stepdata)
```

```
##       steps       date interval daycount weekday     hour
## 17563    NA 2012-11-30     2330       60       6 23.50000
## 17564    NA 2012-11-30     2335       60       6 23.58333
## 17565    NA 2012-11-30     2340       60       6 23.66667
## 17566    NA 2012-11-30     2345       60       6 23.75000
## 17567    NA 2012-11-30     2350       60       6 23.83333
## 17568    NA 2012-11-30     2355       60       6 23.91667
```

# Analysis
### Finding the Daily Means
The first question we shall ask is "what are the daily means of the stepcounts?  To look at the data we will take our stepcounts and fit them into a matrix of 61 rows, one for each day,  and find the means for each day across them.  Then we will find the overall daily means and median of the dataset as a whole.  For the first portion of the analysis, we will be ignoring NA values in the stepcount.


```r
days<-0:60
daydata<-cbind(days,rep(0))
for( i in 0:60) {daydata[i,2]=sum(stepdata[ stepdata[,4]==i,1], na.rm=TRUE)}

dayav<- mean(daydata[,2])
daymed<- median(daydata[,2])
```

Let's look at a daily histogram of these values graphed with the mean and median of the dataset.


```r
plot(daydata, type="h", lwd=5, col= "aquamarine", ylab="Step Count", xlab = "Days In To Study")
abline(h=dayav, lwd=3, col="navy")
abline(h=daymed, lwd=2, col="blueviolet")
legend(0, 21500, legend=c("Mean", "Median"), col=c("navy", "blueviolet"), cex=0.8, lty=c(1,1), lwd=c(5,3))
```

![](PA1_template_files/figure-html/meanplots-1.png)<!-- -->

We can see that the individual was pretty consistently active taking around ten thousand steps a day, with some inconsistency around halfway through the dataset.  Additionally, we can see the first and final days were very inactive.  With our inspections of the head and the tail of the dataset as seen above, we know there were several missing values at the start and end of the dataset.  This is part of what motivates us to impute missing values later in the analysis.

### Graphing Average Daily Activity
Let's take a look at what the individual's average day looked like.  To do this, we rearrange the step data into 61 columns, with each of the 288 rows representing each of the 5 minute intervals the study split the day in to.  Notice we transmute the 288 counts on the X axis into hours (starting from midnight as hour zero) for ease of interpretation.


```r
daymatrix<-matrix(stepdata[,1], nrow=288, ncol=61)
minutemeans<-rowMeans(daymatrix, na.rm=TRUE)
plot(5*(0:287)/60, minutemeans, type="l", lwd=3, col="goldenrod", xlab="Hour of the Day", ylab="Average Step Count in Five Minute Spans")
abline(v=0:24, col="peachpuff")
```

![](PA1_template_files/figure-html/activity1-1.png)<!-- -->

We can see the individual usually stop activity completely around 10 pm, and wake up just befor 6 am.  The peak of their activity is around 8 am-- perhaps they walk to work?-- with sporadic activity throughout the day up until 7 pm, whereupon they usually are much more inactive until their likely sleep times.  So what, and when, is the peak of this activity?


```r
max(minutemeans)
```

```
## [1] 206.1698
```

```r
maxtime<-which.max(minutemeans)
# Number of maximum 5 minute interval
maxtime
```

```
## [1] 104
```

```r
# Hour of maximum activity
floor(maxtime*5/60)
```

```
## [1] 8
```

```r
# Minute of maximum activity
(maxtime*5)%%60
```

```
## [1] 40
```

So we see that the average peak of activity is around 206 steps in a five minute interval at 8:40 in the morning.

### Imputing Missing Values

As we saw before, some of our data is definitely missing, and may be skewing our data.  We are particularly suspicious of the first and final days we gathered data for.  How much exactly?  Let's find out!  First, how many missing values are there?


```r
sum(is.na(stepdata[,1]))
```

```
## [1] 2304
```

This is 2304 missing five-minute intervals-- about 8 entire days worth!  This is a significant portion of our data, and is likely to skew our understanding of the individuals patterns.  Our day-mean graph indicates that there are many days that the individual didn't take any steps, or almost none at all.  It's likely these days we are just missing data- so let's replace any missing timesteps with the average step count of the 5 minute chunks that we just graphed to find the daily activity pattern.  That way, any 'missing' days will be overwritten with the 'average' day.


```r
impdata<-stepdata
for(n in which(is.na(stepdata[,1]))) {
  impdata[n,1] <- minutemeans[n%%288+1]
}
```

Let's see how imputing daily step counts where activity is missing affects our dataset's means and medians.


```r
dayimpdata<-cbind(days,rep(0))
for( i in 0:61) {dayimpdata[i,2]=sum(impdata[ impdata[,4]==i,1])}

impav<- mean(dayimpdata[,2])
impmed<- median(dayimpdata[,2])

plot(daydata, type="h", lwd=5, col= "aquamarine", ylab="Step Counts with Imputed Values in Red", xlab = "Days In To Study", ylim=c(0,25000))
abline(h=dayav, lwd=3, col="navy")
abline(h=daymed, lwd=2, col="blueviolet")

par(new = T)
plot(dayimpdata[,1], dayimpdata[,2], pch=1, cex=1, lwd=2, col="deeppink3", axes=F, xlab=NA, ylab=NA, type="p",ylim=c(0,25000))
abline(h=impav, lwd=2, col="maroon", lty="dashed")
abline(h=impmed, lwd=1, col="salmon", lty="dotted")

legend(0, 25000, legend=c("Unimputed Mean", "Unimputed Median", "Imputed Mean", "Imputed Median"), col=c("navy", "blueviolet", "maroon", "salmon"), cex=0.8, lty=c(1,1,2,3), lwd=c(5,3,2,1))
```

![](PA1_template_files/figure-html/impgraphing-1.png)<!-- -->

The means and medians increase of course-- because we are adding count data where there used to be none.  The red circles, representing the daily means of the imputed dataset, largely match the original data on days where we had lots of data.  We see it diverging exclusively from the original dataset on days where there was very little recorded activity in the middle of our dataset.  These are where the red dots are drastically higher than the teal histogram.  And finally, we notice that even after imputing NA values, we still have 3 days with almost no activity.  These indicate days where activity was consistently recorded as being low, with few NA values.


### Graphing Weekend vs. Weekday Activity

Finally, let's inspect this imputed dataset, and see how the individual's daily activity differed between weekends and weekdays.  We use the output of lubridate's wday() function as described above, and split the imputed dataset in to weekend and weekday data, and reshape and take the means of the imputed total, and imputed weekday and weekend activities identically to how we did in our original daily activity graph. 


```r
impmatrix<-matrix(impdata[,1], nrow=288)
wendmatrix<-matrix(impdata[impdata[,5] %in% c(1,7),1 ], nrow=288)
wdaymatrix<-matrix(impdata[impdata[,5] %in% c(2,3,4,5,6),1 ], nrow=288)
impcount<-rowMeans(impmatrix)
wendcount<-rowMeans(wendmatrix)
wdaycount<-rowMeans(wdaymatrix)
plot(5*(0:287)/60, impcount, type="l", lwd=3, col="goldenrod", xlab="Hour of the Day", ylab="Average Imputed Step Count in Five Minute Spans",  ylim=c(0,300))
abline(v=0:24, col="peachpuff")
par(new=T)
with(as.data.frame(impcount), plot(5*(0:287)/60, wendcount, type="l", lwd=1, col="forestgreen", xlab="", ylab="", ylim=c(0,300), xaxt='n', yaxt='n'))
par(new=T)
with(as.data.frame(impcount), plot(5*(0:287)/60, wdaycount, type="l", lwd=1, col="red", xlab="", ylab="", ylim=c(0,300),xaxt='n', yaxt='n'))
legend(0, 300, legend=c("Total Imputed Average", "Weekend Imputed Average", "Weekday Imputed Average"), col=c("goldenrod", "forestgreen", "red"), cex=0.8, lty=c(1,1,1), lwd=c(5,3,3))
```

![](PA1_template_files/figure-html/wkdygraph-1.png)<!-- -->

We see that on weekends, the individual was less active between 5-8 am, and their peak activity was a little bit lower and later in the day.  They were more consistently active throughout the day on weekends however, and the majority of their activity after 8pm can probably be attributed to weekend activity.

# Conclusions

To sum up, we find that the individual walked around 10,000 steps a day, almost entirely between the hours of 5 am to 10 pm, that 8 days worth of missing values can be imputed with mean activity, but doing so still leaves about 3 days worth of improbably low activity unaccounted for, and that the individual was more active, but active later, on weekends than on weekdays.

