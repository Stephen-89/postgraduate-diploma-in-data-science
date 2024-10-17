library(GGally)
library(ggplot2)
library(plotly)

demographic<-read.csv("JOB PROFICIENCY DATA.csv", header=TRUE)
head(demographic)
transaction<-read.csv("TelecomData_WeeklyData.csv", header=TRUE)
head(transaction)

tcalls<-aggregate(Calls~CustID, data=transaction, FUN=sum)
head(tcalls)

working <- merge(demographic, tcalls, by = "CustID", all = TRUE)
head(working)

# Check the structure and summary statistics
str(working)
summary(working)

# Check for missing values
sum(is.na(working))

working$age_group<-cut(working$Age, breaks=c(0,30,45,Inf), labels=c("18-30","30-45",">45"))
head(working)