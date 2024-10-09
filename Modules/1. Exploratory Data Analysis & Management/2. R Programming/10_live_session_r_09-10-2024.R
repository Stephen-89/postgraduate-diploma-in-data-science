CUST_PROFILE <- read.csv("CUST_PROFILE.csv", header = T, stringsAsFactors=T)
NPSDATA <- read.csv("NPSDATA.csv", header = T, stringsAsFactors=T)
NSVDATA <- read.csv("NSVDATA.csv", header = T, stringsAsFactors=T)

length(unique(CUST_PROFILE$CUSTID))
length(unique(NPSDATA$CUSTID))
length(unique(NSVDATA$CUSTID))