unzip("activity.zip")
origData <-
    read.csv(
        "activity.csv",header = TRUE, colClasses = c("integer", "Date", "integer")
    )
dailySteps<-aggregate(steps~date,data=origData,sum,na.rm=TRUE)
hist(dailySteps$steps)

sprintf("The mean of daily steps is %.0f, and the median is %.0f.",
        mean(dailySteps$steps),median(dailySteps$steps))
stepsInterval<-aggregate(steps~interval,data=origData,mean,na.rm=TRUE)
plot(steps~interval,data=stepsInterval,type="l")
stepsInterval[which.max(stepsInterval$steps),]$interval
missingData <- sum(is.na(origData$steps))

#--------------------- look below for output sprintf --------
sprintf("Number of missing points is %i, %3.1f%% of total.",
        missingData,missingData/length(origData$steps)*100)
# ---------------------- begin imputed value processing -----
imputedData <- origData                                        #Make a copy of the original data
intervalMedians <- aggregate(steps ~ interval, origData, median)   # Calculate step median by interval

imputedData$substitute <- rep(intervalMedians$steps)             # Replicate for each day and add
                                                               # col of substitute data
# Loop through data, substituting imputed value for each NA

for (i in 1:length(imputedData$steps)){                        # Loop through all intervals
    if (is.na(imputedData$steps[i]))
         imputedData$steps[i] <- imputedData$substitute[i]     # Substituting when NA occurs
}

imputedDailySteps<-aggregate(steps~date,data=imputedData,sum,na.rm=TRUE)
hist(imputedDailySteps$steps)

sprintf("The mean of daily steps (with imputation) is %.1f, and the median is %.1f.",
mean(imputedDailySteps$steps),
median(imputedDailySteps$steps))
sprintf("Imputing cause a change of %.1f%% in mean and %.1f%% in median",
(mean(dailySteps$steps)-mean(imputedDailySteps$steps))/mean(dailySteps$steps)*100,
(median(dailySteps$steps)-median(imputedDailySteps$steps))/median(dailySteps$steps)*100)


#df$major2 <-
#   ifelse(df$degree1 == "BA",
#    df$subj1,
#    ifelse(df$degree2 == "BA",
#    df$subj2,NA))

imputedData$day <- as.factor()
    if (substr(imputedData$date,1,1) == "S")
        "Weekend" else "Weekday"










