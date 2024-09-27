# Install necessary packages if you haven't already
# install.packages("rjson")

# Load the required libraries
library(rjson)

# Step 1: Download the ZIP file
zip_url <- "https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-2024.json.zip"
zip_file_path <- "nvdcve-1.1-2024.json.zip"
download.file(zip_url, zip_file_path, mode = "wb")

# Step 2: Unzip the downloaded file
unzip(zip_file_path)

# The JSON file name (you may want to check the actual file name after unzipping)
json_file_name <- "nvdcve-1.1-2024.json"  # Change this if the file name is different
json_file_path <- json_file_name

# Step 3: Read the JSON data from the file
json_data <- paste(readLines(json_file_path), collapse = "\n")

# Parse the JSON data
parsed_json <- fromJSON(json_data)

# Step 4: Extract required information
# Initialize vectors to store extracted information
cve_ids <- c()
descriptions <- c()
vector_strings <- c()
base_scores <- c()

# Loop through each CVE item
if (!is.null(parsed_json$CVE_Items) && length(parsed_json$CVE_Items) > 0) {
  for (item in parsed_json$CVE_Items) {
    # Extract the required information for each item
    cve_id <- item$cve$CVE_data_meta$ID
    
    # Handle missing description
    if (!is.null(item$cve$description$description_data[[1]]$value)) {
      description <- item$cve$description$description_data[[1]]$value
    } else {
      description <- NA  # Use NA for missing descriptions
    }
    
    # Handle missing vector string and base score
    if (!is.null(item$impact$baseMetricV3$cvssV3$vectorString)) {
      vector_string <- item$impact$baseMetricV3$cvssV3$vectorString
    } else {
      vector_string <- NA  # Use NA for missing vector strings
    }
    
    if (!is.null(item$impact$baseMetricV3$cvssV3$baseScore)) {
      base_score <- item$impact$baseMetricV3$cvssV3$baseScore
    } else {
      base_score <- NA  # Use NA for missing base scores
    }
    
    # Append extracted information to vectors
    cve_ids <- c(cve_ids, cve_id)
    descriptions <- c(descriptions, description)
    vector_strings <- c(vector_strings, vector_string)
    base_scores <- c(base_scores, base_score)
  }
} else {
  cat("No CVE items found.\n")
}

# Check lengths of extracted vectors
cat("Lengths of extracted vectors:\n")
cat("CVE IDs:", length(cve_ids), "\n")
cat("Descriptions:", length(descriptions), "\n")
cat("Vector Strings:", length(vector_strings), "\n")
cat("Base Scores:", length(base_scores), "\n")

# Step 5: Create a data frame from the extracted information
cve_data <- data.frame(
  CVE_ID = cve_ids,
  Description = descriptions,
  Vector_String = vector_strings,
  Base_Score = base_scores,
  stringsAsFactors = FALSE
)

# Step 6: Write the data frame to a CSV file
csv_file_path <- "cve_data_2024.csv"
write.csv(cve_data, file = csv_file_path, row.names = FALSE)

# Print confirmation
cat("CVE data has been saved to", csv_file_path, "\n")

# Clean up: remove the downloaded zip file and unzipped JSON file
file.remove(zip_file_path)
file.remove(json_file_name)