# Reproducible Research: Peer Assessment 1


> load the library and set the global option, echo=TRUE and figure path


```r
library(knitr)
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
library(lattice)
opts_chunk$set(echo=TRUE)
```


## Loading and preprocessing the data

```r
setwd("F:\\coursera\\Reproducible Research\\Peer_Assessment_1\\RepData_PeerAssessment1")
zipfile <- unzip("activity.zip")
alldata <- read.csv(zipfile)     ###read the data
clean_data <- na.omit(alldata)   ###omit the missing data
```


## What is mean total number of steps taken per day?

```r
###group the data by date and sum the steps for every day
date_group <- group_by(clean_data,date)     
out_date_group <- summarize(date_group,sum(steps))
mean_every_day <- mean(out_date_group$`sum(steps)`)
median_every_day <- median(out_date_group$`sum(steps)`)
histogram(out_date_group$`sum(steps)`,xlab="every day total steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

```r
#print(mean_every_day,type="html")
sprintf("mean_every_day=%.1f,median_every_day=%.1f",mean_every_day,median_every_day)
```

```
## [1] "mean_every_day=10766.2,median_every_day=10765.0"
```


## What is the average daily activity pattern?

```r
#xyplot(steps ~ interval|format(as.Date(date),"%m-%d"),data=clean_data,type = "l")
sec_clean_data_interval_group <- group_by(clean_data,interval)
sec_clean_out_interval_group <- summarize(sec_clean_data_interval_group ,mean(steps)  )
xyplot(`mean(steps)`  ~ interval,data=sec_clean_out_interval_group ,type = "l",ylab=" the average number of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 

```r
sprintf(" the 5-minute interval that, on average, the maximum number of steps=%.1f",max(sec_clean_out_interval_group$`mean(steps)`))
```

```
## [1] " the 5-minute interval that, on average, the maximum number of steps=206.2"
```


## Imputing missing values

```r
NaData <- alldata[which(is.na(alldata)),]
NARowNum  <- nrow(NaData)    ###get the missing data row num 
ReplaceNaAllData <- alldata
####set the missing data is zero
ReplaceNaAllData[is.na(ReplaceNaAllData )] <- 0
all_date_group <-  group_by(ReplaceNaAllData,date)
all_out_date_group <- summarize(all_date_group ,sum(steps )  )
histogram(all_out_date_group$`sum(steps)`,xlab="total number of steps taken each day ")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 

```r
mean_replace_na_steps <- mean(all_out_date_group$`sum(steps)`)
median_replace_na_steps <- median(all_out_date_group$`sum(steps)`)
sprintf("NARowNum=%d.set the missing data to zero,then the mean=%.1f and median=%.1f",NARowNum ,mean_replace_na_steps,median_replace_na_steps)
```

```
## [1] "NARowNum=2304.set the missing data to zero,then the mean=9354.2 and median=10395.0"
```


## Are there differences in activity patterns between weekdays and weekends?

```r
week_all_na_data <- transform(ReplaceNaAllData,Week=weekdays(as.Date(date)))

#####set the date by weekday and weekend
levels(week_all_na_data$Week )[levels(week_all_na_data$Week) %in%  c("星期六","星期日")]   <- "weekend"
levels(week_all_na_data$Week )[levels(week_all_na_data$Week) %in%  c("星期一","星期二","星期三","星期四","星期五")]   <- "weekday"
week_all_date_group <-  group_by(week_all_na_data,interval,Week)
week_all_out_date_group <- summarize(week_all_date_group ,mean(steps )  )
xyplot(`mean(steps)`  ~ interval|Week,data=week_all_out_date_group ,type = "l",layout=c(1,2),ylab="Numbers of steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png) 
