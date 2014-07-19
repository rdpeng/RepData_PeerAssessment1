setwd("~/RepData_PeerAssessment1/")

if (!file.exists("./figures/")){
   dir.create("figures")
}

act.file = "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"

if (!file.exists("activity.zip")){
   download.file(url=act.file,
                 destfile="activity.zip",
                 method="curl")
}

if (!file.exists("activity.csv")){
   unzip("activity.zip")   
}

act.df <- read.csv("activity.csv",colClasses=c("numeric","Date","numeric"))

tot.step <- aggregate(steps ~ date,data=act.df,FUN=sum)

png("./figures/tot.step.png",height=300,width=400)
hist(tot.step$steps,
     breaks="FD",
     main=NULL,
     xlab="Total steps per day")
dev.off()

list(Mean=mean(tot.step$steps), Median=median(tot.step$steps))

avg.int <- aggregate(steps ~ interval,data=act.df,FUN=mean)

png("./figures/avg.int.png",height=300,width=400)
plot(avg.int$interval,
     avg.int$steps,
     type="l",
     xlab="5-minute interval",
     ylab="Mean steps across days")
dev.off()

max.idx <- which.max(avg.int$steps)
max.hr <- avg.int[max.idx,]$interval %/% 100
max.mn <- avg.int[max.idx,]$interval %% 100
hr.mn <- paste(max.hr,":",max.mn,sep="")
data.frame(AvgSteps=avg.int[max.idx,]$steps,
           Interval=avg.int[max.idx,]$interval,
           Time=hr.mn)

# Create a data frame containing only the NA rows
act.na <- act.df[is.na(act.df$steps),]
# Split this data frame on the date, prerequisite for lapply
act.na.spl <- split(act.na,act.na$date)
# Transform the NA values to the rounded average values
act.na.appl <- lapply(act.na.spl,
                      FUN=transform,
                      steps=round(avg.int$steps))
# Unsplit the data frame
act.na.unspl <- unsplit(act.na.appl,act.na$date)
# Remove the NA rows from the original data frame
act.narm <- act.df[complete.cases(act.df),]
# Combine the NA-stripped and NA-transformed data frames
act.na.merged <- rbind(act.narm,act.na.unspl)
# Order the new data frame so it looks nice
act.df.na <- act.na.merged[order(act.na.merged$date,
                                 act.na.merged$interval),]