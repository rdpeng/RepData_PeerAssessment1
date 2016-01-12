---
title: "Project 1 - RD"
author: "Ryan deMartino"
date: "Wednesday, January 06, 2016"
output:
  html_document
---

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

Reading in the assignment file:

```{r}
PAMD <- read.csv("activity.csv")
```

Making a histogram of total steps per day:

```{r, echo=TRUE}
byday <- tapply(PAMD$steps, PAMD$date, FUN = sum)
hist(byday)
```

Calculating the mean and median total # of steps per day:

```{r}
mean(byday, na.rm = TRUE)
median(byday, na.rm = TRUE)
```

Making a plot of average steps per 5m interval:

```{r, echo=TRUE}
byinterval <- tapply(PAMD$steps, PAMD$interval, FUN = mean, na.rm = TRUE)
plot(PAMD$interval[1:288], byinterval, type = "l", main = "Steps by 5 Minute Interval", xlab = "Time", ylab= "Average Steps")
```

Maximum average steps per 5m interval and when it occurs:

```{r}
match(max(byinterval), byinterval)
print("Highest average steps taken at 8:35AM (~206 steps).")
```

Replace missing with average during that time:

```{r}
labels <- seq(from = 0, to = 2355, by = 5)
merger <- cbind(labels, byinterval)
combo <- merge(PAMD, merger, by.x = "interval", by.y = "labels")
missing <- is.na(combo$steps)
combo_fix <- combo
combo_fix$steps[missing] <- combo_fix$byinterval[missing]
```

Making a histogram of total steps per day (on new set with replaced values):

```{r, echo=TRUE}
byday2 <- tapply(combo_fix$steps, combo_fix$date, FUN = sum)
hist(byday2)
```

Calculating the mean and median total # of steps per day (on new set with replaced values):

```{r}
mean(byday2, na.rm = TRUE)
median(byday2, na.rm = TRUE)
```

Activity patterns of weekdays and weekends:

```{r, echo = TRUE}
wkday <- ifelse(weekdays(as.Date(combo_fix$date)) == "Saturday" | weekdays(as.Date(combo_fix$date)) == "Sunday", "Weekend", "Weekday")
patterns <- cbind(combo_fix, wkday)
library(lattice)
plotdata <- aggregate(steps ~ interval + wkday, patterns, mean)
xyplot(steps ~ interval | factor(wkday), data=plotdata, aspect=1/3, type="l")
```
