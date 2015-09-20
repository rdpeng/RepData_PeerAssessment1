# Ankur Bhatia - peer_assessment_1

This is the RMarkdown file for the Peer Assessment 1 project in the Reproducible data Coursera Class.
Author: Ankur Bhatia
Submit Date: 2015-09-20


# Loading and preprocessing the data


```r
df1 <- read.csv('activity.csv')
library(dplyr)
library(ggplot2)
library(lattice)
```

# What is mean total number of steps taken per day?


```r
df.steps <-
  df1[!is.na(df1$steps), ] %>%
  group_by(date) %>%
  summarise(steps=sum(steps, na.rm=TRUE))
ggplot(df.steps, aes(x=steps)) + geom_histogram()
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 


```r
## Mean of steps per day
mean(df.steps$steps, na.rm=T)
```

```
## [1] 10766.19
```

```r
## Median of steps per day
median(df.steps$steps, na.rm=T)
```

```
## [1] 10765
```

# What is the average daily activity pattern?



```r
df.intsteps <-
  df1[!is.na(df1$steps), ] %>%
  group_by(interval) %>%
  summarise(intsteps = mean(steps, na.rm=TRUE))
plot(df.intsteps, type = "l")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 


```r
df.intsteps[df.intsteps$intsteps == max(df.intsteps$intsteps), ]
```

```
## Source: local data frame [1 x 2]
## 
##   interval intsteps
## 1      835 206.1698
```


# Imputing missing values

```r
## Total number of rows with NAs
dim(df1[is.na(df1), ])[1]
```

```
## [1] 2304
```

```r
## Input missing values with interval average and make histogram
df.fill <-
  merge(df1, df.intsteps) %>%
  mutate(filledsteps = ifelse(is.na(steps), intsteps, steps)) %>%
  select(date, filledsteps) %>%
  group_by(date) %>%
  summarise(filledsteps=sum(filledsteps, na.rm=TRUE))
ggplot(df.fill, aes(x=filledsteps)) + geom_histogram()
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png) 



```r
## Mean of steps per day
mean(df.fill$filledsteps, na.rm=T)
```

```
## [1] 10766.19
```

```r
## Median of steps per day
median(df.fill$filledsteps, na.rm=T)
```

```
## [1] 10766.19
```


# Are there differences in activity patterns between weekdays and weekends?

```r
df2 <-
  df1[!is.na(df1$steps), ] %>%
  mutate(day = weekdays(as.Date(date))) %>%
  mutate(daytype =
           ifelse(day %in% c('Saturday','Sunday'), 'weekend', 'weekday')) %>%
  group_by(daytype, interval) %>%
  summarise(daytypesteps = mean(steps, na.rm=TRUE))

xyplot(daytypesteps ~ interval | daytype, data = df2, layout = c(1, 2), type = "l")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png) 



