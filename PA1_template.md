# PA1_template
tbaber  
March 28, 2016  

```{r setup, include=TRUE

knitr::opts_chunk$set(echo = TRUE)
```



### Loading and processing data

```r
activity <- read.csv("activity.csv", header=TRUE)
### convert character date to POSIX date
activity$date <- as.POSIXct(strptime(activity$date, "%Y-%m-%d"),tz="")
#### first convert integer time to character and pad with leading zeros...
activity$time     <- sprintf("%04d", activity$interval)
#### fill in leading zeros
#### ...then convert to the date type
```
### What is the mean total number of steps taken per day?

```r
activity$time     <- as.POSIXct(activity$time, "%H%M",tz="")
head(activity)
```

```
##   steps       date interval                time
## 1    NA 2012-10-01        0 2016-04-12 00:00:00
## 2    NA 2012-10-01        5 2016-04-12 00:05:00
## 3    NA 2012-10-01       10 2016-04-12 00:10:00
## 4    NA 2012-10-01       15 2016-04-12 00:15:00
## 5    NA 2012-10-01       20 2016-04-12 00:20:00
## 6    NA 2012-10-01       25 2016-04-12 00:25:00
```

```r
str(activity)
```

```
## 'data.frame':	17568 obs. of  4 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : POSIXct, format: "2012-10-01" "2012-10-01" ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
##  $ time    : POSIXct, format: "2016-04-12 00:00:00" "2016-04-12 00:05:00" ...
```

```r
total_steps_by_date <- aggregate(list(total_steps = activity$steps),
                                 by=list(date = activity$date),
                                 FUN=sum,
                                 na.rm=TRUE)
                                 
mean(total_steps_by_date$total_steps)
```

```
## [1] 9354.23
```

```r
median(total_steps_by_date$total_steps,na.rm=T)
```

```
## [1] 10395
```

###What is the average daily activity pattern?

```r
average_steps_by_time <- aggregate(list(average_steps = activity$steps),
                                   by=list(time = activity$time,
                                           interval = activity$interval),
                                   FUN=mean,
                                   na.rm=TRUE)

average_steps_by_time[which.max(average_steps_by_time$average_steps),]   
```

```
##                    time interval average_steps
## 104 2016-04-12 08:35:00      835      206.1698
```

###Plot -What is the average daily activity pattern?

```r
daily_activity <- plot(average_steps ~ time,
     data=average_steps_by_time,
     xlab="Time interval",
     ylab="Mean steps",
     main="Mean Steps By Time Interval",
     type="l",
     col="blue",
     lwd=2)
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)

```r
print(daily_activity)
```

```
## NULL
```


###Imputing missing values

```r
sum(is.na(activity[,"steps"]))
```

```
## [1] 2304
```

```r
# "join" the two data frames using merge()
activity_imputed <- merge(activity,average_steps_by_time,by="interval")
#### correct the NA steps with average steps for the interval
activity_imputed <- within(activity_imputed,
                           steps <- ifelse(is.na(activity_imputed$steps),
                           activity_imputed$average_steps,
                           activity_imputed$steps))
                        
total_steps_by_date_imputed <- aggregate(list(total_steps = activity_imputed$steps),
                                         by=list(date = activity_imputed$date),
                                         FUN=sum,
                                         na.rm=FALSE)
```
###Plot - Total number of steps taken each day

```r
hist(total_steps_by_date_imputed$total_steps,
     breaks=30,
     xlab="Total Steps",
     main="Total Steps Per Day",
     col="lightblue")
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)

```r
plot(density(total_steps_by_date_imputed$total_steps,
             na.rm=TRUE),
     xlab="Total Steps",
     ylab="Density",
     main="Total Steps Per Day",     
     col="purple",
     lwd=3)
```

![](PA1_template_files/figure-html/unnamed-chunk-7-2.png)

```r
par(mfrow=c(1,1))
print(plot)
```

```
## function (x, y, ...) 
## UseMethod("plot")
## <bytecode: 0x0000000008425c18>
## <environment: namespace:graphics>
```
###Are there differences in activity patterns between weekdays and weekends?


```r
activity_imputed$weekday  <- weekdays(activity_imputed$date)

activity_imputed$weekend_indicator <- as.factor(apply(activity_imputed["weekday"], 1, function(x) {
  switch(x,
         "Sunday" = "weekend",
         "Saturday" = "weekend",
         "weekday")
}))

str(activity_imputed)
```

