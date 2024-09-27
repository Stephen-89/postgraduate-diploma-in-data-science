source("base_score_by_vector.R")
library(rjson)

setwd("C:/Users/steph/OneDrive/Desktop/postgraduate-diploma-in-data-science/Modules/1. Exploratory Data Analysis & Management/2. R Programming/NVD-Vulnerabilities-Project-R")

all_cve_ids <- c()
all_nvd_links <- c()
all_vendors <- c()
all_products <- c()
all_descriptions <- c()
all_years <- c()
all_published_dates <- c()
all_vector_strings <- c()
all_base_scores <- c()
all_exploitability_scores <- c()
all_impact_scores <- c()

start_year <- 2002
current_year <- as.numeric(format(Sys.Date(), "%Y"))

for (year in start_year:current_year) {
  
  zip_url <- paste0("https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-", year, ".json.zip")
  zip_file_path <- paste0("nvdcve-1.1-", year, ".json.zip")
  
  tryCatch({
    
    download.file(zip_url, zip_file_path, mode = "wb")
    
    unzip(zip_file_path)
    
    json_file_name <- paste0("nvdcve-1.1-", year, ".json")
    json_file_path <- json_file_name
    
    json_data <- paste(readLines(json_file_path), collapse = "\n")
    
    parsed_json <- fromJSON(json_data)
    
    if (!is.null(parsed_json$CVE_Items) && length(parsed_json$CVE_Items) > 0) {
      
      for (item in parsed_json$CVE_Items) {
        
        cve_id <- item$cve$CVE_data_meta$ID
        
        description <- ifelse(!is.null(item$cve$description$description_data[[1]]$value),
                              item$cve$description$description_data[[1]]$value,
                              NA)
        
        published_date <- ifelse(!is.null(item$publishedDate),
                                 item$publishedDate,
                                 NA)
        
        vector_string <- ifelse(!is.null(item$impact$baseMetricV3$cvssV3$vectorString),
                                item$impact$baseMetricV3$cvssV3$vectorString,
                                NA)
        
        base_score <- ifelse(!is.null(item$impact$baseMetricV3$cvssV3$baseScore),
                             item$impact$baseMetricV3$cvssV3$baseScore,
                             NA)
        
        impact_score <- ifelse(!is.null(item$impact$baseMetricV3$impactScore),
                             item$impact$baseMetricV3$impactScore,
                             NA)
        
        exploitability_score <- ifelse(!is.null(item$impact$baseMetricV3$exploitabilityScore),
                             item$impact$baseMetricV3$exploitabilityScore,
                             NA)
        
        if (!is.null(item$configurations$nodes) && length(item$configurations$nodes) > 0) {
          for (node in item$configurations$nodes) {
            if (!is.null(node$cpe_match) && length(node$cpe_match) > 0) {
              for (cpe in node$cpe_match) {
                if (cpe$vulnerable) {
                  cpe_string <- cpe$cpe23Uri
                  parts <- unlist(strsplit(cpe_string, ":"))
                  vendor <- parts[4]
                  product <- parts[5]
                  break
                }
              }
            } else if (!is.null(node$children) && length(node$children) > 0) {
              first_child <- node$children[[1]]
              if (!is.null(first_child$cpe_match) && length(first_child$cpe_match) > 0) {
                for (cpe in first_child$cpe_match) {
                  if (cpe$vulnerable) {
                    cpe_string <- cpe$cpe23Uri
                    parts <- unlist(strsplit(cpe_string, ":"))
                    vendor <- parts[4]
                    product <- parts[5]
                    break
                  }
                }
              }
            }
          }
        } else {
          vendor <- NA
          product <- NA
        }
        
        all_cve_ids <- c(all_cve_ids, cve_id)
        all_nvd_links <- c(all_nvd_links, paste0("https://nvd.nist.gov/vuln/detail/", cve_id))
        all_vendors <- c(all_vendors, vendor)
        all_products <- c(all_products, product)
        all_descriptions <- c(all_descriptions, description)
        all_years <- c(all_years, year)
        all_published_dates <- c(all_published_dates, published_date)
        all_vector_strings <- c(all_vector_strings, vector_string)
        all_base_scores <- c(all_base_scores, base_score)
        all_impact_scores <- c(all_impact_scores, impact_score)
        all_exploitability_scores <- c(all_exploitability_scores, exploitability_score)
        
      }
      
    } else {
      cat("No CVE items found for the year", year, "\n")
    }
    
    file.remove(zip_file_path)
    file.remove(json_file_name)
    
  }, error = function(e) {
    cat("Error downloading or processing data for year", year, ":", conditionMessage(e), "\n")
  })
  
}

cve_data <- data.frame(
  Cve_Id = all_cve_ids,
  Link = all_nvd_links,
  Vendor = all_vendors,
  Product = all_products,
  Description = all_descriptions,
  Year = all_years,
  Published_Date = all_published_dates,
  Vector_String = all_vector_strings,
  Base_Score = all_base_scores,
  Impact_Score = all_impact_scores,
  Exploitability_Score = all_exploitability_scores,
  stringsAsFactors = FALSE
)

csv_file_path <- "vulnerability_data.csv"
write.csv(cve_data, file = csv_file_path, row.names = FALSE)

cat("Vulnerability data has been saved to", csv_file_path, "\n")