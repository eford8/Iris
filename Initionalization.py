import csv
import pandas as pd
from sklearn.ensemble import RandomForestClassifier

print("Hello Iris")

fileName = "iris_csv.csv"

df = pd.read_csv(fileName)

print(df)

list_of_column_names = list(df.columns)

print('List of column names : ',list_of_column_names)