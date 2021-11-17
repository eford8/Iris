import csv
import numpy as np
import pandas as pd

## Takes the original data and create a modified csv file 

def irisDataInitialization () :

    #Read in the Date from the csv file using Pandas 
    print("Initializing Iris Data\n")
    fileName = "data/iris.csv"
    df = pd.read_csv(fileName)
    list_of_column_names = list(df.columns)
    print('List of column names : ',list_of_column_names)
    print(df)

    #Modify the script so that it only includes flowers from the versicolor and virginica (and the header line). 
    #For simplicity, we will ignore the setosa species.

    newdf = df[(df["class"] != "Iris-setosa")]
    print("The number of lines that are not Iris-setosa: " + str(len(newdf)))

    #if versicolor, class == 1
    #if not versicolor (then it would be virginica), class == 0
    target = []
    for type in newdf["class"]:
        if  type == "Iris-versicolor":
            target.append(1)
        else:
            target.append(0)

    newdf["target"] = target
    del newdf['class']
    
    new_list_of_column_names = list(newdf.columns)
    #sepallength, sepalwidth, petallength, petalwidth, target 

    print(newdf.head())
    #Create a modified csv file for the modified data
    newdf.to_csv("data/irisModified.csv", index = False)

irisDataInitialization()

########## general function for initialization ###########
def generalInitialization(dataType) :
    #Read in the Date from the tsv file using Pandas 
    print("Initializing " + dataType + "\n")
    fileName = "data/" + dataType + ".tsv"
    df = pd.read_csv(fileName, sep='\t', header=0) #dataframe
    list_of_column_names = list(df.columns)
    #print('List of column names : ', list_of_column_names)
    print(df.head())

    #Create a modified csv file for the modified data
    newFileName = "data/" + dataType + "Modified.csv"
    df.to_csv(newFileName, index = False)

generalInitialization("breast")
generalInitialization("horse_colic")
generalInitialization("Gametes_Epistasis")
generalInitialization("magic")


