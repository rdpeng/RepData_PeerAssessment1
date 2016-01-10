#Read csv file

activity<-read.csv("activity.csv")

#convert date from a factor to a date object

activity$date<-strptime(as.character(activity$date),
                        format = "%Y-%m-%d")


