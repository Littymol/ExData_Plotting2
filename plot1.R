# If the dataset is not present in the current working directory then download it
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if (!file.exists("exdata_data_NEI_data.zip")) {
  if (!file.exists("my_data")) {
    dir.create("my_data")
  }
  download.file(fileUrl, destfile="my_data/exdata_data_NEI_data.zip")
  unzip("my_data/exdata_data_NEI_data.zip", exdir=".")
}

##Reading .rds file

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Aggregate by sum the total emissions by year
Total_Emissions <- aggregate(Emissions ~ year,NEI, sum)

png("plot1.png",width=480,height=480,units="px",bg="transparent")

barplot((Total_Emissions$Emissions)/10^6,names.arg=Total_Emissions$year,xlab="Year",ylab="PM2.5 Emissions",  main="Total PM2.5 Emissions")

dev.off()
