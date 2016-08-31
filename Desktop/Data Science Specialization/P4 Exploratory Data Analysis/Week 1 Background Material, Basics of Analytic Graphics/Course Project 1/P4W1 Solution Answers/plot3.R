# Part 4 Course Project 1 - Plot 3
setwd("~/Desktop/Data Science Specialization/P4 Exploratory Data Analysis/Week 1 Background Material, Basics of Analytic Graphics/Course Project 1")
fullData <- read.table("household_power_consumption.txt",
                       header = TRUE, sep = ";", na.strings = "?",
                       colClasses = c(rep("factor", 2), rep("numeric", 7)))
electric <- subset(fullData, Date == "2/2/2007" | Date == "1/2/2007")
electric$DateTime <- strptime(paste(electric$Date, electric$Time), "%d/%m/%Y %H:%M:%S")

# Plot the Graph and Save into a PNG File
png(file = "plot3.png", width = 480, height = 480)
par(mfrow = c(1, 1))
with(electric, {
        plot(as.POSIXct(DateTime), Sub_metering_1, type = "n",
             xlab = "", ylab = "Energy sub Metering")
        lines(as.POSIXct(DateTime), Sub_metering_1, type = "l", col = "black")
        lines(as.POSIXct(DateTime), Sub_metering_2, type = "l", col = "red")
        lines(as.POSIXct(DateTime), Sub_metering_3, type = "l", col = "blue")
        legend("topright", lty = 1, col = c("black", "red", "blue"),
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})
dev.off()