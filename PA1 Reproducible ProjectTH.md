---
title: "Reproducible Project"
author: "H. Tetteh"
date: "29/03/2020"
---

```{r setup, include =FALSE}
library(knitr)
library(dplyr)
library(ggplot2)
knitr::opts_chunk$set(echo = TRUE)
#knitr::knit_hooks$set(plot = knitr::hook_plot_tex)
```

This assignment will be described in multiple parts. You will need to write a report that answers the questions detailed below. Ultimately, you will need to complete the entire assignment in a single R markdown document that can be processed by knitr and be transformed into an HTML file.

## Introduction 
In this project, we will inspect step count data, gathered in 5-minute interval across a period of two months from a personal step-measuring device. We will inspect and graph the individual's walking counts per each day, and their average daily activity pattern. Then, we will impute missing values and replace them with either mean or remove the affected row completely in the dataset to see how this alters these graphs, and compare their weekend to weekday walking habits.


### 1) Loading and preprocessing the data

By looking at the data we can extract useful information such as steps, data and interval. In particular, we will transmute the Date column into the R Date datatype and subtract away the first date count so we can track the number of days since the study began.

```{r activityDataSet}
if (!file.exists('activity.csv')){
  unzip(zipfile = "activity.zip")
}

activityDataSet <- read.csv( file = "activity.csv", header = TRUE)
 
 head(activityDataSet, 20)
 tail(activityDataSet, 20)
```
 
 #### head(activityDataSet, 20)
 
   ####   steps date        interval
#### 1     NA 2012-10-01        0
#### 2     NA 2012-10-01        5
#### 3     NA 2012-10-01       10
#### 4     NA 2012-10-01       15
#### 5     NA 2012-10-01       20
#### 6     NA 2012-10-01       25
#### 7     NA 2012-10-01       30
#### 8     NA 2012-10-01       35
#### 9     NA 2012-10-01       40
#### 10    NA 2012-10-01       45
#### 11    NA 2012-10-01       50
#### 12    NA 2012-10-01       55
#### 13    NA 2012-10-01      100
#### 14    NA 2012-10-01      105
#### 15    NA 2012-10-01      110
#### 16    NA 2012-10-01      115
#### 17    NA 2012-10-01      120
#### 18    NA 2012-10-01      125
#### 19    NA 2012-10-01      130
#### 20    NA 2012-10-01      135
 
  ### tail(activityDataSet, 20)

  ####      steps date         interval
#### 17549    NA 2012-11-30     2220
#### 17550    NA 2012-11-30     2225
#### 17551    NA 2012-11-30     2230
#### 17552    NA 2012-11-30     2235
#### 17553    NA 2012-11-30     2240
#### 17554    NA 2012-11-30     2245
#### 17555    NA 2012-11-30     2250
#### 17556    NA 2012-11-30     2255
#### 17557    NA 2012-11-30     2300
#### 17558    NA 2012-11-30     2305
#### 17559    NA 2012-11-30     2310
#### 17560    NA 2012-11-30     2315
#### 17561    NA 2012-11-30     2320
#### 17562    NA 2012-11-30     2325
#### 17563    NA 2012-11-30     2330
#### 17564    NA 2012-11-30     2335
#### 17565    NA 2012-11-30     2340
#### 17566    NA 2012-11-30     2345
#### 17567    NA 2012-11-30     2350
#### 17568    NA 2012-11-30     2355


#### Analysing the Data
#### Here we have unzipped the compressed folder "activity.zip" in to the folder "activity" which contains our CSV data in "activity.csv". Taking a look at the data, you can see we have a series of step counts (often NA) as well as the date and a steps and intervals refering to the start of the 5 minute interval the device was measuring.By applying head and tail and printing then first and last 20 of the data set.

### 2) What is mean total number of steps taken per day? 

Finding the Daily Means: what are the daily means of the steps? To look at the data we will take our step and find the means for SUM across. Then we will find the overall daily means and median of the dataset as a whole. For the first portion of the analysis, we will be ignoring NA values in the steps. We use the sum function to agregate to the total steps and apply the mean and median fuctions to the sum to return the mean and median to the total number of steps. I Wanted to see how many rows are affected ny the NAs, so I applied the "is.na" to the to Dataset to see how many NAs.

```{r  What is mean total number of steps taken per day? }
# a) Calculate and report the mean and median of total steps taken per day *Excluding NA*
#    Total number of NAs

totalSteps <- aggregate(steps ~ date, activityDataSet, FUN=sum)

sum(is.na(activityDataSet))

mean_Steps_per_day <- mean(totalSteps$steps, na.rm = TRUE)
mean_Steps_per_day

median_Steps_day <- median(totalSteps$steps, na.rm = TRUE)
median_Steps_day

```

