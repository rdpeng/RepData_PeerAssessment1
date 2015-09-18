Peer Assessment 1 - Reproducible Research
==================================================


```r
library(lubridate)
library(plyr)
```

```
## 
## Attaching package: 'plyr'
## 
## The following object is masked from 'package:lubridate':
## 
##     here
```

```r
library(ggplot2)
data <- read.csv("activity.csv")
data$date <- as.POSIXct(data$date)
data_na <- na.omit(data)
```

## What is mean total number of steps taken per day?


```r
data_day <- aggregate(data_na$steps, by = list(date = data_na$date), FUN = sum)
hist(data_day$x, main = "", xlab = "Promedio de pasos por día", ylab = "",
     freq = FALSE, ylim = c(0, 0.00012))
lines(density(data_day$x, na.rm = TRUE), col = 3, lwd = 2)
title("¿Cuál es el promedio de pasos por día?")
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 


```r
mean(data_day$x)
```

```
## [1] 10766.19
```

```r
median(data_day$x)
```

```
## [1] 10765
```

## What is the average daily activity pattern?


```r
data_intervalo <- aggregate(data_na$steps, by = list(interval = data_na$interval),
                            FUN = mean)
plot(data_intervalo$interval, data_intervalo$x, type = "l", col = 4, lwd = 2,
     xlab = "Intervalos de 5 minutos", ylab = "# pasos promedio")
title("Patrón de pasos por intervalos de 5 minutos")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 


```r
data_intervalo$interval[data_intervalo$x == max(data_intervalo$x)]
```

```
## [1] 835
```

## Imputing missing values

Interval average steps.


```r
table(is.na(data))
```

```
## 
## FALSE  TRUE 
## 50400  2304
```


```
## Warning in data_fill$steps[is.na(data_fill$steps)] <- round(data_fill$x):
## número de items para para sustituir no es un múltiplo de la longitud del
## reemplazo
```


```r
data_day2 <- aggregate(data_fill$steps, by = list(date = data_fill$date), FUN = sum)
hist(data_day2$x, main = "", xlab = "Promedio de pasos por día", ylab = "",
     freq = FALSE, ylim = c(0, 0.00020))
lines(density(data_day2$x, na.rm = TRUE), col = 3, lwd = 2)
title("¿Cuál es el promedio de pasos por día?")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png) 


```r
mean(data_day2$x)
```

```
## [1] 10765.64
```

```r
median(data_day2$x)
```

```
## [1] 10762
```

## Are there differences in activity patterns between weekdays and weekends?

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png) 
