---
title: "PA1_template.Rmd"
output: html_document
---

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r}
summary(cars)
```

You can also embed plots, for example:

```{r, echo=FALSE}
plot(cars)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
# First we load the required libraries
library(knitr)
library(data.table)
library(ggplot2)

# For code chunks to be readable and reproducible we set echo equal to TRUE
opts_chunk$set(echo = TRUE)

# We load the already unzipped csv in a data frame
df <- read.csv("activity.csv", as.is=TRUE)

# We generate df2 omitting NAs
df2 <- na.omit(df)

# Then we aggregate steps per date
stepsdate <- aggregate(steps ~ date, df2, sum)

# We create an histogram of total number steps per day
hist(stepsdate$steps, col=1, main="Total number of steps per day", xlab="Steps per day")

# We let the pc calculate the mean of total number of steps per day
mean(stepsdate$steps)

# We let the pc calculate the median of total number of steps per day
median(stepsdate$steps)

# We create the plot with the average number of steps taken and the 5 minute intervals
stepsinterval <- aggregate(steps ~ interval, df2, mean)
colnames(stepsinterval) <- c("interval", "steps")
ggplot(stepsinterval, aes(x=interval, y=steps)) +
geom_line(color="gray", size=1) +
labs(title="Average Daily Activity", x="Interval", y="Number of Steps") +
theme_bw()

# Then we calculate the 5 minute interval and the maximum number of steps
maxstepsinterval <- stepsinterval[which.max(stepsinterval$steps),]
maxstepsinterval

# We now want to get rows with NAs
df_NA <- df[!complete.cases(df),]
nrow(df_NA)

# Then we want to fill NAs values with the mean value at the same interval
for (i in 1:nrow(df)){
if (is.na(df$steps[i])){
interval_val <- df$interval[i]
row_id <- which(stepsinterval$interval == interval_val)
steps_val <- stepsinterval$steps[row_id]
df$steps[i] <- steps_val
}
}

# We aggregate steps per date and get the number of steps in a day
newstepsdate <- aggregate(steps ~ date, df, sum)

# We create an histogram with the number of steps in a day
hist(newstepsdate$steps, col=1, main="Total number of steps per day", xlab="Number of steps per day")

# We now want to obtain the mean and the median of the number of steps per day
mean(newstepsdate$steps)

median(newstepsdate$steps)

# Then we want to get the mean and median of the number of steps per day without NAs
mean(stepsdate$steps)

median(stepsdate$steps)

# To identify differences in activity patterns between weekdays and weekends we first convert date from string to Date
df$date <- as.Date(df$date, "%Y-%m-%d")

# Then we add a new column indicating the day of the week
df$day <- weekdays(df$date)

# And we add a new column called for the day type
df$day_type <- c("weekday")

# We define weekends
for (i in 1:nrow(df)){
if (df$day[i] == "Saturday" || df$day[i] == "Sunday"){
df$day_type[i] <- "weekend"
}
}

# We now convert day_time from character to factor
df$day_type <- as.factor(df$day_type)

# We aggregate steps as interval to obtain the average number of steps in an interval across all days
newstepsdate <- aggregate(steps ~ interval+day_type, df, mean)

# We generate the plots for week days and weekends
library(ggplot2)
qplot(interval, steps, data=newstepsdate, geom=c("line"), xlab="Interval", ylab="Number of steps", main="") + facet_wrap(~ day_type, ncol=1)
dev.off()
qplot(interval, steps, data=newstepsdate, geom=c("line"), xlab="Interval", ylab="Number of steps", main="") + facet_wrap(~ day_type, ncol=1)
