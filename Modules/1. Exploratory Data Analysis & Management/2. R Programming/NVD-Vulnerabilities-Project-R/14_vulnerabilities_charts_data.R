library(ggplot2)

cve_data <- read.csv("vulnerability_data.csv")

cve_data$Range<-cut(cve_data$Base_Score, breaks= c(0,0.1,3.9,6.9,8.9,Inf), labels= c("NA","Low","Medium","High","Critical"))

# Create the bar chart with counts displayed on the bars
ggplot(cve_data, aes(x = Range)) +
  geom_bar(fill = "steelblue", color = "black") +
  geom_text(stat = 'count', aes(label = after_stat(count)), vjust = -0.5, color = "black") +  # Use after_stat(count)
  labs(title = "Vulnerability Count by Severity Level", x = "Severity", y = "Count of Vulnerabilities") +
  theme_minimal()