#### Total NAs = 2304
#### Mean      = 10766.19
#### Median    = 10765

#### We can see that the individual was pretty consistently active taking around ten thousand steps a day(mean = 10766.19)and the (median = 10765), with some inconsistency around halfway through the dataset. Additionally, we can see the first and final days were very inactive. With our inspections of the head and the tail of the dataset as seen above, we know there were several missing values at the start and end of the dataset. This is part of what motivates us to impute missing values later in the analysis.


#### Graphing Average Daily Activity
#### Let us take a look at what the individual average day looked like. To do this, we rearrange the step data into 61 columns, with each of the 288 rows representing each of the 5 minute intervals the study split the day in to. Notice we transmute the 288 counts on the X axis into hours (starting from midnight as hour zero) for ease of interpretation.


```{r Make a histogram of the total number of steps taken}
totalSteps <- aggregate(steps ~ date, activityDataSet, FUN=sum)

hist(totalSteps$steps,
     main = "Total Steps per Day",
     xlab = "Number of Steps")

```

#### We can see the individual usually stop activity completely around 10 pm, and wake up just befor 6 am. The peak of their activity is around 8 am-- perhaps they walk to work?-- with sporadic activity throughout the day up until 7 pm, whereupon they usually are much more inactive until their likely sleep times. So what, and when, is the peak of this activity?

### 3) What is the average daily activity pattern?

```{r What is the average daily activity pattern}

# preprocessing data for plot
Steps_by_interval <- aggregate(steps ~ interval, activityDataSet, mean)

# create a time series plot 
plot(Steps_by_interval$interval, Steps_by_interval$steps, type='l', 
     main="Average number of steps over all days", xlab="5 - Minute Interval", 
     ylab="Average number of steps")
```
#### The 5-minute interval, on average across all the days in the dataset, containing the maximum number of steps.

```{r The 5-minute interval, on average across all the days in the dataset }
#### find row with max of steps
max_steps_row <- which.max(Steps_by_interval$steps)

#### find interval with this max
Steps_by_interval[max_steps_row,]
```
#### The interval 835 has the maximum average value of steps (206.1698).
So we see that the average peak of activity is around 206 steps in a five minute interal.

### 4 Imputing missing values

#### As we saw before, some of our data is definitely missing, and may be skewing our data. We are particularly suspicious of the first and final days we gathered data for. How much exactly? Let us find out! First, how many missing values are there?

### a) Calculate and report the total number of missing values
```{r Imputing missing values}

sum(is.na(activityDataSet))
```
#### Total rows with missing Values 2304 Rows
#### This is 2304 missing five-minute intervals. This is a large portion of our data, and is likely to distort our the actual patterns. Our day-mean graph indicates that there are many days that the individual did not take any steps, or almost none at all. It is likely these days we are just missing data- so let us replace any missing values with the average steps of the 5 minute intervals that we just graphed to find the daily activity pattern. That way, any 'missing' days will be replaced with the 'average' day.


### b)I replace every NA’s with the mean for that 5-minute interval,since 2304 is a large number i can not remove affected rows.
```{r replace every NA’s with the mean}
activityDataSet_imputed <- activityDataSet
for (i in 1:nrow(activityDataSet_imputed)) {
  if (is.na(activityDataSet_imputed$steps[i])) {
    interval_value <- activityDataSet_imputed$interval[i]
    steps_value <- Steps_by_interval[
     Steps_by_interval$interval == interval_value,]
    activityDataSet_imputed$steps[i] <- steps_value$steps
  }
}

```
#### I’ve created new data set data_no_na which equals to activityDataSet_imputed_row but without NA’s. All NA’s are replaced with mean of 5-minute interval.


