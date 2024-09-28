library(dplyr)
library(ggplot2)

vulnerabilities_based_on_vendor_severity_chart <- function(csv_file_path, vendor_name, start_date, end_date) {

  cve_data <- read.csv(csv_file_path, stringsAsFactors = FALSE)

  cve_data$Published_Date <- as.Date(cve_data$Published_Date, format = "%Y-%m-%d")
  cve_data$Base_Score <- as.numeric(cve_data$Base_Score)

  filtered_data <- cve_data %>%
    filter(Published_Date >= start_date & Published_Date <= end_date,
           Vendor == vendor_name,
           !is.na(Vendor) & !is.na(Product) & !is.na(Base_Score))

  if(nrow(filtered_data) == 0) {
    stop("No data found for the specified vendor and date range.")
  }

  product_stats <- filtered_data %>%
    group_by(Product) %>%
    summarise(
      Vulnerability_Count = n(),
      Average_Severity = round(mean(Base_Score), 2),
      .groups = 'drop'
    ) %>%
    arrange(desc(Vulnerability_Count))

  ggplot(product_stats, aes(x = reorder(Product, Vulnerability_Count),
                            y = Vulnerability_Count, fill = Product)) +
    geom_bar(stat = "identity", show.legend = FALSE) +
    geom_text(aes(label = paste(Vulnerability_Count,
                                "\nAvg Base Score:",
                                Average_Severity)),
              position = position_stack(vjust = 0.5),
              color = "white",
              size = 4) +
    coord_flip() +
    labs(title = paste("Vulnerabilities for Vendor:", vendor_name, "between", start_date, "and", end_date),
         subtitle = "Count of vulnerabilities and average severity score",
         x = "Product",
         y = "Number of Vulnerabilities") +
    theme_minimal() +
    theme(
      axis.text.y = element_text(size = 8),
      plot.title = element_text(size = 14, face = "bold"),
      axis.title.x = element_text(size = 12, face = "bold"),
      axis.title.y = element_text(size = 12, face = "bold")
    )

  ggsave("charts/7_vulnerabilities_based_on_vendor_severity_chart.png", width = 10, height = 6)
  cat("Chart saved as 'charts/7_vulnerabilities_based_on_vendor_severity_chart.png'\n")

}

csv_file_path <- "vulnerability_data.csv"
vendor_name <- "freebsd"
start_date <- as.Date("2020-01-01")
end_date <- as.Date("2020-12-31")

# vulnerabilities_based_on_vendor_severity_chart(csv_file_path, vendor_name, start_date, end_date)
