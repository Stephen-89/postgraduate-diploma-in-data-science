# Read CSV
job <- read.csv("Job_Proficiency.csv", header = T)

# Scatter Plot
plot(job$aptitude,job$job_prof,col="red")


# Correlation Coefficient in R
cor(job$aptitude,job$job_prof)

# Simple Linear Regression in R
model1 <- lm(job_prof ~ aptitude, data = job)
model1