library(ggplot2)

demographic<-read.csv("TelecomData_CustDemo.csv", header=TRUE)
head(demographic)

transaction<-read.csv("TelecomData_WeeklyData.csv", header=TRUE)
head(transaction)

working<-merge(demographic, transaction, by=("CustID"),all=TRUE)
working$Age_Group<-cut(working$Age, breaks= c(0,30,45,Inf), labels= c("18-30","30-45",">45"))

trend<-aggregate(Calls~Week+Age_Group, data=working, FUN=sum)

ggplot(trend, aes(x=Week, y=Calls, colour=Age_Group))+geom_line(size=1)+ geom_point(size=3)+labs(y="Calls", title="Fig. No. 14 : TREND LINE")

ggplot(telecom, aes(x=Age_Group,fill=Gender))+geom_bar(position="dodge",
                                                       fill="darkorange")+labs(x="Age Group", y="No. of customers", title="Bar
chart")
