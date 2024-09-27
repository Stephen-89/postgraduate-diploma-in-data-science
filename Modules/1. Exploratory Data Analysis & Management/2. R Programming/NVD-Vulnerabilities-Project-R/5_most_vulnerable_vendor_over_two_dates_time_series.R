library(dplyr)
library(ggplot2)

most_vulnerable_vendor_over_two_dates_time_series_chart <- function(csv_file_path, start_date, end_date, time_unit = "month") {
  
  cve_data <- read.csv(csv_file_path, stringsAsFactors = FALSE)
  
  cve_data$Published_Date <- as.Date(cve_data$Published_Date, format = "%Y-%m-%d")
  
  filtered_cve_data <- cve_data %>%
    filter(Published_Date >= start_date & Published_Date <= end_date) %>%
    filter(!is.na(Vendor) & !is.na(Product))
  
  vendor_counts <- filtered_cve_data %>%
    group_by(Vendor) %>%
    summarise(Total_Vulnerabilities = n()) %>%
    arrange(desc(Total_Vulnerabilities))
  
  top_vendor <- vendor_counts$Vendor[1]
  print(paste("Top vendor:", top_vendor))
  
  top_vendor_data <- filtered_cve_data %>%
    filter(Vendor == top_vendor)
  
  if (time_unit == "month") {
    top_vendor_data$TimePeriod <- format(top_vendor_data$Published_Date, "%Y-%m")
  } else if (time_unit == "week") {
    top_vendor_data$TimePeriod <- format(top_vendor_data$Published_Date, "%Y-%U")
  } else {
    stop("Invalid time_unit. Use 'month' or 'week'.")
  }
  
  time_series_data <- top_vendor_data %>%
    group_by(TimePeriod) %>%
    summarise(Vulnerability_Count = n()) %>%
    arrange(TimePeriod)
  
  if (time_unit == "month") {
    time_series_data$TimePeriod <- as.Date(paste0(time_series_data$TimePeriod, "-01"))
  } else if (time_unit == "week") {
    time_series_data$TimePeriod <- as.Date(strptime(time_series_data$TimePeriod, format="%Y-%U"))
  }
  
  ggplot(data = time_series_data, aes(x = TimePeriod, y = Vulnerability_Count)) +
    geom_line(color = "#2C3E50", size = 1.2) +
    geom_point(color = "#E74C3C", size = 3) +
    geom_text(aes(label = Vulnerability_Count), 
              vjust = -0.8, hjust = 0.5, size = 3, 
              color = "#34495E", fontface = "bold") +
    theme_dark(base_family = "Arial") +
    labs(title = paste("Vulnerability Trend for Top Vendor:", top_vendor),
         subtitle = paste("Date Range:", format(start_date, "%b %Y"), "to", format(end_date, "%b %Y")),
         x = "Time Period",
         y = "Number of Vulnerabilities") +
    scale_x_date(date_labels = "%b %Y", date_breaks = "1 month") +
    theme(
      plot.title = element_text(size = 14, face = "bold", color = "#2C3E50"),
      plot.subtitle = element_text(size = 10, color = "#7F8C8D"),
      axis.text.x = element_text(angle = 45, hjust = 1, color = "#2C3E50"),
      axis.text.y = element_text(color = "#2C3E50"),
      axis.title.x = element_text(size = 12, face = "bold"),
      axis.title.y = element_text(size = 12, face = "bold"),
      panel.grid.major = element_line(color = "#BDC3C7", size = 0.2),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "#ECF0F1", color = NA)
    )
  
    ggsave("charts/5_most_vulnerable_vendor_over_two_dates_time_series_chart.png", width = 10, height = 6)
    cat("Chart saved as 'charts/5_most_vulnerable_vendor_over_two_dates_time_series_chart.png'\n")
    
}

# csv_file_path <- "vulnerability_data.csv"
# start_date <- as.Date("2020-01-01")
# end_date <- as.Date("2020-12-31")

# most_vulnerable_vendor_over_two_dates_time_series_chart(csv_file_path, start_date, end_date, time_unit = "month")

