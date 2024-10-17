library(jsonlite)

# Extract CVE names and CPEs, with additional checks for missing or invalid fields
extract_cve_cpe <- function(data) {

  results <- list()

  for (i in seq_along(data$CVE_Items)) {

    # Check if the item has the expected structure
    if (is.list(data$CVE_Items[[i]]) && !is.null(data$CVE_Items[[i]]$cve)) {

      # Extract the CVE ID (if available)
      cve_id <- data$CVE_Items[[i]]$cve$CVE_data_meta$ID

      print(cve_id)

      # Check if 'configurations' and 'cpe_match' are present
      if (!is.null(data$CVE_Items[[i]]$configurations) && !is.null(data$CVE_Items[[i]]$configurations$nodes)) {

        # Extract the CPE URIs
        cpe_nodes <- data$CVE_Items[[i]]$configurations$nodes

        # Extract all CPE URIs from the 'cpe_match' within the nodes
        cpe_uris <- unlist(lapply(cpe_nodes, function(node) {
          if (!is.null(node$cpe_match)) {
            sapply(node$cpe_match, function(cpe) cpe$cpe23Uri)
          } else {
            return(NULL)
          }
        }))

        # Store the result if we have both CVE ID and CPE URIs
        if (!is.null(cve_id) && length(cpe_uris) > 0) {
          results[[i]] <- list(CVE_ID = cve_id, CPE_URIs = cpe_uris)
        }

      }

    } else {
      # Handle cases where the 'cve' structure is missing
      warning(paste("Skipping entry", i, "- 'cve' field is missing or structure is invalid"))
    }

  }

  return(results)

}

cve_data <- fromJSON("nvdcve-1.1-2024.json", flatten = TRUE)

# Apply the function
cve_cpe_data <- extract_cve_cpe(cve_data)

print(cve_cpe_data)
