import pandas as pd 
import numpy as np
import sys
import statistics

from Iris.code.metrics import metrics ##Emi help, i think we have a ghost. I did not write this but it showed up.

####################
## Purpose of this python script is to parse the file created from the metrics.py file.
## After that, it calculates which classifiers perform the best.
## Then it assigns weights to the classifiers for an ensemble approach. 
####################

####################
## IDEAS
## Average the interations
## Finding the highest score? The lowest score? 
## How will the scores add up to 100% or to One? 
##
## What if we just look at the best performing classifier for each thing? 
####################

#the file header created from the metrics.py file 
#tsvFile.write("DataName\tClassifier\tIteration\tPredictionType\tAccuracy\tf1_score\tf1_weighted\taverage_precision\troc_auc\n")

## What does all.sh look like? 
#python addWeights.py "iris" "Classifications"


print("Calculating weights for the " + sys.argv[1] + " dataset... \n")

metricsFile = 'results/' + sys.argv[1] + sys.argv[2] + 'Metrics.tsv' # this is the file created from metrics.py that we need to parse
outFile = 'results/' + sys.argv[1] + 'Weights.tsv'

metricsDF = pd.read_csv(metricsFile, sep = '\t')

numIterations = metricsDF["Iteration"].max()

## Average the interations

listOfClassifiers = metricsDF["Classifier"].unique()
listOfMetricValues = ["Accuracy", "f1_score", "f1_weighted", "average_precision", "roc_auc" ]

avgInterationsDict = {}  ##Classifier : [List of 5 numbers with them avergaed ]
avgList = []

## reads the classifiers and for each classifier averages the interations. 
for classifier in listOfClassifiers: ## RandomForest
    for metricsType in listOfMetricValues: ## "Accuracy"
        calculateAvg = []

        if metricsDF["Classifier"] == classifier:
            if metricsDF[classifier]  == metricsType:
                number = 0
                ## FIX ME. HOW TO FIND THE NUMBER 
                calculateAvg.append("number")

        ## find the avg
        avg = sum(calculateAvg) / len(calculateAvg)
        avgList.append("avg")

    for value in avgList:
        avgInterationsDict[classifier] = value

## idea is after this block of code, we will have a python dictionary with the classifiers as the keys and the
## values as a list of 5 numbers, each number being the avg of accuracy, f1_score, ect, ect, ect

## What if we just did it on the accuracy score?? 
## This block of code should find which classifier has the best accuracy score
maxClassifier = ""
maxAccuracyScore = 0
for classifier in listOfClassifiers:
    list = avgInterationsDict[classifier]
    accuracyScore = list[0]

    if accuracyScore > maxAccuracyScore:
        maxClassifier = classifier
        maxAccuracyScore = accuracyScore

## this block of code find the best classifier for each of the five scores. 

bestAccuracyClassifier = ""
maxAccuracyScore = 0

bestf1ScoreClassifier = ""
maxf1Score = 0 

bestf1WeightedClassifier = ""
maxf1Wighted = 0

bestAveragePrecisionClassifier = ""
maxAveragePrecision = 0

bestROCAUCClassifier = ""
maxROCAUC = 0


for classifier in listOfClassifiers:
    list = avgInterationsDict[classifier]
    accuracyScore = list[0]
    f1Score = list[1]
    f1Weighted = list[2]
    avergePrecision = list[3]
    rocAuc = list[4]

    if accuracyScore > maxAccuracyScore:
        bestAccuracyClassifier = classifier
        maxAccuracyScore = accuracyScore
    
    if f1Score > maxf1Score:
        bestf1ScoreClassifier = classifier 
        maxf1Score = f1Score

    if f1Weighted > maxf1Wighted:
        bestf1WeightedClassifier = classifier 
        maxf1Wighted = f1Weighted
    
    if avergePrecision > maxAveragePrecision:
        bestAveragePrecisionClassifier = classifier 
        maxAveragePrecision = avergePrecision
    
    if rocAuc > maxROCAUC:
        bestROCAUCClassifier = classifier
        maxROCAUC = rocAuc

print("The classifier with the best accuracy score is " + bestAccuracyClassifier)
print("The classifier with the best f1_score is " + bestf1ScoreClassifier)
print("The classifier with the best f1_weighted score is " + bestf1WeightedClassifier)
print("The classifier with the best average_precision score is " + bestAveragePrecisionClassifier)
print("The classifier with the best roc_auc score is " + bestROCAUCClassifier)










##Accuracy  f1_score    f1_weighted     average_precision   roc_auc
## we have these five scores. What do they do and what do they mean? 