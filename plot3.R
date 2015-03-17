## Use the data.table library to be used as it is very efficient in reading large files
library("data.table")

# Define the names (and location) of the files used and writed
srcfile <- "./data/household_power_consumption.txt"
plotfile <- "./figure/plot3.png"

# Use fread to read in the file into a data.table, handing ? for missing values
DT <- fread(srcfile, header = TRUE, stringsAsFactors = FALSE, na.string = "?", colClasses = "character")

# Subset the data.table for records with Dates "1/2/2007" and "2/2/2007"
DT2 <- DT[Date == "1/2/2007" | Date == "2/2/2007", ]

# Create a new Datetime field for the X-axis plot
DT2[, Datetime := as.POSIXct(strptime(paste(DT2$Date, DT2$Time, sep = " "), "%d/%m/%Y %H:%M:%S"))]

# Convert Sub_metering_1, Sub_metering_2, and Sub_metering_3 into a numeric 
# so that it can be plotted
DT2[ ,Sub_metering_1 := as.numeric(Sub_metering_1)]
DT2[ ,Sub_metering_2 := as.numeric(Sub_metering_2)]
DT2[ ,Sub_metering_3 := as.numeric(Sub_metering_3)]

# Find the range for the Y axis
y_range <- range(0, DT2$Sub_metering_1, DT2$Sub_metering_2, DT2$Sub_metering_3)

# Generate the Line Plot (type = "l"), with a blank x-label and y-label with "Energy sub metering"
plot(DT2$Datetime, DT2$Sub_metering_1, type = "l", 
     xlab = "", ylab = "Energy sub metering", ylim = y_range) # Plot Sub_metering_1 first
lines(DT2$Datetime, DT2$Sub_metering_2, type = "l", col = "red", lwd = 2) # Plot Sub_metering_2
lines(DT2$Datetime, DT2$Sub_metering_3, type = "l", col = "blue", lwd = 2) # Plot Sub_metering_3

# Add the Legend at topright
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col=c("black", "red", "blue"), lwd=2, cex=0.4)

# Copy the Historgram into the plotfile, with the width and height at 480 pixels
dev.copy(png, file=plotfile, width = 480, height = 480)

# Complete the plot and close the png file.
dev.off()
