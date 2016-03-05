##Loading and Processing the data
library(lubridate)
data<-read.csv("activity.csv")
data$date<-ymd(data$date)

##What is the mean total number of steps taken per day?
data2<-data[complete.cases(data),]
stepsday<-tapply(data2$steps,data2$date,sum)
hist(stepsday,breaks=10,main="Frequency of Steps per Day",xlab="Steps per Day")
stepssummary<-mean(stepsday)
stepssummary<-c(stepssummary,median(stepsday))

##What is the average daily pattern?
avepat<-tapply(data$steps,data$interval,function(x){mean(x,na.rm=TRUE)})
ap<-as.data.frame(as.numeric(rownames(avepat)))
ap[,2]<-avepat
plot(ap,type="l",xlab="Interval",ylab="Average Steps per Interval")

##Imputing missing values
NAcount<-nrow(data)-sum(complete.cases(data))
data3<-data
for (i in 1:nrow(data3)){
  if (is.na(data3[i,1])==TRUE){
    data3[i,1]<-ap[ap[,1]==data3[i,3],2]
  }
}
stepsday3<-tapply(data3$steps,data3$date,sum)
hist(stepsday3,breaks=10,main="Frequency of Steps per Day",xlab="Steps per Day")
stepssummary3<-mean(stepsday3)
stepssummary3<-c(stepssummary3,median(stepsday3))
stepssummary-stepssummary3

##Are there differences in activity patterns between weekdays and weekends?
for (i in 1:nrow(data3)){
  if (weekdays(data3[i,2])=="Sunday"){
    data3[i,4]<-"weekend"
  }
  else if (weekdays(data3[i,2])=="Saturday"){
    data3[i,4]<-"weekend"
  }
  else{
    data3[i,4]<-"weekday"
  }
}
edata<-subset(data3,data3[,4]=="weekend")
eavepat<-tapply(edata$steps,edata$interval,mean)
eap<-as.data.frame(as.numeric(rownames(eavepat)))
eap[,2]<-eavepat
ddata<-subset(data3,data3[,4]=="weekday")
davepat<-tapply(ddata$steps,ddata$interval,mean)
dap<-as.data.frame(as.numeric(rownames(davepat)))
dap[,2]<-davepat
plot(dap,type="l",xlab="Interval",ylab="Average Steps per Interval",main="Average Steps per Interval")
lines(eap,col="red")
legend("topright",legend=c("Weekday","Weekend"),lty=c(1,1),col=c("black","red"))

