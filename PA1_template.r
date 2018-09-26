#load the data
fileUrl<-"https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(fileUrl,destfile="./data1/Dataset.zip")
unzip(zipfile="./data1/Dataset.zip",exdir="./data1")
path_rf <- file.path("./data1" , "data1.csv")
files<-list.files(path_rf, recursive=TRUE)
act<-read.csv("./data1/activity.csv")

#Histogram of the total number of steps taken each day
stepperday<-tapply(act$steps,act$date,sum,na.rm=T)
hist(stepperday, xlab = "number of steps",
     main = "the total number of steps taken each day")

#Mean and median number of steps taken each day
summary(stepperday)

#Time series plot of the average number of steps taken


#The 5-minute interval that, on average, contains the maximum number of steps
#Code to describe and show a strategy for imputing missing data
stepsNA <- sum(is.na(act$steps))
dateNA <- sum(is.na(act$date))
intervalNA <- sum(is.na(act$interval))

#Histogram of the total number of steps taken each day after missing values are imputed
numMissingValues <- length(which(is.na(act$steps)))
numMissingValues
###set a function to impute the NA
impute <- function(x, x.impute){ifelse(is.na(x),x.impute,x)}
act2 <- act
act2$steps <- impute(act$steps, mean(act$steps))
###Make a histogram of the total number of steps taken each day
act2step <- tapply(act2$steps, act2$date, sum,na.rm=TRUE)
qplot(act2step, xlab='Total steps per day (Imputed)',bins=50)


#Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends
##make a new vector to describe weekday and weekend
act2$dateType <-  ifelse(as.POSIXlt(act2$date)$wday %in% c(0,6), 'weekend', 'weekday')
##make the plot
avgAct2 <- aggregate(steps ~ interval + dateType, data=act2, mean)
ggplot(avgAct2, aes(interval, steps)) + 
  geom_line() + 
  facet_grid(dateType ~ .) +
  xlab("5-minute interval") + 
  ylab("avarage number of steps")

#All of the R code needed to reproduce the results (numbers, plots, etc.) in the report