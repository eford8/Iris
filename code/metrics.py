import pandas as pd 
import numpy as np
import sys
import os
import csv
import sklearn
from sklearn.metrics import accuracy_score
from sklearn.metrics import f1_score    #also used to calculate f1_weighted 
from sklearn.metrics import roc_auc_score
from sklearn.metrics import average_precision_score

####################
## This Python script parses the tsv file created from "classify.py" or from ensemblePredictions.py and calculates various accuracy scores using
## sklearn.metrics. It does this for all the algorithms used and for each iteration.
## We can see how frequently the predictions from our algorithms coincide with the actual species. 
####################


resultsFile = 'results/Classifications.tsv'
outFile = 'results/Metrics.tsv'
dataResults = pd.read_csv(resultsFile, sep = '\t')

def metrics (dataName):
    filteredResults = dataResults[dataResults["DataName"] == dataName]
    print("Calculating metrics for " + dataName + " dataset\n")
    originalDataFile = 'data/' + dataName + 'Modified.csv'
    
    ogData = pd.read_csv(originalDataFile)

    listOfClassifiers = filteredResults["Classifier"].unique() #dataResults

    numIterations = filteredResults["Iteration"].max() + 1  #dataResults
    
    if not os.path.exists (outFile):
        with open(outFile, "w") as tsvFile:
            tsvFile.write("DataName\tClassifier\tIteration\tPredictionType\tAccuracy\tf1_score\tf1_weighted\taverage_precision\troc_auc\tTime\n") #added the time column
    
    with open(outFile, "a") as tsvFile:
        for classifier in listOfClassifiers:
            for iteration in range(1, numIterations):
                y_pred = []
                y_target = []
                predictionType = ""
                timeElapsed = 0

                for i in range(1, len(filteredResults)):   # this block can be optimized dataResults
                    row = filteredResults.iloc[i] # dataResults
                    if(str(row['Classifier']) == classifier):
                        if(str(row['Iteration']) == str(iteration)):
                            y_pred.append(row['Prediction'])
                            y_target.append(row['Target'])
                            predictionType = row["PredictionType"]
                            timeElapsed = row["Time"]

                accuracy = accuracy_score(y_target, y_pred)
                f1Score = f1_score(y_target, y_pred, average='binary')
                f1Weighted = f1_score(y_target, y_pred, average='weighted')
                averagePrecision = average_precision_score(y_target, y_pred)
                rocAucScore = roc_auc_score(y_target, y_pred)

                #writing the information to the tsv file
                print("Writing the metrics for " + classifier + " for iteration " + str(iteration))
                tsvFile.write('\t'.join([dataName, classifier, str(iteration), str(predictionType), str(accuracy), str(f1Score), str(f1Weighted), str(averagePrecision), str(rocAucScore), str(timeElapsed)]) + '\n')


for dataName in dataResults["DataName"].unique():
    metrics(dataName)
