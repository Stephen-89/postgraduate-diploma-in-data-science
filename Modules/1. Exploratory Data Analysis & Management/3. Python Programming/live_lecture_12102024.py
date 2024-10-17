import numpy as np
import pandas as pd  # Don't forget to import pandas
import scipy.stats as stats
import seaborn as sns
import matplotlib.pyplot as plt
from pathlib import Path
from matplotlib.pyplot import margins, axes

data = pd.read_csv('Bank Churn.csv')

print(data.head())

plt.figure(figsize=(8,5))

data_exited_1 = data[data["Exited"] == 1]
data_exited_0 = data[data["Exited"] == 0]

plt.subplot(1,2,1)
sns.boxplot(x="Exited",y="CreditScore",data=data_exited_1)
plt.title("CreditScore Distribution for Exited=1")

plt.subplot(1,2,2)
sns.boxplot(x="Exited",y="CreditScore",data=data_exited_0)
plt.title("CreditScore Distribution for Exited=0")

plt.tight_layout()
plt.show()

stats.skew(data_exited_1["CreditScore"])
stats.skew(data_exited_0["CreditScore"])

cross_table = pd.crosstab(data['Geography'], data['Exited'], margins=True, margins_name='Total')

cross_table_proportions = cross_table.div(cross_table['Total'], axis=0) * 100

cross_table = cross_table.rename(columns={0: 'Not Exited', 1: 'Exited'})
cross_table_proportions = cross_table_proportions.rename(columns={0: 'Not Exited (%)', 1: 'Exited (%)'})

print("Cross Table (Counts):\n")
print(cross_table)

print("\nCross Table (Proportions):\n")
print(cross_table_proportions.round(2))

correlation_coefficient = data['CreditScore'].corr(data['EstimatedSalary'])
correlation_coefficient.round(4)

data['CreditScore_Cat'] = np.where(data['CreditScore']>=650,1,0)
data.head()


