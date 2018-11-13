#Load the data; it is a text file with ; as separator
library(readr)
elecdata <- read.delim("household_power_consumption.txt", sep=";") 

#Store the data in a dataframe
elecdata <- data.frame(elecdata)
elec <- elecdata
rm(elecdata)

#Replace question marks with NA
#Find all the question marks in data
findq <- elec == "?"
#Replace all the question marks in column
is.na(elec) <- findq
rm(findq)

#Has a lot of dates we won't be analyzing. Need to get those 
#dates.
#Combine Date and Time
elec$DateTime <- paste(elec$Date,elec$Time)
library(lubridate)
elec$DateTime <- dmy_hms(elec$DateTime)

library(dplyr)
elec <- tbl_df(elec)
elecnew <- filter(elec,DateTime >= mdy_hms("02/01/2007 00:00:00"),DateTime < mdy_hms("02/03/2007 00:00:00"))
elec <- elecnew
rm(elecnew)

#Convert factors to numeric; have to first specify as 
#character because otherwise it will just return the 
#internal id indicating the factor

elec$Global_active_power <- as.numeric(as.character(elec$Global_active_power))

#Set png width and height

png("plot1.png", width=480, height=480)

#Create the plot

hist(elec$Global_active_power, col = "Red", 
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", 
     ylab = "Frequency")

#Disconnect from png
dev.off()
