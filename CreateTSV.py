import csv
import numpy as np
import pandas as pd


#Modify the script so that it creates a TSV file that is clearly named (indicates that it's for the iris data). 

with open("DATA/irisData.tsv", "w") as tsvFile:
    tsv_writer = csv.writer(tsvFile, delimiter='\t', lineterminator='\n')
    #tsv_writer.writerow(["Word", "Count"])
    # columns = ["ogRomNum", "prbVersiClassifierOne", "prbVersiClassifierTwo", "prbVersiClassifierThree", "versi/virgincia", "cross-validationFold"]

#It should have columns that indicate the original row number of each iris flower and the probability that each flower is versicolor (for each of the three classifiers). 
#It should also have columns that indicate "versicolor" if the probability for a given classifier was >= 0.5 or "virginica" if the probability was < 0.5. 
#Name these columns descriptively. Each row should indicate which cross-validation fold each flower was used in the test set.



#Write a separate Python script that parses the TSV file and calculates the classification accuracy 
#for each of the three algorithms and prints this to the screen. 
#In other words, how frequently did the predictions ("versicolor" or "virginica") coincide with the actual species.

irisData = "DATA/irisData.tsv"

print("Classification accuracy for Random Forests classifier: ")

print("Classification accuracy for LogisticRegression: ")

print("Classification accuracy for k-nearest neighbors: ")