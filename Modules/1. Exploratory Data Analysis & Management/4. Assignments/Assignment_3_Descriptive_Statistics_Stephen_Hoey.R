#' ---
#' title: "Assignment 3 Descriptive Statistics"
#' author: "Stephen Hoey"
#' date: "Oct 11th, 2024"
#' ---

library(car)
library(ggplot2)
library(e1071)
library(dplyr)

#-------------------------------------------------------#
#Q1 Import Premiums data.
#-------------------------------------------------------#

Premium <- read.csv("Premiums.csv", header = T, stringsAsFactors=T)


#-------------------------------------------------------#
#Q2 Obtain the Mode for the count of policies available across each Zone.
#-------------------------------------------------------#

getmode <- function(x) {
  mode <- unique(x)
  mode[which.max(tabulate(match(x, mode)))]
}
mode_by_zone_name <- aggregate(Premium ~ ZONE_NAME, data = Premium, FUN = getmode)

print(mode_by_zone_name)


#-------------------------------------------------------#
#Q3 Obtain box-whisker plots for Vintage period.
#-------------------------------------------------------#

boxplot(Premium$Vintage_Period, 
        main = "Box-whisker plots for Vintage Period.", 
        xlab = "Vintage Period",
        ylab = "Values",
        col = "lightblue", 
        border = "#0c4c8a")


#-------------------------------------------------------#
#Q4 Detect outliers if present. Hint: use Boxplot() function of ‘car’ Package
#-------------------------------------------------------#

Boxplot(Premium$Vintage_Period, 
        main = "Outliers boxplot of Vintage Period.",
        xlab = "Vintage Period",
        ylab = "Values",
        col = "lightblue",
        border = "#0c4c8a")


#-------------------------------------------------------#
#Q5 Find skewness and kurtosis of Premium amount by Zone.
#-------------------------------------------------------#

summary_stats <- Premium %>%
  group_by(ZONE_NAME) %>%
  summarise(
    Skewness = skewness(Premium),
    Kurtosis = kurtosis(Premium)
  )

print(summary_stats)

ggplot(summary_stats, aes(x = ZONE_NAME, y = Skewness, fill = ZONE_NAME)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = round(Skewness, 2)),
            vjust = -0.5,
            size = 4) +
  labs(title = "Skewness of Premiums by Zone Name", x = "Zone Name", y = "Skewness") +
  theme_dark()

ggplot(summary_stats, aes(x = ZONE_NAME, y = Kurtosis, fill = ZONE_NAME)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = round(Kurtosis, 2)), colour = "white",
            vjust = -0.5,
            size = 4) +
  labs(title = "Kurtosis of Premiums by Zone Name", x = "Zone Name", y = "Kurtosis") +
  theme_dark()


#-------------------------------------------------------#
#Q6 Draw a scatter plot of Premium and Vintage period. 
#-------------------------------------------------------#

ggplot(Premium, aes(x = Premium, y = Vintage_Period)) +
  geom_point(color = "white", size = 2) +
  geom_smooth(method = "lm", color = "#0c4c8a") +
  labs(title = "Scatter Plot of Premium and Vintage Period",
       x = "Premium",
       y = "Vintage Period") +
  theme_dark()


#-------------------------------------------------------#
#Q7 Find the correlation coefficient between Premium and Vintage period and interpret the value.
#-------------------------------------------------------#

correlation_coefficient <- cor(Premium$Premium, Premium$Vintage_Period)

print(correlation_coefficient)

getrelationship <- function(x) {
  if (x == 1) {
    return("Correlation Coefficient indicates a perfect positive relationship.")
  } else if (x == -1) {
    return("Correlation Coefficient indicates a perfect negative relationship.")
  } else if (x == 0) {
    return("Correlation Coefficient indicates no relationship.")
  } else if (x > 0 && x < 1) {
    return("Correlation Coefficient indicates a positive relationship.")
  } else if (x > -1 && x < 0) {
    return("Correlation Coefficient indicates a negative relationship.")
  } else {
    return("Correlation Coefficient out of bounds. It should be between -1 and 1.")
  }
}

relationship <- getrelationship(correlation_coefficient)

print(relationship)
