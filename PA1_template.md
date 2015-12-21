Reproducible Research Assignment One
=====================================
# Loading and preprocessing the data

##Abstract
The dataset contained in the assignment for examination is personal activity monitoring data. The data comprises of two months of observations. Each measurement was taken 5 minutes apart during the months of October and November, 2012.

##Inputting the data
The Activity monitoring data can be downloaded from the url [Activity monitoring data](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip). This is a zip file, so it will be required to download this zip file, unzip it and the read it into a variable by using a function such as read.csv. The code is shown below.
```{r, setoptions, echo=TRUE}
url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
destfile <- "repdata%2Fdata%2Factivity.zip"
download.file(url, destfile)
unzip(destfile)
data <- read.csv("activity.csv", header=TRUE)
```
##Format of the data file
Running names on the dataset reveals its format, that is, three columns titled "steps", "date" and "interval".
```{r}
names(data)
```

##Number of Steps Taken
##The total Number of Steps Taken
By using the sum function the sum of the total steps taken is found to be `r sum(data$steps, na.rm=TRUE)` that is
```{r}
sum(data$steps, na.rm=TRUE)
```
and one must set the na.rm to be true so that missing values are excluded.

# What is mean total number of steps taken per day?
The code below will generate a histogram of the total steps taken per day then the code will output the mean and median of the total steps taken per day.
```{r}
x1 <- unique(data$date)
y1 <- c()
for(i in x1)
    y1 <- c(y1, sum(data[data$date==i,]$steps))
histogram1 <- data.frame(x1, y1)
names(histogram1) <- c("date","total.steps")
mean(histogram1$total.steps, na.rm=TRUE)
median(histogram1$total.steps, na.rm=TRUE)
```
The mean is also around about 10,000 steps, which is about the same as the median.

##Histogram of Steps Taken Per Day
```{r}
hist(histogram1$total.steps, xlab="Total Steps Taken Per Day", ylab="Density", freq=FALSE, breaks=24, main="Histogram of Total Steps Taken Per Day")
```

##Bar Chart of Steps Taken Per Day
```{r}
hist(histogram1$total.steps, xlab="Total Steps Taken Per Day", ylab="Frequency", freq=TRUE, breaks=24, main="Bar Chart of Total Steps Taken Per Day")
```


#What is the average daily activity pattern?
##Time Series Plot
The code below will take all possible values of interval and then average over all step values for that given interval. This will then be represented on a time series.
```{r}
datasubset <- data[which(data$steps != "NA" & data$interval != "NA"),]
x <- unique(datasubset$interval)
y <- c()
for(i in x)
    y <- c(y, mean( datasubset[datasubset$interval==i,]$steps ))
timeseries <- data.frame(x,y)
names(timeseries) <- c("interval","average.steps")
plot(timeseries$interval, timeseries$average.steps, type="l", xlab="Interval", ylab="Average Steps Taken", main="Time Series of Mean Average Steps taken at a given Interval")
```

##Maximum Mean Average Interval
It can be seen from the above plot that the maximum number of steps taken during a five minute interval is on average sometime around 9am. The exact time can be found by fist finding the maxium average steps and then finding the interval that is equal to this.
```{r}
max <- max(timeseries$average.steps)
time <- timeseries[which(timeseries$average.steps==max),]$interval
time
```
The exact interval time is `r time`. This is likely due to people walking to work at this time.

#Imputing missing values
##How Many Rows are missing
The number of missing rows is just the difference between data and datasubset which can be seen below
```{r}
nrow(data)-nrow(datasubset)
```
#Inputting Missing Values
The missing values will be replaced by the global mean.
```{r}
replace <- mean(data$steps,na.rm=TRUE)
data2 <- data
n <- length(data2[is.na(data2$steps),]$steps)
data2[is.na(data2$steps),]$steps <- rep(replace,n)
```

##Histogram for total per day
The code below will sum the number of steps per day and then produce a histogram of the total steps taken per day.
```{r}
x2 <- unique(data2$date)
y2 <- c()
for(i in x2)
    y2 <- c(y2, sum(data2[data2$date==i,]$steps))
histogram <- data.frame(x2, y2)
names(histogram) <- c("date","total.steps")
hist(histogram$total.steps, xlab="Total Steps Taken Per Day", ylab="Density", freq=FALSE, breaks=24, main="Histogram of Total Steps Taken Per Day")
mean(histogram$total.steps)
median(histogram$total.steps)
```
The mean is also around about 10,000 steps, which is about the same as the median.

##Difference?
There is no difference between the mean and median with or without the missing values. This is because of how the missing values were filled in though, which was done on purpose, as it is not appropriate for the researcher to input information beyond what is in the data.

#Are there differences in activity patterns between weekdays and weekends?
To add weekend or weekday as a factor it would be helpful to create a function to do this job
```{r}
check <- function(y)
{
  vector <- c()
  for(x in y)
  {
    if ( weekdays(as.Date(x)) == "Saturday" || weekdays(as.Date(x)) == "Sunday" )
    {
      vector <- c(vector,"weekend")
    }
    else
    {
      vector <- c(vector,"weekday")
    }  
  }
return(vector)
}
```

##Adding in the factor
Next is to add in the factor of weekday or weekend
```{r}
data3 <- cbind(data2, as.factor(check(data2$date)) )
names(data3) <- c("steps", "date", "interval", "factor")
```

##Time Series for weekend and weekday
```{r}
par(mfrow=c(2,1))
x3 <- unique(data3$interval)
y3 <- c()
for(i in x3)
    y3 <- c(y3, mean( data3[(data3$factor=="weekday" & data3$interval==i),]$steps ))
timeseries3 <- data.frame(x3,y3)
names(timeseries3) <- c("interval","average.steps")
plot(timeseries3$interval, timeseries3$average.steps, type="l", xlab="Interval", ylab="Average Steps Weekday", main="Mean Average Steps taken at a given Interval")
x4 <- unique(data3$interval)
y4 <- c()
for(i in x4)
    y4 <- c(y4, mean( data3[(data3$factor=="weekend" & data3$interval==i),]$steps ))
timeseries4 <- data.frame(x4, y4)
names(timeseries4) <- c("interval","average.steps")
plot(timeseries4$interval, timeseries4$average.steps, type="l", xlab="Interval", ylab="Average Steps Weekend", main="Mean Average Steps taken at a given Interval")
```
As clear difference can be seen between weekend and weekday walkings.
