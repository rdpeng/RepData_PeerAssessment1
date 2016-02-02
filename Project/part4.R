#no comment
means<-activitydt[,mean(steps,na.rm = T),
                  .(date)]$V1
activity2<-as.data.frame(activity)
k<-0
for(i in 1:61){
  if(i==1){
    activity2[(i+k):(i*288),"steps"][is.na(activity2[(i+k):(i*288),"steps"])]<-means[i+1]  
  }
  if(i==61){
    activity2[(i+k):(i*288),"steps"][is.na(activity2[(i+k):(i*288),"steps"])]<-means[i-1]
  }
  k<-k+288
}