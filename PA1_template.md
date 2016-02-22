# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data


First we read the data from the cloned local repository. 



```r
rm(list=ls())
setwd("/Users/macbookpro/Documents/Data Science/Reproducible Research/RepData_PeerAssessment1")
data <- read.csv(file="activity.csv")
```


## What is mean total number of steps taken per day?

We will use the the `dplyr` library to group and summarize the data.



```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```


We group the data into the `ByDay` dataframe. We sumarize the `ByDate` dataframe to obtain the `Daily` dataframe where we include the `Avg` and `Total` columns, containing the mean number of steps per interval on each day and the total number of steps per day, respectively. In all cases we ignore missing values with `na.rm = TRUE`.



```r
ByDay <- group_by(data,date)
Daily <-summarize(ByDay, Avg=mean(steps,na.rm=TRUE), Total=sum(steps,na.rm = TRUE))
```


Now we can compute the average daily number of steps, taking care to remove the missing values.



```r
avgdailysteps <- mean(Daily$Total, na.rm = TRUE)
```


We load the `xtable` package to be able to show the daily number of steps as a nice *html* table.



```r
library(xtable)
```

```
## Warning: package 'xtable' was built under R version 3.2.3
```


We put the table into `TT` to display it later. We change the names in `TT` so that the column names of the table are *human readable*.



```r
TT <- xtable(Daily,align="ccrr",digits=c(3,12,2,0),display=c("d","s","f","d"))
names(TT) <- c("Date","Average", "Total")
print(TT,type="html")
```

