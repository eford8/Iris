import pandas as pd 
import sys
import statistics

#from classify import createTSV

#################
## This file take the files created from classify.py and finds the avgPredition, majorityVote, and maxProb
## It is a basic emsemble 
#################

resultsFile = 'results/' + sys.argv[1] + 'Classifications.tsv'
originalDataFile = 'data/' + sys.argv[1] + 'Modified.csv'
outFile = 'results/' + sys.argv[1] + 'EnsemblePredictions.tsv'
classOne = sys.argv[2]
classTwo = sys.argv[3]

dataResults = pd.read_csv (resultsFile, sep = '\t')
ogData = pd.read_csv (originalDataFile)

listOfClassifiers = dataResults["Classifier"].unique()
##listOfClassifiers = ["RandomForest", "LogisticRegression", "KNeighbors", "AutoSklearn", "LCA"]
elementsPerClassifier = int(len(dataResults)/len(listOfClassifiers))

def combinedFunction ():
    listAvg = []
    listMajority = []
    listMax = []

    for x in range(elementsPerClassifier) :
        rowNum = dataResults.iloc[x]["OriginalRow"]
        iteration = dataResults.iloc[x]["Iteration"]
        avgPredictions = []
        majorityPredictions = []
        maxPredictions = []

        for i in range(len(dataResults)):
            row = dataResults.iloc[i]

            if(str(row['OriginalRow']) == str(rowNum)) : 
                if(str(row['Iteration']) == str(iteration)) :

                    avgPredictions.append(row['PredictionScore'])
                    maxPredictions.append(row['PredictionScore'])  
                    majorityPredictions.append(row['PredictionScore'])

                    if(row['PredictionScore'] >= 0.5) :
                        majorityPredictions.append(int(classOne))
                    else :
                        majorityPredictions.append(int(classTwo)) 

        predictionEdits = [abs(val - 0.5) for val in maxPredictions]
        maxVal = max(predictionEdits)
        maxIndex = predictionEdits.index(maxVal)

        listMax.append(maxPredictions[maxIndex])
        listMajority.append(statistics.mean(majorityPredictions)) 
        listAvg.append(statistics.mean(avgPredictions))

    print("Creating TSV file...")
    with open(outFile, "w") as tsvFile:
        print("writing to " + outFile)
        tsvFile.write("OriginalRow\tTarget\tIteration\tClassifier\tPredictionType\tPredictionScore\tPrediction\n")
    
        for x in range(elementsPerClassifier) :
            row = dataResults.iloc[x]

            avgPreditionClass = 0
            majorityPreditionClass = 0
            maxPreditionClass = 0

            #Assigns the class prediction based on the prediction score 
            if listAvg[x] >= 0.5:
                avgPreditionClass = classOne
            else:
                avgPreditionClass = classTwo
            if listMajority[x] >= 0.5:
                majorityPreditionClass = classOne
            else:
                majorityPreditionClass = classTwo
            if listMax[x] >= 0.5:
                maxPreditionClass = classOne
            else:
                maxPreditionClass = classTwo
            
            tsvFile.write(str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("AvgPrediction")+'\t'+str("BasicEnsemble")+'\t'+str(listAvg[x])+'\t'+str(avgPreditionClass)+'\n')
            tsvFile.write(str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("MajorityVote")+'\t'+str("BasicEnsemble")+'\t'+str(listMajority[x])+'\t'+str(majorityPreditionClass)+'\n')
            tsvFile.write(str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("ExtremeProb")+'\t'+str("BasicEnsemble")+'\t'+str(listMax[x])+'\t'+str(maxPreditionClass)+'\n')

combinedFunction()       
    
# Code to find each individual ensemble approach 
def avgPredition():
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
                        predictions.append(classOne)
                    else :
                        predictions.append(classTwo)
          
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
        
        predictionEdits = [abs(val - 0.5) for val in predictions]
        maxVal = max(predictionEdits)
        maxIndex = predictionEdits.index(maxVal)
        list.append(predictions[maxIndex])

    return list

def createTSVFile () :
    listavg = avgPredition()
    listmajority = majorityVote()
    listmax = maxProb()

    print("Creating TSV file...")
    with open(outFile, "w") as tsvFile:
        print("writing to " + outFile)
        tsvFile.write("OriginalRow\tTarget\tIteration\tClassifier\tPredictionType\tPredictionScore\tPrediction\n")
    
        for x in range(elementsPerClassifier) :
            row = dataResults.iloc[x]

            avgPreditionClass = 0
            majorityPreditionClass = 0
            maxPreditionClass = 0

            #Assigns the class prediction based on the prediction score 
            if listavg[x] >= 0.5:
                avgPreditionClass = classOne
            else:
                avgPreditionClass = classTwo
            if listmajority[x] >= 0.5:
                majorityPreditionClass = classOne
            else:
                majorityPreditionClass = classTwo
            if listmax[x] >= 0.5:
                maxPreditionClass = classOne
            else:
                maxPreditionClass = classTwo
            
            tsvFile.write(str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+ str("BasicEnsemble")+'\t'+str("AvgPrediction")+'\t'+str(listavg[x])+'\t'+str(avgPreditionClass)+'\n')
            tsvFile.write(str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+ str("BasicEnsemble")+'\t'+str("MajorityVote")+'\t'+str(listmajority[x])+'\t'+str(majorityPreditionClass)+'\n')
            tsvFile.write(str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+ str("BasicEnsemble")+'\t'+str("ExtremeProb")+'\t'+str(listmax[x])+'\t'+str(maxPreditionClass)+'\n')
            
#avgPredition()
#majorityVote()
#maxProb()        
#createTSVFile()
 
