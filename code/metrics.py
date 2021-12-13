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
    resultsFile = 'results/' + sys.argv[1] + 'Classifications.tsv' #the file created from classify.py #OrigionalRow	Classifier	Iteration   Target  PredictionScore	Prediction
    originalDataFile = 'data/' + sys.argv[1] + 'Modified.csv'
    outfile = 'results/' + sys.argv[1] + 'Metrics.tsv'
    
    dataResults = pd.read_csv (resultsFile, sep = '\t')
    ogData = pd.read_csv (originalDataFile)
    listOfClassifiers = ["RandomForest", 
                        "LogisticRegression", 
                        "KNeighbors",
                        "AutoSklearn",
                        "LCA"
                        # "StructuredData"
                        ]
    #elementsPerClassifier = int(len(dataResults)/len(listOfClassifiers))
    numIterations = 5 + 1 #fix this later

    with open(outfile, "w") as tsvFile:
        tsvFile.write("Classifier\tIteration\tAccuracy\tf1_score\tf1_weighted\taverage_precision\troc_auc\n")

        for classifier in listOfClassifiers:
            for iteration in range(1, numIterations):
                y_pred = []
                y_target = []

                for i in range(1, len(dataResults)):
                    row = dataResults.iloc[i]
                    if(str(row['Classifier']) == classifier) : # change to orininal
                        if(str(row['Iteration']) == str(iteration)) :
                            y_pred.append(row['Prediction'])
                            y_target.append(row['Target'])
                

                #if(len(y_target) >0 & len(y_pred) >0) :
                accuracy = accuracy_score(y_target, y_pred)
                f1Score = f1_score(y_target, y_pred, average='binary')
                f1_weighted = f1_score(y_target, y_pred, average='weighted')
                average_precision = average_precision_score(y_target, y_pred)
                rocAucScore = roc_auc_score(y_target, y_pred)

                ### writing the information to the tsv file
                print("The metrics for " + classifier + " for iteration " + str(iteration) + " are: " )
                tsvFile.write('\t'.join([classifier, str(iteration), str(accuracy), str(f1Score), str(f1_weighted), str(average_precision), str(rocAucScore)])+ '\n')


    # for x in range(elementsPerClassifier):
    #     rowNum = dataResults.iloc[x, 0]
    #     iteration = dataResults.iloc[x, 4]
        
    #     for i in range(len(dataResults)):
    #         row = dataResults.iloc[i]
    #         y_pred = []
    #         y_true = []
    #         if(str(row['OriginalRow']) == str(rowNum)) : # change to original
    #             if(str(row['Iteration']) == str(iteration)) :
                    
    #                 ######
    #                 ## for everything except the roc_score, we just need a way to create two lists/arrays. 
    #                 ## one called y_pred with the predictions
    #                 ## one called y_true with what the orignal data says
    #                 ## then we can easily get all the accuracy metrics
    #                 ######

    #                 y_pred = [0, 1, 0]
    #                 y_true = [0, 0, 1]
                
    #                 accuracy = accuracy_score(y_true, y_pred)
    #                 f1Score = f1_score(y_true, y_pred, average='binary')
    #                 f1_weighted = f1_score(y_true, y_pred, average='weighted')
    #                 average_precision = average_precision_score(y_true, y_pred)
    #                 rocAucScore = roc_auc_score(y_true, y_pred)

    #                 ### writing the information to the tsv file
    #                 print("The metrics for " + classifier + " for iteration " + iteration + " are: " )
    #                 tsvFile.write('\t'.join([classifier + str(iteration) + str(accuracy) + str(f1Score) + str(f1_weighted) + str(average_precision)]) + str(rocAucScore) + '\n')

metrics()

