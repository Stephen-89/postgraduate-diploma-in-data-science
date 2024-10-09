#Q1 Create a matrix with three rows A, B and C and four columns with names Q, W, E and R. Fill the matrix with any numbers between 1 and 10.

q1_matrix<-matrix(c(6,1,5,9,2,6,2,3,7,4,8,5),nrow=3,ncol=4)
rownames(q1_matrix)<-c("A","B","C")
colnames(q1_matrix)<-c("Q","W","E","R")
print(q1_matrix)

#Q2 x = 24, y =”Hello World”, z = 93.65. Identify the class of x, y and z and convert all three into factor.

x<-24
y<-"Hello World"
z<-93.65

class_x<-class(x)
class_y<-class(y)
class_z<-class(z)

factor_x<-factor(x)
factor_y<-factor(y)
factor_z<-factor(z)

#Q3 q = 65.9836
  # a. Find square root of q and round it up to 3 digits.
  # b. Check if log to the base 10 of q is less than 2.

q=65.9836

a_square_root_q<-round(sqrt(q),3)
b_log10_less_than_2<-log10(q)<2

#Q4 x = c(“Intelligence”, “Knowledge”, “Wisdom”, “Comprehension”), y = “I am”, z = “intelligent”
  # a. Find first 4 letters of each word in x.
  # b. Combine y and z to form a sentence “I am intelligent”
  # c. Convert all the words in x to upper case.

x=c("Intelligence", "Knowledge", "Wisdom", "Comprehension")  
y="I am" 
z="intelligent"

a_first_4_letters_in_x<-substr(x, 1, 4)
b_combine_y_and_z<-paste(y,z)
c_toupper_x<-toupper(x)

#Q5