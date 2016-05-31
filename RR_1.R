setwd("C:\\Users\\Bharath.Sivaraman\\Documents\\R programming\\RR-Project1")

library(tidyr)
library(dplyr)
library(ggplot2)
library(ggvis)
library(lubridate)
activity<-read.csv("activity.csv",stringsAsFactors = FALSE)
activity.hist<-activity%>%filter(!is.na(steps)) %>%group_by(date)%>%summarize(steps=sum(steps,na.rm=TRUE))
ggplot(activity.hist)+aes(steps)+geom_histogram(fill="firebrick")+labs(x="Number of steps",y="frequency",title="Histogram of number of steps")
activity.summary<-activity.hist%>%summarize(mean=mean(steps,na.rm=TRUE),median=median(steps,na.rm=TRUE))
activity.times<-activity%>%filter(!is.na(steps))%>%group_by(interval)%>%summarise(mean=mean(steps))
ggplot(activity.times)+aes(interval,mean)+geom_line(color="firebrick",size=1)



activity.times[which.max(activity.times$mean),]


data_imput<-activity
datamiss<-is.na(data$steps)
intervalmean<- tapply(data_imput$steps, data_imput$interval, mean, na.rm=TRUE, simplify = TRUE)
data_imput$steps[datamiss] <- intervalmean[as.character(data_imput$interval[datamiss])]

dataimputnew<-data_imput%>%filter(!is.na(steps))%>%group_by(date)%>%summarise(sumofstep=sum(steps))
ggplot(dataimputnew)+aes(sumofstep)+geom_histogram()
dataimputsummary<-dataimputnew%>%summarize(mean=mean(sumofstep,na.rm=TRUE),median=median(sumofstep,na.rm=TRUE))

The number of missing values `r sum(is.na(data_imput))
`

##Weekdays and weekends

```{r weekdays and weekends,echo=TRUE}

data_imput$date<-ymd(data_imput$date)
week<-data_imput%>%mutate(week=ifelse(weekdays(data_imput$date)=="Saturday"|weekdays(data_imput$date)=="Sunday","weekend","weekday"))
weeknew<-week%>%group_by(interval,week)%>%summarize(avgsteps=mean(steps,na.rm=TRUE))

ggplot(weeknew)+aes(interval,avgsteps,color=week)+geom_line(size=1)+facet_wrap(~week)
