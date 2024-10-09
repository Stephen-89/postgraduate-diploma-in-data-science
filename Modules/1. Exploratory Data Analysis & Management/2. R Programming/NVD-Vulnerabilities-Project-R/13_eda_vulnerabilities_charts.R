library(ggplot2)

cve_data <- read.csv("vulnerability_data.csv")

head(cve_data)
summary(cve_data)
str(cve_data)

cve_data$Base_Score <- as.numeric(cve_data$Base_Score)

# sub1<-subset(cve_data,Base_Score!="NA",select=c(Cve_Id,Description,Base_Score))
# sub2<-subset(cve_data,Base_Score="NA",select=c(Cve_Id,Description,Base_Score))

# Limit to 50 rows
# sub1 <- head(sub1, 50)
# sub2 <- head(sub2, 50)

subset_low_vulnerabilities<-subset(cve_data,Base_Score != "NA" & Base_Score >= 0.1 & Base_Score <= 3.9, select=c(Cve_Id,Base_Score))
head(subset_low_vulnerabilities)
summary(subset_low_vulnerabilities)

summary_stats <- summary(subset_low_vulnerabilities$Base_Score)
summary_df <- data.frame(
  Statistic = names(summary_stats),
  Value = as.numeric(summary_stats)
)

box_plot <- ggplot(subset_low_vulnerabilities, aes(x = "", y = Base_Score)) +
  geom_boxplot(fill = "skyblue", color = "darkblue") +
  labs(title = "Box Plot of Base_Score", y = "Base Score") +
  theme_minimal()

median_value <- median(subset_low_vulnerabilities$Base_Score)

box_plot +
  geom_text(aes(x = 1, y = median_value + 0.1, label = round(median_value, 2)),
            color = "red", size = 5, vjust = -0.5)

bar_chart <- ggplot(summary_df, aes(x = Statistic, y = Value)) +
  geom_bar(stat = "identity", fill = "lightgreen", color = "darkgreen") +
  labs(title = "Summary Statistics of Base_Score Low", x = "Statistic", y = "Value") +
  theme_minimal()

bar_chart +
  geom_text(aes(label = round(Value, 2)), vjust = -0.5, size = 5, color = "black")
