source("4_nvd_processing_loop_calc_score_from_vector.R")
library(rjson)

setwd("C:/Users/steph/OneDrive/Desktop/postgraduate-diploma-in-data-science/Modules/1. Exploratory Data Analysis & Management/2. R Programming")

# Initialize vectors to store combined extracted information
all_cve_ids <- c()
all_descriptions <- c()
all_vector_strings <- c()
all_base_scores <- c()

# Define the starting year and the current year
start_year <- 2024
current_year <- as.numeric(format(Sys.Date(), "%Y"))

# Loop through each year from the start year to the current year
for (year in start_year:current_year) {
  
  # Construct the URL for the CVE JSON file for the given year
  zip_url <- paste0("https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-", year, ".json.zip")
  
  # Define paths for downloading and unzipping
  zip_file_path <- paste0("nvdcve-1.1-", year, ".json.zip")
  
  # Step 1: Download the ZIP file
  tryCatch({
    
    download.file(zip_url, zip_file_path, mode = "wb")
    
    # Step 2: Unzip the downloaded file
    unzip(zip_file_path)
    
    # The JSON file name (you may want to check the actual file name after unzipping)
    json_file_name <- paste0("nvdcve-1.1-", year, ".json")  # Change this if the file name is different
    json_file_path <- json_file_name
    
    # Step 3: Read the JSON data from the file
    json_data <- paste(readLines(json_file_path), collapse = "\n")
    
    # Parse the JSON data
    parsed_json <- fromJSON(json_data)
    
    # Step 4: Extract required information for the current year
    if (!is.null(parsed_json$CVE_Items) && length(parsed_json$CVE_Items) > 0) {
      
      for (item in parsed_json$CVE_Items) {
        # Extract the required information for each item
        cve_id <- item$cve$CVE_data_meta$ID
        
        # Handle missing description
        description <- ifelse(!is.null(item$cve$description$description_data[[1]]$value),
                              item$cve$description$description_data[[1]]$value,
                              NA)
        
        # Handle missing vector string and base score
        vector_string <- ifelse(!is.null(item$impact$baseMetricV3$cvssV3$vectorString),
                                item$impact$baseMetricV3$cvssV3$vectorString,
                                NA)
        
        base_score <- ifelse(!is.null(item$impact$baseMetricV3$cvssV3$baseScore),
                             item$impact$baseMetricV3$cvssV3$baseScore,
                             NA)
        
        # Append extracted information to combined vectors
        all_cve_ids <- c(all_cve_ids, cve_id)
        all_descriptions <- c(all_descriptions, description)
        all_vector_strings <- c(all_vector_strings, vector_string)
        all_base_scores <- c(all_base_scores, base_score)
      }
      
    } else {
      cat("No CVE items found for the year", year, "\n")
    }
    
    # Clean up: remove the downloaded zip file and unzipped JSON file
    file.remove(zip_file_path)
    file.remove(json_file_name)
    
  }, error = function(e) {
    cat("Error downloading or processing data for year", year, ":", conditionMessage(e), "\n")
  })
  
}

# Step 5: Create a data frame from the combined extracted information
cve_data <- data.frame(
  CVE_ID = all_cve_ids,
  Description = all_descriptions,
  Vector_String = all_vector_strings,
  Base_Score = all_base_scores,
  stringsAsFactors = FALSE
)

for (i in 1:nrow(cve_data)) {
  
  cve_id <- cve_data$CVE_ID[i]
  description <- cve_data$Description[i]
  vector_string <- cve_data$Vector_String[i]
  base_score <- cve_data$Base_Score[i]
  
  # Print debugging info
  print(paste("Processing CVE:", cve_id))
  print(paste("Vector String:", vector_string))
  
  # Call the base score calculation
  base_score_value <- tryCatch({
    cvss_v3_base_score(vector_string)
  }, error = function(e) {
    print(paste("Error processing vector:", vector_string, "Error:", e$message))
    return(NA)  # Return NA in case of error
  })
  
  print(paste("Calculated Base Score Value:", base_score_value))
  cat("\n") # For spacing between iterations
  
}

# Step 6: Write the data frame to a CSV file
csv_file_path <- "cve_data_year_2024.csv"
write.csv(cve_data, file = csv_file_path, row.names = FALSE)

# Print confirmation
cat("CVE data from year 2024 has been saved to", csv_file_path, "\n")