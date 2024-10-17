# install.packages("GGally")
# install.packages("plotly")

library(GGally)
library(ggplot2)
library(plotly)

# Part 1

job<-read.csv("JOB PROFICIENCY DATA.csv", header=TRUE)

plot(aptitude,job_prof, main="Fig.No. 1 : ScatterPlot with Regression Line", xlab="Aptitude ", ylab="Job Proficiency", pch=19) abline(lm(job_prof~aptitude), col="darkorange")

pairs(~aptitude+job_prof+testofen+tech_+g_k_,data=job, main="Fig.No. 2 : ScatterPlot Matrix",col="darkorange")

ggpairs(job[,c("aptitude","testofen","tech_","g_k_","job_prof")], title = "Scatter Plot Matrix")

qplot(x=tech_, y=job_prof, data=job, color=aptitude, size=aptitude, xlab="Technical", ylab="Job Proficiency", main="Fig. No. 3 : BUBBLE CHART")

# Part 2

# heatmapdata<-read.csv("Average Temperatures in NY.csv", header=TRUE)
# heatmapdata$Month<-factor(heatmapdata$Month,level=unique(heatmapdata$Month))

# plot_ly(heatmapdata, x=heatmapdata$Month, y=heatmapdata$Year, z=heatmapdata$Temperature, type="heatmap",connectgaps=FALSE,showscale=T)

# Part 3

# transaction<-read.csv("TelecomData_WeeklyData.csv", header=TRUE)
# trend<-aggregate(Calls~Week, data=transaction, FUN=sum)

# plot(trend, type = "o", col = "red", xlab = "week", ylab = "No of calls", main = "total Calls")