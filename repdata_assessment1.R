setwd("F:/Coursera_R")
rm(list = ls())
activity <- read.csv("activity.csv")
index <- complete.cases(activity)
activity_full <- activity[index,]
#extract date using unique function,
#and use "which" to sum the steps with the same date
date <- unique(activity$date)
step_sum <- as.numeric()
step_mean <- as.numeric()
step_median <- as.numeric()

#Notice that for those wtih NA data, they skip the step in the for loop
##because it is activity_full dataset which are processed
for (i in 1:length(date)) {
  step_sum[i] <- sum(activity_full$steps[which(activity_full$date == date[i])])
  step_mean[i] <- mean(activity_full$steps[which(activity_full$date == date[i])])
  step_median[i] <- median(activity_full$steps[which(activity_full$date == date[i])],na.rm = TRUE)
}

#use "as.POSIXlt" to get the month and day as numeric
# why month needs + 1??
month <- as.POSIXlt(date)$mon + 1
day <- as.POSIXlt(date)$mday
##construct a new data.frame in ofer to plot it
step_sum <- data.frame(step_sum,date,month,day)

result <- data.frame(mean = step_mean, median = step_median, Date = date)

library(ggplot2)
library(plyr)
#ddply::Split data frame, apply function, and return results in a data frame
mm <- ddply(step_sum, "date",summarise, step_sum = sum(step_sum))
g <- ggplot(data=mm,aes(x = factor(day),fill = factor(month), y = step_sum)) 
g <- g + geom_bar(stat = "identity",alpha=0.5)
g
## By default, geom_bar uses stat="bin". This makes the height of each bar
#equal to the number of cases in each group, and it is incompatible with 
#mapping values to the y aesthetic. If you want the heights of the bars 
#to represent values in the data, use stat="identity" 
#and map a value to the y aesthetic.

g <- ggplot(activity_full, aes(x = interval, y = steps))
g <- g + geom_line()
g <- g + xlab("Interval") + ylab("steps")
g
##in order to speed up, activity2 removes data with 0 step
activity2 <- activity_full[-which(activity_full$steps==0),]
##get the largest step
activity2[which(activity2$steps == max(activity2$steps)),]
##number of missing values
miss <- nrow(activity)-nrow(activity_full)

activity3 <- activity
for (i in 1:nrow(activity)) {
  if(is.na(activity[i,1])){
    activity3[i,1]<- step_sum[which(date == activity[i,2]),1]/288
  }
}

#replot

step_mean[which(step_mean == "NaN")] <- 0
step_mean[which(step_mean == 0)] <- (step_mean[which(step_mean == 0)] + step_mean[(which(step_mean == 0) + 31)%%62])/2
for (i in c(1,8,32,35,40,41,45,61)){
  activity$steps[which(activity$date == date[i])] <- step_mean[i]
}

step_sum2 <- as.numeric()

for (i in 1:length(date)) {
  step_sum2[i] <- sum(activity$steps[which(activity$date == date[i])])
}
month <- as.POSIXlt(date)$mon + 1
day <- as.POSIXlt(date)$mday
##construct a new data.frame in ofer to plot it
step_sum2 <- data.frame(step_sum2,date,month,day)
library(ggplot2)
library(plyr)
mm2 <- ddply(step_sum2, "date",summarise, step_sum = sum(step_sum2))
g <- ggplot(data=mm2,aes(x = factor(day),fill = factor(month), y = step_sum)) 
g <- g + geom_bar(stat = "identity",alpha=0.5)
g

wkday <- weekdays(as.POSIXlt(date))
for (i in 1:length(wkday)) {
  if((wkday[i]=="星期六") || (wkday[i]=="星期日")){
    wkday[i] <- "weekend"
  }else{
    wkday[i] <- "weekday"
  }
}
weekday <- factor(x = wkday, levels = c("weekday","weekend"))
weekday <- as.character(weekday)
activity4 <- data.frame(activity,weekday)
mmm <- ddply(activity4,c("interval","weekday"), summarise, steps = mean(steps))
nnn <- mmm[which(mmm$weekday == "weekday"),]
nn <- mmm[which(mmm$weekday == "weekend"),]
activity5 <- t(data.frame(t(nnn),t(nn)))
activity5 <- as.data.frame(activity5)
activity5$steps <- as.numeric(as.character(activity5$steps))
activity5$interval <- as.numeric(as.character(activity5$interval))
row.names(activity5) <- c()
library(lattice)
xyplot(activity5$steps ~ activity5$interval |activity5$weekday, layout = c(1,2), type = "l", ylab = "Num of steps", xlab = "interval")

library(ggplot2)
g <- ggplot(data = activity5, aes(x= interval, y = steps))
g <- g + geom_line()
g <- g + facet_grid(weekday ~ .)
g <- g + xlab("5-minute interval")+ ylab("Number of steps")
g
