#no comment
means<-activitydt[,mean(steps,na.rm = T),
                  .(date)]$V1
k<-0
for(i in 1:61){
  activity2[(i+k):(i*288),"steps"][is.na(activity2[(i+k):(i*k),"steps"])]<-means[i]
  k<-k+288
}