## classificationAccuracy Scores
library(tidyverse)
library(dplyr)
library(ggplot2)

directory <- 'Desktop/Piccolo_Research/Iris/data/'
classifiers <- c('RandomForest', 'LogisticRegression', 'KNeighbors')
iterations <- c(`1` = "Iteration 1", `2` = "Iteration 2", `3` ="Iteration 3", `4` = "Iteration 4", `5` = "Iteration 5")

##classification accuracy by iteration 

accuracyScores <- read_tsv(paste0(directory,"irisData.tsv")) %>% 
  filter(`tClassifier` == classifiers[1]) %>% mutate(`probability of versicolor` = round(`probability of versicolor`, 1))
print(accuracyScores)
ggplot(accuracyScores) +
  geom_bar(aes(x=`probability of versicolor`, fill = `cross-validationFold`), width = 0.09) +
  facet_wrap(~`cross-validationFold`, labeller = as_labeller(iterations)) + theme_bw(base_size = 18) + 
  theme(legend.position = "none") + labs(x = "Probability of Versicolor", y = "Counts") +
  scale_y_continuous(limits = c(0,10)) +  scale_x_continuous(breaks = c(0.0, 0.25, 0.50, 0.75, 1.0))+
  ggtitle(paste("Probability of Versicolor\nper Iteration with ", classifiers[1]))


  #### save plot to a pdf 