```
## 'data.frame':	17568 obs. of  8 variables:
##  $ interval         : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ steps            : num  1.72 0 0 0 0 ...
##  $ date             : POSIXct, format: "2012-10-01" "2012-11-23" ...
##  $ time.x           : POSIXct, format: "2016-04-12 00:00:00" "2016-04-12 00:00:00" ...
##  $ time.y           : POSIXct, format: "2016-04-12 00:00:00" "2016-04-12 00:00:00" ...
##  $ average_steps    : num  1.72 1.72 1.72 1.72 1.72 ...
##  $ weekday          : chr  "Monday" "Friday" "Sunday" "Tuesday" ...
##  $ weekend_indicator: Factor w/ 2 levels "weekday","weekend": 1 1 2 1 2 1 2 1 1 2 ...
```

```r
par(mfrow=c(1,2))
```






```r
average_steps_by_time_weekend <- aggregate(list(average_steps = activity_imputed$steps),
                                           by=list(time       = activity_imputed$time.x,
                                                   daytype    = activity_imputed$weekend_indicator),
                                           FUN=mean)
```


###Now draw a panel plot using ggplot2, comparing activity patterns on weekdays and weekends.

```r
library(ggplot2)
qplot(x = time,
      y = average_steps,
      geom="path",
      data = average_steps_by_time_weekend, 
      xlab="Time interval",
      ylab="Average steps",
      main="Activity Patterns\nWeekdays vs. Weekends",
      facets = daytype ~ .)
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)

```r
print(qplot)
```

```
## function (x, y = NULL, ..., data, facets = NULL, margins = FALSE, 
##     geom = "auto", xlim = c(NA, NA), ylim = c(NA, NA), log = "", 
##     main = NULL, xlab = deparse(substitute(x)), ylab = deparse(substitute(y)), 
##     asp = NA, stat = NULL, position = NULL) 
## {
##     if (!missing(stat)) 
##         warning("`stat` is deprecated", call. = FALSE)
##     if (!missing(position)) 
##         warning("`position` is deprecated", call. = FALSE)
##     if (!is.character(geom)) 
##         stop("`geom` must be a character vector", call. = FALSE)
##     argnames <- names(as.list(match.call(expand.dots = FALSE)[-1]))
##     arguments <- as.list(match.call()[-1])
##     env <- parent.frame()
##     aesthetics <- compact(arguments[.all_aesthetics])
##     aesthetics <- aesthetics[!is.constant(aesthetics)]
##     aes_names <- names(aesthetics)
##     aesthetics <- rename_aes(aesthetics)
##     class(aesthetics) <- "uneval"
##     if (missing(data)) {
##         data <- data.frame()
##         facetvars <- all.vars(facets)
##         facetvars <- facetvars[facetvars != "."]
##         names(facetvars) <- facetvars
##         facetsdf <- as.data.frame(mget(facetvars, envir = env))
##         if (nrow(facetsdf)) 
##             data <- facetsdf
##     }
##     if ("auto" %in% geom) {
##         if ("sample" %in% aes_names) {
##             geom[geom == "auto"] <- "qq"
##         }
##         else if (missing(y)) {
##             x <- eval(aesthetics$x, data, env)
##             if (is.discrete(x)) {
##                 geom[geom == "auto"] <- "bar"
##             }
##             else {
##                 geom[geom == "auto"] <- "histogram"
##             }
##             if (missing(ylab)) 
##                 ylab <- "count"
##         }
##         else {
##             if (missing(x)) {
##                 aesthetics$x <- bquote(seq_along(.(y)), aesthetics)
##             }
##             geom[geom == "auto"] <- "point"
##         }
##     }
##     p <- ggplot(data, aesthetics, environment = env)
##     if (is.null(facets)) {
##         p <- p + facet_null()
##     }
##     else if (is.formula(facets) && length(facets) == 2) {
##         p <- p + facet_wrap(facets)
##     }
##     else {
##         p <- p + facet_grid(facets = deparse(facets), margins = margins)
##     }
##     if (!is.null(main)) 
##         p <- p + ggtitle(main)
##     for (g in geom) {
##         params <- arguments[setdiff(names(arguments), c(aes_names, 
##             argnames))]
##         params <- lapply(params, eval, parent.frame())
##         p <- p + do.call(paste0("geom_", g), params)
##     }
##     logv <- function(var) var %in% strsplit(log, "")[[1]]
##     if (logv("x")) 
##         p <- p + scale_x_log10()
##     if (logv("y")) 
##         p <- p + scale_y_log10()
##     if (!is.na(asp)) 
##         p <- p + theme(aspect.ratio = asp)
##     if (!missing(xlab)) 
##         p <- p + xlab(xlab)
##     if (!missing(ylab)) 
##         p <- p + ylab(ylab)
##     if (!missing(xlim)) 
##         p <- p + xlim(xlim)
##     if (!missing(ylim)) 
##         p <- p + ylim(ylim)
##     p
## }
## <environment: namespace:ggplot2>
```

