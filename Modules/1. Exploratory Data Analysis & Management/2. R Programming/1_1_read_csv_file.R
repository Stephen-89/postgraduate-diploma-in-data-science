# Load the libraries
library(tidyverse)

setwd("C:/Users/steph/OneDrive/Desktop/postgraduate-diploma-in-data-science/Modules/1. Exploratory Data Analysis & Management/2. R Programming")

# Load the CSV file
# Replace 'file.csv' with the actual path to your CSV file
data <- read.csv("premiums.csv")

# Data manipulation
cleaned_data <- data %>%
  filter(!is.na(Premium)) %>%          # Filter out rows where Premium is NA
  mutate(new_column = Premium * 2)     # Create a new column that doubles the Premium value

# Summarizing and limiting to top 20 regions
summary_data <- cleaned_data %>%
  group_by(REGION) %>%            # Group by the column for regions (replace with actual name)
  summarize(mean_value = mean(Premium, na.rm = TRUE)) %>%  # Calculate the mean of the Premium column
  arrange(desc(mean_value)) %>%         # Arrange in descending order based on mean_value
  slice_head(n = 20)                    # Keep only the top 20 regions

# Creating a plot
ggplot(summary_data, aes(x = reorder(REGION, mean_value), y = mean_value)) +
  geom_col() +
  labs(title = "Top 20 Regions by Mean Premium Value", x = "Region", y = "Mean Premium Value") +
  coord_flip()                           # Flip coordinates for better readability

# Saving the plot
ggsave("top_20_regions_premium_value_plot.png")  # Save the plot as top_20_regions_premium_value_plot.png