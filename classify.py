import pandas as pd 
import numpy as np
import sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import StratifiedKFold, cross_val_score
import random
import sys



fileName = "DATA/irismodified.csv"

def cross_validate(df, labels, clf) :
    XX = df
    y = labels
    y = y.astype('int')
    #print(XX.shape)
    #print(y.shape)

    scoring_metric = "roc_auc"
    n_jobs = 5

    scores = []
    for i in range(iterations) :
        params = clf[1]
        if "random_state" in params:
            params["random_state"] = i
        
        classifier = clf[0](**params)
        classifier.fit(XX, y)
        #sys.exit()

        skf = StratifiedKFold(n_splits=3, random_state=1, shuffle=True) # you could also say cv=3 in cross_val_score which would be the same thing

        iteration_scores = list(cross_val_score(classifier, XX, y, scoring = scoring_metric, cv=skf, n_jobs=n_jobs))
        scores.append(sum(iteration_scores)/len(iteration_scores))

    return scores
    


iterations = 5

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
        results.append([classifier_name, "labels", str(score)])

print(results)



