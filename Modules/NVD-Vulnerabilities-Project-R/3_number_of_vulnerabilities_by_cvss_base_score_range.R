library(dplyr)
library(ggplot2)

csv_file_path <- "vulnerability_data.csv"

number_of_vulnerabilities_by_cvss_base_score_range_chart <- function(csv_file_path) {

  cve_data <- read.csv(csv_file_path)

  cve_data$Base_Score <- as.numeric(cve_data$Base_Score)

  cve_data <- cve_data %>%
    mutate(Score_Range = cut(Base_Score,
                             breaks = seq(0, 10, by = 0.5),
                             include.lowest = TRUE,
                             right = FALSE,
                             labels = paste0(seq(0, 9.5, by = 0.5), "-", seq(0.5, 10, by = 0.5))))

  score_counts <- cve_data %>%
    filter(!is.na(Score_Range)) %>%
    group_by(Score_Range) %>%
    summarise(Count = n(), .groups = 'drop')

  p <- ggplot(score_counts, aes(x = Score_Range, y = Count, fill = Score_Range)) +
    geom_bar(stat = "identity") +
    geom_text(aes(label = Count),
              position = position_stack(vjust = 0.5),
              color = "white",
              size = 4.5) +
    coord_flip() +
    labs(title = "Number of Vulnerabilities by CVSS Base Score Range",
         x = "CVSS Base Score Range",
         y = "Number of Vulnerabilities") +
    theme_dark() +
    theme(axis.text.y = element_text(size = 8),
          legend.position = "right",
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 8))

  print(p)

  ggsave("charts/3_number_of_vulnerabilities_by_cvss_base_score_range_chart.png", plot = p, width = 10, height = 6)
  cat("Chart saved as 'charts/3_number_of_vulnerabilities_by_cvss_base_score_range_chart.png'\n")

}

number_of_vulnerabilities_by_cvss_base_score_range_chart(csv_file_path)
