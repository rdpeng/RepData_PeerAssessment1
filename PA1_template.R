activity <- read.csv("activity.csv",header=TRUE,colClasses=c("integer","Date","integer"))
head(activity)
tail(activity)

totalStepsByDay <- sapply(with(activity,split(steps,date)),sum,na.rm=T)
hist(totalStepsByDay,xlab="Total Steps Per Day",main="Histogram of Total Steps Per Day")
mean(totalStepsByDay)
median(totalStepsByDay)


avgStepsByInterval <- sapply(with(activity,split(steps,interval)),mean,na.rm=T)
intervals <- names(avgStepsByInterval)
plot(intervals,avgStepsByInterval,type="l")

names(which.max(avgStepsByInterval))

sum(is.na(activity))
missingIndices <- which(is.na(activity))
new_activity <- activity
for(i in missingIndices){
  if(is.na(activity[i,]$steps)){
    new_activity[i,]$steps = avgStepsByInterval[as.character(activity[i,]$interval)]
  }
}
totalStepsByDayNew <- sapply(with(new_activity,split(steps,date)),sum,na.rm=T)
hist(totalStepsByDayNew,xlab="Total Steps Per Day",main="Histogram of Total Steps Per Day New")
mean(totalStepsByDayNew)
median(totalStepsByDayNew)

new_activity$dayType <- with(new_activity,ifelse(weekdays(date)=="Saturday" | weekdays(date)=="Sunday","Weekend","Weekday"))
avgStepsByInterval_DT <- with(new_activity,aggregate(steps,by=list(interval,dayType),mean))
names(avgStepsByInterval_DT) <- c("interval","dayType","steps")
library(lattice)
xyplot(steps~interval|dayType, data=avgStepsByInterval_DT,type="l",ylab="Number of Steps")

