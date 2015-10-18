# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data

First, I load the data and extract only data without NAs

```r
activity<-read.csv("activity.csv")
activity2<-activity[complete.cases(activity),]
```

## What is mean total number of steps taken per day?

In the next step, I load dplyr library to group data by date and summarize steps.
Next, I use the histogram function and calculate the mean value.


```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
byDay<-activity2 %>% group_by(date)%>%summarise(steps=sum(steps))
hist(byDay$step)
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

```r
mean(byDay$step)
```

```
## [1] 10766.19
```

## What is the average daily activity pattern?

Again, I use the dplyr function, this time with grouping by interval.


```r
byInterval<-activity2 %>% group_by(interval)%>%summarise(steps=mean(steps))

plot(byInterval$interval,byInterval$steps,xlab="Time interval",ylab="Avg number of steps",main="Average number of steps by five min intervals",pch=16)
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 
## Imputing missing values

The hardest part of the job.
I calculate and save the mean value for every 5 min interval. 
Then if there is NA I would insert the mean value instead for the interval instead of NA.
This is done here using a for loop.


```r
byInterval<-activity2 %>% group_by(interval)%>%summarise_each(funs(mean))
sum(is.na(activity))
```

```
## [1] 2304
```

```r
activity_new<-activity
for (i in 1:17568)
{        if (is.na(activity[i,1])==TRUE){
                activity_new[i,1]=as.numeric(byInterval[byInterval$interval==activity[i,3],2])
      }
     }

byDay_new<-activity_new %>% group_by(date)%>%summarise(steps=sum(steps))
hist(byDay_new$step)
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 

```r
mean(byDay_new$step)
```

```
## [1] 10766.19
```

```r
median(byDay_new$step)
```

```
## [1] 10766.19
```

## Are there differences in activity patterns between weekdays and weekends?
I used factor variable to extract days of the week, 
then I used a loop to have either free day or work day (I didn't swith the R studio
language, therefore my test values are in Czech. Nevermind, the only difference would
be to use Monday, Tuesday, Wednesday, Thursday and Friday instead of Po-Pá)



```r
activity_new$Day<-weekdays(as.Date(activity_new[,2]))

activity_new$Work=0
for (i in 1:17568)
{        if (activity_new[i,"Day"] %in% c("pondělí","úterý","středa","čtvrtek","pátek")){
                activity_new[i,"Work"]=1
        } else {
                activity_new[i,"Work"]=0}
}
         
activity_new$Work<-as.factor(activity_new$Work)

activity_new_work<-activity_new[activity_new$Work==1,]
activity_new_free<-activity_new[activity_new$Work==0,]
byInterval_free<-activity_new_free %>% group_by(interval)%>%summarise(steps=mean(steps))
byInterval_work<-activity_new_work %>% group_by(interval)%>%summarise(steps=mean(steps))
par(mfrow = c(1,2))
plot(byInterval_work$interval,byInterval_work$steps)
plot(byInterval_free$interval,byInterval_work$steps)
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png) 
