import pandas as pd 
import numpy as np
import sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn.metrics import roc_auc_score
import random
import sys
import csv
import os



fileName = "DATA/irismodified.csv"

def cross_validate(df, labels, clf) :
    X = df
    y = labels
    y = y.astype('int')
    
    scoring_metric = "roc_auc"
    n_jobs = 2

    params = clf[1]
    if "random_state" in params:
        params["random_state"] = 1
    classifier = clf[0](**params)
    sss = StratifiedShuffleSplit(n_splits=5, test_size=0.2, random_state=1) 

    iteration = 0
    probs = np.array([]).reshape(0,2)
    auc_roc_scores = []
    scores = np.array([]).reshape(0,5)

    for train_index, test_index in sss.split(X, y):
        iteration += 1
        print("TRAIN:", train_index, "TEST:", test_index)
        classifier.fit(X[train_index], y[train_index])
        probabilities = classifier.predict_proba(X[test_index])
        probs = np.vstack([probs, probabilities])
        #print("Probabilities")
        #print(probabilities)

        #Find the rocaucscore
        rocaucscores = roc_auc_score(y, classifier.predict_proba(X)[:, 1])
        auc_roc_scores.append(rocaucscores)
        rows, columns = probabilities.shape

        #combine roc_auc score and iteration number to the probabilities 
        auc = np.zeros((rows,1))
        auc[:] = rocaucscores
        combined = np.insert(probabilities, 0, [iteration], axis=1)
        combined = np.append(combined, auc, axis=1)
        combined = np.insert(combined, 1, test_index, axis=1)
        scores = np.vstack([scores,combined])

    
    print(scores)
    return scores
    scores = []
    #for i in range(iterations) :
        #params = clf[1]
        #if "random_state" in params:
            #params["random_state"] = i
        
        #classifier = clf[0](**params)
        #classifier.fit(XX, y)
        #sys.exit()

        
        #skf = StratifiedKFold(n_splits=5, random_state=1, shuffle=True) # you could also say cv=3 in cross_val_score which would be the same thing
        #iterations_predictions = cross_val_predict(classifier, XX, y, method = "predict_proba", cv = skf, n_jobs = n_jobs)
        #iteration_scores = list(cross_val_score(classifier, XX, y, scoring = scoring_metric, cv=skf, n_jobs=n_jobs))
        #scores.append(sum(iteration_scores)/len(iteration_scores))

        #print(iteration_scores)
        #print(iterations_predictions)
        #print(len(iterations_predictions))
        #sys.exit()
    return scores
    


#iterations = 1

CLASSIFIERS = [
    (RandomForestClassifier, {"n_estimators": 100, "random_state" : 0}),
    (LogisticRegression, {"random_state" : 0}),
    (KNeighborsClassifier, {})
]

results = []
random.seed(1)


df = pd.read_csv(fileName).to_numpy()

# gets the data and seperates it from the labels
data = df[:, :3]
predictColumn = df[:, 5]


for classifier in CLASSIFIERS:
    for score in cross_validate(data, predictColumn, classifier):
        classifier_name = str(classifier[0]).split("'")[1].split(".")[-1].replace("Classifier", "")
        results.append([classifier_name, score[0], score[1], score[2], score[3], score[4]])

print("scores")
print(results)
## results are [classifier, iteration number, og row number, probability not virginica, probability virginica, roc score]


#Modify the script so that it creates a TSV file that is clearly named (indicates that it's for the iris data). 
def createTSV(results):
    print("createTSV function called")
    with open("DATA/irisData.tsv", "w") as tsvFile:
        #It should have columns that indicate the original row number of each iris flower and the probability that each flower is versicolor (for each of the three classifiers). 
        #It should also have columns that indicate "versicolor" if the probability for a given classifier was >= 0.5 or "virginica" if the probability was < 0.5. 
        #Name these columns descriptively. Each row should indicate which cross-validation fold each flower was used in the test set.
        tsvFile.write("ogRowNum\ttClassifier\tprobability of versicolor\tprediction\tcross-validationFold\n")
        rownum = 1
        for prediction in results:
            # checks probability of versicolor and makes prediction 
            predict = ""
            if(prediction[4] >= 0.5) :
                predict = "Iris-versicolor"
            else:
                predict = "Iris-virginica"
    
            tsvFile.write('\t'.join([str(int(prediction[2])), str(prediction[0]), str(prediction[4]), predict, str(int(prediction[1]))]) + '\n')
            #tsvFile.write(int(results[2]) + '\t' + results[0] + '\t' + results[4] + '\t' + "prediction" + '\t' + int(results[1]) + '\n')
        #example: 3 RandomForest 0.6    Versicolor  3
        #example: 5 LogReg 0.2 Virgincia 1


#Calling the createTSV function
createTSV(results)

#Write a separate Python script that parses the TSV file and calculates the classification accuracy 
#for each of the three algorithms and prints this to the screen. 
#In other words, how frequently did the predictions ("versicolor" or "virginica") coincide with the actual species.

#-------------------------------------------------------------
#I think part some of the errors I am receiving are due to a lack on data in the tsv file
#This is the fuction I have create. 


##def calClassificationAccuracy (results):
#    irisDataResults = "DATA/irisData.tsv"
#    ogIrisData = "DATA/irisModified.csv"
#    # check if size of file is 0 checking if it is empty or not
#    if os.stat(irisDataResults).st_size == 0:
#        print('File is empty')
#    else:
#        print('File is not empty')
#
#    dataResults = pd.read_csv (irisDataResults, sep = '\t')
#    ogData = pd.read_csv (ogIrisData)
#    classifierList = ["RandomForest", "LogReg", "Kneighbor"]
#    i = 0
#    while i < len(classifierList):
#        typeClassifier = classifierList[i]
#        counterCorrect = 0
#        totalSamples = 0
#
#       #just go throught all the rows that contain the classifier than we want
#       for rows in dataResults[(dataResults["typeClassifier"] == typeClassifier)]:
#           #get orginal row number
#            rowNum = dataResults.loc[(dataResults["ogRowNum"])]
#            #Find out if the flower is versicolor or virginica
#            flowerType = ogData["class"] 
#            print(flowerType)
#            #compare classifier result with real result
#            if dataResults["versi/virgincia"][rowNum] == flowerType:
#                counterCorrect = counterCorrect + 1
#                totalSamples = totalSamples + 1
#            else:
#                totalSamples = totalSamples + 1
#
#        i = i + 1
#        classificationAccuracy = (counterCorrect / totalSamples) * 100
#        print("Classification accuracy for " + typeClassifier + "is: " + classificationAccuracy)
       

#   #Calling the calClassificationAccuracy Function
#calClassificationAccuracy(results)

#------------------------------------------------------------------------
