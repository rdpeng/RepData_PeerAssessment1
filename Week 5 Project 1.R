
#load the data#
library(readstata13)
steps = read.csv("/Users/mcheng/Week 5/activity.csv")

#as.POSIXct(date)#
steps$date <- as.POSIXct(steps$date, "%Y-%m-%d", tz = "GMT")
weekday <- weekdays(steps$date)
steps <- cbind(steps,weekday)
summary(steps)

#summary of number of steps per day#
library(dplyr)
total <- steps %>% group_by(date) %>% summarise(total = sum(steps, na.rm = T))
total
hist(total$total, main = "Total number of steps taken per day", xlab = "Total steps taken per day", ylim = c(0, 30))
mean(total$total, na.rm = T)
median(total$total, na.rm = T)

#average daily activity pattern#
average <- steps %>% group_by(interval) %>% summarise(average = mean(steps, na.rm = T))
average
plot(average$interval, average$average, type = "l", lwd = 2, xlab="Interval", ylab="Average number of steps", main="Average number of steps per interval")
average[which.max(average$average), ]$interval

#impute missing values#
sum(is.na(steps$steps))
imputed_steps <- average$average[match(steps$interval, average$interval)]
steps_imputed <- transform(steps, steps = ifelse(is.na(steps), yes = imputed_steps, no = steps)) %>% group_by(date) %>% summarise(sum = sum(steps))
hist(steps_imputed$sum, xlab = "Total steps per day", ylim = c(0,30), main = "Total number of steps taken each day")
mean(steps_imputed$sum)
median(steps_imputed$sum)

