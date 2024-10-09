cve_data <- read.csv("vulnerability_data.csv")

head(cve_data)
summary(cve_data)

cve_data$Base_Score <- as.numeric(cve_data$Base_Score)

sub_low<-subset(cve_data_low,Base_Score != "NA" & Base_Score >= 0.1 & Base_Score <= 3.9, select=c(Cve_Id,Base_Score))
head(sub_low)
summary(sub_low)

sub2 <- subset(cve_data, Base_Score = "NA", select=c(Cve_Id,Description,Base_Score))
head(sub2)

# descriptions_1 <- sub1$Description[1:10]
descriptions_2 <- sub2$Description[1:10]

# head(descriptions_1)
head(descriptions_2)
