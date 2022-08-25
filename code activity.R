setwd("C:/Users/My/Desktop/Data Science Course/Reproducible Research/Course Project 1")
## set the working directory###
```{r, echo = TRUE}
library(lubridate)
library(ggplot2)
library(dplyr)
library(knitr)
library(lattice)

archiveFile <- "repdata_data_activity.zip"
if(!(file.exists("activity.csv")) { 
  unzip(archiveFile) 
}
```
## First step
```{r, echo = TRUE}
activity <- read.csv("activity.csv")
#transform the date column into date format
activity$date<-ymd(activity$date)
```

##Second Step
##Histogram of the total number of steps taken each day
```{r, echo = TRUE}
hist_1<-data.frame(tapply(activity$steps,activity$date,sum,na.rm=TRUE))
hist_1$date<-rownames(hist_1)
rownames(hist_1)<-NULL
names(hist_1)[[1]]<-"Total Steps"
png("plot1.png")
```
#Total Steps by date bar chart
```{r, echo = TRUE}
ggplot(hist_1,aes(y=`Total Steps`,x=date))+geom_bar(stat="identity") + ylab("Total Steps")+xlab("Date")+ggtitle("Total Steps by date")
dev.off()
```
#Histogram of total steps
```{r, echo = TRUE}
qplot(hist_1$`Total Steps`,geom="histogram",xlab="Total Steps",ylab="Counts",main="Total Steps Historgram")
png("plot1.01.png")
dev.off()
```

##third step
##Mean and median number of steps
```{r, echo = TRUE}
l3<-data.frame(round(tapply(activity$steps,activity$date,mean,na.rm=TRUE),2))
l3$date<-rownames(l3)
rownames(l3)<-NULL
names(l3)[[1]]<-"Mean Steps"
temp<-activity%>%select(date,steps) %>% group_by(date) %>% summarise(median(steps))
names(temp)[[2]]<-"Median Steps"
l3$median<-temp$`Median Steps`
l3<-l3 %>% select(date,`Mean Steps`,median)
 ```
##fourth step
 ##Time series plot of the average number of steps taken
 ```{r, echo = TRUE}
 l4<-l3
 l4$date<-as.Date(l4$date,format="%Y-%m-%d")
 ggplot(l4,aes(x=date,y=`Mean Steps`))+geom_bar(stat="identity")+scale_x_date()+ylab("Mean Steps Every day")+xlab("Date")+ggtitle("Mean Steps by Date")
 png("plot4.png")
 ggplot(l4,aes(x=date,y=`Mean Steps`))+geom_bar(stat="identity")+scale_x_date()+ylab("Mean Steps Every day")+xlab("Date")+ggtitle("Mean Steps by Date")
 dev.off()
 ```

 ##Fifth Step
 ##The 5-minute interval that, on average, contains the maximum number of steps
 
 ```{r, echo = TRUE}
 activity$interval<-factor(activity$interval)
 l5<-aggregate(data=activity,steps~date+interval,FUN="mean")
 l5<-aggregate(data=l5,steps~interval,FUN="max")
 ```
 ##sixth step
 
 ```{r, echo = TRUE}
 Q6<-activity
 Q6$Missing<-is.na(Q6$steps)
 Q6<-aggregate(data=Q6,Missing~date+interval,FUN="sum")
 Q6.1<-data.frame(tapply(Q6$Missing,Q6$date,sum))
 Q6.1$date<-rownames(Q6.1)
 rownames(Q6.1)<-NULL
 names(Q6.1)<-c("Missing","date")
 Q6.1$date<-as.Date(Q6.1$date,format="%Y-%m-%d")
 Q6.2<-data.frame(tapply(Q6$Missing,Q6$interval,sum))
 Q6.2$date<-rownames(Q6.2)
 rownames(Q6.2)<-NULL
 names(Q6.2)<-c("Missing","Interval")
 par(mfrow=c(1,2))
 plot(y=Q6.1$Missing,x=Q6.1$date,main="Missing Value Distribution by Date")
 plot(y=Q6.2$Missing,x=Q6.2$Interval,main="Missing Value Distribution by Interval")
 table(activity$date)
 
 Q6.3<-as.data.frame(Q6.1) %>% select(date,Missing) %>% arrange(desc(Missing))
 Q6.3<-Q6.3[which(Q6.3$Missing!=0),]
 Q6.3$Weekday<-wday(Q6.3$date,label=TRUE)
 Q6.4<-activity
 Q6.4$weekday<-wday(Q6.4$date,label=TRUE)
 #Finding the mean of steps every monday, and every interval
 Q6.5<-aggregate(data=Q6.4,steps~interval+weekday,FUN="mean",na.rm=TRUE)
 #Merge the pre-imputation table Q6.4 table with the average table Q6.5
 Q6.6<-merge(x=Q6.4,y=Q6.5,by.x=c("interval","weekday"),by.y=c("interval","weekday"),all.x=TRUE)
 #Conditionally replacing the steps.x column NA value with the values from steps.y column value 
 Q6.6$Steps.Updated<-0
 for (i in 1:dim(Q6.6)[[1]]){
   if(is.na(Q6.6[i,3])){Q6.6[i,6]=Q6.6[i,5]}
   else {Q6.6[i,6]=Q6.6[i,3]}
 }
 #Now simplify the imputed analytical data frame
 Q6.6 <-Q6.6  %>% select(date,weekday,interval,Steps.Updated)
 names(Q6.6)[[4]]<-"Steps"
 ```

 ## Step 7
 
 ```{r, echo = TRUE}
 png("plot7.png")
 qplot(Q6.6$Steps,geom="histogram",main="Total steps taken histogram post imputation",xlab="Steps",ylab="Count")
 dev.off()
 qplot(Q6.6$Steps,geom="histogram",main="Total steps taken histogram post imputation",xlab="Steps",ylab="Count")
 ```

 ## Step 8
 Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends
 
 ```{r, echo = TRUE}
 Q8<-Q6.6
 levels(Q8$weekday)<-c(1,2,3,4,5,6,7)
 Q8$WDWE<-Q8$weekday %in% c(1,2,3,4,5)
 Q8.1<-aggregate(data=Q8,Steps~interval+WDWE,mean,na.rm=TRUE)
 Q8.1$WDWE<-as.factor(Q8.1$WDWE)
 levels(Q8.1$WDWE)<-c("Weekend","Weekday")
 png("plot8.png")
 ggplot(data=Q8.1,aes(y=Steps,x=interval,group=1,color=WDWE))+geom_line() +scale_x_discrete(breaks = seq(0, 2500, by = 300))+ylab("Mean Steps")+xlab("Intervals")+ggtitle("Mean steps across intervals by Weekend and Weekday")
 dev.off()
 ggplot(data=Q8.1,aes(y=Steps,x=interval,group=1,color=WDWE))+geom_line() +scale_x_discrete(breaks = seq(0, 2500, by = 300))+ylab("Mean Steps")+xlab("Intervals")+ggtitle("Mean steps across intervals by Weekend and Weekday")
 #Producing the panel plot
 Q8.1$interval<-as.numeric(as.character(Q8.1$interval))
 xyplot(data=Q8.1,Steps~interval|WDWE, grid = TRUE, type = c("p", "smooth"), lwd = 4,panel = panel.smoothScatter)
 png("plott8.1.png")
 xyplot(data=Q8.1,Steps~interval|WDWE, grid = TRUE, type = c("p", "smooth"), lwd = 4,panel = panel.smoothScatter)
 dev.off()
 ```