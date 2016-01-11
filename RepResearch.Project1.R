#required Libraries
library(dplyr)

#define activity data set
df = read.csv(file.choose())

#transform dataset to steps by day
steps.per.day = df %>% group_by(date) %>% summarise( sum = sum(steps))

#histogram of steps per day 
hist(steps.per.day$sum)

#mean and median steps per day 
mean(steps.per.day$sum, na.rm = TRUE)

median(steps.per.day$sum, na.rm = TRUE)

#transform dataset to steps by interval
steps.per.interval = df %>% na.omit() %>% group_by(interval) %>% summarize(steps = mean(steps))

#timeseries plot
plot(steps ~ interval, type = "l", data = steps.per.interval)

#find interval with maximum amount of steps
steps.per.interval[which.max(steps.per.interval$steps),]

#finding number of NA values
sum(is.na(df$steps))

#subset na valuess
nas = is.na(df$steps)
steps = steps.per.interval$steps
names(steps) = steps.per.interval$interval
df$steps[nas] = steps[as.character(df$interval[nas])]

#check if any nas
sum(is.na(df$steps))

#transform imputed dataset to steps by day 
imputed.steps.per.day  = df %>% group_by(date) %>% summarise( sum = sum(steps))

#histogram of steps per day 
hist(imputed.steps.per.day$sum)

#mean and median steps per day 
mean(imputed.steps.per.day$sum, na.rm = TRUE)

median(imputed.steps.per.day$sum, na.rm = TRUE)

#clean date format
df$date = ymd(df$date)

#add "weekday" column
df = df %>% mutate(weekday = ifelse(weekdays(df$date) == "Saturday" | weekdays(df$date) == "Sunday", "Weekend", "Weekday"))

#summarise steps per interval per weekday factor
steps.per.interval.day = df %>% group_by(interval, weekday) %>% summarise(steps = mean(steps))

#plot of steps per interval between weekday and weekend  
s = ggplot(interval_full, aes(x=interval, y=steps, color = weekday)) + geom_line() + facet_wrap(~weekday, ncol = 1, nrow=2)
s