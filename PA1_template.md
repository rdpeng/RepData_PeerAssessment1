---
title: "PA1_template"
author: "Mariana"
date: "31/8/2020"
output: 
  html_document: 
    toc: yes
    keep_md: yes
pdf_document: default
keep_md: yes
self_contained: no
  
---
##

```r
library(readr)
library(tidyr)
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
library(knitr)
setwd("C:/Users/vlrxo/Desktop/Mariana/Github/RepData_PeerAssessment1")
activity <- read_csv("activity.csv")
```

```
## Parsed with column specification:
## cols(
##   steps = col_double(),
##   date = col_date(format = ""),
##   interval = col_double()
## )
```



```r
pruebaactivity <- filter(activity, steps>=0 )
datos1 <- aggregate(pruebaactivity$steps, by = list(pruebaactivity$date), FUN = sum)
  colnames(datos1) <- c("date", "sum_steps")
```



```r
gráfica1 <-  qplot(sum_steps, data = datos1,
                   main = "  Total number of steps per day")
      gráfica1
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->



```r
promedio_pasos <-mean(datos1$sum_steps)
     promedio_pasos 
```

```
## [1] 10766.19
```

```r
mediana_pasos <- median(datos1$sum_steps)
      mediana_pasos
```

```
## [1] 10765
```
##The total mean of steps per day is 10766.19


```r
datos2 <- aggregate(pruebaactivity$steps, 
                     by = list(pruebaactivity$interval), FUN = mean)
colnames(datos2) <- c("interval", "mean_steps")
  gráfica2 <- qplot(datos2$interval, datos2$mean_steps, 
       main = "Interval vs average steps per day",
       ylab = "Mean Steps", xlab = "Interval", geom = "line")  
    gráfica2
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->
## The activity increases at the half of it.


```r
máxsteps <- which.max(datos2$mean_steps)
máxsteps
```

```
## [1] 104
```

```r
datos2$interval[máxsteps]
```

```
## [1] 835
```
##The 835 interval has the máximum number of steps.


```r
activityNA <- is.na(activity)
sum(activityNA)
```

```
## [1] 2304
```



```r
activity$steps[is.na(activity$steps)] <-datos2$mean_steps
```


```r
fillactivity <- activity
datosfill <- aggregate(fillactivity$steps, by = list(date = fillactivity$date), FUN = sum)
    colnames(datosfill) <- c("date", "sum_steps")
```



```r
gráfica3 <-  barplot(datosfill$sum_steps, data = datosfill, names.arg = datosfill$date,
                   main = "  Total number of steps per day (fill)")
```

```
## Warning in plot.window(xlim, ylim, log = log, ...): "data" is not a graphical
## parameter
```

```
## Warning in axis(if (horiz) 2 else 1, at = at.l, labels = names.arg, lty =
## axis.lty, : "data" is not a graphical parameter
```

```
## Warning in title(main = main, sub = sub, xlab = xlab, ylab = ylab, ...): "data"
## is not a graphical parameter
```

```
## Warning in axis(if (horiz) 1 else 2, cex.axis = cex.axis, ...): "data" is not a
## graphical parameter
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->
## November 26 was the day that was more active for people


```r
promedio_pasosfill <-mean(datosfill$sum_steps)
   promedio_pasosfill
```

```
## [1] 10766.19
```

```r
mediana_pasosfill <- median(datosfill$sum_steps)
   mediana_pasosfill
```

```
## [1] 10766.19
```
##With all the NAs filled, only the median change, but it wasnt significant, it only changed 1.19 steps. The mean value remained the same.


```r
Sys.setlocale("LC_TIME", "English")
```

```
## [1] "English_United States.1252"
```

```r
dias1 <- weekdays(as.Date(fillactivity$date)) %in% c('Saturday','Sunday') 
fillactivity$weekday <- factor(dias1, labels = c("weekday", "weekend"))

pasoseintervalos <- aggregate(steps ~ interval + weekday, fillactivity, FUN = mean)

largo <- length(pasoseintervalos$interval) / 2
pasoseintervalos$x <- rep(seq_along(pasoseintervalos$interval[1:largo]), 2)

pasos <- nrow(pasoseintervalos)/2
division <- round(pasos) / 12
```




```r
graph4 <- ggplot(pasoseintervalos, aes(x = x, y = steps), ylabs)

graph4 <- ggplot(pasoseintervalos, aes(x = x, y = steps))
graph4 <- graph4 + scale_x_discrete(breaks=pasoseintervalos$x[seq(1, pasos, division)],
                          labels=pasoseintervalos$interval[seq(1, pasos, division)])
graph4 <- graph4 + facet_wrap(~ weekday, ncol = 1)
graph4 <- graph4 + geom_line()
graph4 <- graph4 + theme(axis.text.x=element_text(angle=90,vjust=.2,hjust=1))
graph4 <- graph4 + labs(x = "Interval")
graph4 <- graph4 + labs(y = "Mean Number of Steps")

graph4
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png)<!-- -->
##The activity in the weekends notably increases. 

