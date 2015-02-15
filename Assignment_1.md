---
title: "Peer Assignment 1"
author: "Antoni Riady Lewa"
date: "Saturday, February 14, 2015"
output: html_document
---
===============================================================================================

####Loading and preprocessing the data
Below are the codes used to load the data as well as the necessary libraries used in this analysis
```{r, echo=TRUE,warning=FALSE,message=FALSE}
rm(list=ls())
setwd("C:\\Users\\AntoniRiady\\Dropbox\\Projects\\Coursera\\Reproducible Research\\Assignment 1")
library(dplyr)
library(lattice)
library(ggplot2)
data <-read.csv("activity.csv")
```
Grouping the data based on dates and intervals..
```{r, echo=TRUE,warning=FALSE,message=FALSE}
data_by_date<-group_by(data,date)
data_by_interval<-group_by(data,interval)
```

####What is mean total number of steps taken per day?
1. Calculate the total number of steps taken per day
```{r, echo=TRUE,warning=FALSE,message=FALSE}
sum_data_by_date<-summarize(data_by_date,sum(steps,na.rm=TRUE))
names(sum_data_by_date)<-c("Date","Sum")
sum_data_by_date
```
2. If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day
```{r, echo=TRUE,warning=FALSE,message=FALSE}
hist(sum_data_by_date$Sum,data=sum_data_by_date,xlab="Total Number of Steps/Day",main="Distribution of Total Number of Steps Taken per Day")
```





3.Calculate and report the mean and median of the total number of steps taken per day
```{r, echo=TRUE,warning=FALSE,message=FALSE}
mean_data_by_date<-summarize(data_by_date,mean(steps,na.rm=TRUE))
names(mean_data_by_date)<-c("Date","Mean")
mean_data_by_date
median_data_by_date<-summarize(data_by_date,median(steps,na.rm=TRUE))
names(median_data_by_date)<-c("Date","Median")
median_data_by_date
```

####What is the average daily activity pattern?
1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
```{r, echo=TRUE,warning=FALSE,message=FALSE}
mean_data_by_interval<-summarize(data_by_interval,mean(steps,na.rm=TRUE))
names(mean_data_by_interval)<-c("Interval","Mean")
plot(mean_data_by_interval$Interval,mean_data_by_interval$Mean,type="l",xlab="Interval",ylab="Mean Steps",main="Mean Number of Steps Taken\nAcross All Days")
```






2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
```{r, echo=TRUE,warning=FALSE,message=FALSE}
mean_data_by_interval[mean_data_by_interval$Mean>=max(mean_data_by_interval$Mean),"Interval"]
```

####Imputing missing values
1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
```{r, echo=TRUE,warning=FALSE,message=FALSE}
sum(!complete.cases(data))
```
2. & 3. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

Create a new dataset that is equal to the original dataset but with the missing data filled in.
```{r, echo=TRUE,warning=FALSE,message=FALSE}
#replacing NA values with 0
data_edited<-data%>%mutate(steps=ifelse(is.na(steps),0,steps))
data_by_date_edited<-group_by(data_edited,date)
sum_data_by_date_edited<-summarize(data_by_date_edited,sum(steps,na.rm=TRUE))
names(sum_data_by_date_edited)<-c("Date","Sum")
```
4. Make a histogram of the total number of steps taken each day 
```{r, echo=TRUE,warning=FALSE,message=FALSE}
hist(sum_data_by_date_edited$Sum,data=sum_data_by_date_edited,xlab="Total Number of Steps/Day",main="Distribution of Total Number of Steps Taken per Day\n(After Imputing Missing Values)")
```


and Calculate and report the mean and median total number of steps taken per day. 
```{r, echo=TRUE,warning=FALSE,message=FALSE}
mean_data_by_date_edited<-summarize(data_by_date_edited,mean(steps,na.rm=TRUE))
names(mean_data_by_date_edited)<-c("Date","Mean")
mean_data_by_date_edited
median_data_by_date_edited<-summarize(data_by_date_edited,median(steps,na.rm=TRUE))
names(median_data_by_date_edited)<-c("Date","Median")
median_data_by_date_edited
```

Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?
```{r, echo=TRUE,warning=FALSE,message=FALSE}
mean_data_by_date_before<-mean_data_by_date
names(mean_data_by_date_before)<-c("Date","Mean Before")
merge(mean_data_by_date_before,mean_data_by_date_edited)

median_data_by_date_before<-median_data_by_date
names(median_data_by_date_before)<-c("Date","Median Before")
merge(median_data_by_date_before,median_data_by_date_edited)
```
As we can see from the table above, no impact of imputing missing data since the NA values are perfectly grouped by days

####Are there differences in activity patterns between weekdays and weekends?
1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
```{r, echo=TRUE,warning=FALSE,message=FALSE}
data_weekday<-data
data_weekday$is_weekday<-NA
data_weekday<-data_weekday%>%mutate(is_weekday=ifelse(weekdays(as.Date(date))=="Saturday"|weekdays(as.Date(date))=="Sunday","weekend","weekday"))
data_weekday_grouped<-group_by(data_weekday,interval,is_weekday)
mean_data_by_weekday<-summarize(data_weekday_grouped,mean(steps,na.rm=TRUE))
names(mean_data_by_weekday)<-c("Interval","Is_Weekday","Mean_Steps")
mean_data_by_weekday
```
2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.
```{r, echo=TRUE,warning=FALSE,message=FALSE}
ggplot(mean_data_by_weekday,aes(Interval,Mean_Steps))+geom_line()+geom_point()+facet_wrap(~Is_Weekday,nrow=2,ncol=1)+ylab("Number of Steps")+xlab("Interval")
```





As we can see from the chart above, there is noticeable difference between activity patterns during weekdays vs during weekends