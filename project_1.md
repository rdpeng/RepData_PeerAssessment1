This is a document describing analysis of data obtained from a personal
activity monitoring device. The device collects steps taken from the
user in 5 minute intervals. The data is labeled per day.

First of all, we need to download the data and check the name of the
file extracted from the .zip document.

    url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
    download.file(url, destfile = "activity_monitor.zip")
    unzip("activity_monitor.zip")
    list.files()

    ## [1] "activity_monitor.zip" "activity.csv"         "project_1.html"      
    ## [4] "project_1.Rmd"        "side_script_draft.R"

We could see that the name of the file is “activity.csv”. By knowing the
extension, we can pick the correct function in R to read it in, and then
check the content of the data frame.

    activity <- read.csv("activity.csv")
    head(activity)

    ##   steps       date interval
    ## 1    NA 2012-10-01        0
    ## 2    NA 2012-10-01        5
    ## 3    NA 2012-10-01       10
    ## 4    NA 2012-10-01       15
    ## 5    NA 2012-10-01       20
    ## 6    NA 2012-10-01       25

    str(activity)

    ## 'data.frame':    17568 obs. of  3 variables:
    ##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...

We can see it is a data frame with three variables and 17.568
observations. As expected, among the variables there is the number of
steps, under the column “steps”; the interval of time when it was
obtained, in minutes, under the column “interval”; and the date in
format year-month-day when the measurement was taken, under the column
“date”.

In order to facilitate R plotting, it will be helpful to transform
“date” variable into a Date class object in R. We will do this by using
the function as.Date(). Since it accepts only character objects as
input, we will first transform it from factor to character, and then
perform transforming into Date object.

    activity$date <- as.character(activity$date)
    activity$date <- as.Date(activity$date, format = "%Y-%m-%d")
    class(activity$date)

    ## [1] "Date"

### What is the mean total number of steps taken per day?

In order to answer the question about the mean total number of steps
taken per day, we need to sum all the intervals collected in each day,
to obtain a total per day, before getting the average of all across
days. The easiest way to do it is by using the dplyr function
group\_by() followed by the function summarise(). dplyr package is
included in the tidyverse package, together with ggplot2, tidyr and
others, all developed by Hadley Wickham, and that are all useful in data
analysis. Furthermore, we need the function %&gt;% to pass the content
from the left variable to the right function, and it is obtained from
the package magrittr. We could have loaded the packages in the
beginning, but it is better to load them here for you to see where they
are being used.

    library(tidyverse)

    ## ── Attaching packages ──────────────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.7
    ## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## Warning: package 'ggplot2' was built under R version 3.4.4

    ## Warning: package 'tidyr' was built under R version 3.4.4

    ## Warning: package 'purrr' was built under R version 3.4.4

    ## Warning: package 'dplyr' was built under R version 3.4.4

    ## Warning: package 'stringr' was built under R version 3.4.4

    ## ── Conflicts ─────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

    library(magrittr)

    ## 
    ## Attaching package: 'magrittr'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     set_names

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     extract

    per_day_table <- activity %>% 
          group_by(date) %>% 
          summarise(total_steps = sum(steps, na.rm = T))

    ## Warning: package 'bindrcpp' was built under R version 3.4.4

    hist(per_day_table$total_steps, breaks = 15, las = 1, xlab = "number of steps",
         main = "Frequency of steps taken per day")

![](project_1_files/figure-markdown_strict/average-1.png)

    average_per_day <- mean(per_day_table$total_steps)
    paste0("The average number of steps per day is ", round(average_per_day), ".")

    ## [1] "The average number of steps per day is 9354."

### What is the average daily activity pattern?

