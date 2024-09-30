library(dplyr)
library(ggplot2)

csv_file_path <- "vulnerability_data.csv"

top_20_vendors_with_most_vulnerabilities_chart <- function(csv_file_path) {

  cve_data <- read.csv(csv_file_path)

  cve_data$Base_Score <- as.numeric(cve_data$Base_Score)

  filtered_data <- cve_data %>%
    filter(!is.na(Base_Score), !is.na(Vendor), !is.na(Product))

  top_vendors_products <- filtered_data %>%
    group_by(Vendor) %>%
    summarise(Vulnerability_Count = n(), .groups = 'drop') %>%
    arrange(desc(Vulnerability_Count)) %>%
    head(20)

  # Create a bubble chart
  p <- ggplot(top_vendors_products, aes(x = reorder(Vendor, Vulnerability_Count),
                                        y = Vulnerability_Count,
                                        size = Vulnerability_Count,
                                        fill = Vendor)) +
    geom_point(shape = 21, alpha = 0.7) +
    scale_size(range = c(2, 10)) +
    coord_flip() +
    labs(title = "Top 20 Vendors with Most Vulnerabilities",
         x = "Vendor",
         y = "Number of Vulnerabilities") +
    theme_dark() +
    theme(axis.text.y = element_text(size = 8),
          legend.position = "right",
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 8))

  print(p)

  ggsave("charts/1_top_20_vendors_with_most_vulnerabilities_chart.png", plot = p, width = 10, height = 6)
  cat("Chart saved as 'charts/1_top_20_vendors_with_most_vulnerabilities_chart.png'\n")

}

top_20_vendors_with_most_vulnerabilities_chart(csv_file_path)
