Load Libraries

    library("ggplot2")
    library("dplyr")

1.  Code for reading in dataset and processing data

<!-- -->

    activity <- read.csv("activity.csv", header = TRUE, sep = ",", colClasses = c("numeric","character","numeric"))
    activity$date <- as.Date(activity$date, format = "%m/%d/%Y")

1.  Make a histogram of total steps per day

<!-- -->

    DailyActivity <- aggregate(steps ~ date, activity, sum)

    #create histogram plot
    ggplot(DailyActivity, aes(steps)) + 
      geom_histogram(color = "red", fill = "red") + 
      ggtitle("Distribution of total steps per day")

![](PA1_Template_files/figure-markdown_strict/unnamed-chunk-3-1.png)<!-- -->

1.  Mean and median \# of steps per day

<!-- -->

    StepsMean <- mean(DailyActivity$steps)
    StepsMedian <- median(DailyActivity$steps)

1.  Time series plot of avg \# of steps taken

<!-- -->

    DailyStepActivity <- aggregate(steps ~ interval, activity, mean)

    #create plot
    ggplot(DailyStepActivity, aes(interval, steps)) + 
      geom_line() + 
      ggtitle("Average daily activity pattern")  +
      labs(x = "interval",  y = "steps")

![](PA1_Template_files/figure-markdown_strict/unnamed-chunk-5-1.png)<!-- -->

1.  The five minute interval that on average contains max \# of steps

<!-- -->

    MaxInterval <- which(DailyStepActivity$steps == max(DailyStepActivity$steps))
    MaxInt <- DailyStepActivity[MaxInterval, 1]
    MaxInt

    ## [1] 835

1.  Code to impute missing values

<!-- -->

    MissingValues <- sum(is.na(activity$steps))


    RevisedActivity <- activity
    RevisedActivity <- merge(activity, DailyStepActivity, by = "interval")
    RevisedActivity$steps.x[is.na(RevisedActivity$steps.x)] <- RevisedActivity$steps.y
    RevisedMissingValues <- sum(is.na(RevisedActivity$steps.x))

    RevisedDailyActivity <- aggregate(steps.x ~ date, RevisedActivity, sum)
    RevisedStepsMean <- mean(RevisedDailyActivity$steps.x)
    RevisedStepsMedian <- median(RevisedDailyActivity$steps.x)

1.  Histogram of total \# of steps taken each day after missing values
    imputed

<!-- -->

    ggplot(RevisedDailyActivity, aes(steps.x)) + 
      geom_histogram(color = "green", fill = "green") + 
      ggtitle("Revised distribution of total steps per day")

![](PA1_Template_files/figure-markdown_strict/unnamed-chunk-8-1.png)<!-- -->

1.  Plot comparing avg steps taken per 5 minute interval across weekdays
    and weekends

<!-- -->

    WeekActivity <- RevisedActivity %>% 
      mutate(Weekday = weekdays(RevisedActivity$date)) %>%
      mutate(WeekdayClass = "Weekday")

    weekend <- WeekActivity$Weekday %in% c("Saturday", "Sunday") 
    WeekActivity$WeekdayClass[weekend == TRUE] <- "Weekend"

    DailyStepActivityByWeekDayType <- aggregate(steps.x ~ interval + WeekdayClass, WeekActivity, mean)

    #create plot
    ggplot(DailyStepActivityByWeekDayType, aes(interval, steps.x)) + 
      geom_line() + 
      facet_wrap(~ WeekdayClass, nrow = 2, ncol = 1) +
      labs(x = "interval",  y = "steps")

![](PA1_Template_files/figure-markdown_strict/unnamed-chunk-9-1.png)<!-- -->

1.  All the R code need to reproduce results. All code is contained
    above.