To answer this question it is needed to show a time series plot with the
number of steps in average taken in a each period of the day across all
days analyzed. By looking at the format of the 5-minute interval, it is
shown in a way not useful for plotting, where minutes are represented in
the last two digits, and hours in the first two. When it is null, only
the last digits are shown, as in the 0 to 55 minutes, whereas the first
hour is represented as 100. Let’s take a look on that.

    unique(activity$interval)

    ##   [1]    0    5   10   15   20   25   30   35   40   45   50   55  100  105
    ##  [15]  110  115  120  125  130  135  140  145  150  155  200  205  210  215
    ##  [29]  220  225  230  235  240  245  250  255  300  305  310  315  320  325
    ##  [43]  330  335  340  345  350  355  400  405  410  415  420  425  430  435
    ##  [57]  440  445  450  455  500  505  510  515  520  525  530  535  540  545
    ##  [71]  550  555  600  605  610  615  620  625  630  635  640  645  650  655
    ##  [85]  700  705  710  715  720  725  730  735  740  745  750  755  800  805
    ##  [99]  810  815  820  825  830  835  840  845  850  855  900  905  910  915
    ## [113]  920  925  930  935  940  945  950  955 1000 1005 1010 1015 1020 1025
    ## [127] 1030 1035 1040 1045 1050 1055 1100 1105 1110 1115 1120 1125 1130 1135
    ## [141] 1140 1145 1150 1155 1200 1205 1210 1215 1220 1225 1230 1235 1240 1245
    ## [155] 1250 1255 1300 1305 1310 1315 1320 1325 1330 1335 1340 1345 1350 1355
    ## [169] 1400 1405 1410 1415 1420 1425 1430 1435 1440 1445 1450 1455 1500 1505
    ## [183] 1510 1515 1520 1525 1530 1535 1540 1545 1550 1555 1600 1605 1610 1615
    ## [197] 1620 1625 1630 1635 1640 1645 1650 1655 1700 1705 1710 1715 1720 1725
    ## [211] 1730 1735 1740 1745 1750 1755 1800 1805 1810 1815 1820 1825 1830 1835
    ## [225] 1840 1845 1850 1855 1900 1905 1910 1915 1920 1925 1930 1935 1940 1945
    ## [239] 1950 1955 2000 2005 2010 2015 2020 2025 2030 2035 2040 2045 2050 2055
    ## [253] 2100 2105 2110 2115 2120 2125 2130 2135 2140 2145 2150 2155 2200 2205
    ## [267] 2210 2215 2220 2225 2230 2235 2240 2245 2250 2255 2300 2305 2310 2315
    ## [281] 2320 2325 2330 2335 2340 2345 2350 2355

Therefore, it is needed to transform it and turn everything into
minutes. First we need to group the data by interval, and then transform
the interval into minutes. Let’s see how it is made.

    per_interval_table <- activity %>% 
          group_by(interval) %>% 
          summarise(average_across_days = mean(steps, na.rm = T))

    per_interval_table$minutes_from_interval <- per_interval_table$interval %% 100
    per_interval_table$hours_from_interval <- floor(per_interval_table$interval/100)
    per_interval_table$proper_minutes <- per_interval_table$hours_from_interval*60 + per_interval_table$minutes_from_interval
    per_interval_table$proper_minutes

    ##   [1]    0    5   10   15   20   25   30   35   40   45   50   55   60   65
    ##  [15]   70   75   80   85   90   95  100  105  110  115  120  125  130  135
    ##  [29]  140  145  150  155  160  165  170  175  180  185  190  195  200  205
    ##  [43]  210  215  220  225  230  235  240  245  250  255  260  265  270  275
    ##  [57]  280  285  290  295  300  305  310  315  320  325  330  335  340  345
    ##  [71]  350  355  360  365  370  375  380  385  390  395  400  405  410  415
    ##  [85]  420  425  430  435  440  445  450  455  460  465  470  475  480  485
    ##  [99]  490  495  500  505  510  515  520  525  530  535  540  545  550  555
    ## [113]  560  565  570  575  580  585  590  595  600  605  610  615  620  625
    ## [127]  630  635  640  645  650  655  660  665  670  675  680  685  690  695
    ## [141]  700  705  710  715  720  725  730  735  740  745  750  755  760  765
    ## [155]  770  775  780  785  790  795  800  805  810  815  820  825  830  835
    ## [169]  840  845  850  855  860  865  870  875  880  885  890  895  900  905
    ## [183]  910  915  920  925  930  935  940  945  950  955  960  965  970  975
    ## [197]  980  985  990  995 1000 1005 1010 1015 1020 1025 1030 1035 1040 1045
    ## [211] 1050 1055 1060 1065 1070 1075 1080 1085 1090 1095 1100 1105 1110 1115
    ## [225] 1120 1125 1130 1135 1140 1145 1150 1155 1160 1165 1170 1175 1180 1185
    ## [239] 1190 1195 1200 1205 1210 1215 1220 1225 1230 1235 1240 1245 1250 1255
    ## [253] 1260 1265 1270 1275 1280 1285 1290 1295 1300 1305 1310 1315 1320 1325
    ## [267] 1330 1335 1340 1345 1350 1355 1360 1365 1370 1375 1380 1385 1390 1395
    ## [281] 1400 1405 1410 1415 1420 1425 1430 1435

