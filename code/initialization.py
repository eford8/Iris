import csv
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_validate  #defaults to 5-fold CV
from sklearn.model_selection import train_test_split 

#Read in the Date from the csv file using Pandas 
print("Hello Iris")
fileName = "DATA/iris.csv"
df = pd.read_csv(fileName)
list_of_column_names = list(df.columns)
print('List of column names : ',list_of_column_names)
print(df)

#Modify the script so that it only includes flowers from the versicolor and virginica (and the header line). 
#For simplicity, we will ignore the setosa species for now.

newdf = df[(df["class"] != "Iris-setosa")]
print(newdf.head())
print("The number of lines that are not Iris-setosa: " + str(len(newdf)))

#if versicolor, class == 1
#if not versicolor (then it would be virginica), class == 0
lables = []
for type in newdf["class"]:
    if  type == "Iris-versicolor":
        lables.append(1)
    else:
        lables.append(0)

newdf["lables"] = lables


new_list_of_column_names = list(newdf.columns)
print(new_list_of_column_names)
#sepallength, sepalwidth, petallength, petalwidth, class, lables 

#Create a modified csv file for the modified data
newdf.to_csv("DATA/irisModified.csv", index = False)
modifiedDate = "DATA/irisModified.csv"