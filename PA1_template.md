# Reproducible Research: Peer Assessment 1



## Loading and preprocessing the data

Data are loaded into the variable "activity". 


```r
activity <- tbl_dt(read.csv("activity.csv", stringsAsFactors = FALSE))
```

## What is mean total number of steps taken per day?

### Data processing

The activity data are summarized by grouping the data by date into the variable "tns". 


```r
tns <- 
    activity %>% 
    group_by(date) %>% 
    summarize(steps = sum(steps, na.rm = TRUE))
```

### Plot

```r
qplot(date, steps, 
      data = tns, 
      geom = "histogram", stat = "identity", 
      main = "Total number of steps taken each day"
      ) + theme(axis.text.x = element_text(angle = 90))
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 


```r
#Mean and median of total nr of steps taken per day
mean_tns   <- mean(tns$steps)
median_tns <- median(tns$steps)
```
Mean of the total number of steps taken per day  : 9354.2295082  
Median of the total number of steps taken per day: 10395  

## What is the average daily activity pattern?

The avarage daily activity pattern are summarized by grouping the activity data by interval into the variable "adap".

### Data processing

```r
adap <- 
    activity %>% 
    group_by(interval) %>% 
    summarize(steps = mean(steps, na.rm = TRUE))
```
### Plot

```r
qplot(interval, steps, 
      data = adap, 
      geom = "line", stat = "identity",
      main = "Avarage daily activity")
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png) 


```r
#Max number of steps
max_ns <- adap[which.max(adap$steps),interval]
```

Interval containing the maximum number of steps : 835  

## Imputing missing values


```r
#Number of missing values 
na_nr <- nrow(activity %>% filter(is.na(steps)))
```

The initial dataset contains 2304 missing values for the step variable.  

*Imputation strategy:*   To correct the dataset those missing values will be replaced by the mean value of the corresponding 5-minutes interval. This will be done by a lookup to the table "adap", which already contains the number of step's average for each interval. 

### Data processing

```r
#Activity dataset with no missing value
activity_c <- 
    activity %>%
    #lookup to adap, to complete the missing values
    mutate(steps = ifelse(is.na(steps),adap[adap[,interval]==interval,]$steps,steps)) 
#Corrected dataset containing the total dayly step number 
tns_c <- 
    activity_c %>% 
    group_by(date) %>% 
    summarize(steps = sum(steps, na.rm = TRUE))
```
### Plot

```r
qplot(date, steps, 
      data = tns_c, 
      geom = "histogram", stat = "identity",
      main = "Corrected total number of steps taken each day"
      ) + theme(axis.text.x = element_text(angle = 90))
```

![](PA1_template_files/figure-html/unnamed-chunk-11-1.png) 


```r
#Mean and median of total nr of steps taken per day
mean_tns_c   <- mean(tns_c$steps)
median_tns_c <- median(tns_c$steps)
```
Mean of the total number of steps taken per day  : 10766.1886792    
Median of the total number of steps taken per day: 10766.1886792 

## Are there differences in activity patterns between weekdays and weekends?

### Data processing

A dataset "adap_w" containing the average number of step per interval is generated. A new variable "wd" is added to "adap_w" to enable us to segregate the rows between those belonging to a weekday and those belonging to a  weekend. 


```r
adap_w <- 
    activity_c %>% 
    mutate(wd  = ifelse(wday(date) %in% c(1,7),"Weekend","Weekday")) %>%
    group_by(wd,interval) %>% 
    summarize(steps = mean(steps))
adap_w$wd = as.factor(adap_w$wd)
```
### Plot

```r
qplot(interval, steps, 
      data = adap_w, 
      facets = wd ~ . , 
      geom = "line",
      main = "Activity patterns comparison between weekdays and weekends?")
```

![](PA1_template_files/figure-html/unnamed-chunk-14-1.png) 
