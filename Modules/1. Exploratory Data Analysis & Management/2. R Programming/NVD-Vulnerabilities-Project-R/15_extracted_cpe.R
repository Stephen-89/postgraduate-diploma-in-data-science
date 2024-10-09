library(jsonlite)

json_data <- fromJSON("nvdcve-1.1-2024.json")
cve_id <- "CVE-2024-0056"

results <- list()

for (item in json_data$CVE_Items) {

  print(json_data$CVE_Items)
  # print(item$CVE_data_meta$ID)

  if (item$CVE_data_meta$ID == cve_id) {

    print(item$CVE_data_meta$ID)

    configurations <- item$configurations

    print(item)

    results$cpe_matches <- list()
    results$children <- list()

    if (!is.null(configurations)) {

      for (node in configurations) {
        print(node)
        if (!is.null(node$cpe_match)) {
          results$cpe_matches <- c(results$cpe_matches, node$cpe_match)
        }
        if (!is.null(node$children)) {
          results$children <- c(results$children, node$children)
        }
      }

    }

    break
  }
}

print(results)