### c) printing the first and last 20 rows of the new Dataset(activityDataSet_imputed)
```{r printing the first and last 20 rows}
#activityDataSet_imputed
head(activityDataSet_imputed, 20)

 ####        steps     date      interval
#### 17549	7.0754717	2012-11-30	2220	
#### 17550	8.6981132	2012-11-30	2225	
#### 17551	9.7547170	2012-11-30	2230	
#### 17552	2.2075472	2012-11-30	2235	
#### 17553	0.3207547	2012-11-30	2240	
#### 17554	0.1132075	2012-11-30	2245	
#### 17555	1.6037736	2012-11-30	2250	
#### 17556	4.6037736	2012-11-30	2255	
#### 17557	3.3018868	2012-11-30	2300	
#### 17558	2.8490566	2012-11-30	2305
#### 17559	0.0000000	2012-11-30	2310	
#### 17560	0.8301887	2012-11-30	2315	
#### 17561	0.9622642	2012-11-30	2320	
#### 17562	1.5849057	2012-11-30	2325	
#### 17563	2.6037736	2012-11-30	2330	
#### 17564	4.6981132	2012-11-30	2335	
#### 17565	3.3018868	2012-11-30	2340	
#### 17566	0.6415094	2012-11-30	2345	
#### 17567	0.2264151	2012-11-30	2350	
#### 17568	1.0754717	2012-11-30	2355

tail(activityDataSet_imputed, 20)

 
 
####    stepS        date      interval
#### 1	  1.7169811	2012-10-01	0	
#### 2	  0.3396226	2012-10-01	5	
#### 3	  0.1320755	2012-10-01	10	
#### 4	  0.1509434	2012-10-01	15	
#### 5	  0.0754717	2012-10-01	20	
#### 6	  2.0943396	2012-10-01	25	
#### 7	  0.5283019	2012-10-01	30	
#### 8	  0.8679245	2012-10-01	35	
#### 9	  0.0000000	2012-10-01	40	
#### 10  1.4716981	2012-10-01	45
#### 11	0.3018868	2012-10-01	50	
#### 12	0.1320755	2012-10-01	55	
#### 13	0.3207547	2012-10-01	100	
#### 14	0.6792453	2012-10-01	105	
#### 15	0.1509434	2012-10-01	110	
#### 16	0.3396226	2012-10-01	115	
#### 17	0.0000000	2012-10-01	120	
#### 18	1.1132075	2012-10-01	125	
#### 19	1.8301887	2012-10-01	130	
#### 20	0.1698113	2012-10-01	135	
``` 


#### checking how many Rows of NAs are affected
```{r checking how many Rows of NAs are affected}
sum(is.na(activityDataSet_imputed))
```
#### I’ve created new data set data_no_NA which equals to data_row but without NA’s. All NA’s are replaced with mean of 5-minute interval, so NA is equal to 0 now.


### d) Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day

####The means and medians increase because we are adding count data where there used to be NAs. representing the daily means of the imputed dataset, largely match of the original data on days where we had lots of data. 

```{r Calculate and report the mean and median total number of steps taken per day}

df_imputed_steps <- aggregate(steps ~ date, activityDataSet_imputed , sum)
head(df_imputed_steps, 20)

sum(is.na(df_imputed_steps))
```
### Calculating the mean and median of imputed data
```{r Calculating the mean and median of imputed data}
mean(df_imputed_steps$steps)

median(df_imputed_steps$steps)

```

```{r Make a histogram of the total number of steps taken each day}
hist(df_imputed_steps$steps, main="Histogram of total number of steps per day (imputed)", 
xlab="Total number of steps in a day")
```

#### Graphing Weekend vs. Weekday Activity
#### Finally, we use this imputed dataset to plot a new graph, and see how the individual daily activity changed between weekends and weekdays. I used "type_of_day" function as described below, and split the imputed dataset in to weekend and weekday data, and reshape and take the means of the imputed total, and imputed weekday and weekend activities identically to how we did in our original daily activity graph.

### 5) Are there differences in activity patterns between weekdays and weekends?

```{r Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day. }
activityDataSet_imputed['type_of_day'] <- weekdays(as.Date(activityDataSet_imputed$date))
activityDataSet_imputed$type_of_day[activityDataSet_imputed$type_of_day  %in% c('Saturday','Sunday') ] <- "weekend"
activityDataSet_imputed$type_of_day[activityDataSet_imputed$type_of_day != "weekend"] <- "weekday"

```

```{r Convert type_of_day from character to factor }

activityDataSet_imputed$type_of_day <- as.factor(activityDataSet_imputed$type_of_day)
```

```{r Make a panel plot containing a time series plot}
df_imputed_steps_by_interval <- aggregate(steps ~ interval + type_of_day, activityDataSet_imputed , mean)
```


```{r The Make a panel plot containing a time series plot}
qplot(interval, 
      steps, 
      data = df_imputed_steps_by_interval, 
      type = 'l', 
      geom=c("line"),
      xlab = "Interval", 
      ylab = "Number of steps", 
      main = "Average Daily Activity Pattern") +
  facet_wrap(~ type_of_day, ncol = 1)
```
#### We see that on weekends, the individual was less active between 0 to 500 intervals and their peak activity was a little bit lower and later in the day during weekends. They were more consistently active throughout the day on weekends however, and the majority of their activities increase after 750 and 2000 intervals can probably be attributed to weekend activity.

#### Conclusions
To sum up, we find that the individual walked around 10,000 steps a day, there are 2304 missing data(2304/12+24 = 8 days) 8 days worth of missing values can be imputed with mean activity, but doing so still leaves about 3 days worth of improbably low activity unaccounted for, and that the individual was more active, but active later, on weekends than on weekdays.
