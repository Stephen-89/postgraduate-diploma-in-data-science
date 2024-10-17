library(e1071)
library(dplyr)

masterdata <- read.csv("Bank Churn.csv", header = T, stringsAsFactors=T)
str(masterdata)

head(masterdata, 5)

fun_1<-function(x){
  c(
    count = length(x),
    skewness = skewness(x,na.rm=T,type=2)
  )
}

aggregate(CreditScore~Exited,data=masterdata,FUN=fun_1)

fun_2<-function(x){
  c(
    count = length(x),
    mean = mean(x)
  )
}

summary_status_CreditScore <- aggregate(CreditScore~Exited,data=masterdata,FUN=fun_2)
summary_status_CreditScore

masterdata %>%
  group_by(Exited) %>%
  summarise(count=length(CreditScore),mean=mean(CreditScore)) %>%
  as.data.frame()

Exited_geo<-table(masterdata$Geography,masterdata$Exited)
colnames(Exited_geo)<-c("Stayed","Exited")
Exited_geo

Exited_geo2<-round(prop.table(Exited_geo,1)*100,2)
Exited_geo2

round(cor(masterdata$CreditScore,masterdata$EstimatedSalary),4)


masterdata$CreditScore_cat<-ifelse(masterdata$CreditScore>=650,1,0)
head(masterdata,5)

Exited_geo_cross<-table(masterdata$CreditScore_cat,masterdata$Exited)
colnames(Exited_geo_cross)<-c("Stayed","Exited")
Exited_geo_cross

masterdata %>%
  group_by(Geography,Gender) %>%
  summarise(n=length(CreditScore),
            mean = mean(CreditScore),
            median = median(CreditScore)) %>%
  as.data.frame()

geography_distribution_np <- masterdata %>%
  group_by(Geography) %>%
  summarize(Products=sum(NumOfProducts))

barplot(geography_distribution_np$Products, 
        names.arg = geography_distribution_np$Geography,
        ylim = c(0, max(geography_distribution_np$Products) + 500), 
        col=c("steelblue", "orange3", "darkgreen"),
        xlab = "Geography", 
        ylab = "Number of Products", 
        main = "Number of Products by Geography")
