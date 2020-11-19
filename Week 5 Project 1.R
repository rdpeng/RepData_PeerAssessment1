
#load the data#
library(readstata13)
activity = read.csv("/Users/mcheng/Week 5/activity.csv")

#as.POSIXct(date)#
activity$date <- as.Date(activity$date, "%Y-%m-%d", tz = "Europe/Zurich")
class(activity$date)

#summary of number of steps per day#
library(dplyr)
total <- activity %>% group_by(date) %>% summarise(total = sum(steps, na.rm = T))
total
hist(total$total, main = "Total number of steps taken per day", xlab = "Total steps taken per day", ylim = c(0, 30))
mean(total$total, na.rm = T)
median(total$total, na.rm = T)

#average daily activity pattern#
average <- activity %>% group_by(interval) %>% summarise(average = mean(steps, na.rm = T))
average
plot(average$interval, average$average, type = "l", lwd = 2, xlab="Interval", ylab="Average number of steps", main="Average number of steps per interval")
average[which.max(average$average), ]$interval

#impute missing values#
sum(is.na(activity$steps))
missing_index <- is.na(activity$steps)
m <- mean(average$average)
activity_imputed <- activity
activity_imputed[missing_index,1]<-m
activity_imputed_1 <- activity_imputed %>% group_by(date) %>% summarise(sum = sum(steps))
hist(activity_imputed_1$sum, xlab = "Total steps per day", ylim = c(0,30), main = "Total number of steps taken each day")
mean(activity_imputed_1$sum)
median(activity_imputed_1$sum)

#differences in daily activity pattern between weekdays and weekends#
activity_imputed$weekday <- weekdays(activity_imputed$date)
activity_imputed <- activity_imputed %>% mutate(day = ifelse(weekday=="Saturday" | weekday=="Sunday", "Weekend", "Weekday"))
as.factor(activity_imputed$day)
average2 <- activity_imputed %>% group_by(day, interval) %>% summarise(mean = mean(steps))
average2
library(lattice)
png("plot.png", width = 480, height = 480, units = "px")
with(average2, xyplot(mean ~ interval | day, 
                     type = "l",      
                     main = "Number of Steps within Intervals by day",
                     xlab = "Daily Intervals",
                     ylab = "Number of Steps"))
dev.off()
