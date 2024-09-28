library(dplyr)
library(ggplot2)
library(lubridate)

csv_file_path <- "vulnerability_data.csv"

trend_mean_and_median_cvss_base_scores_over_time_line_plot <- function(csv_file_path, time_interval = "month") {

  cve_data <- read.csv(csv_file_path)

  cve_data$Published_Date <- as.Date(cve_data$Published_Date, format = "%Y-%m-%d")
  cve_data$Base_Score <- as.numeric(cve_data$Base_Score)

  cve_data <- cve_data %>%
    mutate(Time_Interval = case_when(
      time_interval == "month" ~ floor_date(Published_Date, "month"),
      time_interval == "quarter" ~ floor_date(Published_Date, "quarter"),
      time_interval == "year" ~ floor_date(Published_Date, "year"),
      TRUE ~ Published_Date  # Default is no aggregation
    ))

  score_trends <- cve_data %>%
    filter(!is.na(Base_Score)) %>%
    group_by(Time_Interval) %>%
    summarise(
      Mean_Base_Score = mean(Base_Score, na.rm = TRUE),
      Median_Base_Score = median(Base_Score, na.rm = TRUE),
      .groups = 'drop'
    )

  p <- ggplot(score_trends, aes(x = Time_Interval)) +
    geom_line(aes(y = Mean_Base_Score, color = "Mean", linetype = "Mean"), size = 1.2) +
    geom_line(aes(y = Median_Base_Score, color = "Median", linetype = "Median"), size = 1.2) +
    geom_point(aes(y = Mean_Base_Score, color = "Mean"), size = 2) +
    geom_point(aes(y = Median_Base_Score, color = "Median"), size = 2) +
    labs(title = "Trend of Mean and Median CVSS Base Scores Over Time",
         subtitle = paste("Grouped by", toupper(time_interval)),
         x = "Time Interval",
         y = "CVSS Base Score",
         color = "Metric",
         linetype = "Metric") +
    scale_color_manual(values = c("Mean" = "#1f78b4", "Median" = "#33a02c")) +
    scale_linetype_manual(values = c("Mean" = "solid", "Median" = "dashed")) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(size = 12, hjust = 0.5),
      axis.title = element_text(size = 14),
      axis.text = element_text(size = 12),
      legend.position = "top",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 12),
      panel.grid.minor = element_blank()
    )

  print(p)

  ggsave("charts/8_trend_mean_and_median_cvss_base_scores_over_time_line_plot.png", plot = p, width = 12, height = 6)
  cat("Chart saved as 'charts/8_trend_mean_and_median_cvss_base_scores_over_time_line_plot.png'\n")

}

trend_mean_and_median_cvss_base_scores_over_time_line_plot(csv_file_path, time_interval = "year")
