#! /bin/bash

#python initialization.py

#python classify.py "iris" "Iris-versicolor" "Iris-virginica"
#python classify.py "iris" "1" "0"
#python classify.py "breast" "1" "0"
#python classify.py "horse_colic" "2" "1"
#python classify.py "Gametes_Epistasis" "1" "0"
#python classify.py "magic" "1" "0"


#python ensemblePredictions.py "iris" "1" "0"
#python ensemblePredictions.py "breast" "1" "0"
#python ensemblePredictions.py "horse_colic" "2" "1"
#python ensemblePredictions.py "Gametes_Epistasis" "1" "0"
#python ensemblePredictions.py "magic" "1" "0"


#python metrics.py "iris" "Classifications"
#python metrics.py "breast" "Classifications"
#python metrics.py "horse_colic" "Classifications"
#python metrics.py "Gametes_Epistasis" "Classifications"
#python metrics.py "magic" "Classifications"


#python metrics.py "iris" "EnsemblePredictions"
#python metrics.py "breast" "EnsemblePredictions"
#python metrics.py "horse_colic" "EnsemblePredictions"
#python metrics.py "Gametes_Epistasis" "EnsemblePredictions"
#python metrics.py "magic" "EnsemblePredictions"

python addWeights.py "iris" "Classifications"



