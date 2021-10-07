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

#Write a separate Python script that parses the TSV file and calculates the classification accuracy 
#for each of the three algorithms and prints this to the screen. 
#In other words, how frequently did the predictions ("versicolor" or "virginica") coincide with the actual species.
 
resultsFile = "DATA/irisClassifications.tsv"
origionalData = "DATA/irisModified.csv"
outfile = "DATA/classificationAccuracy.tsv"

# check if size of file is 0 checking if it is empty or not
if os.stat(resultsFile).st_size == 0:
    print('File is empty')
else:
    print('File is not empty')

dataResults = pd.read_csv (resultsFile, sep = '\t')
ogData = pd.read_csv (origionalData)
classifierList = ["RandomForest", "LogisticRegression", "KNeighbors"]

with open(outfile, "w") as tsvFile:
    tsvFile.write("Iteration\tClassifier\tClassificationAccurayScore\n")

    #####################
    #We should probably make this more efficient so that it can be automated for any number of classifiers and iterations
    # #################### 

    for typeClassifier in classifierList:
        rowCounter = 0
        foldOneCounter = 0
        foldTwoCounter = 0
        foldThreeCounter = 0
        foldFourCounter = 0
        foldFiveCounter = 0
        TOTAINTERATIONS = 20
        TOTALSAMPLES = 100
        
        #just go throught all the rows that contain the classifier than we want
        for row in dataResults["Classifier"]:
            #compares the tClassifier to the type we are looking for
            if row == typeClassifier:
                #get orginal row number
                ogRowNum = dataResults["OrigionalRow"].iloc[rowCounter]

                #Find out if the orginal flower is versicolor or virginica
                classType = ogData["class"].iloc[ogRowNum]

                #find the cross-validationFold
                interationNum = dataResults["Iteration"].iloc[rowCounter]

                #compare classifier result with real result for each fold
                if interationNum == 1:
                    if dataResults["Prediction"].iloc[rowCounter] == classType:
                        foldOneCounter += 1
                if interationNum == 2:
                    if dataResults["Prediction"].iloc[rowCounter] == classType:
                        foldTwoCounter += 1
                if interationNum == 3:
                    if dataResults["Prediction"].iloc[rowCounter] == classType:
                        foldThreeCounter += 1
                if interationNum == 4:
                    if dataResults["Prediction"].iloc[rowCounter] == classType:
                        foldFourCounter += 1
                if interationNum == 5:
                    if dataResults["Prediction"].iloc[rowCounter] == classType:
                        foldFiveCounter += 1
                
            rowCounter += 1

        classificationAccuracy = (foldOneCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for iteration one is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(1), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldTwoCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for iteration two is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(2), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldThreeCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for iteration three is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(3), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldFourCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for interation four is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(4), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldFiveCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for iteration five is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(5), typeClassifier, str(classificationAccuracy)]) + '\n')
          
 