#-------------------------------------------------------#
#Q1 Create a matrix with three rows A, B and C and four columns with names Q, W, E and R. Fill the matrix with any numbers between 1 and 10.
#-------------------------------------------------------#

q1_matrix <- matrix(c(6,1,5,9,2,6,2,3,7,4,8,5),nrow=3,ncol=4)
rownames(q1_matrix) <- c("A","B","C")
colnames(q1_matrix) <- c("Q","W","E","R")
print(q1_matrix)


#-------------------------------------------------------#
#Q2 x = 24, y =”Hello World”, z = 93.65. Identify the class of x, y and z and convert all three into factor.
#-------------------------------------------------------#

x <- 24
y <- "Hello World"
z <- 93.65

class_x <- class(x)
class_y <- class(y)
class_z <- class(z)

factor_x <- factor(x)
factor_y <- factor(y)
factor_z <- factor(z)


#-------------------------------------------------------#
#Q3 q = 65.9836
  # a. Find square root of q and round it up to 3 digits.
  # b. Check if log to the base 10 of q is less than 2.
#-------------------------------------------------------#

q = 65.9836

q3_a_square_root_q <- round(sqrt(q),3)
q3_b_log10_less_than_2 <- log10(q)<2


#-------------------------------------------------------#
#Q4 x = c(“Intelligence”, “Knowledge”, “Wisdom”, “Comprehension”), y = “I am”, z = “intelligent”
  # a. Find first 4 letters of each word in x.
  # b. Combine y and z to form a sentence “I am intelligent”
  # c. Convert all the words in x to upper case.
#-------------------------------------------------------#

x = c("Intelligence", "Knowledge", "Wisdom", "Comprehension")
y = "I am"
z = "intelligent"

q4_a_first_4_letters_in_x <- substr(x, 1, 4)
q4_b_combine_y_and_z <- paste(y,z)
q4_c_toupper_x <- toupper(x)


#-------------------------------------------------------#
#Q5 a = c(3,4,14,17,3,98,66,85,44) Print “Yes” if the numbers in ‘a’ are divisible by 3 and “No” if they are not divisible by 3 using ifelse().
#-------------------------------------------------------#

a = c(3,4,14,17,3,98,66,85,44)
divisible_by_3 <- ifelse(a %% 3 == 0,"Yes","No")
print(divisible_by_3)


#-------------------------------------------------------#
#Q6 b = c(36,3,5,19,2,16,18,41,35,28,30,31) List all the numbers less than 30 in b using for loop.
#-------------------------------------------------------#

b = c(36,3,5,19,2,16,18,41,35,28,30,31)
for (i in b) {
  if (i < 30) {
    print(i)
  }
}


#-------------------------------------------------------#
# Q7 Date = “01/30/18”
  # a. Convert Date into standard date format (yyyy-mm-dd) and name it as Date_new.
  # b. Extract day of week and month from Date_new.
  # C. Find the difference in the current system date and Date_new.
#-------------------------------------------------------#

Date = "01/30/18"

#Q7 a
Date_new <- as.Date(Date, format = "%m/%d/%y")

#Q7 b
day_of_week <- format(Date_new, "%d")
month <- format(Date_new, "%m")

#Q7 c
todays_date <- Sys.Date()
difference_in_days <- todays_date - Date_new
print(difference_in_days)
