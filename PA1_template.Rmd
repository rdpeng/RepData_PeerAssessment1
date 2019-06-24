echo = TRUE
act <- NULL
act <- read.csv("activity.csv", header = T, sep = ",")



echo = TRUE
dfSummary <- NULL
sU2 <- NULL
sU <- NULL
mnInt <- NULL
act2 <- NULL
meanSU2 <- NULL
medianSU2 <- NULL
act2Weekend <- NULL
act2Weekday <- NULL
meanAct2Weekday <- NULL
meanAct2Weekend <- NULL


echo = TRUE
sU <- tapply(act$steps, act$date, sum, na.rm=T)


echo = TRUE
hist(sU, xlab = "sum of steps per day", main = "histogram of steps per day")


echo = TRUE
meanSU <- round(mean(sU))
medianSU <- round(median(sU))

print(c("The mean is",meanSU))


print(c("The median is",medianSU))


echo = TRUE
mnInt <- tapply(act$steps, act$interval, mean, na.rm=T)
plot(mnInt ~ unique(act$interval), type="l", xlab = "5-min interval")


echo = TRUE
mnInt[which.max(mnInt)]


echo = TRUE
table(is.na(act) == TRUE)

summary(act)


echo = TRUE
act2 <- act  # creation of the dataset that will have no more NAs
for (i in 1:nrow(act)){
  if(is.na(act$steps[i])){
    act2$steps[i]<- mnInt[[as.character(act[i, "interval"])]]
  }
}


echo = TRUE
sU2 <- tapply(act2$steps, act2$date, sum, na.rm=T)
echo = TRUE
hist(sU2, xlab = "sum of steps per day", main = "histogram of steps per day")


meanSU2 <- round(mean(sU2))
medianSU2 <- round(median(sU2))


echo = TRUE
print(c("The mean is",meanSU2))


print(c("The median is",medianSU2))


echo = TRUE
dfSummary <- rbind(dfSummary, data.frame(mean = c(meanSU, meanSU2), median = c(medianSU, medianSU2)))
rownames(dfSummary) <- c("with NA's", "without NA's")
print(dfSummary)


echo = TRUE
summary(act2)



echo = TRUE
act2$weekday <- c("weekday")
act2[weekdays(as.Date(act2[, 2])) %in% c("Saturday", "Sunday", "samedi", "dimanche", "saturday", "sunday", "Samedi", "Dimanche"), ][4] <- c("weekend")
table(act2$weekday == "weekend")

act2$weekday <- factor(act2$weekday)


echo = TRUE
act2Weekend <- subset(act2, act2$weekday == "weekend")
act2Weekday <- subset(act2, act2$weekday == "weekday")

meanAct2Weekday <- tapply(act2Weekday$steps, act2Weekday$interval, mean)
meanAct2Weekend <- tapply(act2Weekend$steps, act2Weekend$interval, mean)


echo = TRUE
library(lattice)
dfWeekday <- NULL
dfWeekend <- NULL
dfFinal <- NULL
dfWeekday <- data.frame(interval = unique(act2Weekday$interval), avg = as.numeric(meanAct2Weekday), day = rep("weekday", length(meanAct2Weekday)))
dfWeekend <- data.frame(interval = unique(act2Weekend$interval), avg = as.numeric(meanAct2Weekend), day = rep("weekend", length(meanAct2Weekend)))
dfFinal <- rbind(dfWeekday, dfWeekend)

xyplot(avg ~ interval | day, data = dfFinal, layout = c(1, 2), 
       type = "l", ylab = "Number of steps")

