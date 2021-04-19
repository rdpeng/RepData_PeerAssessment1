---
title: "Reproducible Research: Peer Assessment 1..."
author: "Darwin Reynell Nava"
date: "19 de abril de 2021"
output: html_document
---

## Loading and preprocessing the data  
```{r echo=TRUE}  
library(dplyr)
steps <- read.csv("./activity.csv", sep=",", header=TRUE)  
steps <- na.omit(steps)  
steps$date <- as.Date(steps$date)  
by_day <- group_by(steps, date)  
steps_daily <- summarize(by_day, steps=sum(steps))  
```

## What is mean total number of steps taken per day?  
```{r echo=TRUE}  
par(mar=c(4,4,2,1))  
hist(steps_daily$steps, breaks=30, xlab="Number of steps", ylab = "Frequency", main = "Distribution. Number of steps daily", col="yellow", xlim=c(0, 25000))  
abline(v= mean(steps_daily$steps, na.rm = TRUE), lwd=2, lty=4, col="red")  
abline(v= median(steps_daily$steps, na.rm = TRUE), lwd=2,lty=2,col="blue")  
m <- paste("Mean:",mean(steps_daily$steps, na.rm = TRUE))  
md <- paste("Median:",median(steps_daily$steps, na.rm = TRUE))  
legend("topright", cex=0.7, pch=c(16,16),col=c("red", "blue"), legend=c(m, md))  
print(paste(m, " ", md))  
```  