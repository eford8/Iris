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

#python analyzePredictions.py

python metrics.py "iris" 
python metrics.py "breast"
python metrics.py "horse_colic"
python metrics.py "Gametes_Epistasis"
python metrics.py "magic"