#Peer assesment 1 Getting and cleaning data
rm(list=ls()) #cleaning vars
cat("\014")  #clear screen

## LOADING DATA
crudos<-read.table("activity.csv",sep=",",header=T) #names steps date interval

## SELECTING VALID DATA (non na data)
datos<-crudos[complete.cases(crudos),] 

## DAY ANALYSIS
# Grouping data per day
A<-1;AA<-1;AAA<-1;fechas<-datos$date[datos$interval==0]
for (i in 1:max(as.numeric(datos$date))) {
  A[i]<-mean(datos$steps[as.numeric(datos$date)==i])
  AA[i]<-sum(datos$steps[as.numeric(datos$date)==i])
  AAA[i]<-median(datos$steps[as.numeric(datos$date)==i])  
}

# Total, mean and median of steps per day
DD<-data.frame(steps=AA[AA!=0],mean=A[AA!=0],median=AAA[AA!=0],date=as.Date(fechas))

# histogram of total
hist(DD$steps)

#mean and median per day
data.frame(mean=DD$mean,median=DD$median,date=as.Date(fechas))


## INTERVAL ANALYSIS
#Grouping dat per interval
B<-1;BB<-1;BBB<-1;intervalos<-datos$interval[as.numeric(datos$date)==2]
for (i in 1:length(intervalos)){
  B[i]<-sum(datos$steps[datos$interval==intervalos[i]])
  BB[i]<-mean(datos$steps[datos$interval==intervalos[i]])
  BBB[i]<-median(datos$steps[datos$interval==intervalos[i]])
}

# Total, mean and median of steps per interval
ID<-data.frame(steps=B,mean=BB,median=BBB,interval=intervalos)

#Plot steps per interval
plot(ID$interval,ID$mean)

#Interval with max average steps
ID[ID$mean==max(ID$mean),]


##MISSING DATA
#Number of NA
NANumber<-length(crudos$steps[is.na(crudos$steps)])

#Replacing the NA values (for the mean of the interval)
RD<-crudos;temp<-0
for (i in 1:length(RD$steps)){
  if(is.na(RD$steps[i])) {RD$steps[i]<-ID$mean[ID$interval==RD$interval[i]]}
}

#Grouping NEW data per day
AR<-1;AAR<-1;AAAR<-1; fechasR<-as.Date(RD$date[RD$interval==0])

for (i in 1:length(fechasR)) {
  AR[i]<-sum(RD$steps[as.numeric(RD$date)==i])
  AAR[i]<-mean(RD$steps[as.numeric(RD$date)==i])
  AAAR[i]<-median(RD$steps[as.numeric(RD$date)==i])
}

# Total, mean and median of steps per day, with replaced data
RDD<-data.frame(steps=AR[AR!=0],mean=AAR[AR!=0],median=AAAR[AR!=0], date=as.Date(fechasR))

#Histogram
hist(RDD$steps)


##WEEK WEEKEND PATTERN (in revised data)
# Creating two levels variable with week and weekend days
days<-as.factor(c("weekday","weekend"))
for (i in 1:length(RD$date)){
  if(weekdays(as.Date(RD$date[i])) == "sabado" || weekdays(as.Date(RD$date[i])) == "domingo")
  {days[i]="weekend"}
  if(weekdays(as.Date(RD$date[i])) != "sabado" & weekdays(as.Date(RD$date[i])) != "domingo")
  {days[i]="weekday"} 
}
RDW<-data.frame(RD,days)

#Grouping data per interval of weekday end weekend
C<-1;D<-1;intervalos<-datos$interval[as.numeric(datos$date)==2]
for (i in 1:length(intervalos)){ 
    C[i]<-mean(RDW$steps[RDW$interval==intervalos[i] & RDW$days=="weekday"])
    D[i]<-mean(RDW$steps[RDW$interval==intervalos[i] & RDW$days=="weekend"])  
}


par(mfrow=c(2,1))
plot(intervalos,C, main=" Figure 1: weekdays")
plot(intervalos,D, main=" Figure 2: weekend")






