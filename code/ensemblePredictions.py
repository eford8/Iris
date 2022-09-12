import pandas as pd 
import sys
import statistics
import os

#################
## This file take the files created from classify.py and finds the averageProb, majorityVote, and maxProb
## It is a basic emsemble 
#################

#resultsFile = 'results/' + sys.argv[1] + sys.argv[2] + 'Classifications.tsv'
resultsFile = 'results/Classifications.tsv'
#originalDataFile = 'data/' + sys.argv[1] + 'Modified.csv'
#outFile = 'results/' + sys.argv[1] + sys.argv[2] + 'EnsemblePredictions.tsv'
outFile = 'results/Classifications.tsv'
classOne = sys.argv[1]
classTwo = sys.argv[2]

dataResults = pd.read_csv (resultsFile, sep = '\t')
#dataResults = dataResults[Classifier in listOfClassifiers]
#ogData = pd.read_csv (originalDataFile)

#listOfClassifiers = dataResults["Classifier"].unique()
listOfClassifiers = ["RandomForest", "LogisticRegression", "SVC", "KNeighbors"]
dataResults = dataResults[dataResults.Classifier.isin(listOfClassifiers)]
#elementsPerClassifier = int(len(dataResults)/len(listOfClassifiers))

def combinedFunction (dataName):
    originalDataFile = 'data/' + dataName + 'Modified.csv'
    ogData = pd.read_csv (originalDataFile)
    singleData = dataResults[dataResults["DataName"] == dataName]
    elementsPerClassifier = int(len(singleData)/len(listOfClassifiers))
    listAvg = []
    listMajority = []
    listMax = []

    for x in range(elementsPerClassifier) :
        rowNum = singleData.iloc[x]["OriginalRow"]
        iteration = singleData.iloc[x]["Iteration"]
        averageProb = []
        majorityPredictions = []
        maxPredictions = []

        for i in range(len(singleData)):
            row = singleData.iloc[i]

            if(str(row['OriginalRow']) == str(rowNum)) : 
                if(str(row['Iteration']) == str(iteration)) :

                    averageProb.append(row['PredictionScore'])
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
        listAvg.append(statistics.mean(averageProb))

    print("Creating TSV file...")
    if not os.path.exists(outFile):
        with open(outFile, "w") as tsvFile:
            print("writing to " + outFile)
            tsvFile.write("DataName\tOriginalRow\tTarget\tIteration\tClassifier\tPredictionType\tPredictionScore\tPrediction\n")
    
    with open(outFile, 'a') as tsvFile:
        for x in range(elementsPerClassifier) :
            row = singleData.iloc[x]

            averageProbClass = 0
            majorityPreditionClass = 0
            maxPreditionClass = 0

            #Assigns the class prediction based on the prediction score 
            if listAvg[x] >= 0.5:
                averageProbClass = classOne
            else:
                averageProbClass = classTwo
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
            tsvFile.write(dataName+'\t'+str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("AverageProb")+'\t'+ensembleType+'\t'+str(listAvg[x])+'\t'+str(averageProbClass)+'\n')
            tsvFile.write(dataName+'\t'+str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("MajorityVote")+'\t'+ensembleType+'\t'+str(listMajority[x])+'\t'+str(majorityPreditionClass)+'\n')
            tsvFile.write(dataName+'\t'+str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("ExtremeProb")+'\t'+ensembleType+'\t'+str(listMax[x])+'\t'+str(maxPreditionClass)+'\n')

#for dataName in dataResults["DataName"].unique():
combinedFunction("magic")   #dataName

