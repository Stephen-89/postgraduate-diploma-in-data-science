# install.packages("lubridate")

library(lubridate)
library(plotly)

cve_data <- read.csv("vulnerability_data.csv")

heatmapdata_vuln <- subset(cve_data, select = c(Year, Published_Date, Base_Score))
heatmapdata_vuln <- na.omit(heatmapdata_vuln)

heatmapdata_vuln$Published_Date <- gsub("T.*", "", heatmapdata_vuln$Published_Date)
heatmapdata_vuln$Published_Date <- ymd(heatmapdata_vuln$Published_Date)

heatmapdata_vuln$Month <- month(heatmapdata_vuln$Published_Date, label = TRUE, abbr = TRUE)
head(heatmapdata_vuln)

heatmapdata_vuln$Month<-factor(heatmapdata_vuln$Month,level=unique(heatmapdata_vuln$Month))

plot_ly(heatmapdata_vuln, x=heatmapdata_vuln$Month, y=heatmapdata_vuln$Year, z=heatmapdata_vuln$Base_Score, type="heatmap",connectgaps=FALSE,showscale=T)

trend<-aggregate(Base_Score~Year, data=heatmapdata_vuln, FUN=sum)

plot(trend, type = "o", col = "#0c4c8a", xlab = "Year", ylab = "Total Base Scores",
     main = "Base Score Trend")