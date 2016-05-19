### Load the data:

    setwd("C:/Users/JP/Desktop/Data Science Certification/5.- Reproducible Research/Project 1")

    act <- read.csv("activity.csv") 

### What is mean total number of steps taken per day?

    #Steps per day
    SPD <- tapply(act$steps,act$date,sum,na.rm=TRUE)
    #Histogram
    hist(SPD,xlab = "Steps per day",col = "red")

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-2-1.png)

    dev.copy(png,"StepsDay.png")

    ## png 
    ##   3

    dev.off()

    ## png 
    ##   2

    #Mean and Median
    mean(SPD)

    ## [1] 9354.23

    median(SPD)

    ## [1] 10395

### What is the average daily activity pattern?

    #Average steps per interval
    SPI <- tapply(act$steps,act$interval,mean,na.rm=TRUE)
    plot(SPI,type = "l",col = "red",xaxt="n")
    axis(1,at=1:288,labels = rownames(SPI))

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-3-1.png)

    dev.copy(png,"AvgInt.png")

    ## png 
    ##   3

    dev.off()

    ## png 
    ##   2

The interval number 835 is the one with the max steps in average

    #Five minute interval with the max average
    head(sort(SPI,decreasing = TRUE),1)

    ##      835 
    ## 206.1698

    #Five minute interval with the max average
    head(sort(SPI,decreasing = TRUE),1)

    ##      835 
    ## 206.1698

### Imputing missing values

Total number of missing values in the dataset

    #Total number of missing values in the dataset
    nrow(act[complete.cases(act) == FALSE,])

    ## [1] 2304

To fill all the missing values I use the average of the interval that
was in the SPI variable. The new dataset with the missing values filled
in is act1.

    #Filling all the missing values
    SPI1 <- cbind(as.numeric(rownames(SPI)),as.numeric(SPI))
    colnames(SPI1) <- c("interval","value")

    act1 <- merge(act, as.data.frame(SPI1), by = "interval")

    act1$NewSteps <- ifelse(is.na(act1$steps) == TRUE, act1$value, act1$steps)

    #New dataset
    act1 <- act1[,c(1,3,5)]
    head(act1)

    ##   interval       date NewSteps
    ## 1        0 2012-10-01 1.716981
    ## 2        0 2012-11-23 0.000000
    ## 3        0 2012-10-28 0.000000
    ## 4        0 2012-11-06 0.000000
    ## 5        0 2012-11-24 0.000000
    ## 6        0 2012-11-15 0.000000

Steps per day with the new dataset

    #Steps per day
    SPD1 <- tapply(act1$NewSteps,act1$date,sum,na.rm=TRUE)
    #Histogram
    hist(SPD1,xlab = "Steps per day",col = "blue")

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-8-1.png)

    dev.copy(png,"StepsDayCom.png")

    ## png 
    ##   3

    dev.off()

    ## png 
    ##   2

    #Mean and Median
    mean(SPD1)

    ## [1] 10766.19

    median(SPD1)

    ## [1] 10766.19

Compare both datasets

    #Both histograms
    par(mfrow = c(1,2))
    hist(SPD,xlab = "Steps per day (with missing values)",col = "red")
    hist(SPD1,xlab = "Steps per day (with NO missing values)",col = "blue")

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-9-1.png)

We can see that the data has a more simetric shape after imputong the
missing values

### Are there differences in activity patterns between weekdays and weekends?

Create a new factor variable in the dataset with two levels - "weekday"
and "weekend"

    #Create a new factor variable in the dataset with two levels - "weekday" and "weekend" 
    act1$Day <- ifelse(as.POSIXlt(act1$date)$wday > 0 & as.POSIXlt(act1$date)$wday < 6, "weekday", "weekend")

Make a panel plot containing a time series plot of the 5-minute interval
(x-axis) and the average number of steps taken, averaged across all
weekday days or weekend days (y-axis).

    #intervals in weekdays ve weekends
    WD <- subset(act1,act1$Day == "weekday")
    WE <- subset(act1,act1$Day == "weekend")

    #Make a panel plot
    WD1 <- tapply(WD$NewSteps,WD$interval,mean,na.rm=TRUE)
    WE1 <- tapply(WE$NewSteps,WE$interval,mean,na.rm=TRUE)

    par(mfrow = c(2,1),oma = c(2,2,2,2),mar = c(2,2,2,2))
    plot(WD1,type = "l",col = "red",xaxt="n", xlab = "Interval", ylab = "Average Steps")
    axis(1,at=1:288,labels = rownames(WD1))
    dev.copy(png,"Weekdays.png")

    ## png 
    ##   3

    dev.off()

    ## png 
    ##   2

    plot(WE1,type = "l",col = "blue",xaxt="n", xlab = "Interval", ylab = "Average Steps")
    axis(1,at=1:288,labels = rownames(WE1))
    dev.copy(png,"weekends.png")

    ## png 
    ##   3

    dev.off()

    ## png 
    ##   2

    title("Compare weekdays with weekend", outer = TRUE)

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-11-1.png)
