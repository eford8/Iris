# Iris
Title: Using Machine Learning Ensemble Algorithms to Classify Biological Entities 
Project Purpose: The overarching purpose of this project is to find ways to more accurately predict patient outcomes based on RNA expression profiles related to human disease. In this part of the project, a combination of machine learning algorithms will be created and tested using various biological datasets. 

Datasets were found from:  https://epistasislab.github.io/pmlb/ 
All dataset have 2 classes.
We are using a variety of dataset types...for example, many rows, not many columns; many columns, not many rows; many rows and columns.

https://epistasislab.github.io/pmlb/profile/breast.html "breast"
https://github.com/EpistasisLab/pmlb/blob/master/datasets/breast/metadata.yaml   
n_observations = 699
n_features = 10
inbalance = 0.1
The last column named "Target" has a 0 or a 1 (458 zero's and 241 ones)

https://epistasislab.github.io/pmlb/profile/GAMETES_Epistasis_2_Way_1000atts_0.4H_EDM_1_EDM_1_1.html "Gametes_Epistasis"
https://github.com/EpistasisLab/pmlb/blob/master/datasets/GAMETES_Epistasis_2_Way_1000atts_0.4H_EDM_1_EDM_1_1/metadata.yaml
n_observations = 1600
n_features = 1000
inbalance = 0
The last column named "Target" has a 0 or a 1 (exactly 800 zeros and 800 ones)

https://epistasislab.github.io/pmlb/profile/magic.html  "magic"
https://github.com/EpistasisLab/pmlb/blob/master/datasets/magic/metadata.yaml
n_observations = 19020
n_features = 10
inbalance = 0.09
The last column named "Target" has a 0 or a 1 (12332 zeros and 6688 ones)
description: particle shower measurements used to classify which type of radiation caused the particle shower. 
class: g,h # gamma (signal), hadron (background)

https://epistasislab.github.io/pmlb/profile/horse_colic.html   "horse colic"
https://github.com/EpistasisLab/pmlb/blob/master/datasets/horse_colic/metadata.yaml
n_observations = 368
n_features = 22
inbalance = 0.07
The last column named "Target" has a 0 or a 1 (232 zeros and 136 ones)

https://epistasislab.github.io/pmlb/profile/hypothyroid.html "hypothyroid"
https://github.com/EpistasisLab/pmlb/blob/master/datasets/hypothyroid/metadata.yaml
n_observations = 3163
n_features = 25
inbalance = 0.82
The last column named "Target" has a 0 or a 1 (151 zeros and 3012 ones)

