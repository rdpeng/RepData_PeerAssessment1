act <- read.csv("RepData_PeerAssessment1/activity.csv")
names(act)
head(act)
sapply(act, class)
act$date <- as.Date(act$date)
act$Steps <- as.numeric(act$Steps)
length(unique(act$interval))
colnames(act) <- c("Steps", "Date", "Interval")
library(dplyr)
actSummary <- group_by(act, Date) %>%
    summarize(totalSteps = sum(Steps), meanSteps=mean(Steps), medianSteps=median(Steps))

## histogram
library(ggplot2)
myMean <- mean(actSummary$totalSteps, na.rm=T)
myMedian <- median(actSummary$totalSteps, na.rm=T)

g <- ggplot(actSummary, aes(x=totalSteps), na.rm=T)
g + geom_histogram(na.rm=T, bins=25) +
    geom_vline(xintercept=(myMean), linetype="solid", size=1, col = "green") +
    geom_vline(xintercept=(myMedian), linetype="dashed", size=1, col="red") +
    labs(title="Histogram of Steps", x="Steps/Day", y="Count") 


## Line plot 1
actInterval <- group_by(act, interval) %>% 
    summarize(meanSteps=mean(steps, na.rm=T))
max = max(actInterval$meanSteps)
maxStepInterval <- filter(actInterval, meanSteps > 206.1)
maxStepInterval<-as.data.frame(maxStepInterval)

plot(actInterval$interval, actInterval$meanSteps, type="l", xlab="Interval", ylab="Steps", col = "42")
abline(v = maxStepInterval$interval, col = "purple", lwd = "3")

## data for lineplot 2
## Create a column for days of the week
byWeekType <- mutate(act, WeekType = weekdays(act$date, abbreviate=FALSE))
weekDays <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
weekEnds <- c("Saturday", "Sunday")

for (day in 1:5){
    byWeekType$WeekType <- gsub(weekDays[day], "Weekdays", byWeekType$WeekType)
}
    
for (day in 1:2){
    byWeekType$WeekType <- gsub(weekEnds[day], "Weekends", byWeekType$WeekType)
}

#convert to `factor` and specify the `levels/labels`
weekdays <- byWeekType$WeekType[,]
final <- group_by(byWeekType, interval) %>% 
    summarize(meanSteps=mean(steps, na.rm=T))
max = max(actInterval$meanSteps)
maxStepInterval <- filter(actInterval, meanSteps > 206.1)
maxStepInterval<-as.data.frame(maxStepInterval)

plot(actInterval$interval, actInterval$meanSteps, type="l", xlab="Interval", ylab="Steps", col = "42")
abline(v = maxStepInterval$interval, col = "purple", lwd = "3")

## Imputing missing values
library(mice)
imputed<-mice(act, meth='pmm')
completedData <- complete(imputed, 1)

## Look at histogram of imputed data
impSummary <- group_by(completedData, Date) %>%
    summarize(totalSteps = sum(Steps), meanSteps=mean(Steps), medianSteps=median(Steps))

impMyMean <- mean(impSummary$totalSteps, na.rm=T)
impMyMedian <- median(impSummary$totalSteps, na.rm=T)

g <- ggplot(impSummary, aes(x=totalSteps), na.rm=T)
g + geom_histogram(na.rm=T, bins=25) +
    geom_vline(xintercept=(impMyMean), linetype="solid", size=1, col = "green") +
    geom_vline(xintercept=(impMyMedian), linetype="dashed", size=1, col="red") +
    labs(title="Histogram of Steps", x="Steps/Day", y="Count") 

## Create a factor variable weekday and weekday

    

## panel plot

## Weekday
weekend_panel <- group_by(Weekend_final, interval) %>%
    summarize(meanSteps=mean(steps, na.rm=T))
max = max(weekend_panel$meanSteps)
maxStepInterval <- filter(weekend_panel, meanSteps %in% max)
maxStepInterval<-as.data.frame(maxStepInterval)

plot(weekend_panel$interval, weekend_panel$meanSteps, type="l", xlab="Interval", ylab="Steps", col = "42")
abline(v = maxStepInterval$interval, col = "purple", lwd = "3")

## Weekend
