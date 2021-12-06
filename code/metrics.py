import pandas as pd 
import numpy as np
import sys
import csv
import sklearn
from sklearn.metrics import accuracy_score
from sklearn.metrics import f1_score    #also used to calculate f1_weighted 
from sklearn.metrics import roc_auc_score
from sklearn.metrics import average_precision_score
from sklearn.metrics import precision_recall_curve #AUPRC

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
                        "KNeighbors"
                        #, "AutoSklearn", 
                        # "StructuredData"
                        ]
    #elementsPerClassifier = int(len(dataResults)/len(listOfClassifiers))
    numIterations = 5 + 1 #fix this later

    with open(outfile, "w") as tsvFile:
        tsvFile.write("Classifier\tIteration\tAccuracy\tf1_score\tf1_weighted\taverage_precision\troc_auc\tprecision\trecall\tthresholds\n")

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
                #implementing AUPRC
                precision, recall, thresholds = precision_recall_curve( y_target, y_pred) #AUPRC
                print(precision)
                print(recall)
                print(thresholds)

                ### writing the information to the tsv file
                print("The metrics for " + classifier + " for iteration " + str(iteration) + " are: " )
                tsvFile.write('\t'.join([classifier, str(iteration), str(accuracy), str(f1Score), str(f1_weighted), str(average_precision), str(rocAucScore), str(precision), str(recall), str(thresholds)])+ '\n')

metrics()

