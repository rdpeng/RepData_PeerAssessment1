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

tot.step.hist <- aggregate(steps ~ date,data=act.df,FUN=sum)

svg("./figures/tot.step.hist.svg",height=4,width=5)
plot(tot.step.hist$date,tot.step.hist$steps,
     type="h",
     lwd=5,
     xlab="Date",
     ylab="Total steps per day")
dev.off()