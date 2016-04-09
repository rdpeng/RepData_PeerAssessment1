data<-read.table("household_power_consumption.txt",header=T,sep=";", stringsAsFactors=FALSE, dec=".")
names(data)
data[,1]<-as.Date(data$Date,format = "%d/%m/%Y")
for (i in 3:9){
  data[,i]<-as.numeric(data[,i]) 
}
class(data$Global_active_power)

library(dplyr)
d1_d2=data %>%
  select(Date, Time,Global_active_power,Global_reactive_power,Voltage,
         Sub_metering_1,Sub_metering_2,Sub_metering_3) %>%
  filter(Date >="2007-02-01" & Date<="2007-02-02")
datetime <- strptime(paste(d1_d2$Date, d1_d2$Time, sep=" "), "%Y-%m-%d %H:%M:%S") 

#Plot 4
png("plot4.png", width=480, height=480)
par(mfrow=c(2,2))
plot(datetime, d1_d2$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
plot(datetime, d1_d2$Voltage, type="l", xlab="datetime", ylab="Voltage")
plot(datetime,d1_d2$Sub_metering_1,type="l",xlab=" ",ylab="Energy sub metering")
lines(datetime,d1_d2$Sub_metering_2,col="red")
lines(datetime,d1_d2$Sub_metering_3,col="blue")
plot(datetime, d1_d2$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power (kilowatts)")
dev.off()