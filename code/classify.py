import pandas as pd 
import numpy as np
import sklearn
from autosklearn.classification import AutoSklearnClassifier ## install auto-sklearn
from deslib.dcs.lca import LCA # for now we are doing dynamic classifier selection (DCS)
from deslib.des.meta_des import METADES
from deslib.static.oracle import Oracle
from deslib.des.knora_e import KNORAE
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn.svm import SVC
from sklearn.metrics import roc_auc_score
from autokeras import StructuredDataClassifier
import random
import sys
import csv
import os
import time

####################
## This file takes a modified datafile and makes predictions using different classification algorithms.
## It creates a file called Classifications.tsv
####################


fileName = "data/" + sys.argv[1] + "Modified.csv"
outFile = "/results/ClassificationsIris.tsv"
#outFile = "/results/" + sys.argv[1] + "Classifications.tsv"
classOne = sys.argv[2]
classTwo = sys.argv[3]
count = 0
autoSklearnVariations = ["Pick one from a list", "Ensemble from a list", "Pick one from all algorithms", "Unrestricted ensemble"]


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

    iteration = 0
    #this needs to be more available for people
    probs = np.array([]).reshape(0,2)
    aucRocScores = []
    scores = np.array([]).reshape(0,5)
    
    #autosklearn requires casting from numpy.object_
    X = X.astype(float)

    for train_index, test_index in sss.split(X, y):
        iteration += 1
        if(iteration > 5) :
            break
        print("Iteration: " + str(iteration) + "\n")
        probabilities = np.ndarray

        #print("TRAIN:", train_index, "TEST:", test_index)
        #print("TRAINING X SET \n",clf, X[train_index])

        classifier.fit(X[train_index], y[train_index])

        if(classifier == StructuredDataClassifier) :
            probabilities = classifier.predict(X[test_index])
        elif(classifier == Oracle or classifier == KNORAE ) :
            probabilities = classifier.predict_proba(X[test_index], y[test_index]) 
        else:
            probabilities = classifier.predict_proba(X[test_index])

        #print(X[test_index])
        #print(probs)
        #print(probabilities)
        probs = np.vstack([probs, probabilities])

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
    
    #print(scores)
    return scores

CLASSIFIERS = [
    (RandomForestClassifier, {"n_estimators": 100, "random_state" : 0}),
    (LogisticRegression, {"random_state" : 0, "max_iter" : 500}),
    (SVC, {"random_state": 0, "probability": True}),
    (KNeighborsClassifier, {"n_neighbors":10}),
    
    #Pick one from a list [RF, LC, KN, SVC]
    (AutoSklearnClassifier, {"time_left_for_this_task":60, 
                                "per_run_time_limit":30,
                                "ensemble_size":1, # for now we don't want it to find ensemble algorithms
                                "memory_limit":None,
                                "include":{'classifier': ["random_forest", "SGDClassifier", "k_nearest_neighbors", "liblinear_svc"]}
                                }),
    
    #Ensemble from list [RF, LC, KN, SVC]
    (AutoSklearnClassifier, {"time_left_for_this_task":60, 
                                "per_run_time_limit":30,
                                #"ensemble_size":1, 
                                "memory_limit":None,
                                "include":{'classifier': ["random_forest", "SGDClassifier", "k_nearest_neighbors", "liblinear_svc"]}
                                }),

    #Pick one from all algorithms
    (AutoSklearnClassifier, {"time_left_for_this_task":60, 
                                "per_run_time_limit":30,
                                "ensemble_size":1, # for now we don't want it to find ensemble algorithms
                                "memory_limit":None,
                                }),

    #Unrestricted ensemble 
    (AutoSklearnClassifier, {"time_left_for_this_task":60, 
                                "per_run_time_limit":30,
                                #"ensemble_size":1, 
                                "memory_limit":None,
                                }),


   # (StructuredDataClassifier, {})
   (METADES, {"random_state": 0}),
   (LCA, {#"pool_classifiers" : [RandomForestClassifier, LogisticRegression, KNeighborsClassifier],
            "random_state": 0
            }),
   (Oracle, {"random_state": 0}),
   (KNORAE, {"random_state": 0})
   
]

results = []
random.seed(1)

df = pd.read_csv(fileName).to_numpy()

data = df[:, :-1]
predictColumn = df[ :, -1:].ravel()

print(predictColumn)

for classifier in CLASSIFIERS:
    #Record start time
    start = time.time()
    if(classifier == AutoSklearnClassifier) :
        count += 1
    for score in crossValidate(data, predictColumn, classifier):
        #record end time
        end = time.time()
        #the difference between the start and end time in milli. secs
        timeElapsed = (end - start) * 10**3  #the units for this measurement are "ms"
        classifier_name = str(classifier[0]).split("'")[1].split(".")[-1].replace("Classifier", "")
        if(classifier_name == AutoSklearnClassifier) :
            classifier_name = "AutoSklearn: " + autoSklearnVariations[count -1]
        results.append([classifier_name, score[0], score[1], score[2], score[3], score[4], timeElapsed])

print("scores")
print(results)

def appendTSV(results):
    if(not os.path.exists(outFile)): 
        with open(outFile, "w") as tsvFile:
            tsvFile.write("DataName\tOriginalRow\tTarget\tIteration\tClassifier\tPredictionType\tPredictionScore\tPrediction\tTime\n")
    
    with open(outFile, "a") as tsvFile:
        for prediction in results:
            predict = ""
            target = predictColumn[int(prediction[2])]

            if(prediction[4] >= 0.5):
                predict = classOne
            else:
                predict = classTwo

            predictionType = ""
            basic = ["RandomForest", "LogisticRegression", "SVC", "KNeighbors"]    
            if prediction[0] in basic:
                predictionType = "Basic"
            else:
                predictionType = "Ensemble"

            tsvFile.write('\t'.join([str(sys.argv[1]), str(int(prediction[2])), str(target), str(int(prediction[1])), str(prediction[0]), str(predictionType), str(prediction[4]), predict, str(prediction[5])]) + '\n')

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

            tsvFile.write('\t'.join([str(sys.argv[1]), str(int(prediction[2])), str(target), str(int(prediction[1])), str(prediction[0]), str("Basic"), str(prediction[4]), predict]) + '\n')

#createTSV(results)
appendTSV(results)
