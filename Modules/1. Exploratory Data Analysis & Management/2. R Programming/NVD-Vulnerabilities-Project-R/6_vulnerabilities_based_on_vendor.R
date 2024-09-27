library(dplyr)
library(ggplot2)

vulnerabilities_based_on_vendor_chart <- function(csv_file_path, vendor_name, start_date, end_date) {
  
  cve_data <- read.csv(csv_file_path, stringsAsFactors = FALSE)
  
  cve_data$Published_Date <- as.Date(cve_data$Published_Date, format = "%Y-%m-%d")
  cve_data$Base_Score <- as.numeric(cve_data$Base_Score)
  
  filtered_data <- cve_data %>%
    filter(Published_Date >= start_date & Published_Date <= end_date, 
           Vendor == vendor_name,
           !is.na(Vendor) & !is.na(Product))
  
  if(nrow(filtered_data) == 0) {
    stop("No data found for the specified vendor and date range.")
  }
  
  product_counts <- filtered_data %>%
    group_by(Product) %>%
    summarise(Vulnerability_Count = n(), .groups = 'drop') %>%
    arrange(desc(Vulnerability_Count))
  
  ggplot(product_counts, aes(x = reorder(Product, Vulnerability_Count), 
                             y = Vulnerability_Count, fill = Product)) +
    geom_bar(stat = "identity", show.legend = FALSE) +
    geom_text(aes(label = Vulnerability_Count), 
              position = position_stack(vjust = 0.5),
              color = "white",
              size = 4.5) +
    coord_flip() +
    labs(title = paste("Vulnerabilities for Vendor:", vendor_name, "between", start_date, "and", end_date),
         x = "Product",
         y = "Number of Vulnerabilities") +
    theme_dark() +
    theme(
      axis.text.y = element_text(size = 8),
      plot.title = element_text(size = 14, face = "bold"),
      axis.title.x = element_text(size = 12, face = "bold"),
      axis.title.y = element_text(size = 12, face = "bold")
    )
  
  ggsave("charts/6_vulnerabilities_based_on_vendor_chart.png", width = 10, height = 6)
  cat("Chart saved as 'charts/6_vulnerabilities_based_on_vendor_chart.png'\n")
  
}

csv_file_path <- "vulnerability_data.csv"
vendor_name <- "freebsd"
start_date <- as.Date("1999-01-01")
end_date <- as.Date("2024-09-27")

vulnerabilities_based_on_vendor_chart(csv_file_path, vendor_name, start_date, end_date)