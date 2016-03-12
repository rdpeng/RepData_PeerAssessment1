# Reproducible Research
Adam  
March 10, 2016  
Declarations

```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(ggplot2)
library(lubridate)
```
Download the Dataset

```r
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip",temp)
stepdata <- read.csv(unz(temp, "activity.csv"),stringsAsFactors = F)
unlink(temp)
```

What is the mean and median number of steps taken per day?

```r
daily_data <- stepdata %>% select(date,steps) %>% group_by(date) %>% summarise(total_steps=sum(steps,na.rm=T))
mean(daily_data$total_steps, na.rm=T)
```

```
## [1] 9354.23
```

```r
median(daily_data$total_steps, na.rm=T)
```

```
## [1] 10395
```

```r
hist(daily_data$total_steps, breaks = 15, freq = F, xlab = 'Daily Steps', ylab = 'Probability', main = 'Histogram of Daily Step Total with Kernel Density Plot')
lines(density(daily_data$total_steps, na.rm = T, from = 0, to = max(daily_data$total_steps)))
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)

What is the average daily activity pattern?

```r
time_data <- stepdata %>% select(interval,steps) %>% group_by(interval) %>% summarise(avg_steps=mean(steps,na.rm=T))
plot(time_data, type='l')
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)

```r
max_location<-grep(max(time_data$avg_steps,na.rm=T),time_data$avg_steps)
time_data[max_location,]
```

```
## Source: local data frame [1 x 2]
## 
##   interval avg_steps
##      (int)     (dbl)
## 1      835  206.1698
```

Impute Missing Values:

```r
  filled_data <- stepdata %>% select(date,interval,steps) %>% left_join(time_data, by="interval")
  filled_data <- filled_data %>% mutate(imputed_steps = ifelse(is.na(steps),avg_steps,steps))
  imputed_totals <- aggregate(imputed_steps ~ date, data=filled_data, FUN=sum)
  hist(imputed_totals$imputed_steps, breaks = 15, freq = F, xlab = 'Daily Steps', ylab = 'Probability', main = 'Histogram of Daily Step Total after Imputing Missing Values\n with Kernel Density Plot')
  lines(density(imputed_totals$imputed_steps, na.rm = T, from = 0, to = max(imputed_totals$imputed_steps)))
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)

```r
  summary(filled_data)  
```

```
##      date              interval          steps          avg_steps      
##  Length:17568       Min.   :   0.0   Min.   :  0.00   Min.   :  0.000  
##  Class :character   1st Qu.: 588.8   1st Qu.:  0.00   1st Qu.:  2.486  
##  Mode  :character   Median :1177.5   Median :  0.00   Median : 34.113  
##                     Mean   :1177.5   Mean   : 37.38   Mean   : 37.383  
##                     3rd Qu.:1766.2   3rd Qu.: 12.00   3rd Qu.: 52.835  
##                     Max.   :2355.0   Max.   :806.00   Max.   :206.170  
##                                      NA's   :2304                      
##  imputed_steps   
##  Min.   :  0.00  
##  1st Qu.:  0.00  
##  Median :  0.00  
##  Mean   : 37.38  
##  3rd Qu.: 27.00  
##  Max.   :806.00  
## 
```



Are there different patterns between weekdays and weekends?

```r
  filled_data$weekday <- weekdays(ymd(filled_data$date))
  filled_data <- transform(filled_data, grouping = ifelse(weekday == "Saturday"|weekday == "Sunday","Weekend","Weekday"))
  comparison_data <- filled_data %>% select(grouping,interval,imputed_steps) %>% group_by(grouping,interval) %>%
      summarise(avg_steps=mean(imputed_steps, na.rm=T))
  ggplot(data=comparison_data, aes(interval,avg_steps))+geom_line(color="black")+facet_wrap(~grouping,nrow=2)
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png)
