library(dplyr)
library(ggplot2)

number_of_vulnerabilities_published_between_months_chart <- function(csv_file_path, start_date, end_date) {

  cve_data <- read.csv(csv_file_path, stringsAsFactors = FALSE)

  cve_data$Published_Date <- as.Date(cve_data$Published_Date, format = "%Y-%m-%d")

  filtered_cve_data <- cve_data %>%
    filter(Published_Date >= start_date & Published_Date <= end_date)

  filtered_cve_data$YearMonth <- format(filtered_cve_data$Published_Date, "%Y-%m")

  monthly_counts <- filtered_cve_data %>%
    group_by(YearMonth) %>%
    summarise(Vulnerability_Count = n()) %>%
    arrange(YearMonth)

  title <- paste("Number of Vulnerabilities Published between Months:", start_date, "-", end_date)

  # Plot the data
  p <- ggplot(monthly_counts, aes(x = YearMonth, y = Vulnerability_Count, fill = YearMonth)) +
    geom_bar(stat = "identity") +
    geom_text(aes(label = Vulnerability_Count),
              position = position_stack(vjust = 0.5),
              color = "white",
              size = 4.5) +
    coord_flip() +
    labs(title = title,
         x = "Month",
         y = "Number of Vulnerabilities") +
    theme_dark() +
    theme(axis.text.y = element_text(size = 8),
          legend.position = "right",
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 8))

  print(p)

  ggsave("charts/4_number_of_vulnerabilities_published_between_months_chart.png", width = 10, height = 6)
  cat("Chart saved as 'charts/4_number_of_vulnerabilities_published_between_months_chart.png'\n")

}

csv_file_path <- "vulnerability_data.csv"
start_date <- as.Date("2020-01-01")
end_date <- as.Date("2020-12-31")

number_of_vulnerabilities_published_between_months_chart(csv_file_path, start_date, end_date)

