library(dplyr)
library(ggplot2)
library(lubridate)

vulnerabilities_that_fall_into_v3_score_ranges <- function(csv_file_path) {

  cve_data <- read.csv(csv_file_path)

  print(summary(cve_data))

  cve_data$Base_Score <- as.numeric(cve_data$Base_Score)

  cve_data <- cve_data %>%
    mutate(Severity = case_when(
      Base_Score >= 0.1 & Base_Score <= 3.9 ~ "Low",
      Base_Score >= 4.0 & Base_Score <= 6.9 ~ "Medium",
      Base_Score >= 7.0 & Base_Score <= 8.9 ~ "High",
      Base_Score >= 9.0 & Base_Score <= 10.0 ~ "Critical",
      is.na(Base_Score) | Base_Score <= 0.0 ~ "None",
      TRUE ~ NA_character_
    ))

  print(head(cve_data))

  severity_counts <- cve_data %>%
    group_by(Severity) %>%
    summarise(Count = n()) %>%
    arrange(factor(Severity, levels = c("Low", "Medium", "High", "Critical", "None")))

  print(severity_counts)

  ggplot(severity_counts, aes(x = factor(Severity, levels = c("Low", "Medium", "High", "Critical", "None")),
                              y = Count, fill = Severity)) +
    geom_bar(stat = "identity", show.legend = TRUE) +
    geom_text(aes(label = Count), vjust = -0.3) +
    labs(title = "Vulnerabilities by Severity (CVSS v3)", x = "Severity", y = "Number of Vulnerabilities") +
    theme_minimal() +
    scale_fill_manual(values = c("None" = "grey", "Low" = "green", "Medium" = "yellow",
                                 "High" = "orange", "Critical" = "red"))

}

vulnerabilities_that_fall_into_v3_score_ranges("vulnerability_data.csv")
