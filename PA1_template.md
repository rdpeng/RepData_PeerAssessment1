RepData_PeerAssessment1_TZs
Zsolt Terjek
2023-06-03
Calling the libraries

library(tidyverse)
## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.1     ✔ readr     2.1.4
## ✔ forcats   1.0.0     ✔ stringr   1.5.0
## ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
## ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
## ✔ purrr     1.0.1     
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
library(mice)
## 
## Attaching package: 'mice'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     cbind, rbind

### Loading and preprocessing the data

Reading the data downloaded to the desktop

activity <- read.csv("C:/Users/zterjek/Desktop/activity.csv")

### What is mean total number of steps taken per day?

Calculate the total steps taken per day, visualize it with a histogram

perdaysum <- aggregate(steps ~ date, activity, sum)

hist(perdaysum$steps, breaks = 20, col = "steelblue")

![image](https://github.com/zsoltterjek/RepData_PeerAssessment1/assets/128890269/0203fc3f-04d6-4292-9f11-cc0fd2fbecb5)

Calculate and report the average and median of total taken steps

perdaymean <- mean(perdaysum$steps)

perdaymed <- median(perdaysum$steps)

perdaymean
## [1] 10766.19
perdaymed
## [1] 10765

### What is the average daily activity pattern?

Calculate the average steps taken by intervals, visualize it with a line chart

perintervalmean <- aggregate(steps ~ interval, activity, mean)

plot(perintervalmean$interval, perintervalmean$steps, type = "l", col = "darkred",
     lwd = 1.5)

![image](https://github.com/zsoltterjek/RepData_PeerAssessment1/assets/128890269/f43a4cd6-c32c-45ac-84e7-582726dd0c8c)

Calculate and report the interval when max steps were taken

maxstepsperinterval <- max(perintervalmean$steps)

maxstepsinterval <- filter(perintervalmean, steps == maxstepsperinterval)

maxstepsinterval$interval
## [1] 835

### Imputing missing values

Calculate and report the interval when max steps were taken

maxstepsperinterval <- max(perintervalmean$steps)

maxstepsinterval <- filter(perintervalmean, steps == maxstepsperinterval)

maxstepsinterval$interval
## [1] 835
Impute the missing values with predictive mean matching

md.pattern(activity)

![image](https://github.com/zsoltterjek/RepData_PeerAssessment1/assets/128890269/7e8abacf-6a3d-4ad6-b467-9148023bf00e)


##       date interval steps     
## 15264    1        1     1    0
## 2304     1        1     0    1
##          0        0  2304 2304

activity_imputed <- data.frame(original = activity$steps,
    imputed_steps = complete(mice(activity, method = "pmm"))$steps)
## 
##  iter imp variable
##   1   1  steps
##   1   2  steps
##   1   3  steps
##   1   4  steps
##   1   5  steps
##   2   1  steps
##   2   2  steps
##   2   3  steps
##   2   4  steps
##   2   5  steps
##   3   1  steps
##   3   2  steps
##   3   3  steps
##   3   4  steps
##   3   5  steps
##   4   1  steps
##   4   2  steps
##   4   3  steps
##   4   4  steps
##   4   5  steps
##   5   1  steps
##   5   2  steps
##   5   3  steps
##   5   4  steps
##   5   5  steps
## Warning: Number of logged events: 1

activity_imputed$num <- 1:17568
activity$num <- 1:17568

merged_activity <- merge(activity, activity_imputed, by = "num")
merged_activity <- merged_activity[,-c(1, 2)]
merged_activity <- rename(merged_activity, original_steps = original)
md.pattern(merged_activity)

![image](https://github.com/zsoltterjek/RepData_PeerAssessment1/assets/128890269/0da5078f-626c-4930-b58d-c20397b2d572)

##       date interval imputed_steps original_steps     
## 15264    1        1             1              1    0
## 2304     1        1             1              0    1
##          0        0             0           2304 2304

Calculate the total steps taken per day of the imputed dataset, visualize it with a histogram

perdaysum_merged <- aggregate(imputed_steps ~ date, merged_activity, sum)

hist(perdaysum_merged$imputed_steps, breaks = 20, col = "darkgreen")

![image](https://github.com/zsoltterjek/RepData_PeerAssessment1/assets/128890269/cc144fcd-0ce5-4b9b-b6fb-b2d38f13ec86)

Calculate and report the average and median of total taken steps in the imputed dataset

perdaymean_merged <- mean(perdaysum_merged$imputed_steps)

perdaymed_merged <- median(perdaysum_merged$imputed_steps)

perdaymean_merged
## [1] 10479.26
perdaymed_merged
## [1] 10439


### Are there differences in activity patterns between weekdays and weekends?

Checking the weekdays

merged_activity$date <- as.Date(merged_activity$date)

merged_activity$daytype <- as.factor(ifelse(weekdays(merged_activity$date) %in%                         c("szombat", "vasárnap"), "Weekend", "Weekday"))
Calculate the average steps taken by intervals, visualize it with a line chart with weekdays and weekends separated

grouped <- merged_activity %>% group_by(daytype, interval) %>%
    summarize_at("imputed_steps", mean)

ggplot(grouped, aes(interval, imputed_steps))+
    geom_line(aes(col = daytype))+
    facet_wrap(.~ grouped$daytype, nrow = 2, ncol = 1)

![image](https://github.com/zsoltterjek/RepData_PeerAssessment1/assets/128890269/b5e182a5-7b8c-4aa7-aaac-0fb1819ed0a8)
