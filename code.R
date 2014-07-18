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

png("./figures/tot.step.hist.png",height=350,width=450)
plot(tot.step$date,tot.step$steps,
     type="h",
     lwd=5,
     xlab="Date",
     ylab="Total steps per day")
dev.off()

list(Mean=mean(tot.step$steps), Median=median(tot.step$steps))