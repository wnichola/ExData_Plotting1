## Use the data.table library to be used as it is very efficient in reading large files
library("data.table")

# Define the names (and location) of the files used and writed
srcfile <- "./data/household_power_consumption.txt"
plotfile <- "./figure/plot2.png"

# Use fread to read in the file into a data.table, handing ? for missing values
DT <- fread(srcfile, header = TRUE, stringsAsFactors = FALSE, na.string = "?", colClasses = "character")

# Subset the data.table for records with Dates "1/2/2007" and "2/2/2007"
DT2 <- DT[Date == "1/2/2007" | Date == "2/2/2007", ]

# Create a new Datetime field for the X-axis plot
DT2[, Datetime := as.POSIXct(strptime(paste(DT2$Date, DT2$Time, sep = " "), "%d/%m/%Y %H:%M:%S"))]

# Convert Global_active_power into a numeric so that it can be plotted
DT2[ ,Global_active_power := as.numeric(Global_active_power)]

# Generate the Line Plot (type = "l"), with a blank x-label and y-label with "Global Active Power"
plot(DT2$Datetime, DT2$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")

# Copy the Historgram into the plotfile, with the width and height at 480 pixels
dev.copy(png, file=plotfile, width = 480, height = 480)

# Complete the plot and close the png file.
dev.off()
