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
#internal id indicating the factor; Sub_metering_3 is
#already a number; the other two are factors

elec$Sub_metering_1 <- as.numeric(as.character(elec$Sub_metering_1))
elec$Sub_metering_2 <- as.numeric(as.character(elec$Sub_metering_2))

#Get Days of Week, Filter To Get Only Thu, Fri, Sat; the
#filtering isn't really necessary since data is only for
#Friday and Saturday, but I kept it in case needed later
elecnew <- elec %>%
           select(DateTime, 
                  Sub_metering_1, Sub_metering_2,Sub_metering_3) %>%
           mutate(weekday = wday(DateTime)) %>%
           filter(wday(DateTime) %in% c(5, 6, 7))

elec <- elecnew
rm(elecnew)
  
#Set png width and height

png("plot3.png", width=480, height=480)

#Create the plot

plot(elec$DateTime,elec$Sub_metering_1, 
     type = "l",
     xlab="",
     ylab="Energy sub metering"
     )
     lines(elec$DateTime,elec$Sub_metering_2, col = "red")
     lines(elec$DateTime,elec$Sub_metering_3, col = "blue")

legend("topright", col = c("black","red", "blue"), lty = 1, lwd = 2, 
       legend=c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))  
     
#Disconnect from png
dev.off()
