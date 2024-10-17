data <- read.csv("basic_salary2.csv", header = T, stringsAsFactors=T)
# data2 <- read.csv(file.choose(), header = T)

head(data, 10)
tail(data, 10)
dim(data)

unique(data$Location)

str(data)

# mean(data$ba)
# mean(data$ms)

mean(data$ba, na.rm = TRUE)
mean(data$ms, na.rm = TRUE)

max(data$ba, na.rm = TRUE)
max(data$ms, na.rm = TRUE)

min(data$ba, na.rm = TRUE)
min(data$ms, na.rm = TRUE)

names(data)
summary(data)

history(max.show=25)
savehistory(file="02-10-2024.txt")
loadhistory(file="02-10-2024.txt")

data2<-sum(is.na(data$ba))
data2

# data3 = na.omit(data2)
# dim(data3)

sub<-data[c(3:7),]
sub

sub2<-data[c(2,6,9,12),c(1,4,6)]
sub2

sub3<-data[,c(1,4,6)]
sub3

sub4<-subset(data,Location == "DELHI" & ba > 17000)
sub4

sub5<-subset(data,select=c(First_Name,Last_Name))
sub5

sub6<-subset(data,Location == "DELHI" & ba > 17000, select=c(First_Name,Last_Name,Location,ba))
sub6

attach(data)
sort1<-data[order(ba),]
head(sort1)

sort2<-data[order(-ba),]
head(sort2)

sort3<-data[order(ba, decreasing = TRUE),]
head(sort3)