library(dplyr)
library(ggplot2)

# csv_file_path <- "vulnerability_data.csv"

number_of_vulnerabilities_by_cvss_base_score_range_chart <- function(csv_file_path) {
 
  cve_data <- read.csv(csv_file_path)
  
  cve_data$Base_Score <- as.numeric(cve_data$Base_Score)
  
  cve_data <- cve_data %>%
    mutate(Score_Range = cut(Base_Score, 
                             breaks = seq(0, 10, by = 1),
                             include.lowest = TRUE, 
                             right = FALSE,
                             labels = paste0(seq(0, 9, by = 1), "-", seq(1, 10, by = 1))))
  
  score_counts <- cve_data %>%
    filter(!is.na(Score_Range)) %>%
    group_by(Score_Range) %>%
    summarise(Count = n(), .groups = 'drop')
  
  print(score_counts)
  
  ggplot(score_counts, aes(x = Score_Range, y = Count, fill = Score_Range)) +
    geom_bar(stat = "identity") +
    geom_text(aes(label = Count), vjust = -0.5, size = 3) +
    labs(title = "Number of Vulnerabilities by CVSS Base Score Range",
         x = "CVSS Base Score Range",
         y = "Number of Vulnerabilities") +
    theme_dark() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave("charts/3_number_of_vulnerabilities_by_cvss_base_score_range_chart.png", width = 10, height = 6)
  cat("Chart saved as 'charts/3_number_of_vulnerabilities_by_cvss_base_score_range_chart.png'\n")
   
}
