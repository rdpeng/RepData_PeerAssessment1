# Part 4 Course Project 1 - Plot 1
setwd("~/Desktop/Data Science Specialization/P4 Exploratory Data Analysis/Week 1 Background Material, Basics of Analytic Graphics/Course Project 1")
fullData <- read.table("household_power_consumption.txt",
                       header = TRUE, sep = ";", na.strings = "?",
                       colClasses = c(rep("factor", 2), rep("numeric", 7)))
electric <- subset(fullData, Date == "2/2/2007" | Date == "1/2/2007")

# Plot the Graph and Save into a PNG File
png(file = "plot1.png", width = 480, height = 480)
par(mfrow = c(1, 1))
hist(electric$Global_active_power, col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()