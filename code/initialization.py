import csv
import numpy as np
import pandas as pd


def irisDataInitialization () :

    #Read in the Date from the csv file using Pandas 
    print("Initializing Iris Data\n")
    fileName = "data/iris.csv"
    df = pd.read_csv(fileName)
    list_of_column_names = list(df.columns)
    print('List of column names : ',list_of_column_names)
    print(df)

    #Modify the script so that it only includes flowers from the versicolor and virginica (and the header line). 
    #For simplicity, we will ignore the setosa species for now.

    newdf = df[(df["class"] != "Iris-setosa")]
    print(newdf.head())
    print("The number of lines that are not Iris-setosa: " + str(len(newdf)))

    #if versicolor, class == 1
    #if not versicolor (then it would be virginica), class == 0
    lables = []
    for type in newdf["class"]:
        if  type == "Iris-versicolor":
            lables.append(1)
        else:
            lables.append(0)

    newdf["lables"] = lables


    new_list_of_column_names = list(newdf.columns)
    print(new_list_of_column_names)
    #sepallength, sepalwidth, petallength, petalwidth, class, lables 

    #Create a modified csv file for the modified data
    newdf.to_csv("data/irisModified.csv", index = False)
    #modifiedDate = "data/irisModified.csv"

#irisDataInitialization()


####### BREAST DATA ############

def breastDataInitialization () :
    #Read in the Date from the tsv file using Pandas 
    print("Initializing Breast Data\n")
    fileName = "breast.tsv"
    df = pd.read_csv(fileName, sep='\t', header=0) #dataframe
    list_of_column_names = list(df.columns)
    print('List of column names : ', list_of_column_names)
    print(df.head())

    #Create a modified csv file for the modified data
    df.to_csv("breast.csv", index = False)
    modifiedDate = "breast.csv"

##breastDataInitialization() 

######## HORSE COLIC DATA #############
def horseColicInitialization() :
    #Read in the Date from the tsv file using Pandas 
    print("Initializing horse colic\n")
    fileName = "horse_colic.tsv"
    df = pd.read_csv(fileName, sep='\t', header=0) #dataframe
    list_of_column_names = list(df.columns)
    print('List of column names : ', list_of_column_names)
    print(df.head())

    #Create a modified csv file for the modified data
    df.to_csv("horse_colic.csv", index = False)
    modifiedDate = "horse_colic.csv"

##horseColicInitialization()

########## MAGIC DATA ################
def magicDataInitialization() :
    #Read in the Date from the tsv file using Pandas 
    print("Initializing magic data\n")
    fileName = "magic.tsv"
    df = pd.read_csv(fileName, sep='\t', header=0) #dataframe
    list_of_column_names = list(df.columns)
    print('List of column names : ', list_of_column_names)
    print(df.head())

    #Create a modified csv file for the modified data
    df.to_csv("magic.csv", index = False)
    modifiedDate = "magic.csv"

##magicDataInitialization()

############### GAMETE EPISTASIS ###############
def gameteEpistasisInitialization() :
    #Read in the Date from the tsv file using Pandas 
    print("Initializing magic data\n")
    fileName = "Gametes_Epistasis.tsv"
    df = pd.read_csv(fileName, sep='\t', header=0) #dataframe
    list_of_column_names = list(df.columns)
    print('List of column names : ', list_of_column_names)
    print(df.head())

    #Create a modified csv file for the modified data
    df.to_csv("Gametes_Epistasis.csv", index = False)
    modifiedDate = "Gametes_Epistasis.csv"

##gameteEpistasisInitialization()

########## general function for initialization ###########
def generalInitialization(dataType) :
    #Read in the Date from the tsv file using Pandas 
    print("Initializing " + dataType + "\n")
    fileName = "data/" + dataType + ".tsv"
    df = pd.read_csv(fileName, sep='\t', header=0) #dataframe
    list_of_column_names = list(df.columns)
    print('List of column names : ', list_of_column_names)
    print(df.head())

    #Create a modified csv file for the modified data
    newFileName = "data/" + dataType + "Modified.csv"
    df.to_csv(newFileName, index = False)
    #modifiedDate = newFileName

generalInitialization("breast")
generalInitialization("horse_colic")
generalInitialization("Gametes_Epistasis")
generalInitialization("magic")


