# Part 4 Course Project 1 - Plot 4
setwd("~/Desktop/Data Science Specialization/P4 Exploratory Data Analysis/Week 1 Background Material, Basics of Analytic Graphics/Course Project 1")
fullData <- read.table("household_power_consumption.txt",
                       header = TRUE, sep = ";", na.strings = "?",
                       colClasses = c(rep("factor", 2), rep("numeric", 7)))
electric <- subset(fullData, Date == "2/2/2007" | Date == "1/2/2007")
electric$DateTime <- strptime(paste(electric$Date, electric$Time), "%d/%m/%Y %H:%M:%S")

# Plot the Graph and Save into a PNG File
png(file = "plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))
with(electric, {
        plot(as.POSIXct(DateTime), Global_active_power, pch = ".", type = "l",
             xlab = "DateTime", ylab = "Global Active Power")
        plot(as.POSIXct(DateTime), Voltage, pch = ".", type = "l", xlab = "DateTime")
        plot(as.POSIXct(DateTime), Sub_metering_1, type = "n",
             xlab = "DateTime", ylab = "Energy sub Metering")
        lines(as.POSIXct(DateTime), Sub_metering_1, type = "l", col = "black")
        lines(as.POSIXct(DateTime), Sub_metering_2, type = "l", col = "red")
        lines(as.POSIXct(DateTime), Sub_metering_3, type = "l", col = "blue")
        legend("topright", lty = 1, col = c("black", "red", "blue"), bty = "n",
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
        plot(as.POSIXct(DateTime), Global_reactive_power, pch = ".", type = "l",
             xlab = "DateTime", ylab = "Global Reactive Power")
})
dev.off()