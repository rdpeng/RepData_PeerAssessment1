# PA1_template
Joana  
28 December 2016  
######## Packages needed for the Project

```r
library(tidyr)
```

```
## Warning: package 'tidyr' was built under R version 3.3.2
```

```r
library(scales)
```

```
## Warning: package 'scales' was built under R version 3.3.2
```

```r
library(dplyr)
```

```
## Warning: package 'dplyr' was built under R version 3.3.2
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

```r
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.3.2
```

```r
library(rmarkdown)
```

```
## Warning: package 'rmarkdown' was built under R version 3.3.2
```
# **Project Assignment 1**

This is an R Markdown document.
This project aims to write a report about activity patterns following diferent criteria.


## *What is the mean total number of steps taken per day?*

1. Checking the dataset structure.


```r
act<-read.csv("activity.csv")
str(act)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```
2. Next step will be calculating the total steps per day and removing any missing values.


```r
rem<-filter(act,steps != "NA")
## calculate the total per day
total<-aggregate(rem$steps,by= list(rem$date),FUN=sum)
colnames(total)<-c("Days","Steps")
```

### Histogram of the total steps taken per day


```r
st<-hist(total$Steps,main="Histogram of number of steps taken per day",xlab="Total steps taken per day", col="skyblue")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

```r
print(st)
```

```
## $breaks
## [1]     0  5000 10000 15000 20000 25000
## 
## $counts
## [1]  5 12 28  6  2
## 
## $density
## [1] 1.886792e-05 4.528302e-05 1.056604e-04 2.264151e-05 7.547170e-06
## 
## $mids
## [1]  2500  7500 12500 17500 22500
## 
## $xname
## [1] "total$Steps"
## 
## $equidist
## [1] TRUE
## 
## attr(,"class")
## [1] "histogram"
```

######**Calculating the mean of the total steps taken per day**


```r
mean_act<-mean(total$Steps,na.rm=TRUE)
print(mean_act)
```

```
## [1] 10766.19
```
###### **Calculating the median of the total steps taken per day**

```r
median_act<-median(total$Steps,na.rm=TRUE)
print(median_act)
```

```
## [1] 10765
```

## *What is the average daily activity pattern?*

1. Calculate the 5-minute interval average steps taken per day


```r
avera<-aggregate(rem$steps,by= list(rem$interval),FUN=mean)
colnames(avera)<-c("interval","steps")
```

2. Time-series plot of the average steps taken per day in a 5 minute interval


```r
h<-ggplot(avera,aes(x=interval,y=steps))+geom_line(color="skyblue")+
  ggtitle("Time series of the average number of steps taken per 5-minute interval")+
  xlab("5 minute interval identifiers")+
  ylab("Average Steps taken per day")
print(h)
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

3. Which 5 minute interval accross all days contains the maximum number of steps


```r
avera$steps<-round(avera$steps,2)
max<-avera[which.max(avera$steps),]
print(max)
```

```
##     interval  steps
## 104      835 206.17
```

## *Imputting Missing Values*
1. Total number of missing values in the dataset?

```r
mis<-act[which(is.na(act)),]
dim(mis)
```

```
## [1] 2304    3
```
2. Strategy to fill the missing values in the dataset.

```r
impute<-act ## To create an empty DF with same dimensions
index<-is.na(impute$steps) ## To find the index of missing values
mis<-tapply(act$steps,act$interval,mean,na.rm=TRUE,simplify = TRUE) ##calculate new values
impute$steps[index]<-mis[as.character(impute$interval[index])]##replace them through index
```
3. New dataset with the filling values summed per day

```r
new <- tapply(impute$steps,impute$date, sum, na.rm=TRUE, simplify=T)
```

#### Histogram, Median and Mean


```r
par(mfrow = c(1,2))
hist(new, col = "dark blue",xlim=c(0,25000),ylim = c(0,40),main = paste("Histogram (Imputed)"),xlab= "Total steps taken per day",adj=0.5)
hist(total$Steps, col = "light blue",xlim=c(0,25000),ylim = c(0,40),main = paste("Histogram (Non-Imputed)"),xlab = "Total steps taken per day", adj=0.5)
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)<!-- -->



4. 
######**Calculating the mean of the total steps taken per day when imputting NA values***


```r
mean_new<-mean(new,na.rm=TRUE)
print(mean_new)
```

```
## [1] 10766.19
```
###### **Calculating the median of the total steps taken per day when imputying NA values**

```r
median_new<-median(new,na.rm=TRUE)
print(median_new)
```

```
## [1] 10766.19
```

Comparatively to the mean results, we achieve exactly the same value for both imputted data and non imputted, which is 10766.19 steps . 

We only see changes occurring at median level, once median takes into consideration the exactly the middle point of a number set, in which half the numbers are above the median and half are below, we have achieved exactly the same value for mean and median in the Imputted Dataset,of 10766.19 steps as well.


## *Are there differences in activity patterns between weekdays and weekends?*

1. This are the steps to create the new factor variable in the imputted dataframe.


```r
#Great input here from the ifelse conditions which very simply shows me how to tackle this matter, by using mutate to generate this extra column) ifelse(test, yes, no)
impute$date<-as.Date(impute$date,format="%Y-%m-%d") 
days<-c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")

impute<-mutate(impute, weektype=ifelse(weekdays(impute$date) == "Saturday"|weekdays(impute$date) =="Sunday","weekend","weekday"))

#creating the factor variable

impute$weektype<-as.factor(impute$weektype)

#oduble checked with grep('weekend',impute$weektype) if it was working
#[p-0we need now to summarize once more so we can plot the time series

week<-aggregate(steps~weektype+interval,data=impute,FUN=mean) 
```

2. Time series plot about activity based on the weektype


```r
p<-ggplot(week,aes(x=interval, y=steps, color = weektype))+geom_line()+ facet_grid(weektype~.)
print(p)
```

![](PA1_template_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

```
Thank you for your attention!

