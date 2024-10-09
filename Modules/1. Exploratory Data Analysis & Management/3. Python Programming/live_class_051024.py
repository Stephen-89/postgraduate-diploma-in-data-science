import pandas as pd

# sal_data = pd.read_csv('sal_data.csv')
# bonus_data = pd.read_csv('bonus_data.csv')

# print(sal_data.head())
# print(bonus_data.head())

# datamerge=pd.merge(sal_data,bonus_data)
# print(datamerge)

# leftjoin=pd.merge(sal_data,bonus_data,how='left')
# print(leftjoin)

# rightjoin=pd.merge(sal_data,bonus_data,how='right')
# print(rightjoin)

# outerjoin=pd.merge(sal_data,bonus_data,how='outer')
# print(outerjoin)

Salary_1 = pd.read_csv('basic_salary - 1.csv')
Salary_2 = pd.read_csv('basic_salary - 2.csv')
frames=[Salary_1,Salary_2]
# appendsalary=pd.concat(frames)
appendsalary=pd.concat(frames)
#print(appendsalary)


test = pd.concat(([Salary_1, Salary_2]))
#print(test)

salary_data = pd.read_csv('basic_salary.csv')

A=salary_data.groupby('Location')['ms'].sum()
print(A)

B=salary_data.groupby(['Location', 'Grade'])['ms'].sum()
print(B)

C=salary_data.groupby(['Location', 'Grade'])['ms'].mean()
print(C)

D=salary_data.groupby(['Location', 'Grade'])['ms'].min()
print(D)

E=salary_data.groupby(['Location', 'Grade'])['ms'].max()
print(E)
