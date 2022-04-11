import pandas as pd 
import numpy as np
import sklearn
from autosklearn.classification import AutoSklearnClassifier ## install auto-sklearn
from deslib.dcs.lca import LCA # for now we are doing dynamic classifier selection (DCS)
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

####################
## This file takes a modified datafile and tried to predict the different outcomes.
## It creates a file called "type of data" Classifications.tsv
##
####################


fileName = "data/" + sys.argv[1] + "Modified.csv"
outFile = "/results/" + sys.argv[1] + "WeightedClassifications.tsv"
classOne = sys.argv[2]
classTwo = sys.argv[3]

def crossValidate(df, labels, clf) :
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
    print(sss)
    sys.exit()

    iteration = 0
    #this needs to be more available for people
    probs = np.array([]).reshape(0,2)
    aucRocScores = []
    averageSubRoc = []
    scores = np.array([]).reshape(0,5)
    
    #autosklearn requires casting from numpy.object_
    X = X.astype(float)

    for train_index, test_index in sss.split(X, y):
        iteration += 1
        if(iteration > 5) :
            break

        ### for every classifier
        ###split again
        subsss = StratifiedShuffleSplit(n_splits=5, test_size=0.2, random_state=1)
        subiter = 0
        subprobs = np.array([]).reshape(0,2)
        subscores = np.array([]).reshape(0,5)
        subaucRocScores = []


        ##subX and suby
        subX = X[train_index]
        suby = y[train_index]
        for sub_train_index, sub_test_index in subsss.split(X[train_index], y[train_index]):
            subiter +=1
            if(subiter > 3) :
                break
            print("Sub-iteration: " + str(subiter) + "\n")
            subprobabilities = np.ndarray
            
            classifier.fit(subX[sub_train_index], suby[sub_train_index])
            if(classifier == StructuredDataClassifier) :
                subprobabilities = classifier.predict(subX[sub_test_index])
            else :
                subprobabilities = classifier.predict_proba(subX[sub_test_index])

            print(subX[sub_test_index])
            print(subprobs)
            print(subprobabilities)
            subprobs = np.vstack([subprobs, subprobabilities])

            subrocaucscores = roc_auc_score(suby, classifier.predict_proba(subX)[:,1])
            subaucRocScores.append(subrocaucscores)

        print(subaucRocScores)
        subAverage = np.mean(subaucRocScores)
        averageSubRoc.append(subAverage)
        print(averageSubRoc)
        #sys.exit()



        ###train and test
        ###fit
        ###get probabilities
        ##find the average for each classifier
        ##use that as the weight

        #calculate the score? off of the weights

        #print("Classifier: " + str(clf[0]))
        #print("Iteration: " + str(iteration) + "\n")
        probabilities = np.ndarray

        #print("TRAIN:", train_index, "TEST:", test_index)
        #print("TRAINING X SET \n",clf, X[train_index])

        classifier.fit(X[train_index], y[train_index])

        if(classifier == StructuredDataClassifier) :
            probabilities = classifier.predict(X[test_index])
        else : 
            probabilities = classifier.predict_proba(X[test_index])

        #print(X[test_index])
        #print(probs)
        #print(probabilities)
        probs = np.vstack([probs, probabilities])

        #print("Iteration: " + str(iteration))
        #print("SubIteration: " + str(subiter))
        #print(probs)
        print("")


        #Find the rocaucscore
        rocaucscores = roc_auc_score(y, classifier.predict_proba(X)[:, 1])
        aucRocScores.append(rocaucscores)
        rows, columns = probabilities.shape

        #combine roc_auc score and iteration number to the probabilities 
        auc = np.zeros((rows,1))
        auc[:] = rocaucscores
        combined = np.insert(probabilities, 0, [iteration], axis=1)
        combined = np.append(combined, auc, axis=1)
        combined = np.insert(combined, 1, test_index, axis=1)
        scores = np.vstack([scores,combined])
    
    print(scores)
    print(np.mean(averageSubRoc))
    return [(scores, np.mean(averageSubRoc))]

CLASSIFIERS = [
    (RandomForestClassifier, {"n_estimators": 100, "random_state" : 0}),
    (LogisticRegression, {"random_state" : 0}),
    (KNeighborsClassifier, {}),
    (AutoSklearnClassifier, {"time_left_for_this_task":30, 
                                "per_run_time_limit":15,
                                "ensemble_size":1, # for now we don't want it to find ensemble algorithms
                                "include":{'classifier': ["random_forest", "k_nearest_neighbors"]}
                                }),
    #(StructuredDataClassifier, {})
   (LCA, {#"pool_classifiers" : [RandomForestClassifier, LogisticRegression, KNeighborsClassifier],
            "random_state": 0
            })
   
]

results = []
weights = []
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
    for scoreweight in crossValidate(data, predictColumn, classifier):
        print(scoreweight)
        scores = scoreweight[0]
        weight = scoreweight[1]
        classifier_name = str(classifier[0]).split("'")[1].split(".")[-1].replace("Classifier", "")
        for score in scores:
            results.append([classifier_name, score[0], score[1], score[2], score[3]*weight, score[4]])
            weights.append([classifier_name, weight])

print("scores")
print(results)
print(weights)

def createTSV(results):
    print("Creating TSV file...")
    with open(outFile, "w") as tsvFile:
        print("writing to " + outFile)
        tsvFile.write("DataName\tOriginalRow\tTarget\tIteration\tClassifier\tPredictionType\tPredictionScore\tPrediction\n")

        for prediction in results:
            predict = ""
            target = predictColumn[int(prediction[2])]
            
            if(prediction[4] >= 0.5) :
                predict = classOne
            else:
                predict = classTwo

            tsvFile.write('\t'.join([str(sys.argv[1]), str(int(prediction[2])), str(target), str(int(prediction[1])), str(prediction[0]), str("weighted"), str(prediction[4]), predict]) + '\n')

createTSV(results)
