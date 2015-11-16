library(timeDate)
library(ggplot2)
library(scales)
library(Hmisc)

assign1data <- read.csv("activity.csv")

smstpsaggdata <- aggregate(steps ~ date, assign1data, sum)

mnstpsaggdata <- aggregate(steps ~ date, assign1data, mean)

mdstpsaggdata <- aggregate(steps ~ date, assign1data, median)

smstpsaggdataint <- aggregate(steps ~ interval, assign1data, sum)

mnstpsaggdataint <- aggregate(steps ~ interval, assign1data, mean)

mdstpsaggdataint <- aggregate(steps ~ interval, assign1data, median)

mnstpsperday <- mean(assign1data$steps, na.rm = T)

mdstpsperday <- median(assign1data$steps, na.rm = T)

qplot(data = smstpsaggdata, x = date, y = steps, geom ="histogram", stat = "identity")

ggplot(data=mnstpsaggdataint, aes(x=interval, y=steps)) +
  geom_line() +
  xlab("5-minute interval") +
  ylab("mean of number of steps taken") 


no_of_NAs <- sum(!complete.cases(assign1data$steps))
filleddata <- transform(assign1data, steps = ifelse(is.na(assign1data$steps), 
                                                    mnstpsaggdataint$steps[match(assign1data$interval, mnstpsaggdataint$interval)], assign1data$steps))
