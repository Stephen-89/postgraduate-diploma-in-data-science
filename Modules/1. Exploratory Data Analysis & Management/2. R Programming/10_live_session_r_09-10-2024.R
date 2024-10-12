CUST_PROFILE <- read.csv("CUST_PROFILE.csv", header = T, stringsAsFactors=T)
NPSDATA <- read.csv("NPSDATA.csv", header = T, stringsAsFactors=T)
NSVDATA <- read.csv("NSVDATA.csv", header = T, stringsAsFactors=T)

length(unique(CUST_PROFILE$CUSTID))
length(unique(NPSDATA$CUSTID))
length(unique(NSVDATA$CUSTID))

agg_sales<-aggregate(NSV~CUSTID, data = NSVDATA, FUN = sum)
head(agg_sales)

smstop<-agg_sales[order(-agg_sales$NSV),]
head(smstop,10)

smsbottom<-agg_sales[order(agg_sales$NSV),]
head(smsbottom,10)

mapped<-merge(agg_sales,CUST_PROFILE,by="CUSTID")
head(mapped)

top<-mapped[order(-mapped$NSV),]
top100<-head(top,100)
top10<-head(top,10)

library("ggplot2")

ggplot(top10,aes(x=REGION,y=NSV))+
  geom_bar(stat="identity",fill="blue")+
  labs(x="REGION",y="MEAN NSV",title="REGIONWISE SALES")

LoB<-aggregate(NSV~BUSINESS,data=NSVDATA,FUN=sum)
Tot<-sum(LoB$NSV)
LoB$CONTRI<-(LoB$NSV/Tot)*100
LoB

nps_range<-merge(NPSDATA,CUST_PROFILE,by="CUSTID",)
median_nps<-aggregate(NPS~REGION,data=nps_range,FUN=median)
median_nps
