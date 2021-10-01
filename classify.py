import pandas as pd 
import numpy as np
import sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn.metrics import roc_auc_score
import random
import sys
import csv
import os

fileName = "DATA/irismodified.csv"

def cross_validate(df, labels, clf) :
    X = df
    y = labels
    y = y.astype('int')
    
    scoring_metric = "roc_auc"
    n_jobs = 2

    params = clf[1]
    if "random_state" in params:
        params["random_state"] = 1
    classifier = clf[0](**params)
    sss = StratifiedShuffleSplit(n_splits=5, test_size=0.2, random_state=1) 

    iteration = 0
    probs = np.array([]).reshape(0,2)
    auc_roc_scores = []
    scores = np.array([]).reshape(0,5)

    for train_index, test_index in sss.split(X, y):
        iteration += 1
        print("TRAIN:", train_index, "TEST:", test_index)
        classifier.fit(X[train_index], y[train_index])
        probabilities = classifier.predict_proba(X[test_index])
        probs = np.vstack([probs, probabilities])
        #print("Probabilities")
        #print(probabilities)

        #Find the rocaucscore
        rocaucscores = roc_auc_score(y, classifier.predict_proba(X)[:, 1])
        auc_roc_scores.append(rocaucscores)
        rows, columns = probabilities.shape

        #combine roc_auc score and iteration number to the probabilities 
        auc = np.zeros((rows,1))
        auc[:] = rocaucscores
        combined = np.insert(probabilities, 0, [iteration], axis=1)
        combined = np.append(combined, auc, axis=1)
        combined = np.insert(combined, 1, test_index, axis=1)
        scores = np.vstack([scores,combined])

    
    print(scores)
    return scores

CLASSIFIERS = [
    (RandomForestClassifier, {"n_estimators": 100, "random_state" : 0}),
    (LogisticRegression, {"random_state" : 0}),
    (KNeighborsClassifier, {})
]

results = []
random.seed(1)

df = pd.read_csv(fileName).to_numpy()

# gets the data and seperates it from the labels
data = df[:, :3]
predictColumn = df[:, 5]

for classifier in CLASSIFIERS:
    for score in cross_validate(data, predictColumn, classifier):
        classifier_name = str(classifier[0]).split("'")[1].split(".")[-1].replace("Classifier", "")
        results.append([classifier_name, score[0], score[1], score[2], score[3], score[4]])

print("scores")
print(results)
## results are [classifier, iteration number, og row number, probability not virginica, probability virginica, roc score]

#Modify the script so that it creates a TSV file that is clearly named (indicates that it's for the iris data). 
def createTSV(results):
    print("createTSV function called")
    with open("DATA/irisData.tsv", "w") as tsvFile:
        tsvFile.write("ogRowNum\ttClassifier\tprobability of versicolor\tprediction\tcross-validationFold\n")
        rownum = 1
        for prediction in results:
            # checks probability of versicolor and makes prediction 
            predict = ""
            if(prediction[4] >= 0.5) :
                predict = "Iris-versicolor"
            else:
                predict = "Iris-virginica"
    
            tsvFile.write('\t'.join([str(int(prediction[2])), str(prediction[0]), str(prediction[4]), predict, str(int(prediction[1]))]) + '\n')
            #tsvFile.write(int(results[2]) + '\t' + results[0] + '\t' + results[4] + '\t' + "prediction" + '\t' + int(results[1]) + '\n')
        #example: 3 RandomForest 0.6    Versicolor  3
        #example: 5 LogReg 0.2 Virgincia 1

#Calling the createTSV function
createTSV(results)