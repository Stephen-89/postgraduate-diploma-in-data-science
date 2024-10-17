library(dplyr)
library(ggplot2)
library(lubridate)

csv_file_path <- "vulnerability_data.csv"

mean_vendor_provided_score_over_time_line_plot <- function(csv_file_path, vendor_name, time_interval = "year") {

  cve_data <- read.csv(csv_file_path)

  cve_data$Published_Date <- as.Date(cve_data$Published_Date, format = "%Y-%m-%d")
  cve_data$Base_Score <- as.numeric(cve_data$Base_Score)

  vendor_data <- cve_data %>%
    filter(!is.na(Base_Score), Vendor == vendor_name)

  if(nrow(vendor_data) == 0) {
    cat("No data available for the specified vendor:", vendor_name, "\n")
    return(NULL)
  }

  vendor_data <- vendor_data %>%
    mutate(Time_Interval = case_when(
      time_interval == "month" ~ floor_date(Published_Date, "month"),
      time_interval == "quarter" ~ floor_date(Published_Date, "quarter"),
      time_interval == "year" ~ floor_date(Published_Date, "year"),
      TRUE ~ Published_Date
    ))

  vendor_score_trends <- vendor_data %>%
    group_by(Time_Interval) %>%
    summarise(
      Mean_Base_Score = mean(Base_Score, na.rm = TRUE),
      .groups = 'drop'
    )

  p <- ggplot(vendor_score_trends, aes(x = Time_Interval, y = Mean_Base_Score)) +
    geom_line(size = 1.2, color = "#1f78b4") +
    geom_point(size = 3, color = "#1f78b4") +
    labs(title = paste("Mean CVSS Base Scores for", vendor_name, "Over Time"),
         subtitle = paste("Grouped by", toupper(time_interval)),
         x = "Time Interval",
         y = "Mean CVSS Base Score") +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(size = 12, hjust = 0.5),
      axis.title = element_text(size = 14),
      axis.text = element_text(size = 12),
      panel.grid.minor = element_blank()
    )

  print(p)

  ggsave(paste0("charts/10_mean_score_for_", gsub(" ", "_", tolower(vendor_name)), "_over_time.png"), plot = p, width = 12, height = 6)
  cat("Chart saved as 'charts/10_mean_score_for_", gsub(" ", "_", tolower(vendor_name)), "_over_time.png'\n")

}

mean_vendor_provided_score_over_time_line_plot(csv_file_path, vendor_name = "microsoft", time_interval = "year")
