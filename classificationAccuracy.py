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
 
irisDataResults = "DATA/irisData.tsv"
ogIrisData = "DATA/irisModified.csv"

# check if size of file is 0 checking if it is empty or not
if os.stat(irisDataResults).st_size == 0:
    print('File is empty')
else:
    print('File is not empty')

dataResults = pd.read_csv (irisDataResults, sep = '\t')
ogData = pd.read_csv (ogIrisData)
classifierList = ["RandomForest", "LogisticRegression", "KNeighbors"]

with open("DATA/classificationAccuracy.tsv", "w") as tsvFile:
    tsvFile.write("interationNumber\tClassifier\tclassificationAccuraySorce\n")

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
        for row in dataResults["tClassifier"]:
            #compares the tClassifier to the type we are looking for
            if row == typeClassifier:
                #get orginal row number
                ogRowNum = dataResults["ogRowNum"].iloc[rowCounter]

                #Find out if the orginal flower is versicolor or virginica
                flowerType = ogData["class"].iloc[ogRowNum]

                #find the cross-validationFold
                interationNum = dataResults["cross-validationFold"].iloc[rowCounter]

                #compare classifier result with real result for each fold
                if interationNum == 1:
                    if dataResults["prediction"].iloc[rowCounter] == flowerType:
                        foldOneCounter += 1
                if interationNum == 2:
                    if dataResults["prediction"].iloc[rowCounter] == flowerType:
                        foldTwoCounter += 1
                if interationNum == 3:
                    if dataResults["prediction"].iloc[rowCounter] == flowerType:
                        foldThreeCounter += 1
                if interationNum == 4:
                    if dataResults["prediction"].iloc[rowCounter] == flowerType:
                        foldFourCounter += 1
                if interationNum == 5:
                    if dataResults["prediction"].iloc[rowCounter] == flowerType:
                        foldFiveCounter += 1
                
            rowCounter += 1

        classificationAccuracy = (foldOneCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for interation one is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(1), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldTwoCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for interation two is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(2), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldThreeCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for interation three is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(3), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldFourCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for interation four is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(4), typeClassifier, str(classificationAccuracy)]) + '\n')

        classificationAccuracy = (foldFiveCounter / TOTAINTERATIONS)
        print("Classification accuracy for " + typeClassifier + " for interation five is: " + str(classificationAccuracy))
        tsvFile.write('\t'.join([str(5), typeClassifier, str(classificationAccuracy)]) + '\n')
          
 