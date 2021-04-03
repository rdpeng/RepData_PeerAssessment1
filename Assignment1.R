data <- read.csv("activity.csv", stringsAsFactors = FALSE)
data$date <- as.Date(data$date, "%Y-%m-%d")

data <- as.data.frame(data)

data1 <- data

Q1 <- ddply(data, "date", summarise,
            nsteps = sum(steps, na.rm = TRUE))

ggplot(data = Q1, aes(x = nsteps)) +
  geom_histogram(fill = "skyblue", col="black",bins = 20) +
  xlab("Total Steps Per Day") +
  ylab("Frequency Count") +
  ggtitle("Total Number of Steps")

mean(Q1$nsteps)
median(Q1$nsteps)

# Average Activity Pattern 

means <- with(na.omit(data), tapply(steps, interval, mean))
head(means, 5)


Q2 <- ddply(data, "interval", summarise,
            nSteps = mean(steps, na.rm = TRUE))

ggplot(data = Q2, aes(x= interval, y = nSteps)) +
  geom_line(color = "red") +
  xlab("5 Minute Interval")+
  ylab("Average Steps") +
  theme_economist_white()




# Which 5 minute interval, on average across all the days in the dataset, contain the maximun number of steps

means[which(means == max(means))]

# Imputting missing values 
sum(is.na(data))
vis_dat(data)
vis_miss(data)
nrow(data)
(2304/17568)
head(data)
tail(data)

data2 <- data

intUQ <- unique(data2$interval)  # getting the number of unique values from the interval
rows <- nrow(data[is.na(data2), ]) # rows with no missing data

NAintr <- data[is.na(data2), 3] # of missing values in the interval columns
STEPSna <-data[is.na(data2), 1] # of missing values steps first columns 

# i for rows, j for columns. Dinov's data science textbook ( 2018:79-81) was useful 
# to in creating a function that deals with missing values. 

for (j in 1:2304){       # missing values 
  for (i in 1:288) {     # number of intervals 
    if(NAintr[j] == intUQ[i]) # if they are equal t
      STEPSna[j] <- means[i] # then replace with the means from the mneans columns
  }
}

indX <- is.na(data$steps)
data$steps <- replace(data$steps, indX, STEPSna)
head(data)

Q3 <- ddply(data2, "date", summarise, Nsteps = sum(steps, na.rm = TRUE))

ggplot(data = Q3, aes(x = Nsteps)) +
  geom_histogram(fill = "skyblue", col = "red", bins = 20) +
  xlab("Total Steps per Day") +
  ylab("Frequency (count)") +
  theme_clean()

steps <- with(data = data, tapply(steps,date, sum))
vis_dat(data)
vis_miss(data)
mean(steps)
median(steps)

#Are there difference in activity patterns between weekends and weekdays 

Q3 <- data
Q3 <- mutate(Q3, day = weekdays(Q3$date))
Q3 <- as.data.frame(Q3)

weekdays <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
Q3$day <- factor((weekdays(Q3$date) %in% weekdays), 
                 levels=c(FALSE, TRUE), labels=c('Weekend', 'Weekday'))

weekdays <- subset(Q3, day == "Weekday")
weekends <- subset(Q3, day == "Weekend")

wday <- aggregate(steps~interval, weekdays, mean)
wend <- aggregate(steps~interval, weekends, mean)

days_activity <- cbind(wday,wend$steps)

names(days_activity)[2] <- "Weekday"
names(days_activity)[3] <- "Weekend"

p1 <- ggplot(data = days_activity, aes(x = interval, y = Weekday, col = "black")) + 
  geom_line() + theme_fivethirtyeight() + ggtitle("Avg Daily Activity by Weekdays/Weekend")

p2 <- ggplot(data = days_activity, aes(x = interval, y = Weekend, col ="red")) + 
  geom_line()+ theme_fivethirtyeight()

Final <- p1 / p2
Final + xlab("Interval") + ylab("Number of Steps") +
  xlim(0,2500)



 












