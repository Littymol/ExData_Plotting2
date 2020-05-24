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


## Subset motot vehicle related NEI data

motor<- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE) 
motorSCC <- SCC[motor,]$SCC
mv_NEI <- NEI[NEI$SCC %in% motorSCC,]

# Subset the vehicles NEI data by each city's fip and add city name.
Baltimore_NEI <- mv_NEI[mv_NEI$fips=="24510",]
Baltimore_NEI$city <- "Baltimore City"

LosAngeles_NEI <- mv_NEI[mv_NEI$fips=="06037",]
LosAngeles_NEI$city <- "Los Angeles County"

# Combine the two subsets with city name into one data frame
bothNEI <- rbind(Baltimore_NEI,LosAngeles_NEI)



png("plot6.png",width=480,height=480,units="px",bg="transparent")

library(ggplot2)

g <- ggplot(bothNEI,aes(factor(year),Emissions,fill=city)) +
  geom_col() +facet_grid(scales = "free",space="free",.~city)+
  theme_bw() +  guides(fill=F) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA(1999-2008)"))

print(g)
dev.off()