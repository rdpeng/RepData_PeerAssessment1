library(ggplot2)
library(data.table)
library(plyr)
library(sqldf)



if (!file.exists("actmoni_data")) {
  dir.create("actmoni_data")
}
if (!file.exists("actmoni_data/activity.csv")){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
  download.file(fileUrl, destfile = "actmoni_data/activity.zip")
  unzip("actmoni_data/repdata-data-activity.zip")
}




actmoni_data <- read.csv('activity.csv', header = TRUE, sep = ",",
                         colClasses=c("numeric", "character", "numeric"))
actmoni_data$date <- as.Date(actmoni_data$date, format = "%Y-%m-%d")
actmoni_data$interval <- as.factor(actmoni_data$interval)




actmoni_data.ignore.na <- na.omit(actmoni_data) 
daily.steps <- rowsum(actmoni_data.ignore.na$steps, format(actmoni_data.ignore.na$date, '%Y-%m-%d')) 
daily.steps <- data.frame(daily.steps) 
names(daily.steps) <- ("steps")
hist(daily.steps$steps, 
     main="Histogram of steps taken / day",
     breaks=10, col="red",
     xlab="Total number of steps taken daily",
     ylab="Number of times / day")


mean(daily.steps$steps); 
median(daily.steps$steps) 





steps_per_interval <- aggregate(actmoni_data$steps, 
                                by = list(interval = actmoni_data$interval),
                                FUN=mean, na.rm=TRUE)
steps_per_interval$interval <- 
  as.integer(levels(steps_per_interval$interval)[steps_per_interval$interval])
colnames(steps_per_interval) <- c("interval", "steps")
ggplot(steps_per_interval, aes(x=interval, y=steps)) +   
  geom_line(color="green", size=1) +  
  labs(title="Average Daily Activity Pattern", x="Interval", y="Number of steps") +  
  theme_bw()


interval.mean.steps[which.max(interval.mean.steps$mean), ]





missing_vals <- sum(is.na(actmoni_data$steps))

tNA <- sqldf(' 
             SELECT d.*            
             FROM "actmoni_data" as d
             WHERE d.steps IS NULL 
             ORDER BY d.date, d.interval ')

NROW(tNA) 


na_fill <- function(actmoni_data, pervalue) {
  na_index <- which(is.na(actmoni_data$steps))
  na_replace <- unlist(lapply(na_index, FUN=function(idx){
    interval = actmoni_data[idx,]$interval
    pervalue[pervalue$interval == interval,]$steps
  }))
  fill_steps <- actmoni_data$steps
  fill_steps[na_index] <- na_replace
  fill_steps
}


actmoni_data_fill <- data.frame(  
  steps = na_fill(actmoni_data, steps_per_interval),  
  date = actmoni_data$date,  
  interval = actmoni_data$interval)
str(actmoni_data_fill)
sum(is.na(actmoni_data_fill$steps))

fill_steps_per_day <- aggregate(steps ~ date, actmoni_data_fill, sum)
colnames(fill_steps_per_day) <- c("date","steps")

ggplot(fill_steps_per_day, aes(x = steps)) + 
  geom_histogram(fill = "purple", binwidth = 1000) + 
  labs(title="Histogram of steps taken / day", 
       x = "Number of steps / Day", y = "Number of times / day")+theme_bw()
steps_mean_fill   <- mean(fill_steps_per_day$steps, na.rm=TRUE)
steps_median_fill <- median(fill_steps_per_day$steps, na.rm=TRUE)


t1.mean.steps.per.day <- as.integer(t1.total.steps / NROW(t1.total.steps.by.date) )
t1.mean.steps.per.day
t1.median.steps.per.day <- median(t1.total.steps.by.date$t1.total.steps.by.date)
t1.median.steps.per.day






weekdays_steps <- function(actmoni_data) {
  weekdays_steps <- aggregate(actmoni_data$steps, by=list(interval = actmoni_data$interval),
                              FUN=mean, na.rm=T)
  weekdays_steps$interval <- 
    as.integer(levels(weekdays_steps$interval)[weekdays_steps$interval])
  colnames(weekdays_steps) <- c("interval", "steps")
  weekdays_steps
}

actmoni_data_by_weekdays <- function(actmoni_data) {
  actmoni_data$weekday <- 
    as.factor(weekdays(actmoni_data$date))
  weekend_actmoni_data <- subset(actmoni_data, weekday %in% c("Saturday","Sunday"))
  weekday_actmoni_data <- subset(actmoni_data, !weekday %in% c("Saturday","Sunday"))
  
  weekend_steps <- weekdays_steps(weekend_actmoni_data)
  weekday_steps <- weekdays_steps(weekday_actmoni_data)
  
  weekend_steps$dayofweek <- rep("weekend", nrow(weekend_steps))
  weekday_steps$dayofweek <- rep("weekday", nrow(weekday_steps))
  
  actmoni_data_by_weekdays <- rbind(weekend_steps, weekday_steps)
  actmoni_data_by_weekdays$dayofweek <- as.factor(actmoni_data_by_weekdays$dayofweek)
  actmoni_data_by_weekdays
}

actmoni_data_weekdays <- actmoni_data_by_weekdays(actmoni_data_fill)

ggplot(actmoni_data_weekdays, aes(x=interval, y=steps)) + 
  geom_line(color="blue") + 
  facet_wrap(~ dayofweek, nrow=2, ncol=1) +
  labs(x="Interval", y="Number of steps")+theme_bw()

