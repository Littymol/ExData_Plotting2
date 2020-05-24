##If the dataset is not present in the current working directory then download it
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

##Subsetting NEI based on Baltimore City, Maryland fips == "24510"
Baltimore_NEI <- subset(NEI,fips == 24510)

png("plot3.png",width=480,height=480,units="px",bg="transparent")

library(ggplot2)

g<-ggplot(Baltimore_NEI,aes(factor(year),Emissions,fill=type)) +
  geom_col() +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

print(g)

dev.off()
