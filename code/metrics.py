import pandas as pd 
import numpy as np
import sys
import csv
import os
import sklearn
from sklearn.metrics import accuracy_score
from sklearn.metrics import f1_score    #also used to calculate f1_weighted 
from sklearn.metrics import roc_auc_score
from sklearn.metrics import average_precision_score

from Iris.code.ensemblePredictions import avgPredition

####################
## This Python script parses the TSV file created from "classify.py" and calculates various accuracy scorces using
## sklearn.metrics. It does this for all the algorithms used and for each interation.
## We can see how frequently the predictions from our algorithms coincide with the actual species. 
####################

## Other notes used to create the file
### every file Iteration	Classifier	ClassificationAccurayScore
### classifier, interation
### randomForest, 5, accuracy   f1      f1_weighted     roc_auc     average_precision
####metric  score
#### accuracy   f1      f1_weighted       average_precision     roc_auc 
### seperate file for every dataset 

datasetlist = ["iris", "breast", "Gametes_Epistasis", "horse_colic", "magic"]

def metrics (dataset):
    print("Calculating metrics for " + dataset + " dataset\n")
    resultsFile = "results/" + dataset + "Predictions.tsv"  ##the file created from ensemblePredictions ##make sure the names match
    ##OrigionalRow	Classifier	PredictionScore	Prediction	Iteration ## rows in the file

    origionalData = "data/" + dataset + "Modified.csv"
    outfile = "results/" + dataset + "metrics.tsv"

    dataResults = pd.read_csv (resultsFile, sep = '\t')
    ogData = pd.read_csv (origionalData)
    classifierList = ["RandomForest", "LogisticRegression", "KNeighbors", "AutoSklearn", "StructuredData"]

    numIterations = [1, 2, 3, 4, 5] ##How are we going to account for the fluctuation of num of iterations??

    with open(outfile, "w") as tsvFile:
        tsvFile.write("Classifier\tIteration\taccuracy\tf1_score\tf1_weighted\taverage_precision\troc_auc\n")

    for classifier in classifierList:
        for iteration in numIterations:

            ######
            ## for everything except the roc_score, we just need a way to create two lists/arrays. 
            ## one called y_pred with the predictions
            ## one called y_true with what the orignal data says
            ## then we can easily get all the accuracy metrics, other than the roc_score
            ######

            y_pred = [0, 1, 0]
            y_true = [0, 0, 1]
            
            accuracy = accuracy_score(y_true, y_pred)
            f1Score = f1_score(y_true, y_pred, average='binary')
            f1_weighted = f1_score(y_true, y_pred, average='weighted')
            average_precision = average_precision_score(y_true, y_pred)
            ##still need to figure out the roc_score stuff

            ### writing the information to the tsv file
            print("The metrics for " + classifier + " for iteration " + iteration + " are: " )
            tsvFile.write('\t'.join([classifier + str(iteration) + str(accuracy) + str(f1Score) + str(f1_weighted) + str(average_precision)]) + '\n')



def getaccuracyScore ():
    y_pred = [0, 2, 1, 3] ##need to create an arracy with all the preditions
    y_true = [0, 1, 2, 3] ##need to create an arracy with all the ogdata
    accuracy_score(y_true, y_pred)

def getf1Score ():
    y_true = [0, 1, 2, 0, 1, 2]
    y_pred = [0, 2, 1, 0, 0, 1]
    f1_score(y_true, y_pred, average='binary')

def getf1WeightedScore ():
    y_true = [0, 1, 2, 0, 1, 2]
    y_pred = [0, 2, 1, 0, 0, 1]
    f1_score(y_true, y_pred, average='weighted')

def getRocScore ():
    print("This needs help")
    """
    >>> from sklearn.datasets import load_breast_cancer
    >>> from sklearn.linear_model import LogisticRegression
    >>> from sklearn.metrics import roc_auc_score
    >>> X, y = load_breast_cancer(return_X_y=True)
    >>> clf = LogisticRegression(solver="liblinear", random_state=0).fit(X, y)
    >>> roc_auc_score(y, clf.predict_proba(X)[:, 1])
    0.99...
    >>> roc_auc_score(y, clf.decision_function(X))
    0.99...
    """

def getAveragePrecisionScore ():
    y_true = np.array([0, 0, 1, 1])
    y_scores = np.array([0.1, 0.4, 0.35, 0.8])
    average_precision_score(y_true, y_scores)





## old code for manually finding the accuracy for each algorithms and it's five iterations 
"""
with open(outfile, "w") as tsvFile:
    tsvFile.write("Iteration\tClassifier\tClassificationAccurayScore\n")

    #####################
    #We should probably make this more efficient so that it can be automated for any number of classifiers and iterations
    ##################### 

    for typeClassifier in classifierList:
        rowCounter = 0
        foldOneCounter = 0
        foldTwoCounter = 0
        foldThreeCounter = 0
        foldFourCounter = 0
        foldFiveCounter = 0
        TOTAINTERATIONS = 20
        TOTALSAMPLES = 100
        
        #just go throught all the rows that contain the classifier than we want
        for row in dataResults["Classifier"]:
            #compares the typeClassifier to the type we are looking for
            if row == typeClassifier:
                #get orginal row number
                ogRowNum = dataResults["OrigionalRow"].iloc[rowCounter]

                #Find out if the orginal flower is versicolor or virginica
                classType = ogData["class"].iloc[ogRowNum]

                #find the cross-validationFold
                interationNum = dataResults["Iteration"].iloc[rowCounter]

                #compare classifier result with real result for each fold
                if interationNum == 1:
                    if dataResults["Prediction"].iloc[rowCounter] == classType:
                        foldOneCounter += 1
                if interationNum == 2:
                    if dataResults["Prediction"].iloc[rowCounter] == classType:
                        foldTwoCounter += 1
                if interationNum == 3:
                    if dataResults["Prediction"].iloc[rowCounter] == classType:
                        foldThreeCounter += 1
                if interationNum == 4:
                    if dataResults["Prediction"].iloc[rowCounter] == classType:
                        foldFourCounter += 1
                if interationNum == 5:
                    if dataResults["Prediction"].iloc[rowCounter] == classType:
                        foldFiveCounter += 1
                
            rowCounter += 1

        classificationAccuracy = (foldOneCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for iteration one is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(1), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldTwoCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for iteration two is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(2), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldThreeCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for iteration three is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(3), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldFourCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for interation four is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(4), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldFiveCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for iteration five is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(5), typeClassifier, str(classificationAccuracy)]) + '\n')
          
"""