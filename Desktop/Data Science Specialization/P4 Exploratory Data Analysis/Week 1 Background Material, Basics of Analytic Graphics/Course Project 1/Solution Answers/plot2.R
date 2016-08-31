# Part 4 Course Project 1 - Plot 2
setwd("~/Desktop/Data Science Specialization/P4 Exploratory Data Analysis/Week 1 Background Material, Basics of Analytic Graphics/Course Project 1")
fullData <- read.table("household_power_consumption.txt",
                       header = TRUE, sep = ";", na.strings = "?",
                       colClasses = c(rep("factor", 2), rep("numeric", 7)))
electric <- subset(fullData, Date == "2/2/2007" | Date == "1/2/2007")
electric$DateTime <- strptime(paste(electric$Date, electric$Time), "%d/%m/%Y %H:%M:%S")

# Plot the Graph and Save into a PNG File
png(file = "plot2.png", width = 480, height = 480)
par(mfrow = c(1, 1))
with(electric, plot(as.POSIXct(DateTime), Global_active_power,
                    pch = ".", type = "l",
                    xlab = "",
                    ylab = "Global Active Power (kilowatts)"))
dev.off()