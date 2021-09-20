import csv
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_validate  #defaults to 5-fold CV
from sklearn.model_selection import train_test_split 

#Read in the Date from the csv file using Pandas 
print("Hello Iris")
fileName = "DATA/iris_csv.csv"
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


#use scikit-learn to perform classification using the Random Forests classifier.
clf = RandomForestClassifier(random_state=0)

#First we need to spilt the date into training and testing sets

#X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=0)

#Then we need to use 5 fold-cross validation


#X = [[ 1,  2,  3],  # 2 samples, 3 features  #The size of X is typically (n_samples, n_features), which means that samples are represented as rows and features are represented as columns.
#      [11, 12, 13]]
# y = [0, 1]  # classes of each sample
#Use clf.fit() to train the date
#clf.fit(X, y)
RandomForestClassifier(random_state=1) # set the random seed using the RANDOM_STATE argument. Use a random seed of 1.

#use clf.score() to score the data


#Modify the script so that it creates a TSV file that is clearly named (indicates that it's for the iris data). 

with open("DATA/irisData.tsv", "w") as tsvFile:
    tsv_writer = csv.writer(tsvFile, delimiter='\t', lineterminator='\n')
    #tsv_writer.writerow(["Word", "Count"])
    # columns = ["ogRomNum", "prbVersiClassifierOne", "prbVersiClassifierTwo", "prbVersiClassifierThree", "versi/virgincia", "cross-validationFold"]

#It should have columns that indicate the original row number of each iris flower and the probability that each flower is versicolor (for each of the three classifiers). 
#It should also have columns that indicate "versicolor" if the probability for a given classifier was >= 0.5 or "virginica" if the probability was < 0.5. 
#Name these columns descriptively. Each row should indicate which cross-validation fold each flower was used in the test set.