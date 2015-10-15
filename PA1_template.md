# Reproducible Research: Peer Assessment 1




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
opts_chunk$set(echo=TRUE,fig.path=".\\figure\\")
```


## Loading and preprocessing the data

```r
setwd("F:\\coursera\\Reproducible Research\\Peer_Assessment_1\\RepData_PeerAssessment1")
zipfile <- unzip("activity.zip")
alldata <- read.csv(zipfile)
clean_data <- na.omit(alldata)
```


## What is mean total number of steps taken per day?

```r
date_group <- group_by(clean_data,date)
out_date_group <- summarize(date_group,sum(steps))
mean_every_day <- mean(out_date_group$`sum(steps)`)
print(mean_every_day,type="html")
```

```
## [1] 10766.19
```


## What is the average daily activity pattern?

```r
xyplot(steps ~ interval|format(as.Date(date),"%m-%d"),data=clean_data,type = "l")
```

![](.\figure\unnamed-chunk-3-1.png) 


## Imputing missing values

```r
NaData <- alldata[which(is.na(alldata)),]
NARowNum  <- nrow(NaData)
ReplaceNaAllData <- alldata
ReplaceNaAllData[is.na(ReplaceNaAllData )] <- 0
all_date_group <-  group_by(ReplaceNaAllData,date)
all_out_date_group <- summarize(all_date_group ,sum(steps )  )
histogram(all_out_date_group$`sum(steps)`,xlab="total number of steps taken each day ")
```

![](.\figure\unnamed-chunk-4-1.png) 

```r
mean_replace_na_steps <- mean(all_out_date_group$`sum(steps)`)
median_replace_na_steps <- median(all_out_date_group$`sum(steps)`)
sprintf("NARowNum=%d,mean=%.1f,median=%.1f",NARowNum ,mean_replace_na_steps,median_replace_na_steps)
```

```
## [1] "NARowNum=2304,mean=9354.2,median=10395.0"
```


## Are there differences in activity patterns between weekdays and weekends?

```r
week_all_na_data <- transform(ReplaceNaAllData,Week=weekdays(as.Date(date)))
levels(week_all_na_data$Week )[levels(week_all_na_data$Week) %in%  c("星期六","星期日")]   <- "weekend"
levels(week_all_na_data$Week )[levels(week_all_na_data$Week) %in%  c("星期一","星期二","星期三","星期四","星期五")]   <- "weekday"
week_all_date_group <-  group_by(week_all_na_data,interval,Week)
week_all_out_date_group <- summarize(week_all_date_group ,mean(steps )  )
xyplot(`mean(steps)`  ~ interval|Week,data=week_all_out_date_group ,type = "l",layout=c(1,2),ylab="Numbers of steps")
```

![](.\figure\unnamed-chunk-5-1.png) 
