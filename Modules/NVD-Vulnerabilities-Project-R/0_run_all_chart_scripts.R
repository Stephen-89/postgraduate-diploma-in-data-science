source("1_top_20_vendors_most_vulnerabilities.R")
source("2_top_5_vendors_by_number_of_vulnerabilities_published_per_months.R")
source("3_number_of_vulnerabilities_by_cvss_base_score_range.R")
source("4_number_of_vulnerabilities_published_between_months.R")
source("5_most_vulnerable_vendor_over_two_dates_time_series.R")
source("6_vulnerabilities_based_on_vendor.R")
source("7_vulnerabilities_based_on_vendor_severity.R")
source("8_trend_mean_and_median_cvss_base_scores_over_time.R")
source("9_mean_vendor_score_over_time_top_5.R")
source("10_mean_vendor_provided_score_over_time.R")

setwd("C:/Users/steph/OneDrive/Desktop/postgraduate-diploma-in-data-science/Modules/1. Exploratory Data Analysis & Management/2. R Programming/NVD-Vulnerabilities-Project-R")

csv_file_path <- "vulnerability_data.csv"
start_date <- as.Date("2023-01-01")
end_date <- as.Date("2023-12-31")
vendor_name <- "apache"
time_interval <- "year"

# 1
top_20_vendors_with_most_vulnerabilities_chart(csv_file_path)

# 2
top_5_vendors_by_number_of_vulnerabilities_published_per_months_chart(csv_file_path, start_date, end_date)

# 3
number_of_vulnerabilities_by_cvss_base_score_range_chart(csv_file_path)

# 4
number_of_vulnerabilities_published_between_months_chart(csv_file_path, start_date, end_date)

# 5
most_vulnerable_vendor_over_two_dates_time_series_chart(csv_file_path, start_date, end_date, time_unit = "month")

# 6
vulnerabilities_based_on_vendor_chart(csv_file_path, vendor_name, start_date, end_date)

# 7
vulnerabilities_based_on_vendor_severity_chart(csv_file_path, vendor_name, start_date, end_date)

# 8
trend_mean_and_median_cvss_base_scores_over_time_line_plot(csv_file_path, time_interval)

# 9
mean_vendor_score_over_time_top_5_line_plot(csv_file_path, time_interval, top_n_vendors = 5)

# 10
mean_vendor_provided_score_over_time_line_plot(csv_file_path, vendor_name, time_interval)
