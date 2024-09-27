# Install ggplot2 if needed
#install.packages("ggplot2")
library(ggplot2)

# Load a dataset (for example, a CSV file)
data <- read.csv("premiums.csv")

# View the first few rows of the dataset
head(data)

# Check the structure of the dataset
str(data)

# Get summary statistics of the dataset
summary(data)

# Check for missing values in the entire dataset
sum(is.na(data))

# Check missing values by column
colSums(is.na(data))

# Frequency of PRODUCT
table(data$PRODUCT)

# Frequency of REGION
table(data$REGION)

# Bar plot for PRODUCT
barplot(table(data$PRODUCT), main = "Product Distribution", col = "lightblue")

# Bar plot for REGION
barplot(table(data$REGION), main = "Region Distribution", col = "lightgreen")

# Summary of Sum_Assured
summary(data$Sum_Assured)

# Histogram of Sum_Assured
hist(data$Sum_Assured, main = "Distribution of Sum Assured", xlab = "Sum Assured", col = "blue", breaks = 20)

# Boxplot for Premium
boxplot(data$Premium, main = "Boxplot of Premium", horizontal = TRUE, col = "orange")

# Contingency table for PRODUCT and REGION
table(data$PRODUCT, data$REGION)

# Stacked bar plot for PRODUCT and REGION
barplot(table(data$PRODUCT, data$REGION), beside = TRUE, col = c("red", "blue", "green"), main = "Product vs Region")

# Histogram for Sum Assured
ggplot(data, aes(x = Sum_Assured)) +
  geom_histogram(binwidth = 50000, fill = "blue", color = "black") +
  ggtitle("Histogram of Sum Assured")

# Boxplot of Premium by Product
ggplot(data, aes(x = PRODUCT, y = Premium)) +
  geom_boxplot(fill = "lightblue") +
  ggtitle("Premium by Product")

# Scatter plot of Sum Assured vs Premium
ggplot(data, aes(x = Sum_Assured, y = Premium)) +
  geom_point() +
  ggtitle("Scatter Plot of Sum Assured vs Premium")
