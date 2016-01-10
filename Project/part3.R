#Creating a timeserie variable containig steps mean by interval

timeserie<-activitydt[,mean(steps,na.rm = T),
                      .(interval)]
#plotting the time serie
qplot(interval,V1,
      data = timeserie,
      geom = "line")

#For the last question we will get the max ave # of steps

timeserie[V1==max(timeserie$V1)]