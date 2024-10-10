#' ---
#' title: "Assignment 2 Data Management"
#' author: "Stephen Hoey"
#' date: "Oct 10th, 2024"
#' ---

library(xlsx)

#-------------------------------------------------------#
#Q1 Import Premiums data and name it as Premium.
#-------------------------------------------------------#

Premium <- read.csv("Premiums.csv", header = T, stringsAsFactors=T)


#-------------------------------------------------------#
#Q2 Check number of rows, columns in the data.
#-------------------------------------------------------#

row_column <- dim(Premium)
num_rows <- row_column[1]
num_columns <- row_column[2]

print(num_rows)

print(num_columns)


#-------------------------------------------------------#
#Q3 Display first 10 rows and last 5 rows.
#-------------------------------------------------------#

head(Premium, 10)
tail(Premium, 5)


#-------------------------------------------------------#
#Q4 Describe (summarize) all variables.
#-------------------------------------------------------#

summary(Premium)


#-------------------------------------------------------#
#Q5 Display top 5 and bottom 5 policies in terms of premium amount.
#-------------------------------------------------------#

top_5_policies <- Premium[order(-Premium$Premium), ][1:5, ]
print(top_5_policies)

bottom_5_policies <- Premium[order(Premium$Premium), ][1:5, ]
print(bottom_5_policies)


#-------------------------------------------------------#
#Q6 Calculate the sum for variable ???Sum_Assured??? by ???Region??? variable.
#-------------------------------------------------------#

sum_for_sum_assured_by_regions <- aggregate(Sum_Assured ~ REGION, data = Premium, FUN = sum)
print(sum_for_sum_assured_by_regions)


#-------------------------------------------------------#
#Q7 Create a subset of policies of Asia Standard Plan with Sum_Assured < = 50,000. Keep variables Policy_No, Zone_name, Plan and Sum_Assured in the subset data.
#-------------------------------------------------------#

premium_subset_asia_standard <- subset(Premium,Plan == "Asia Standard Plan" & Sum_Assured <= 50000, select=c(POLICY_NO, ZONE_NAME, Plan, Sum_Assured))
print(premium_subset_asia_standard)


#-------------------------------------------------------#
#Q8 Export the subsetted data into an xlsx file.
#-------------------------------------------------------#

write.xlsx(premium_subset_asia_standard, "premium_subset_asia_standard.xlsx")