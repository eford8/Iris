import pandas as pd 
import numpy as np
import sklearn
from autosklearn.classification import AutoSklearnClassifier ## install auto-sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn.metrics import roc_auc_score
from autokeras import StructuredDataClassifier
import random
import sys
import csv
import os

fileName = "data/" + sys.argv[1] + "Modified.csv"
outfile = "results/" + sys.argv[1] + "Classifications.tsv"
class1 = sys.argv[2]
class2 = sys.argv[3]

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
    ########
    #this needs to be more available for peole
    probs = np.array([]).reshape(0,2)
    auc_roc_scores = []
    scores = np.array([]).reshape(0,5)
    
    #autosklearn requires casting from numpy.object_
    X = X.astype(float)
    for train_index, test_index in sss.split(X, y):
        iteration += 1
        probabilities = np.ndarray
        print("TRAIN:", train_index, "TEST:", test_index)
        print("TRAINING X SET \n",clf, X[train_index])
        classifier.fit(X[train_index], y[train_index])
        if(classifier == StructuredDataClassifier) :
            probabilities = classifier.predict(X[test_index])
        else : 
            probabilities = classifier.predict_proba(X[test_index])
        print(X[test_index])
        print(probs)
        print(probabilities)
        probs = np.vstack([probs, probabilities])


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

    
    #print(scores)
    return scores

CLASSIFIERS = [
    (RandomForestClassifier, {"n_estimators": 100, "random_state" : 0}),
    (LogisticRegression, {"random_state" : 0}),
    (KNeighborsClassifier, {})#,
    #(AutoSklearnClassifier, {}),
    #(StructuredDataClassifier, {})
]

results = []
random.seed(1)

df = pd.read_csv(fileName).to_numpy()

# gets the data and seperates it from the labels
# if (sys.argv[1] == "iris") :
#     data = df[:, :3]
#     predictColumn = df[:, 5]
# else :
data = df[:, :-1]
predictColumn = df[ :, -1:].ravel()

print(predictColumn)

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
    print(outfile)
    with open(outfile, "w") as tsvFile:
        print("writing to " + outfile)
        tsvFile.write("OriginalRow\tClassifier\tIteration\tTarget\tPredictionScore\tPrediction\n")
        rownum = 1
        for prediction in results:
            # checks probability of versicolor and makes prediction 
            predict = ""

            target = predictColumn[int(prediction[2])]
            #print(target)
            #print("here")
            if(prediction[4] >= 0.5) :
                predict = class1
            else:
                predict = class2
    
            tsvFile.write('\t'.join([str(int(prediction[2])), str(prediction[0]), str(int(prediction[1])), str(target), str(prediction[4]), predict]) + '\n')
            #tsvFile.write(int(results[2]) + '\t' + results[0] + '\t' + results[4] + '\t' + "prediction" + '\t' + int(results[1]) + '\n')
        #example: 3 RandomForest 0.6    Versicolor  3
        #example: 5 LogReg 0.2 Virgincia 1

#Calling the createTSV function
createTSV(results)