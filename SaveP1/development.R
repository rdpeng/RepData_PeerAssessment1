


stepsPerDay <- aggregate(.~date, data=DS, sum) %>% select(c(date, steps))

par(mfrow = c(1, 2))
hist(stepsPerDay$steps, main="Histogram over steps per day", xlab="steps per day", col="red")
barplot(stepsPerDay$steps, names.arg = stepsPerDay$date, main="Barplot over steps per day",
        ylab="steps", xlab="date", col="blue")


stepsPerintervalMean <- aggregate(.~interval, data=DS, mean)
stepsPerintervalMean <- select(stepsPerintervalMean, c(interval, steps))
plot(stepsPerintervalMean$interval, stepsPerintervalMean$steps, type="l",
     main="Average steps per interval", xlab="interval", ylab="Average no of steps")

subset(stepsPerintervalMean$interval, stepsPerintervalMean$steps==max(stepsPerintervalMean$steps, na.rm = TRUE) )
subset(stepsPerintervalMean$interval, stepsPerintervalMean$steps==min(stepsPerintervalMean$steps, na.rm = TRUE) )

sub <- subset(DS, DS$interval==40)

sub <- subset(DS, is.na(DS$steps) )

for(i in unique(DS$interval)){
      DS$steps[DS$interval==i&is.na(DS$steps)] <- mean(DS$steps[DS$interval==i], na.rm=T) }


stepsPerDayTot <- aggregate(.~date, data=DS, sum)
stepsPerDayTot <- select(stepsPerDayTot, c(date, steps))

DSCompleted$Weekday <- factor(ifelse(weekdays(DSCompleted$date) %in% c("lördag", "söndag"), "weekend", "weekday") )


stepsPerintervalWeekdayMean <- aggregate(.~interval, data=DSCompleted[DSCompleted$Weekday=="weekday",], mean)
stepsPerintervalWeekdayMean$Day <- as.factor("weekday")  ## factorize weekday
stepsPerintervalWeekendMean <- aggregate(.~interval, data=DSCompleted[DSCompleted$Weekday=="weekend",], mean)
stepsPerintervalWeekendMean$Day <- as.factor("weekend")
stepsPerintervalWeekdayMean <- rbind(stepsPerintervalWeekdayMean, stepsPerintervalWeekendMean)

library(lattice)
xyplot(stepsPerintervalWeekdayMean$step ~ stepsPerintervalWeekdayMean$interval | stepsPerintervalWeekdayMean$Day , 
       type="h", xlab="Interval", ylab="Numbers of steps" ,layout = c(1, 2))  ## Plot with 2 panels


aggregate(DSCompleted$steps, by = list(DSCompleted$Weekday), FUN = mean)