<!-- html table generated in R 3.2.2 by xtable 1.8-2 package -->
<!-- Mon Feb 22 03:40:11 2016 -->
<table border=1>
<tr> <th>  </th> <th> Date </th> <th> Average </th> <th> Total </th>  </tr>
  <tr> <td align="center"> 1 </td> <td align="center"> 2012-10-01 </td> <td align="right">  </td> <td align="right"> 0 </td> </tr>
  <tr> <td align="center"> 2 </td> <td align="center"> 2012-10-02 </td> <td align="right"> 0.44 </td> <td align="right"> 126 </td> </tr>
  <tr> <td align="center"> 3 </td> <td align="center"> 2012-10-03 </td> <td align="right"> 39.42 </td> <td align="right"> 11352 </td> </tr>
  <tr> <td align="center"> 4 </td> <td align="center"> 2012-10-04 </td> <td align="right"> 42.07 </td> <td align="right"> 12116 </td> </tr>
  <tr> <td align="center"> 5 </td> <td align="center"> 2012-10-05 </td> <td align="right"> 46.16 </td> <td align="right"> 13294 </td> </tr>
  <tr> <td align="center"> 6 </td> <td align="center"> 2012-10-06 </td> <td align="right"> 53.54 </td> <td align="right"> 15420 </td> </tr>
  <tr> <td align="center"> 7 </td> <td align="center"> 2012-10-07 </td> <td align="right"> 38.25 </td> <td align="right"> 11015 </td> </tr>
  <tr> <td align="center"> 8 </td> <td align="center"> 2012-10-08 </td> <td align="right">  </td> <td align="right"> 0 </td> </tr>
  <tr> <td align="center"> 9 </td> <td align="center"> 2012-10-09 </td> <td align="right"> 44.48 </td> <td align="right"> 12811 </td> </tr>
  <tr> <td align="center"> 10 </td> <td align="center"> 2012-10-10 </td> <td align="right"> 34.38 </td> <td align="right"> 9900 </td> </tr>
  <tr> <td align="center"> 11 </td> <td align="center"> 2012-10-11 </td> <td align="right"> 35.78 </td> <td align="right"> 10304 </td> </tr>
  <tr> <td align="center"> 12 </td> <td align="center"> 2012-10-12 </td> <td align="right"> 60.35 </td> <td align="right"> 17382 </td> </tr>
  <tr> <td align="center"> 13 </td> <td align="center"> 2012-10-13 </td> <td align="right"> 43.15 </td> <td align="right"> 12426 </td> </tr>
  <tr> <td align="center"> 14 </td> <td align="center"> 2012-10-14 </td> <td align="right"> 52.42 </td> <td align="right"> 15098 </td> </tr>
  <tr> <td align="center"> 15 </td> <td align="center"> 2012-10-15 </td> <td align="right"> 35.20 </td> <td align="right"> 10139 </td> </tr>
  <tr> <td align="center"> 16 </td> <td align="center"> 2012-10-16 </td> <td align="right"> 52.38 </td> <td align="right"> 15084 </td> </tr>
  <tr> <td align="center"> 17 </td> <td align="center"> 2012-10-17 </td> <td align="right"> 46.71 </td> <td align="right"> 13452 </td> </tr>
  <tr> <td align="center"> 18 </td> <td align="center"> 2012-10-18 </td> <td align="right"> 34.92 </td> <td align="right"> 10056 </td> </tr>
  <tr> <td align="center"> 19 </td> <td align="center"> 2012-10-19 </td> <td align="right"> 41.07 </td> <td align="right"> 11829 </td> </tr>
  <tr> <td align="center"> 20 </td> <td align="center"> 2012-10-20 </td> <td align="right"> 36.09 </td> <td align="right"> 10395 </td> </tr>
  <tr> <td align="center"> 21 </td> <td align="center"> 2012-10-21 </td> <td align="right"> 30.63 </td> <td align="right"> 8821 </td> </tr>
  <tr> <td align="center"> 22 </td> <td align="center"> 2012-10-22 </td> <td align="right"> 46.74 </td> <td align="right"> 13460 </td> </tr>
  <tr> <td align="center"> 23 </td> <td align="center"> 2012-10-23 </td> <td align="right"> 30.97 </td> <td align="right"> 8918 </td> </tr>
  <tr> <td align="center"> 24 </td> <td align="center"> 2012-10-24 </td> <td align="right"> 29.01 </td> <td align="right"> 8355 </td> </tr>
  <tr> <td align="center"> 25 </td> <td align="center"> 2012-10-25 </td> <td align="right"> 8.65 </td> <td align="right"> 2492 </td> </tr>
  <tr> <td align="center"> 26 </td> <td align="center"> 2012-10-26 </td> <td align="right"> 23.53 </td> <td align="right"> 6778 </td> </tr>
  <tr> <td align="center"> 27 </td> <td align="center"> 2012-10-27 </td> <td align="right"> 35.14 </td> <td align="right"> 10119 </td> </tr>
  <tr> <td align="center"> 28 </td> <td align="center"> 2012-10-28 </td> <td align="right"> 39.78 </td> <td align="right"> 11458 </td> </tr>
  <tr> <td align="center"> 29 </td> <td align="center"> 2012-10-29 </td> <td align="right"> 17.42 </td> <td align="right"> 5018 </td> </tr>
  <tr> <td align="center"> 30 </td> <td align="center"> 2012-10-30 </td> <td align="right"> 34.09 </td> <td align="right"> 9819 </td> </tr>
  <tr> <td align="center"> 31 </td> <td align="center"> 2012-10-31 </td> <td align="right"> 53.52 </td> <td align="right"> 15414 </td> </tr>
  <tr> <td align="center"> 32 </td> <td align="center"> 2012-11-01 </td> <td align="right">  </td> <td align="right"> 0 </td> </tr>
  <tr> <td align="center"> 33 </td> <td align="center"> 2012-11-02 </td> <td align="right"> 36.81 </td> <td align="right"> 10600 </td> </tr>
  <tr> <td align="center"> 34 </td> <td align="center"> 2012-11-03 </td> <td align="right"> 36.70 </td> <td align="right"> 10571 </td> </tr>
  <tr> <td align="center"> 35 </td> <td align="center"> 2012-11-04 </td> <td align="right">  </td> <td align="right"> 0 </td> </tr>
  <tr> <td align="center"> 36 </td> <td align="center"> 2012-11-05 </td> <td align="right"> 36.25 </td> <td align="right"> 10439 </td> </tr>
  <tr> <td align="center"> 37 </td> <td align="center"> 2012-11-06 </td> <td align="right"> 28.94 </td> <td align="right"> 8334 </td> </tr>
  <tr> <td align="center"> 38 </td> <td align="center"> 2012-11-07 </td> <td align="right"> 44.73 </td> <td align="right"> 12883 </td> </tr>
  <tr> <td align="center"> 39 </td> <td align="center"> 2012-11-08 </td> <td align="right"> 11.18 </td> <td align="right"> 3219 </td> </tr>
  <tr> <td align="center"> 40 </td> <td align="center"> 2012-11-09 </td> <td align="right">  </td> <td align="right"> 0 </td> </tr>
  <tr> <td align="center"> 41 </td> <td align="center"> 2012-11-10 </td> <td align="right">  </td> <td align="right"> 0 </td> </tr>
  <tr> <td align="center"> 42 </td> <td align="center"> 2012-11-11 </td> <td align="right"> 43.78 </td> <td align="right"> 12608 </td> </tr>
  <tr> <td align="center"> 43 </td> <td align="center"> 2012-11-12 </td> <td align="right"> 37.38 </td> <td align="right"> 10765 </td> </tr>
  <tr> <td align="center"> 44 </td> <td align="center"> 2012-11-13 </td> <td align="right"> 25.47 </td> <td align="right"> 7336 </td> </tr>
  <tr> <td align="center"> 45 </td> <td align="center"> 2012-11-14 </td> <td align="right">  </td> <td align="right"> 0 </td> </tr>
  <tr> <td align="center"> 46 </td> <td align="center"> 2012-11-15 </td> <td align="right"> 0.14 </td> <td align="right"> 41 </td> </tr>
  <tr> <td align="center"> 47 </td> <td align="center"> 2012-11-16 </td> <td align="right"> 18.89 </td> <td align="right"> 5441 </td> </tr>
  <tr> <td align="center"> 48 </td> <td align="center"> 2012-11-17 </td> <td align="right"> 49.79 </td> <td align="right"> 14339 </td> </tr>
  <tr> <td align="center"> 49 </td> <td align="center"> 2012-11-18 </td> <td align="right"> 52.47 </td> <td align="right"> 15110 </td> </tr>
  <tr> <td align="center"> 50 </td> <td align="center"> 2012-11-19 </td> <td align="right"> 30.70 </td> <td align="right"> 8841 </td> </tr>
  <tr> <td align="center"> 51 </td> <td align="center"> 2012-11-20 </td> <td align="right"> 15.53 </td> <td align="right"> 4472 </td> </tr>
  <tr> <td align="center"> 52 </td> <td align="center"> 2012-11-21 </td> <td align="right"> 44.40 </td> <td align="right"> 12787 </td> </tr>
  <tr> <td align="center"> 53 </td> <td align="center"> 2012-11-22 </td> <td align="right"> 70.93 </td> <td align="right"> 20427 </td> </tr>
  <tr> <td align="center"> 54 </td> <td align="center"> 2012-11-23 </td> <td align="right"> 73.59 </td> <td align="right"> 21194 </td> </tr>
  <tr> <td align="center"> 55 </td> <td align="center"> 2012-11-24 </td> <td align="right"> 50.27 </td> <td align="right"> 14478 </td> </tr>
  <tr> <td align="center"> 56 </td> <td align="center"> 2012-11-25 </td> <td align="right"> 41.09 </td> <td align="right"> 11834 </td> </tr>
  <tr> <td align="center"> 57 </td> <td align="center"> 2012-11-26 </td> <td align="right"> 38.76 </td> <td align="right"> 11162 </td> </tr>
  <tr> <td align="center"> 58 </td> <td align="center"> 2012-11-27 </td> <td align="right"> 47.38 </td> <td align="right"> 13646 </td> </tr>
  <tr> <td align="center"> 59 </td> <td align="center"> 2012-11-28 </td> <td align="right"> 35.36 </td> <td align="right"> 10183 </td> </tr>
  <tr> <td align="center"> 60 </td> <td align="center"> 2012-11-29 </td> <td align="right"> 24.47 </td> <td align="right"> 7047 </td> </tr>
  <tr> <td align="center"> 61 </td> <td align="center"> 2012-11-30 </td> <td align="right">  </td> <td align="right"> 0 </td> </tr>
   </table>


