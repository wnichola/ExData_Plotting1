## Use the data.table library to be used as it is very efficient in reading large files
library("data.table")

# Define the names (and location) of the files used and writed
srcfile <- "../data/household_power_consumption.txt"
plotfile <- "./figure/plot4.png"

# Use fread to read in the file into a data.table, handing ? for missing values
DT <- fread(srcfile, header = TRUE, stringsAsFactors = FALSE, na.string = "?", colClasses = "character")

# Subset the data.table for records with Dates "1/2/2007" and "2/2/2007"
DT2 <- DT[Date == "1/2/2007" | Date == "2/2/2007", ]

# Create a new Datetime field for the X-axis plot
DT2[, Datetime := as.POSIXct(strptime(paste(DT2$Date, DT2$Time, sep = " "), "%d/%m/%Y %H:%M:%S"))]

# Convert relevant date into a numeric so that it can be plotted
DT2[ ,Global_active_power := as.numeric(Global_active_power)]
DT2[ ,Voltage := as.numeric(Voltage)]
DT2[ ,Sub_metering_1 := as.numeric(Sub_metering_1)]
DT2[ ,Sub_metering_2 := as.numeric(Sub_metering_2)]
DT2[ ,Sub_metering_3 := as.numeric(Sub_metering_3)]
DT2[ ,Voltage := as.numeric(Voltage)]
DT2[ ,Global_reactive_power := as.numeric(Global_reactive_power)]

# Set the canvas to take in 4 plots appearing across the columns in a row first
# before moving to the next row
par(mfrow = c(2,2))

# Plot 1: Datetime by Global Active Power
plot(DT2$Datetime, DT2$Global_active_power, type = "l", xlab = "", ylab = "Global active power")

# Plot 2: Datetime by Voltage
plot(DT2$Datetime, DT2$Voltage, type = "l", xlab = "", ylab = "Voltage")

# Plot 3: Datetime by Sub_metering_1, Sub_metering_2, and Sub_metering_3
# Find the range for the Y axis for Plot 3
y_range <- range(0, DT2$Sub_metering_1, DT2$Sub_metering_2, DT2$Sub_metering_3)

# Generate the Line Plot (type = "l"), with a blank x-label and y-label with "Energy sub metering"
plot(DT2$Datetime, DT2$Sub_metering_1, type = "l", 
     xlab = "", ylab = "Energy sub metering", ylim = y_range) # Plot Sub_metering_1 first
lines(DT2$Datetime, DT2$Sub_metering_2, type = "l", col = "red", lwd = 2) # Plot Sub_metering_2
lines(DT2$Datetime, DT2$Sub_metering_3, type = "l", col = "blue", lwd = 2) # Plot Sub_metering_3

# Add the Legend at topright
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col=c("black", "red", "blue"), lwd=2, cex=0.3, bty = "n")

# Plot 4: Datetime by Global Reactive Power
plot(DT2$Datetime, DT2$Global_reactive_power, type = "l", xlab = "", ylab = "Global reactive power")

# Copy the Historgram into the plotfile, with the width and height at 480 pixels
dev.copy(png, file=plotfile, width = 480, height = 480)

# Complete the plot and close the png file.
dev.off()