Now we can plot the time series plot for average steps accordingly.

    with(per_interval_table, plot(proper_minutes/60, average_across_days, type = "l", 
                                  xlab = "time of the day (24h format)", 
                                  ylab = "average number of steps", 
                                  main = "Average steps per hour",
                                  xaxt = "n", las = 1
                                  ))
    xticks <- seq(0,23, by = 2)
    axis(at = xticks, side = 1)
    abline(v = per_interval_table[which.max(per_interval_table$average_across_days), "proper_minutes"]/60, col = "red")

![](project_1_files/figure-markdown_strict/average%20daily%20steps-1.png)

Great! By the plot we can see that around 8:45h in the morning is the
time of the day with more steps activity for the user we are analyzing.
Maybe he/she runs at this time of the day, with sprints that make more
steps fit in a 5-minute interval comparing with other intervals’ number
of steps.

### Imputing missing values

Missing values in the data can compromise the results reported. They can
exist because of measurement or record errors, or due to not turning on
the device on determined days. Let’s take a look on how many missing
values are in our data.

    number_missing <- nrow(activity[is.na(activity$steps),])
    total <- nrow(activity)

    paste0("There are ", number_missing, " missing values out of ", total, " observations.")

    ## [1] "There are 2304 missing values out of 17568 observations."

    percentage <- number_missing/total*100

    paste0("Missing data comprehends ", round(percentage), " percent of total.")

    ## [1] "Missing data comprehends 13 percent of total."

13 percent is a considerable amount of the data. A way to deal with
those missing values is by imputing them, and a reasonable way to impute
those values is by assigning the interval’s average to them. To do so,
first we need to check the pattern of the missing data.

    missing <- activity[is.na(activity$steps),]
    head(missing)

    ##   steps       date interval
    ## 1    NA 2012-10-01        0
    ## 2    NA 2012-10-01        5
    ## 3    NA 2012-10-01       10
    ## 4    NA 2012-10-01       15
    ## 5    NA 2012-10-01       20
    ## 6    NA 2012-10-01       25

Apparently the missing data is in whole days. Let’s check if this is
true.

    unique(missing$date)

    ## [1] "2012-10-01" "2012-10-08" "2012-11-01" "2012-11-04" "2012-11-09"
    ## [6] "2012-11-10" "2012-11-14" "2012-11-30"

    table(as.factor(sort(missing[,"interval"])))

    ## 
    ##    0    5   10   15   20   25   30   35   40   45   50   55  100  105  110 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ##  115  120  125  130  135  140  145  150  155  200  205  210  215  220  225 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ##  230  235  240  245  250  255  300  305  310  315  320  325  330  335  340 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ##  345  350  355  400  405  410  415  420  425  430  435  440  445  450  455 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ##  500  505  510  515  520  525  530  535  540  545  550  555  600  605  610 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ##  615  620  625  630  635  640  645  650  655  700  705  710  715  720  725 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ##  730  735  740  745  750  755  800  805  810  815  820  825  830  835  840 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ##  845  850  855  900  905  910  915  920  925  930  935  940  945  950  955 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 1000 1005 1010 1015 1020 1025 1030 1035 1040 1045 1050 1055 1100 1105 1110 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 1115 1120 1125 1130 1135 1140 1145 1150 1155 1200 1205 1210 1215 1220 1225 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 1230 1235 1240 1245 1250 1255 1300 1305 1310 1315 1320 1325 1330 1335 1340 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 1345 1350 1355 1400 1405 1410 1415 1420 1425 1430 1435 1440 1445 1450 1455 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 1500 1505 1510 1515 1520 1525 1530 1535 1540 1545 1550 1555 1600 1605 1610 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 1615 1620 1625 1630 1635 1640 1645 1650 1655 1700 1705 1710 1715 1720 1725 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 1730 1735 1740 1745 1750 1755 1800 1805 1810 1815 1820 1825 1830 1835 1840 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 1845 1850 1855 1900 1905 1910 1915 1920 1925 1930 1935 1940 1945 1950 1955 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 2000 2005 2010 2015 2020 2025 2030 2035 2040 2045 2050 2055 2100 2105 2110 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 2115 2120 2125 2130 2135 2140 2145 2150 2155 2200 2205 2210 2215 2220 2225 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 2230 2235 2240 2245 2250 2255 2300 2305 2310 2315 2320 2325 2330 2335 2340 
    ##    8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
    ## 2345 2350 2355 
    ##    8    8    8

