import pandas as pd 
import sys
import statistics

#################
## This file take the files created from classificationAccuracy.py and finds the avgPredition, majorityVote, and maxProb
#################

resultsFile = 'results/' + sys.argv[1] + 'Classifications.tsv'
originalDataFile = 'data/' + sys.argv[1] + 'Modified.csv'
outfile = 'results/' + sys.argv[1] + 'EnsemblePredictions.tsv'
class1 = sys.argv[2]
class2 = sys.argv[3]

dataResults = pd.read_csv (resultsFile, sep = '\t')
ogData = pd.read_csv (originalDataFile)

listOfClassifiers = ["RandomForest", "LogisticRegression", "KNeighbors"]
elementsPerClassifier = int(len(dataResults)/len(listOfClassifiers))


def avgPredition():
    ### you can make predictions based on the origional row number
    list = []
    for x in range(elementsPerClassifier) :
        rowNum = dataResults.iloc[x]["OriginalRow"]
        iteration = dataResults.iloc[x]["Iteration"]
        predictions = []
        for i in range(len(dataResults)):
            row = dataResults.iloc[i]
            if(str(row['OriginalRow']) == str(rowNum)) : # change to orininal
                if(str(row['Iteration']) == str(iteration)) :
                    predictions.append(row['PredictionScore']) 
        #if(len(predictions) > 0) :        
        list.append(statistics.mean(predictions))
    return list


def majorityVote():
    list = []
    for x in range(elementsPerClassifier) :
        rowNum = dataResults.iloc[x]["OriginalRow"]
        iteration = dataResults.iloc[x]["Iteration"]
        predictions = []
        for i in range(len(dataResults)):
            row = dataResults.iloc[i]
            if(str(row['OriginalRow']) == str(rowNum)) :
                if(str(row['Iteration']) == str(iteration)) :
                    if(row['PredictionScore'] >= 0.5) :
                        predictions.append(class1)
                    else :
                        predictions.append(class2)
        #if(len(predictions) > 0) :  
        list.append(statistics.mode(predictions))
    return list


def maxProb():
    list = []
    for x in range(elementsPerClassifier) :
        rowNum = dataResults.iloc[x]["OriginalRow"]
        iteration = dataResults.iloc[x]["Iteration"]
        predictions = []
        for i in range(len(dataResults)):
            row = dataResults.iloc[i]
            if(str(row['OriginalRow']) == str(rowNum)) :
                if(str(row['Iteration']) == str(iteration)) :
                    predictions.append(row['PredictionScore'])
        #if(len(predictions) > 0) :  
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
    tsvFile.write("OriginalRow\tTarget\tIteration\tAvgPrediction\tMajorityVote\tExtremeProb\n")
    for x in range(elementsPerClassifier) :
        row = dataResults.iloc[x]
        tsvFile.write(str(row["OriginalRow"]) + '\t' + str(row["Target"]) + '\t' + str(row["Iteration"]) + "\t" +  str(listavg[x]) + '\t' + str(listmajority[x]) + '\t' + str(listmax[x]) + '\n')
