import pandas as pd 
import sys
import statistics
import os
import time

#################
## This file take the files created from classify.py and finds the averageProb, majorityVote, and maxProb
## It is a basic emsemble 
#################


resultsFile = 'results/Classifications.tsv'
outFile = 'results/Classifications.tsv'
classOne = sys.argv[1]
classTwo = sys.argv[2]

dataResults = pd.read_csv (resultsFile, sep = '\t')

listOfClassifiers = ["RandomForest", "LogisticRegression", "SVC", "KNeighbors"]
dataResults = dataResults[dataResults.Classifier.isin(listOfClassifiers)]
#elementsPerClassifier = int(len(dataResults)/len(listOfClassifiers))

def combinedFunction (dataName):
    originalDataFile = 'data/' + dataName + 'Modified.csv'
    ogData = pd.read_csv (originalDataFile)
    singleData = dataResults[dataResults["DataName"] == dataName]
    elementsPerClassifier = int(len(singleData)/len(listOfClassifiers))
    listMean = []
    listMajority = []
    listMax = []
    listTime = []   #Added for keeping track of the time
    print("Running ensemble predictions for " + dataName + " dataset....")

    for x in range(elementsPerClassifier) :
        rowNum = singleData.iloc[x]["OriginalRow"]
        iteration = singleData.iloc[x]["Iteration"]
        classifyTime = 0
        meanProb = []
        majorityPredictions = []
        maxPredictions = []

        
        for i in range(len(singleData)):
            row = singleData.iloc[i]
                        
            if(str(row['OriginalRow']) == str(rowNum)) : 
                if(str(row['Iteration']) == str(iteration)) :

                    meanProb.append(row['PredictionScore'])
                    maxPredictions.append(row['PredictionScore'])  
                    majorityPredictions.append(row['PredictionScore'])
                    
                    classifyTime = classifyTime + row['Time']

                    if(row['PredictionScore'] >= 0.5) :
                        majorityPredictions.append(int(classOne))
                    else :
                        majorityPredictions.append(int(classTwo)) 

        predictionEdits = [abs(val - 0.5) for val in maxPredictions]
        maxVal = max(predictionEdits)
        maxIndex = predictionEdits.index(maxVal)

        listMax.append(maxPredictions[maxIndex])
        listMajority.append(statistics.mean(majorityPredictions)) 
        listMean.append(statistics.mean(meanProb))

        #record end time
        end = time.time()

        listTime.append(classifyTime)

    print("Creating TSV file...")
    if not os.path.exists(outFile):
        with open(outFile, "w") as tsvFile:
            print("writing to " + outFile)
            tsvFile.write("DataName\tOriginalRow\tTarget\tIteration\tClassifier\tPredictionType\tPredictionScore\tPrediction\tTime\n")
    
    with open(outFile, 'a') as tsvFile:
        for x in range(elementsPerClassifier) :
            row = singleData.iloc[x]

            meanProbClass = 0
            majorityPreditionClass = 0
            maxPreditionClass = 0

            #Assigns the class prediction based on the prediction score 
            if listMean[x] >= 0.5:
                meanProbClass = classOne
            else:
                meanProbClass = classTwo
            if listMajority[x] >= 0.5:
                majorityPreditionClass = classOne
            else:
                majorityPreditionClass = classTwo
            if listMax[x] >= 0.5:
                maxPreditionClass = classOne
            else:
                maxPreditionClass = classTwo
            
            ensembleType = "BasicEnsemble"
            #if(sys.argv[2] == "Weighted"):
            #    ensembleType = "WeightedEnsemble"

            tsvFile.write(dataName+'\t'+str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("MeanProb")+'\t'+ensembleType+'\t'+str(listMean[x])+'\t'+str(meanProbClass)+'\t'+str(listTime[x])+'\n')
            tsvFile.write(dataName+'\t'+str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("MajorityVote")+'\t'+ensembleType+'\t'+str(listMajority[x])+'\t'+str(majorityPreditionClass)+'\t'+str(listTime[x])+'\n')
            tsvFile.write(dataName+'\t'+str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("ExtremeProb")+'\t'+ensembleType+'\t'+str(listMax[x])+'\t'+str(maxPreditionClass)+'\t'+str(listTime[x])+'\n')

for dataName in dataResults["DataName"].unique():
    combinedFunction(dataName)

#combinedFunction("iris")   #dataName
#combinedFunction("breast")
#combinedFunction("horse_colic")
#combinedFunction("Gametes_Epistasis")
#combinedFunction("magic")
#combinedFunction("hypothyroid")

