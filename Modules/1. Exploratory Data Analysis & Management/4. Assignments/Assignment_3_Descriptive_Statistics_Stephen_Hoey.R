library(ggplot2)


# Import Premiums data. 
Premium <- read.csv("Premiums.csv", header = T, stringsAsFactors=T)


# Obtain the Mode for the count of policies available across each Zone.
mode <- function(x) {
  uniq_x <- unique(x)
  uniq_x[which.max(tabulate(match(x, uniq_x)))]
}
mode_by_zone_name <- aggregate(Premium ~ ZONE_NAME, data = Premium, FUN = mode)
print(mode_by_zone_name)


# Obtain box-whisker plots for Vintage period. 
boxplot(Premium$Vintage_Period, main = "Box-whisker plots for Vintage period.", ylab = "Vintage Period", col = "lightblue", border = "darkblue")

# Detect outliers if present. Hint: use Boxplot() function of ‘car’ Package


# Find skewness and kurtosis of Premium amount by Zone.


# Draw a scatter plot of Premium and Vintage period. 
ggplot(Premium, aes(x = Vintage_Period, y = Premium)) +
  geom_point(color = "blue", size = 2) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Scatter Plot of Premium and Vintage Period",
       x = "Vintage Period",
       y = "Premium") +
  theme_dark()


# Find the correlation coefficient between Premium and Vintage period and interpret the value.
correlation_coefficient <- cor(Premium$Premium, Premium$Vintage_Period, use = "complete.obs")
cat("Correlation Coefficient between Premium and Vintage Period:", correlation_coefficient, "\n")