Now, we can show a histogram of the total number of steps take daily, we adjust the number of breaks and anotate it apropiately. 



```r
hist(Daily$Total,breaks=8,col="lightgreen",main="Total Number of Steps", xlab="Daily Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)


We compute the mean and median of the total number of steps taken daily, taking care to remove any missing values.



```r
meansteps <- mean(Daily$Total,na.rm=TRUE)
mediansteps <- median(Daily$Total,na.rm=TRUE)
```

The computed values are `meansteps=`9354.2295082 and `mediansteps=`10395.

## What is the average daily activity pattern?


Now we need to group by `interval` and summarize accordingly. In `Intervaly` we collect the average number of steps taken on each interval across all days, taking care to remove any missing values with `na.rm=TRUE`.



```r
ByInterval <- group_by(data,interval)
Intervaly <-summarize(ByInterval, Avg=mean(steps,na.rm=TRUE))
```


Now we can plot the average number of steps from `Intervaly` to show how it varies along the 5-minute intervals. Note that the hour is encoded in the interval in such a way that interval corresponding to 800 is really 8:00.


```r
plot(Intervaly$interval,Intervaly$Avg,type="l",main="Daily Activity Pattern",xlab="Interval",cex.axis=0.8,xaxp=c(0,2400,12),ylab="Interval Average",col="blue")
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)


