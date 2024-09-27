#install.packages("caret")
library(caret)

x<-10
y<-46

x<-c(2,3,4)
y<-c(5,6,7)
z<-c("a","b","c")

df<-data.frame(x,y,z)

max(df$y)
min(df$x)

## add a new column to df
df$sum<-df$x+df$y
df$v<-c(4,1,9)

mean(df$x)
length(df$y)
levels(df$z)
unique(df$z)

df$sum<-NULL
