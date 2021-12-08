import pandas as pd 
import numpy as np
import sys
import csv
import sklearn
from sklearn.metrics import accuracy_score
from sklearn.metrics import f1_score    #also used to calculate f1_weighted 
from sklearn.metrics import roc_auc_score
from sklearn.metrics import average_precision_score

####################
## This Python script parses the tsv file created from "classify.py" and calculates various accuracy scorces using
## sklearn.metrics. It does this for all the algorithms used and for each interation.
## We can see how frequently the predictions from our algorithms coincide with the actual species. 
####################

def metrics ():
    print("Calculating metrics for " + sys.argv[1] + " dataset\n")
    resultsFile = 'results/' + sys.argv[1] + 'Classifications.tsv' #the file created from classify.py
    originalDataFile = 'data/' + sys.argv[1] + 'Modified.csv'
    outFile = 'results/' + sys.argv[1] + 'Metrics.tsv'
    
    dataResults = pd.read_csv(resultsFile, sep = '\t')
    ogData = pd.read_csv(originalDataFile)

    listOfClassifiers = ["RandomForest", 
                        "LogisticRegression", 
                        "KNeighbors"
                        #, "AutoSklearn", 
                        # "StructuredData"
                        ]
    #elementsPerClassifier = int(len(dataResults)/len(listOfClassifiers))
    numIterations = 5 + 1 #fix this later

    with open(outFile, "w") as tsvFile:
        tsvFile.write("Classifier\tIteration\tAccuracy\tf1_score\tf1_weighted\taverage_precision\troc_auc\tprecision\trecall\tthresholds\n")

        for classifier in listOfClassifiers:
            for iteration in range(1, numIterations):
                y_pred = []
                y_target = []

                for i in range(1, len(dataResults)):
                    row = dataResults.iloc[i]
                    if(str(row['Classifier']) == classifier) : # change to original
                        if(str(row['Iteration']) == str(iteration)) :
                            y_pred.append(row['Prediction'])
                            y_target.append(row['Target'])
                

                #if(len(y_target) >0 & len(y_pred) >0) :
                accuracy = accuracy_score(y_target, y_pred)
                f1Score = f1_score(y_target, y_pred, average='binary')
                f1Weighted = f1_score(y_target, y_pred, average='weighted')
                averagePrecision = average_precision_score(y_target, y_pred)
                rocAucScore = roc_auc_score(y_target, y_pred)

                ### writing the information to the tsv file
                print("Writing the metrics for " + classifier + " for iteration " + str(iteration))
                tsvFile.write('\t'.join([classifier, str(iteration), str(accuracy), str(f1Score), str(f1Weighted), str(averagePrecision), str(rocAucScore)]) + '\n')

metrics()