We compute which interval has the maximum average of steps, as follows: 



```r
m <- which(Intervaly$Avg==max(Intervaly$Avg))
print(m)
```

```
## [1] 104
```

The interval where the maximum average number of steps occurs is the 104th, corresponding to time 835. 

In *human readable* terms the interval corresponds to:



```r
hours <- Intervaly$interval[m] %/% 100
minutes <- Intervaly$interval[m] %% 100
maxtimestart <- sprintf("%02d:%02d",hours,minutes)
```

Since the time interval already encodes the time the step measurement is taken, we can say that the 5-minute where the maximum activity occurs is the one begining at 08:35.

## Imputing missing values


We need to know the number of NAs in the dataset. We will store that number in `numnas` and the total number of registers in `totrow`


```r
numnas <- sum(is.na(data$step))
totrow <- length(data$step) 

numnas
```

```
## [1] 2304
```

```r
totrow
```

```
## [1] 17568
```


We will use the mean number of steps for each interval to fill in any missing data. To that effect, we need an array that shows where the NAs are and we will substitute those NAs by the corresponding values.



```r
wherenas <- is.na(data$step)
newdata <- cbind(data,Avg=Intervaly$Avg)
newdata$steps[wherenas] <- newdata$Avg[wherenas]
```


Now we repeat the previous analysis to try to understand the effect of filling in the NAs.



```r
NewByDay <- group_by(newdata,date)
NewDaily <-summarize(NewByDay, Avg=mean(steps,na.rm=TRUE), Total=sum(steps,na.rm = TRUE))
```


We now compute the mean and median of the total number of daily steps taken.



```r
newmeansteps <- mean(NewDaily$Total)
newmediansteps <- median(NewDaily$Total)
```

Since we need to compare with the previous results, we will use a table.


```r
DF <- data.frame(NAs_Removed=c(meansteps,mediansteps),NAs_FilledIn=c(newmeansteps,newmediansteps),row.names=c("Mean","Median"))

print(xtable(DF), type="html")
```

