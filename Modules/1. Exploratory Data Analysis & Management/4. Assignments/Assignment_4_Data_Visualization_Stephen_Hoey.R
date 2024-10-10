#' ---
#' title: "Assignment 4 Data Visualization"
#' author: "Stephen Hoey"
#' date: "Oct 10th, 2024"
#' ---

library(RColorBrewer)
library(ggplot2)
library(dplyr)

#-------------------------------------------------------#
#Q1 Import Premium and Claim data and merge both data sets into one data.
#-------------------------------------------------------#

Premium <- read.csv("Premiums.csv", header = T, stringsAsFactors=T)
Claim <- read.csv("Claims.csv", header = T, stringsAsFactors=T)

merged_data <- merge(Premium,Claim, by = "POLICY_NO")


#-------------------------------------------------------#
#Q2 For each zone, obtain the mean Premium and plot a bar chart showing the mean Premium over zone. (Use any color from a palette from R( Color Brewer)
#-------------------------------------------------------#

mean_premiums <- merged_data %>%
  group_by(ZONE_NAME) %>%
  summarise(
    mean_premiums = mean(Premium, na.rm = TRUE)
  )

ggplot(mean_premiums, aes(x = ZONE_NAME, y = mean_premiums)) +
  geom_bar(stat = "identity", fill = brewer.pal(n = 3, name = "Dark2")) +
  geom_text(aes(label = round(mean_premiums, 2)), colour = "white") +
  theme_dark() +
  labs(title = "Mean Premiums by Zone Name", x = "Zone Name", y = "Mean Premiums")


#-------------------------------------------------------#
#Q3 Obtain a stacked bar chart for all the Zones over Sub plans by the Premium amount.
#-------------------------------------------------------#

total_premiums <- merged_data %>%
  group_by(ZONE_NAME, Sub_Plan) %>%
  summarise(
    total_premiums = sum(Premium, na.rm = TRUE)
  )

ggplot(total_premiums, aes(x = ZONE_NAME, y = total_premiums, fill = Sub_Plan)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette = "Dark2") +
  geom_text(aes(label = round(total_premiums, 2)), position = position_stack(vjust = 0.5), color = "white")  +
  theme_dark() +
  labs(title = "Total Premiums by Zone Name and Sub Plan", x = "Zone Name", y = "Total Premiums")


#-------------------------------------------------------#
#Q4 Obtain a heat map of Plan and Zone with respective average Premium.
#-------------------------------------------------------#

average_premiums <- merged_data %>%
  group_by(Plan, ZONE_NAME) %>%
  summarise(
    average_Premiums = mean(Premium, na.rm = TRUE)
  )

ggplot(average_premiums, aes(x = Plan, y = ZONE_NAME, fill = average_Premiums)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "lightblue", high = "#0c4c8a") +
  geom_text(aes(label = round(average_Premiums, 2)), color = "white") +
  theme_dark() +
  labs(title = "Heat Map of Average Premiums by Plan and Zone Name", 
       x = "Plan", 
       y = "Zone Name", 
       fill = "Average Premiums")


#-------------------------------------------------------#
#Q5 Obtain a pie chart using ggplot2 for Premium amount across different sub plans. (Use any palette from R (Color Brewer)   
#-------------------------------------------------------#

premium_amounts <- merged_data %>%
  group_by(Sub_Plan) %>%
  summarise(
    amounts = mean(Premium, na.rm = TRUE)
  )

ggplot(premium_amounts, aes(x = "", y = amounts, fill = Sub_Plan)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  scale_fill_brewer(palette = "Dark2") +
  geom_text(aes(label = round(amounts, 2)), position = position_stack(vjust = 0.5), color = "white") +
  theme_void() +
  labs(title = "Premium Amounts Across Different Sub Plans", fill = "Sub Plan")
  