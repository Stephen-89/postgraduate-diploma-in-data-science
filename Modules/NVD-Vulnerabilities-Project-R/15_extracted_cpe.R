library(jsonlite)

json_data <- readLines("nvdcve-1.1-2024-1-vulnerability.json", warn = FALSE)
parsed_json <- fromJSON(paste(json_data, collapse = ""))

cve_cpe_relationship <- list()

extract_cpe <- function(nodes) {
  print(nodes)
  cpe_list <- list()
  for (node in nodes) {
    if (!is.null(node$cpe_match)) {
      for (cpe in node$cpe_match) {
        cpe_list <- c(cpe_list, cpe$cpe23Uri)
      }
    }
    if (!is.null(node$children)) {
      cpe_list <- c(cpe_list, extract_cpe(node$children))
    }
  }
  return(cpe_list)
}


for (vulnerability in parsed_json$CVE_Items) {
  
  cve_id <- vulnerability$CVE_data_meta$ID
  
  
  if (!is.null(vulnerability$nodes)) {
    
    cpe_list <- extract_cpe(vulnerability$nodes)
    cve_cpe_relationship[[cve_id]] <- if (length(cpe_list) > 0) cpe_list else NA
    
    print(cve_id)
    print(cpe_list)
    
  }
  
}

print(cve_cpe_relationship)

cve_cpe_df <- do.call(rbind, lapply(names(cve_cpe_relationship), function(cve_id) {
  cpes <- unlist(cve_cpe_relationship[[cve_id]])
  if (length(cpes) > 0) {
    data.frame(CVE_ID = cve_id, CPE_URI = cpes, stringsAsFactors = FALSE)
  } else {
    data.frame(CVE_ID = cve_id, CPE_URI = NA, stringsAsFactors = FALSE)
  }
}))

write.csv(cve_cpe_df, "cve_cpe_relationship.csv", row.names = FALSE)

print("Exported CVE to CPE relationship to cve_cpe_relationship.csv")