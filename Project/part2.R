#Creation of the histogram

library(data.table)

#reading data using data.table package
fread("activity.csv")

#Creating histogram using qplot and data.table "by" grouping
library(ggplot2)

qplot(V1,data=activitydt[,sum(steps),by=date],
      xlab = "Daily sum")

#mean calculation using data.table "by" grouping

mean(activitydt[,sum(steps),by=date]$V1,
     na.rm = T)

#median calculation using data.table "by" grouping

median(activitydt[,sum(steps),by=date]$V1,
     na.rm = T)