There are eight dates with missing data, and all intervals have eight
entries. So yes, all the intervals in those dates consist in all of the
missing data. Probably this happened because the user forgot to turn the
device on or to wear it at those dates. By using the table already
built, containing the average values for all of the intervals, we will
impute the missing values and assign them to a new variable.

    missing <- arrange(missing, date, interval)
    missing$steps <- rep(per_interval_table$average_across_days, 8)
    imputed <- activity
    imputed <- arrange(imputed, date, interval)
    imputed[is.na(imputed$steps),"steps"] <- missing[,"steps"]
    imputed[is.na(imputed$steps),]

    ## [1] steps    date     interval
    ## <0 rows> (or 0-length row.names)

We can see that now there are no rows with missing steps value. Done!
Let’s make a histogram to see how the data looks like now that there are
no missing values.

    per_day_imputed <- imputed %>% 
          group_by(date) %>% 
          summarise(total_steps = sum(steps))
    hist(per_day_imputed$total_steps, breaks = 15, las = 1, xlab = "steps",
         main = "Total number of steps taken per day")

![](project_1_files/figure-markdown_strict/histogram%20imputed-1.png)

The histogram looks a different from before imputing values, since the
dates with missing values were accounted as zero steps, what does not
reflect the real behavior of the user. How does the mean and median
differ from before imputing the values?

    mean_steps <- mean(per_day_imputed$total_steps)
    median_steps <- median(per_day_imputed$total_steps)

    paste0("The mean of steps taken per day after imputing missing  values is ", round(mean_steps), 
           " and the median is ", round(median_steps), ".")

    ## [1] "The mean of steps taken per day after imputing missing  values is 10766 and the median is 10766."

We can see that the data is normally distributed, since the median and
the mean are the same! It is interesting to notice how the result differ
from the one obtained before imputing the missing data. It was 9354
steps on average and now, with the imputed data, it is 10766, showing an
increase of more than a thousand steps per day, a huge impact on a
person’s activity. This difference shows the importance of dealing with
missing data adequately.

### Are there differences in activity patterns between weekdays and weekends?

In order to answer the question about differences between weekdays and
weekends steps pattern of the user, we will use R function weekdays() on
the data with the imputed values.

    imputed$weekday <- weekdays(imputed$date)

    days <- unique(imputed$weekday)

    weekdays <- data.frame(dayname = days,
                           week_or_weekend = c(rep("weekday", 5), rep("weekend", 2)))

    merged <- merge(imputed, weekdays, by.x = "weekday", by.y = "dayname")

    merged_minute_intervals <- merge(merged, per_interval_table, by = "interval") 

    per_interval_weekday <- merged_minute_intervals %>%
          group_by(week_or_weekend,proper_minutes) %>%
          summarise(total_steps = mean(steps))

    ggplot(per_interval_weekday, aes(proper_minutes/60, total_steps)) + geom_line() +
          facet_grid(rows = vars(week_or_weekend))

![](project_1_files/figure-markdown_strict/weekdays-1.png)

It is possible to see that during weekends there is a considerable
decrease in the number of steps taken in the morning, and an increase in
steps taken in the evenings.
