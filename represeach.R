#COMO SE DEBE FACER:http://fch808.github.io/RepData_PeerAssessment1/



if(!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")) {
  temp <- tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip",temp)
  unzip(temp)
  unlink(temp)
}

data <- read.csv("activity.csv")
stepsday <- aggregate(steps ~ date, data, sum)
hist(stepsday$steps, main = paste("Total Steps every Day"), col="green", xlab="Steps")



dmean <- mean(stepsday$steps)
dmedian <- median(stepsday$steps)


stepsinterval <- aggregate(steps ~ interval, data, mean)
plot(stepsinterval$interval,stepsinterval$steps, type="l", xlab="Interval", ylab="Steps",main="Average Number of Steps per Day by Interval")

max_interval <- stepsinterval[which.max(stepsinterval$steps),1]

incompletecases<-sum(!complete.cases(data$steps))

imputed_data <- transform(data, steps = ifelse(is.na(data$steps), stepsinterval$steps[match(data$interval, stepsinterval$interval)], data$steps))

imputed_data[as.character(imputed_data$date) == "2012-10-01", 1] <- 0

stepsday_i <- aggregate(steps ~ date, imputed_data, sum)
hist(stepsday_i$steps, main = paste("Total Steps Every Day"), col="blue", xlab="Steps")

hist(stepsday$steps, main = paste("Total Steps Every Day"), col="red", xlab="Steps", add=T)
legend("topright", c("Imputed", "Non-imputed"), col=c("blue", "red"), lwd=10)

dmean.i <- mean(stepsday_i$steps)
dmedian.i <- median(stepsday_i$steps)

mean_diff <- dmean.i - dmean
med_diff <- dmedian.i - dmedian

total_diff <- sum(stepsday_i$steps) - sum(stepsday$steps)

library(lattice)
library(reshape2)
data[,2]<-as.Date(data[,2])
data[,"days"]<-weekdays(data[,2])
for (i in 1:nrow(data)) {
  if (data$days[i] == "sábado" | data$days[i]  == "domingo") {
    data$dayOfWeek[i] = "weekend"
  } else {
    data$dayOfWeek[i] = "weekday"
  }
}
```
```{r}
w <- tapply(data$steps,list(data$interval,data$dayOfWeek),mean,na.rm=T)

w <- melt(w)

colnames(w) <- c("interval","day","steps")

library(lattice)
library(reshape2)
xyplot(w$steps ~ w$interval | w$day, layout=c(1,2),type="l",main="Time Series Plot of the Average of Total Steps (weekday vs. weekend)",xlab="Time intervals (in minutes)",ylab="Average of Total Steps")
