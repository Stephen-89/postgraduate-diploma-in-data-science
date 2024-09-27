setwd("C:/Users/steph/OneDrive/Desktop/postgraduate-diploma-in-data-science/Modules/1. Exploratory Data Analysis & Management/2. R Programming")

# Load the CSV file
# Replace 'file.csv' with the actual path to your CSV file
data <- read.csv("premiums.csv")

# Extract the 'REGION' column as a list
region_list <- as.list(data$REGION)
# Extract the 'Premium' column as a list
premium_list <- as.list(data$Premium)

count <- 0
for(i in region_list){
  if(i=="Mumbai I")
    count=count+1
}
print(paste("Mumbai I:",count))

limited_premium_list <- head(premium_list, 5)
limited_region_list <- region_list[1:5]

#datedf<-data.frame(limited_premium_list, limited_region_list)
#datedf

premium_vector <- data$Premium

# Calculate mean
mean_premium <- mean(premium_vector, na.rm = TRUE)
# Calculate median
median_premium <- median(premium_vector, na.rm = TRUE)
# Calculate mode (mode is a bit trickier, so we use a custom function)
mode_premium <- as.numeric(names(sort(table(premium_vector), decreasing = TRUE)[1]))

mean_premium
median_premium
mode_premium

# Combine mean, median, and mode into a vector
premium_stats <- c(mean_premium, median_premium, mode_premium)
# Give names to each statistic for labeling in the bar plot
names(premium_stats) <- c("Mean", "Median", "Mode")

# Create the bar plot
barplot(premium_stats, 
        main = "Mean, Median, and Mode of Premiums", 
        ylab = "Premium Value", 
        col = c("blue", "green", "red"),
        beside = TRUE)