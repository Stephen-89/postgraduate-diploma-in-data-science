library(dplyr)
library(ggplot2)

top_5_vendors_by_number_of_vulnerabilities_published_per_months_chart <- function(csv_file_path, start_date, end_date) {
  
  cve_data <- read.csv(csv_file_path, stringsAsFactors = FALSE)
  
  cve_data$Published_Date <- as.Date(cve_data$Published_Date, format = "%Y-%m-%d")
  
  filtered_cve_data <- cve_data %>%
    filter(Published_Date >= start_date & Published_Date <= end_date) %>%
    filter(!is.na(Vendor) & !is.na(Product))
  
  filtered_cve_data$YearMonth <- format(filtered_cve_data$Published_Date, "%Y-%m")
  
  monthly_counts <- filtered_cve_data %>%
    group_by(YearMonth, Vendor, Product) %>%
    summarise(Vulnerability_Count = n(), .groups = 'drop') %>%
    arrange(YearMonth, desc(Vulnerability_Count))
  
  top_vendors <- monthly_counts %>%
    group_by(YearMonth) %>%
    top_n(5, Vulnerability_Count) %>%
    ungroup()
  
  print(top_vendors)
  
  title <- paste("Top 5 Vendors by Number of Vulnerabilities Published per Month:", start_date, "-", end_date)
  
  ggplot(data = top_vendors, aes(x = YearMonth, y = Vulnerability_Count, fill = Vendor)) +
    geom_bar(stat = "identity", position = "dodge") +
    geom_text(aes(label = Vulnerability_Count), vjust = -0.3, size = 3, position = position_dodge(0.9)) +
    theme_dark() +
    labs(title = title,
         x = "Month",
         y = "Number of Vulnerabilities") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave("charts/2_top_5_vendors_by_number_of_vulnerabilities_published_per_months_chart.png", width = 10, height = 6)
  cat("Chart saved as 'charts/2_top_5_vendors_by_number_of_vulnerabilities_published_per_months_chart.png'\n")
  
}

# csv_file_path <- "vulnerability_data.csv"
# start_date <- as.Date("2020-01-01")
# end_date <- as.Date("2020-12-31")

# top_5_vendors_by_number_of_vulnerabilities_published_per_months_chart(csv_file_path, start_date, end_date)