import pandas as pd 
import sys
import statistics

#################
## This file take the files created from classificationAccuracy.py and finds the avgPredition, majorityVote, and maxProb
#################

resultsFile = 'results/' + sys.argv[1] + 'Classifications.tsv'
originalDataFile = 'data/' + sys.argv[1] + 'Modified.csv'
outfile = 'results/' + sys.argv[1] + 'EnsemblePredictions.py'

dataResults = pd.read_csv (resultsFile, sep = '\t')
ogData = pd.read_csv (originalDataFile)

listOfClassifiers = ["randomForest", "logisticRegression", "KNeighbors"]
elementsPerClassifier = int(len(dataResults)/len(listOfClassifiers))


def avgPredition():
    ### you can make predictions based on the origional row number
    list = []
    for x in range(elementsPerClassifier) :
        rowNum = dataResults.iloc[x, 0]
        iteration = dataResults.iloc[x, 4]
        predictions = []
        for i in range(len(dataResults)):
            row = dataResults.iloc[i]
            if(str(row['OriginalRow']) == str(rowNum)) : # change to orininal
                if(str(row['Iteration']) == str(iteration)) :
                    predictions.append(row['PredictionScore'])          
        list.append(statistics.mean(predictions))
    return list


def majorityVote():
    list = []
    for x in range(elementsPerClassifier) :
        rowNum = dataResults.iloc[x, 0]
        iteration = dataResults.iloc[x, 4]
        predictions = []
        for i in range(len(dataResults)):
            row = dataResults.iloc[i]
            if(str(row['OriginalRow']) == str(rowNum)) :
                if(str(row['Iteration']) == str(iteration)) :
                    if(row['PredictionScore'] >= 0.5) :
                        predictions.append(1)
                    else :
                        predictions.append(0)
        list.append(statistics.mode(predictions))
    return list


def maxProb():
    list = []
    for x in range(elementsPerClassifier) :
        rowNum = dataResults.iloc[x, 0]
        iteration = dataResults.iloc[x, 4]
        predictions = []
        for i in range(len(dataResults)):
            row = dataResults.iloc[i]
            if(str(row['OriginalRow']) == str(rowNum)) :
                if(str(row['Iteration']) == str(iteration)) :
                    predictions.append(row['PredictionScore'])
        predictionEdits = [abs(val - 0.5) for val in predictions]
        maxVal = max(predictionEdits)
        maxIndex = predictionEdits.index(maxVal)
        list.append(predictions[maxIndex])
    return list


listavg = avgPredition()
listmajority = majorityVote()
listmax = maxProb()

#create a tsv file
with open(outfile, "w") as tsvFile:
    tsvFile.write("OriginalRow\tTarget\tIteration\tAvgPredition\tMajorityVote\tMaxProb\n")
    for x in range(elementsPerClassifier) :
        tsvFile.write(str(dataResults.iloc[x, 0]) + '\t' + str(ogData["target"].iloc[dataResults.iloc[x, 0]]) + '\t' + str(dataResults.iloc[x, 4]) + "\t" +  str(listavg[x]) + '\t' + str(listmajority[x]) + '\t' + str(listmax[x]) + '\n')
