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

step_mean[which(step_mean == "NaN")] <- 0
step_mean[which(step_mean == 0)] <- (step_mean[which(step_mean == 0)] + step_mean[(which(step_mean == 0) + 31)%%62])/2


for (i in c(1,8,32,35,40,41,45,61)){
  activity$steps[which(activity$date == date[i])] <- step_mean[i]
}

step_sum2 <- as.numeric()

for (i in 1:length(date))
{
  step_sum2[i] <- sum(activity$steps[which(activity$date == date[i])])
}


month <- as.POSIXlt(date)$mon + 1
day <- as.POSIXlt(date)$mday
step_sum2 <- data.frame(step_sum2,date,month,day)
mm <- ddply(step_sum2, "date", summarise, stepsum = sum(step_sum2))


ggplot(data=mm, aes(x = factor(day),fill = factor(month), y = stepsum)) + geom_bar(stat = "identity",alpha=0.5)
