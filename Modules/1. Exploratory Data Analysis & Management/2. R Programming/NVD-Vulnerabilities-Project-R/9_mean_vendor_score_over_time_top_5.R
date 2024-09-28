library(dplyr)
library(ggplot2)
library(lubridate)

csv_file_path <- "vulnerability_data.csv"

mean_vendor_score_over_time_top_5_line_plot <- function(csv_file_path, time_interval = "year", top_n_vendors = 5) {

  cve_data <- read.csv(csv_file_path)

  cve_data$Published_Date <- as.Date(cve_data$Published_Date, format = "%Y-%m-%d")
  cve_data$Base_Score <- as.numeric(cve_data$Base_Score)

  cve_data <- cve_data %>%
    filter(!is.na(Base_Score), !is.na(Vendor))

  top_vendors <- cve_data %>%
    group_by(Vendor) %>%
    summarise(Total_Vulnerabilities = n(), .groups = 'drop') %>%
    arrange(desc(Total_Vulnerabilities)) %>%
    slice_head(n = top_n_vendors) %>%
    pull(Vendor)

  cve_data <- cve_data %>%
    filter(Vendor %in% top_vendors)

  cve_data <- cve_data %>%
    mutate(Time_Interval = case_when(
      time_interval == "month" ~ floor_date(Published_Date, "month"),
      time_interval == "quarter" ~ floor_date(Published_Date, "quarter"),
      time_interval == "year" ~ floor_date(Published_Date, "year"),
      TRUE ~ Published_Date
    ))

  vendor_score_trends <- cve_data %>%
    group_by(Time_Interval, Vendor) %>%
    summarise(
      Mean_Base_Score = mean(Base_Score, na.rm = TRUE),
      .groups = 'drop'
    )

  p <- ggplot(vendor_score_trends, aes(x = Time_Interval, y = Mean_Base_Score, color = Vendor, group = Vendor)) +
    geom_line(size = 1.2) +
    geom_point(size = 2) +
    labs(title = "Mean CVSS Base Scores for Top Vendors Over Time",
         subtitle = paste("Top", top_n_vendors, "Vendors by Number of Vulnerabilities"),
         x = "Time Interval",
         y = "Mean CVSS Base Score",
         color = "Vendor") +
    scale_color_brewer(palette = "Set1") +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(size = 12, hjust = 0.5),
      axis.title = element_text(size = 14),
      axis.text = element_text(size = 12),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 10),
      panel.grid.minor = element_blank()
    )

  print(p)

  ggsave("charts/9_mean_vendor_score_over_time_top_5_line_plot.png", plot = p, width = 12, height = 6)
  cat("Chart saved as 'charts/9_mean_vendor_score_over_time_top_5_line_plot.png'\n")

}

mean_vendor_score_over_time_top_5_line_plot(csv_file_path, time_interval = "year", top_n_vendors = 5)
