import pandas as pd 
import sys
import statistics

#################
## This file take the files created from classify.py and finds the averageProb, majorityVote, and maxProb
## It is a basic emsemble 
#################

resultsFile = 'results/' + sys.argv[1] + 'Classifications_2.tsv'
originalDataFile = 'data/' + sys.argv[1] + 'Modified.csv'
outFile = 'results/' + sys.argv[1] + 'EnsemblePredictions_2.tsv'
classOne = sys.argv[2]
classTwo = sys.argv[3]

dataResults = pd.read_csv (resultsFile, sep = '\t')
ogData = pd.read_csv (originalDataFile)

listOfClassifiers = dataResults["Classifier"].unique()
elementsPerClassifier = int(len(dataResults)/len(listOfClassifiers))

def combinedFunction ():
    listAvg = []
    listMajority = []
    listMax = []

    for x in range(elementsPerClassifier) :
        rowNum = dataResults.iloc[x]["OriginalRow"]
        iteration = dataResults.iloc[x]["Iteration"]
        averageProb = []
        majorityPredictions = []
        maxPredictions = []

        for i in range(len(dataResults)):
            row = dataResults.iloc[i]

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
    with open(outFile, "w") as tsvFile:
        print("writing to " + outFile)
        tsvFile.write("DataName\tOriginalRow\tTarget\tIteration\tClassifier\tPredictionType\tPredictionScore\tPrediction\n")
    
        for x in range(elementsPerClassifier) :
            row = dataResults.iloc[x]

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
            
            tsvFile.write(str(sys.argv[1])+'\t'+str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("AverageProb")+'\t'+str("BasicEnsemble")+'\t'+str(listAvg[x])+'\t'+str(averageProbClass)+'\n')
            tsvFile.write(str(sys.argv[1])+'\t'+str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("MajorityVote")+'\t'+str("BasicEnsemble")+'\t'+str(listMajority[x])+'\t'+str(majorityPreditionClass)+'\n')
            tsvFile.write(str(sys.argv[1])+'\t'+str(row["OriginalRow"])+'\t'+str(row["Target"])+'\t'+str(row["Iteration"])+"\t"+str("ExtremeProb")+'\t'+str("BasicEnsemble")+'\t'+str(listMax[x])+'\t'+str(maxPreditionClass)+'\n')

combinedFunction()      
