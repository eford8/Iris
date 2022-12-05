import csv
import numpy as np
import pandas as pd

## Takes the original data and create a modified csv file 

def irisDataInitialization () :
    #Read in the Date from the csv file using Pandas 
    print("Initializing Iris Data\n")

    fileName = "data/iris.csv"
    df = pd.read_csv(fileName)
    columnNames = list(df.columns)

    print('List of column names : ', columnNames)
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
    
    newColumnNames = list(newdf.columns)
    #sepallength, sepalwidth, petallength, petalwidth, target 

    print(newdf.head())
    #Create a modified csv file for the modified data
    newdf.to_csv("data/irisModified.csv", index = False)

irisDataInitialization()

########## general function for initialization ###########

def generalInitialization(dataType) :
    #Read in the data from the tsv file using Pandas 
    print("Initializing " + dataType + "\n")

    fileName = "data/" + dataType + ".tsv"
    df = pd.read_csv(fileName, sep='\t', header=0) #dataframe

    columnNames = list(df.columns)
    print(df.head())

    #Create a modified csv file for the modified data
    newFileName = "data/" + dataType + "Modified.csv"
    df.to_csv(newFileName, index = False)

def horseColicInitialization(dataType) :
    #Read in the data from the tsv file using Pandas
    print("Initializing " + dataType + "\n")

    fileName = "data/" + dataType + ".tsv"
    df = pd.read_csv(fileName, sep='\t', header=0) #dataframe

    columnNames = list(df.columns)
    print(df.head())

    #Changing the "1" --> "0" and the "2" --> "1"
    df.loc[df["target"] == 1, "target"] = 0
    df.loc[df["target"] == 2, "target"] = 1

    #Create a modified csv file for the modified data
    newFileName = "data/" + dataType + "Modified.csv"
    df.to_csv(newFileName, index = False)

def gseBreastInitialization(dataType, targetType, target1, target2) :

    #Read in the data from the tsv file using Pandas
    print("Initializing " + dataType + "\n")

    fileName = "data/" + dataType + ".txt"
    clinical_filename = "data/" + dataType + "_Clinical.txt" 
    df = pd.read_csv(fileName, sep='\t', header=0) #dataframe
    clinical = pd.read_csv(clinical_filename, sep='\t', header=0)
    print('Here')
    print(df)
    print("again")
    print(clinical)
    target_column = clinical[["SampleID", targetType]]
    target_column.dropna(inplace=True)
    print(target_column)
    newdf = df.merge(target_column, on="SampleID", how="inner")
    newdf.rename(columns={targetType :"target"}, inplace = True)
    newdf.pop('SampleID')

    columnNames = list(newdf.columns)
    print(columnNames)
    print(newdf["target"])

    #Changing the "1" --> "0" and the "2" --> "1"
    newdf.loc[newdf["target"] == target1, "target"] = 0
    newdf.loc[newdf["target"] == target2, "target"] = 1

    #df[~((df["target"] != 0) and (df["target"] != 1))]
        

    #Create a modified csv file for the modified data
    newFileName = "data/" + dataType + targetType +"Modified.csv"
    newdf.to_csv(newFileName, index = False)

gseBreastInitialization("GSE2109_Breast", "Histology", "Ductal Carcinoma", "Lobular Carcinoma")
gseBreastInitialization("GSE2109_Breast", "Pathological_HER2_Neu", "Positive", "Negative")
gseBreastInitialization("GSE2109_Breast", "Pathological_ER", "Positive", "Negative")

gseBreastInitialization("GSE2109_Colon", "Pathological_M", "0", "1")
gseBreastInitialization("GSE2109_Colon", "Histology", "Adenocarcinoma", "Mucinous Carcinoma")
gseBreastInitialization("GSE2109_Colon", "Family_History_of_Cancer", "Yes", "No")
generalInitialization("breast")
generalInitialization("horse_colic")
horseColicInitialization("horse_colic")
generalInitialization("Gametes_Epistasis")
generalInitialization("magic")
generalInitialization("hypothyroid")