<!-- html table generated in R 3.2.2 by xtable 1.8-2 package -->
<!-- Mon Feb 22 03:40:11 2016 -->
<table border=1>
<tr> <th>  </th> <th> NAs_Removed </th> <th> NAs_FilledIn </th>  </tr>
  <tr> <td align="right"> Mean </td> <td align="right"> 9354.23 </td> <td align="right"> 10766.19 </td> </tr>
  <tr> <td align="right"> Median </td> <td align="right"> 10395.00 </td> <td align="right"> 10766.19 </td> </tr>
   </table>


Clearly, filling in the NAs has an effect on both the mean and median number of daily steps, increasing both.


We will now repeat the histogram, and determine what changes ocurr when we fill in the NAs.


```r
hist(NewDaily$Total,breaks=8,col="lightblue",main="Total Number of Steps", xlab="Daily Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-15-1.png)

Some changes are apparent, but we will see them more clearly if we place both histograms 
side by side and use the same scales.

First we need to make sure that we can capture the maximum of the frecuency in each histogram while keeping the `breaks` the same. To do this we will capture the `counts` in each histogram.


```r
oldhist <- hist(Daily$Total,breaks=8, plot=FALSE)
newhist <- hist(NewDaily$Total,breaks=8, plot=FALSE)

maxcount <- max(max(oldhist$counts),max(newhist$counts))
```

Now we can show the histograms with the correct vertical scale using the `ylim` parameter.


```r
op <- par(mfrow=c(1,2))

hist(Daily$Total, breaks=8, col="lightgreen", 
     main="Total Number of Steps\nNAs removed", 
     xlab="Daily Steps", 
     ylim=c(0,maxcount)
     )


hist(NewDaily$Total, breaks=8, col="lightblue",
     main="Total Number of Steps\nNAs filled in", 
     xlab="Daily Steps", 
     ylim=c(0,maxcount)
     )
```

![](PA1_template_files/figure-html/unnamed-chunk-17-1.png)

```r
par(op)
```


## Are there differences in activity patterns between weekdays and weekends?

First, we add the day of the week as a column to the `newdata` data frame, which has all the missing values from the original data filled in with the mean number of steps for the interval. Then, we determine which days of the week correspond to the weekend and create a new data frame; `finaldata` which has all that information.

The column `kind` is a factor with two levels `weekend` and `weekday`.



```r
newdataWd <- cbind(newdata, day=weekdays(as.Date(newdata$date), abbreviate=TRUE))
weekend <- (newdataWd$day == "Sat") | ((newdataWd$day == "Sun"))
finaldata <- cbind(newdataWd,kind=as.factor(c("weekday","weekend")[weekend+1]))
```


Now we need to group, first by kind and then by interval. The data frame `KindIntervaly` will summarize the mean number of steps by interval and kind of day of the week.



```r
ByKindInterval <- group_by(group_by(finaldata,kind), interval, add=TRUE)
groups(ByKindInterval)
```

```
## [[1]]
## kind
## 
## [[2]]
## interval
```

```r
KindIntervaly <-summarize(ByKindInterval, Avg=mean(steps))
```


Now we use the `lattice` package to create a panel plot where we can see the weekend and weekday activity pattern. 



```r
library(lattice)
xyplot(Avg~interval|kind,data=KindIntervaly, layout=c(1,2),type="l",
       xaxp=c(0,2400,12),
       xlab="Interval",ylab="Mean number of steps",
       main="Weekend vs. Weekday Activity Pattern",
       scales = list(x=list(tick.number=12, axs="i")),
       col="blue"
       )
```

![](PA1_template_files/figure-html/unnamed-chunk-20-1.png)


We can clearly see that the weekend activity pattern is different from the weekday activity pattern. The weekend has high variation of activity across the day and lower overall values while the weekday activity pattern has a sharp increase very early in the morning arond 5:30 and a large spike near 8:30.

The graph is quite possibly showing that people get up early during weekdays and stay in bed longer during weekends. The large spike possibly reflects a morning workout during the weekdays.
