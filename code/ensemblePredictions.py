import pandas as pd 

#################
## This file take the files created from classificationAccuracy.py and finds the avgPredition, majorityVote, and maxProb
#################

listOfDataTypes = ["iris", "breast", "horse_colic", "Gametes_Epistasis", "magic"]
resultsFileList = ["results/irisClassifications.tsv", "results/breastClassification.tsv", "results/horse_colicClassification.tsv", "results/Gametes_EpistasisClassification.tsv", "results/magicClassification.tsv"]
origionalDataFileList = ["data/irisModified.csv", "data/breastModified.csv", "data/horse_colicModified.csv", "data/Gametes_EpistasisModified.csv", "data/magicModified.csv"]

#file created from classificationAccuracy.py
classificationAccuracy = "results/classificationAccuracy.tsv"

#file to be created after running ensemblePredictions
outfile = "results/ensemblePredictions.tsv"


#make a for loop that does this five times, for each type of data
for resultsFile in resultsFileList:
    dataResults = pd.read_csv (resultsFile, sep = '\t')
    for ogdataFile in origionalDataFileList:
        ogData = pd.read_csv (ogdataFile)

# break up the tsv file into three different files/dataframes  ######instead of doing this, use a for loop
#randomForestData = dataResults[0:100] 
#logisticRegressionData = dataResults[100:200]
#KNeighborsData = dataResults[200:300]

listOfClassifiers = ["randomForest", "logisticRegression", "KNeighbors"]

#for classifier in listOfClassifiers:
#    for row in dataResults:
#        if row.whatever == classifier:
#            then.......



def avgPredition():
    print("This function takes the three preditions from each classifier and finds the avg.")
    list = []
    for x in range(0, 100):
        preditionOne = randomForestData.iloc[x, 2]
        preditionTwo = logisticRegressionData.iloc[x, 2]
        preditionThree = KNeighborsData.iloc[x, 2]
        avg = (preditionOne + preditionTwo + preditionThree) / 3
        list.append(avg)
    return list


def majorityVote():
    #majoirty vote = if two or more says it is the class
    #2/3 prob for veriscolor
    #3/3 prob or 0/3 = 0 versicolor
    print("This function find the majority vote.")
    list = []
    for x in range(0, 100):
        preditionOne = randomForestData.iloc[x, 3]
        preditionTwo = logisticRegressionData.iloc[x, 3]
        preditionThree = KNeighborsData.iloc[x, 3]
        count = 0 
        if preditionOne == "Iris-versicolor":
            count += 1
        if preditionTwo == "Iris-versicolor":
            count += 1
        if preditionThree == "Iris-versicolor":
            count += 1

        majority = count /3
        #print("The majority vote is: " + str(count)  + "/3")
        list.append(majority)
    return list


def maxProb():
    print("This function find which classifier has the highest prob.")
    list = []
    for x in range(0, 100):
        preditionOne = randomForestData.iloc[x, 2]
        preditionTwo = logisticRegressionData.iloc[x, 2]
        preditionThree = KNeighborsData.iloc[x, 2]

        #find the greatest distance away from point five
        #find the aboulste value of # - 0.5
        #ex: 09 - 05 = 04
        #ex: 01 - 05  = 04

        preditionOne = abs(preditionOne - 0.5)
        preditionTwo = abs(preditionTwo - 0.5)
        preditionThree = abs(preditionThree - 0.5)


        if preditionOne > preditionTwo:
            if preditionOne > preditionThree:
                highestPredition = randomForestData.iloc[x, 2]
            else:
                highestPredition = KNeighborsData.iloc[x, 2]
        if preditionTwo > preditionOne:
            if preditionTwo > preditionThree:
                highestPredition = logisticRegressionData.iloc[x, 2]
            else:
                highestPredition = KNeighborsData.iloc[x, 2]


        #print("The classifier with the highest prediction is: " + highestPredition)
        list.append(highestPredition)
    return(list)


listavg = avgPredition()
listmajority = majorityVote()
listmax = maxProb()

#create a tsv file
with open(outfile, "w") as tsvFile:
    tsvFile.write("OrigionalRow\tClass\tAvgPredition\tMajorityVote\tMaxProb\n")
    for x in range(0, 100):
        tsvFile.write(str(dataResults.iloc[x, 0]) + '\t' + str(ogData["class"].iloc[dataResults.iloc[x, 0]]) + "\t" +  str(listavg[x]) + '\t' + str(listmajority[x]) + '\t' + str(listmax[x]) + '\n')


