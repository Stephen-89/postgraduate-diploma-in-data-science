import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv('Bank Churn.csv')

salary_by_gender = data.groupby('Gender')['EstimatedSalary'].sum().reset_index()

plt.figure(figsize=(8, 6))
plt.bar(salary_by_gender['Gender'], salary_by_gender['EstimatedSalary'], color=['blue', 'pink'])

plt.title('Total Estimated Salary by Gender')
plt.xlabel('Gender')
plt.ylabel('Total Estimated Salary')
plt.xticks(rotation=0)

# Adding values on the bars
for index, value in enumerate(salary_by_gender['EstimatedSalary']):
    plt.text(index, value, f'{value:,.0f}', ha='center', va='bottom', fontsize=10)

plt.tight_layout()

plt.show()