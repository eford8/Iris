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



fileName = "DATA/irismodified.csv"

def cross_validate(df, labels, clf) :
    X = df
    y = labels
    y = y.astype('int')
    #print(XX.shape)
    #print(y.shape)

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

    for train_index, test_index in sss.split(X, y):
        iteration += 1
        #print("TRAIN:", train_index, "TEST:", test_index)
        classifier.fit(X[train_index], y[train_index])
        probabilities = classifier.predict_proba(X[test_index])
        probs = np.vstack([probs, probabilities])
        print("Probabilities")
        print(probabilities)
        #Find the rocaucscore
        rocaucscores = roc_auc_score(y, classifier.predict_proba(X)[:, 1])
        auc_roc_scores.append(rocaucscores)
        print("roc scores")
        print(rocaucscores)
    
    print(probs.shape)
    print(auc_roc_scores)
    return probs, auc_roc_scores
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
    scores, auc_scores = cross_validate(data, predictColumn, classifier)
    for score in scores:
        classifier_name = str(classifier[0]).split("'")[1].split(".")[-1].replace("Classifier", "")
        results.append([classifier_name, "labels", str(score)])

print("scores")
print(results)


#Modify the script so that it creates a TSV file that is clearly named (indicates that it's for the iris data). 
def createTSV(results):
    print("createTSV function called")
    with open("DATA/irisData.tsv", "w") as tsvFile:
        #It should have columns that indicate the original row number of each iris flower and the probability that each flower is versicolor (for each of the three classifiers). 
        #It should also have columns that indicate "versicolor" if the probability for a given classifier was >= 0.5 or "virginica" if the probability was < 0.5. 
        #Name these columns descriptively. Each row should indicate which cross-validation fold each flower was used in the test set.
        tsvFile.write("ogRomNum\tprbVersiRandomForest\tprbVersiLogReg\tprbVersiKNeighbor\tversi/virgincia\tcross-validationFold\n")

#Calling the createTSV function
#createTSV(results)

#Write a separate Python script that parses the TSV file and calculates the classification accuracy 
#for each of the three algorithms and prints this to the screen. 
#In other words, how frequently did the predictions ("versicolor" or "virginica") coincide with the actual species.
def calClassificationAccuracy (results):
    irisData = "DATA/irisData.tsv"
    #with open(irisData, "w") as tsvFile:
     #   for row in tsvFile:
      #      print(row)

    print("Classification accuracy for Random Forests classifier: ")
    print("Classification accuracy for LogisticRegression: ")
    print("Classification accuracy for k-nearest neighbors: ")

#Calling the calClassificationAccuracy Function
#calClassificationAccuracy(results)


