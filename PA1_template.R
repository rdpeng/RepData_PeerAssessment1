library(dplyr)
library(ggplot2)
url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
zipFile <- "Nike.zip"
#download and unzip the file
if (!file.exists(zipFile)) {download.file(url, zipFile, mode = "wb")}
dataPath <- "Nike"
if (!file.exists(dataPath)) {unzip(zipFile)}
a <- read.csv("activity.csv",header=TRUE)
####################
total_steps <- tapply(a$steps, a$date, FUN=sum, na.rm=TRUE)
hist(total_steps, breaks=20, xlab = "Total daily Steps",main="Histogram of Total Steps by day")
mean(total_steps, na.rm=TRUE)
median(total_steps, na.rm=TRUE)

####################
library(ggplot2)
averages <- aggregate(x=list(steps=a$steps), by=list(interval=a$interval),
                      FUN=mean, na.rm=TRUE)
plot(averages,type="l",col="red",main="Steps over interval",xlab="Interval",ylab="Steps")
averages[which(averages$steps== max(averages$steps)),]


#####################
#1
sum(is.na(a))
#2
replacemean <- function(x) replace(x, is.na(x), mean(x, na.rm = TRUE))
data_new <- a
data_new$steps <- replacemean(data_new$steps)
head(data_new)
#3
stepsByDayImputed <- tapply(data_new$steps, data_new$date, sum)
#4
hist(stepsByDayImputed, xlab='Total steps per day (Imputed)', ylab='Frequency using binwith 500', breaks=20)
mean(stepsByDayImputed)
median(stepsByDayImputed)


#########

#1
new_data_week <- a
week <- function (x){if(x=="Saturday" || x=="Sunday"){"weekend"}else{"weekday"}}
new_data_week$dateType <- ifelse(as.POSIXlt(new_data_week$date)$wday %in% c(0,6), 'weekend', 'weekday')
#2
grp <- aggregate(steps ~ interval + dateType, data=new_data_week, mean)
hist(grp$step,col="red",xlab="Total number of steps each day",ylab="count",main="Average Steps after imutation")
#3
plot(steps~intervals|dayType ,
       data = grp,
       type='l',
       layout= c(1,2),
       ylab = 'Number of steps',
       xlab='Interval')


averageStepsPerWeekday <- tapply(weekdays$steps,weekdays$interval,mean)
finalDt <- data.frame(steps=c(averageStepsPerWeekend,averageStepsPerWeekday),
                      dayType = c(rep('weekend',length(averageStepsPerWeekend)),
                                  rep('weekday',length(averageStepsPerWeekday))) )
finalDt$invervals <- as.numeric(row.names(finalDt))
xyplot(steps~intervals|dayType ,
       data = finalDt,
       type='l',
       layout= c(1,2),
       ylab = 'Number of steps',
       xlab='Interval')


