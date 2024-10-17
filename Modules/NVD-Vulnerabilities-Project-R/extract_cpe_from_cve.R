# Load necessary libraries
library(jsonlite)
library(dplyr)

# Load the CVE JSON data (replace with your actual file path)
cve_data <- fromJSON("nvdcve-1.1-2024.json", flatten = TRUE)

# Inspect the structure of the loaded data
str(cve_data)

# Check if CVE_Items exists and is a list
if ("CVE_Items" %in% names(cve_data) && is.list(cve_data$CVE_Items)) {
  # Loop through each CVE item to extract CVE ID and CPEs
  for (item in cve_data$CVE_Items) {
    # Check if 'cve' field exists
    if ("cve" %in% names(item)) {
      # Check if 'CVE_data_meta' exists
      if ("CVE_data_meta" %in% names(item$cve)) {
        cve_id <- item$cve$CVE_data_meta$ID  # Extract CVE ID
        print(paste("CVE ID:", cve_id))  # Print the CVE ID

        # Initialize a vector to store CPEs for this CVE
        cpe_entries <- c()

        # Check if configurations exist and is a list
        if (!is.null(item$configurations) && is.list(item$configurations)) {
          nodes <- item$configurations$nodes

          # Check if nodes exist and is a list
          if (!is.null(nodes) && is.list(nodes)) {
            # Debug: print the nodes structure
            print(str(nodes))

            # Extract CPEs using a modified approach
            cpe_entries <- extract_cpe(nodes)
          } else {
            print("No nodes found or nodes is not a list.")
          }
        } else {
          print("Configurations are missing or not a list.")
        }
      } else {
        print("CVE_data_meta is missing in the cve structure.")
      }
    } else {
      print("CVE structure is not as expected. 'cve' field is missing.")
    }
  }
} else {
  print("CVE_Items is missing or not a list.")
}
