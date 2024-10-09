salary <- read.csv("basic_salary2.csv", header = T, stringsAsFactors=T)
quantile(salary$ba,na.rm=T)
quantile(salary$ba,prob=c(0.1,0.5,0.8),na.rm=T)
