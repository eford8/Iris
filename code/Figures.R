############################################################ AccuracyLineGraph.R #######################################################################

library(tidyverse)

## This R script takes all the metrics data for the three basic classifiers 
## (Random Forest, Logistic Regression, and K-nearest neighbors) as well as 
## LCA, autosklearn, a basic ensemble approach, and a weighted ensemble approach. 
## It create a line graph with the approachs on the x-axis and the roc_score
## on the y-axis. 


## colorblind friendly palette
redBlueCB = c("#d73027", "#f46d43", "#fdae61", "#74add1", "#4575b4")


#Read in all the metrics data for basic Classifiers, LCA, and sklearn
irisMetrics <- read_tsv("irisClassificationsMetrics.tsv")
breastMetrics <- read_tsv("breastClassificationsMetrics.tsv")
horseColicMetrics <- read_tsv("horse_colicClassificationsMetrics.tsv")
magicMetrics <- read_tsv("magicClassificationsMetrics.tsv")
GametesMetrics <- read_tsv("Gametes_EpistasisClassificationsMetrics.tsv")

#Add a DataType Column
irisMetrics = add_column(irisMetrics, DataType = "Iris")
breastMetrics = add_column(breastMetrics, DataType = "Breast")
horseColicMetrics = add_column(horseColicMetrics, DataType = "HorseColic")
magicMetrics = add_column(magicMetrics, DataType = "Magic")
GametesMetrics = add_column(GametesMetrics, DataType = "Gametes")


#Read in all the metrics data for basic ensemble approach 
irisEnsemble <- read_tsv("irisEnsemblePredictionsMetrics.tsv")
breastEnsemble <- read_tsv("breastEnsemblePredictionsMetrics.tsv")
horseColicEnsemble <- read_tsv("horse_colicEnsemblePredictionsMetrics.tsv")
magicEnsemble <- read_tsv("magicEnsemblePredictionsMetrics.tsv")
GametesEnsemble <- read_tsv("Gametes_EpistasisEnsemblePredictionsMetrics.tsv")

#Add a DataType Column
irisEnsemble = add_column(irisEnsemble, DataType = "Iris")
breastEnsemble = add_column(breastEnsemble, DataType = "Breast")
horseColicEnsemble = add_column(horseColicEnsemble, DataType = "HorseColic")
magicEnsemble = add_column(magicEnsemble, DataType = "Magic")
GametesEnsemble = add_column(GametesEnsemble, DataType = "Gametes")


#Read in all the metrics data for weighted ensemble approach 
irisWeighted <- read_tsv("irisWeightedEnsemblePredictionsMetrics.tsv")
breastWeighted <- read_tsv("breastWeightedEnsemblePredictionsMetrics.tsv")
horseColicWeighted <- read_tsv("horse_colicWeightedEnsemblePredictionsMetrics.tsv")
#magicWeighted <- read_tsv("magicWeightedEnsemblePredictionsMetrics.tsv")
#GametesWeighted <- read_tsv("Gametes_EpistasisWeightedEnsemblePredictionsMetrics.tsv")

#Add a DataType Column
irisWeighted = add_column(irisWeighted, DataType = "Iris")
breastWeighted = add_column(breastWeighted, DataType = "Breast")
horseColicWeighted = add_column(horseColicWeighted, DataType = "HorseColic")
#magicWeighted = add_column(magicWeighted, DataType = "Magic")
#GametesWeighted = add_column(GametesWeighted, DataType = "Gametes")


#------------ Find the mean accuracy score for all the interations -----------#

## Basic Classifiers ## ____________________________________

irisMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> irisMetrics

breastMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> breastMetrics

horseColicMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> horseColicMetrics

magicMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> magicMetrics

GametesMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> GametesMetrics


## Basic Ensemble ## _____________________________________________


irisEnsemble %>% 
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> irisEnsemble

breastEnsemble %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> breastEnsemble

horseColicEnsemble %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> horseColicEnsemble

magicEnsemble %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> magicEnsemble


GametesEnsemble %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> GametesEnsemble



## Weighted Ensemble ## _______________________________________________

view(breastWeighted)

irisWeighted %>% 
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> irisWeighted

breastWeighted %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> breastWeighted

horseColicWeighted %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> horseColicWeighted

magicWeighted %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> magicWeighted


GametesWeighted %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> GametesWeighted



## --------------------- Combining all the data sets --------------- ##


combinedBasic = rbind(irisMetrics, horseColicMetrics)
combinedBasic = rbind(combinedBasic, magicMetrics)
combinedBasic = rbind(combinedBasic, GametesMetrics)
combinedBasic = rbind(combinedBasic, breastMetrics)

combinedEnsemble = rbind(irisEnsemble, horseColicEnsemble)
combinedEnsemble = rbind(combinedEnsemble, magicEnsemble)
combinedEnsemble = rbind(combinedEnsemble, GametesEnsemble)
combinedEnsemble = rbind(combinedEnsemble, breastEnsemble)

#combinedWeighted = rbind(irisWeighted, horseColicWeighted)
#combinedWeighted = rbind(combinedWeighted, magicWeighted)
#combinedWeighted = rbind(combinedWeighted, GametesWeighted)
#combinedWeighted = rbind(combinedWeighted, breastWeighted)

combinedMega = rbind(combinedBasic, combinedEnsemble)
#combinedMega = rbind(combinedMega, combinedWeighted)


## --------------------- Basic metrics Bar Plot ----------------------##

combinedBasic %>%
  filter(Classifier != "LCA") %>%
  filter(Classifier != "AutoSklearn") %>%
  ggplot(aes(x=TypesofMetrics, y=Score, fill = DataType)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  theme_bw(base_size = 15) + 
  ggtitle("Metrics for Basic Classifiers") +
  facet_grid(.~ DataType) + 
  facet_grid(Classifier ~ DataType) + 
  scale_fill_manual(values=redBlueCB) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) + 
  theme(legend.position="none") +
  xlab("Metrics") +
  theme(plot.title=element_text(hjust=0.5)) 
ggsave("MetricsforBasicClassifiersBarPlot.pdf", width = 9, height = 6.5, units = "in")

combinedBasic %>%
  #filter(Classifier != "LCA") %>%
  #filter(Classifier != "AutoSklearn") %>%
  ggplot(aes(x=TypesofMetrics, y=Score, fill = DataType)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  theme_bw(base_size = 10) + 
  #ggtitle("Metrics for Five Classifiers") +
  facet_grid(.~ DataType) + 
  facet_grid(Classifier ~ DataType) + 
  scale_fill_manual(values=redBlueCB) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) + 
  theme(legend.position="none") +
  xlab("Metrics") +
  theme(plot.title=element_text(hjust=0.5)) 
ggsave("MetricsforFiveClassifiersBarPlot.pdf", width = 9, height = 6.5, units = "in")



## ------------------ line graph with the roc_score as the y-axis ----------------#



combinedMega %>%
  filter(TypesofMetrics == "roc_auc") %>%
  ggplot(aes(x = factor(Classifier, levels=c("LogisticRegression", "KNeighbors", 
                                             "RandomForest", "AutoSklearn", "LCA", 
                                             "AverageProb", "ExtremeProb", "MajorityVote")), 
             y = Score , color = DataType, group = 1)) +
  facet_grid(~DataType) + 
  geom_line(color = "red", size = 1) + 
  geom_point(color = "red", size = 2) + 
  xlab("Type of Classification Method") + 
  ylab("Area Under roc_auc Curve") + 
  theme_bw(base_size = 18) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) + 
  theme(legend.position="none") + 
  theme(plot.title=element_text(hjust=0.5)) 
ggsave("Roc_ScoreLineGraph.pdf", width = 9, height = 6.5, units = "in")

combinedMega %>%
  filter(TypesofMetrics == "Accuracy") %>%
  ggplot(aes(x = factor(Classifier, levels=c("LogisticRegression", "KNeighbors", 
                                             "RandomForest", "AutoSklearn", "LCA", 
                                             "AverageProb", "ExtremeProb", "MajorityVote")), 
             y = Score , color = DataType, group = 1)) +
  facet_grid(~DataType) + 
  geom_line(color = "red", size = 1) + 
  geom_point(color = "red", size = 2) + 
  xlab("Type of Classification Method") + 
  ylab("Accuracy") + 
  theme_bw(base_size = 18) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) + 
  theme(legend.position="none") + 
  theme(plot.title=element_text(hjust=0.5)) 
ggsave("AccuracyLineGraph.pdf", width = 9, height = 6.5, units = "in")


########################################################### BasicClassifiers.R ###############################################################################

install.packages("tidyverse", dependencies = TRUE)

library(tidyverse, lib.loc="C:/Program Files/R/R-4.1.3/library")

library(tidyverse)


#Read in all the basic Classifications Data
iris <- read_tsv("irisClassifications.tsv")
breast <- read_tsv("breastClassifications.tsv")
horseColic <- read_tsv("horse_colicClassifications.tsv")
magic <- read_tsv("magicClassifications.tsv")
Gametes <- read_tsv("Gametes_EpistasisClassifications.tsv")

#Method: Divides the graph into six different boxes
#Facet by two targets
#Color by Target

iris %>%
  filter(Classifier != "LCA") %>%
  filter(Classifier != "AutoSklearn") %>%
  mutate(Target = replace(Target, Target == 0, "Virginica")) %>%
  mutate(Target = replace(Target, Target == 1, "Versicolor")) %>%
  rename(Species = Target) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Species, levels=c("Virginica","Versicolor" )))) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ factor(Species, levels=c("Virginica","Versicolor" ))) + 
  theme_bw(base_size = 16) + 
  labs(color="Species") +
  ggtitle("Basic Classifier Predictions Dataset: Iris") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") + 
  theme(legend.position="none")
ggsave("SixBoxesIrisClassifications.pdf", width = 9, height = 6.5, units = "in")


breast %>% 
  filter(Classifier != "LCA") %>%
  filter(Classifier != "AutoSklearn") %>%
  mutate(Target = replace(Target, Target == 0, "Class One")) %>%
  mutate(Target = replace(Target, Target == 1, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Target))) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ Target) + 
  theme_bw(base_size = 16) + 
  labs(color="Target") +
  ggtitle("Basic Classifier Predictions Dataset: Breast") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") +
  theme(legend.position="none") 
ggsave("SixBoxesBreastClassifications.pdf", width = 9, height = 6.5, units = "in")


horseColic %>% 
  filter(Classifier != "LCA") %>%
  filter(Classifier != "AutoSklearn") %>%
  mutate(Target = replace(Target, Target == 0, "Class One")) %>%
  mutate(Target = replace(Target, Target == 1, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Target))) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ Target) + 
  theme_bw(base_size = 16) + 
  labs(color="Target") +
  ggtitle("Basic Classifier Predictions Dataset: Horse Colic") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") +
  theme(legend.position="none") 
ggsave("SixBoxesHorseColicClassifications.pdf", width = 9, height = 6.5, units = "in")



magic %>%
  #filter(Iteration == "1") %>%
  mutate(Target = replace(Target, Target == 0, "Class One")) %>%
  mutate(Target = replace(Target, Target == 1, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Target))) +
  #make the points transparent
  geom_point(alpha = 0.05) + 
  #make the points very small
  #geom_point(shape = ".") + 
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ Target) + 
  theme_bw(base_size = 16) + 
  labs(color="Target") +
  ggtitle("Basic Classifier Predictions Dataset: Magic") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") +
  theme(legend.position="none") 
ggsave("SixBoxesMagicClassifications.pdf", device = "pdf",  width = 9, height = 6.5, units = "in")


Gametes %>%
  mutate(Target = replace(Target, Target == 0, "Class One")) %>%
  mutate(Target = replace(Target, Target == 1, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Target))) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ Target) + 
  theme_bw(base_size = 16) + 
  labs(color="Target") +
  ggtitle("Basic Classifier Predictions Dataset: Gametes Epistasis") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") +
  theme(legend.position="none")
ggsave("SixBoxesGametesEpistasisClassifications.pdf", width = 9, height = 6.5, units = "in")


## -------Six box type graphs--------  ##


iris %>%
  #filter(Classifier != "LCA") %>%
  #filter(Classifier != "AutoSklearn") %>%
  mutate(Target = replace(Target, Target == 0, "Virginica")) %>%
  mutate(Target = replace(Target, Target == 1, "Versicolor")) %>%
  rename(Species = Target) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Species, levels=c("Virginica","Versicolor" ))), size = 3) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ factor(Species, levels=c("Virginica","Versicolor" ))) + 
  theme_bw(base_size = 11) + 
  labs(color="Species") +
  ggtitle("Iris Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") + 
  theme(legend.position="none") + 
  theme(plot.title=element_text(hjust=0.5))
ggsave("8BoxIrisClassifications.pdf", width = 9, height = 6.5, units = "in")

breast %>%
  #filter(Classifier != "LCA") %>%
  #filter(Classifier != "AutoSklearn") %>%
  mutate(Target = replace(Target, Target == 0, "Class One")) %>%
  mutate(Target = replace(Target, Target == 1, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Target), size = 3) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ Target) + 
  theme_bw(base_size = 11) + 
  labs(color="Target") +
  ggtitle("Breast Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") + 
  theme(legend.position="none") + 
  theme(plot.title=element_text(hjust=0.5))
ggsave("8BoxBreastClassifications.pdf", width = 9, height = 6.5, units = "in")

horseColic %>%
  #filter(Classifier != "LCA") %>%
  #filter(Classifier != "AutoSklearn") %>%
  mutate(Target = replace(Target, Target == 1, "Class One")) %>%
  mutate(Target = replace(Target, Target == 2, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Target), size = 3) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ Target) + 
  theme_bw(base_size = 11) + 
  labs(color="Target") +
  ggtitle("Horse Colic Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") + 
  theme(legend.position="none") + 
  theme(plot.title=element_text(hjust=0.5))
ggsave("8BoxHorseColicClassifications.pdf", width = 9, height = 6.5, units = "in")

magic %>%
  #filter(Classifier != "LCA") %>%
  #filter(Classifier != "AutoSklearn") %>%
  mutate(Target = replace(Target, Target == 0, "Class One")) %>%
  mutate(Target = replace(Target, Target == 1, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Target)) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ Target) + 
  #make the points transparent
  geom_point(alpha = 0.05) + 
  #make the points very small
  #geom_point(shape = ".") + 
  theme_bw(base_size = 11) + 
  labs(color="Target") +
  ggtitle("Magic Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") + 
  theme(legend.position="none") + 
  theme(plot.title=element_text(hjust=0.5))
ggsave("8BoxMagicClassifications.pdf", width = 9, height = 6.5, units = "in")


Gametes %>%
  filter(Iteration == "1") %>%
  mutate(Target = replace(Target, Target == 0, "Class One")) %>%
  mutate(Target = replace(Target, Target == 1, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Target))) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ Target) + 
  theme_bw(base_size = 11) + 
  labs(color="Target") +
  ggtitle("Gametes Epistasis Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") +
  theme(legend.position="none")
ggsave("8BoxGametesEpistasisClassifications.pdf", width = 9, height = 6.5, units = "in")


########################################################## BoxAndWhiskerPlots.R  #############################################################333

library(tidyverse)


## colorblind friendly palette
redBlueCB = c("#d73027", "#f46d43", "#fdae61", "#74add1", "#4575b4")


#Read in all the metrics data for basic Classifiers, LCA, and sklearn
irisMetrics <- read_tsv("irisClassificationsMetrics.tsv")
breastMetrics <- read_tsv("breastClassificationsMetrics.tsv")
horseColicMetrics <- read_tsv("horse_colicClassificationsMetrics.tsv")
magicMetrics <- read_tsv("magicClassificationsMetrics.tsv")
GametesMetrics <- read_tsv("Gametes_EpistasisClassificationsMetrics.tsv")

#Add a DataType Column
irisMetrics = add_column(irisMetrics, DataType = "Iris")
breastMetrics = add_column(breastMetrics, DataType = "Breast")
horseColicMetrics = add_column(horseColicMetrics, DataType = "HorseColic")
magicMetrics = add_column(magicMetrics, DataType = "Magic")
GametesMetrics = add_column(GametesMetrics, DataType = "Gametes")


#Read in all the metrics data for basic ensemble approach 
irisEnsemble <- read_tsv("irisEnsemblePredictionsMetrics.tsv")
breastEnsemble <- read_tsv("breastEnsemblePredictionsMetrics.tsv")
horseColicEnsemble <- read_tsv("horse_colicEnsemblePredictionsMetrics.tsv")
magicEnsemble <- read_tsv("magicEnsemblePredictionsMetrics.tsv")
GametesEnsemble <- read_tsv("Gametes_EpistasisEnsemblePredictionsMetrics.tsv")

#Add a DataType Column
irisEnsemble = add_column(irisEnsemble, DataType = "Iris")
breastEnsemble = add_column(breastEnsemble, DataType = "Breast")
horseColicEnsemble = add_column(horseColicEnsemble, DataType = "HorseColic")
magicEnsemble = add_column(magicEnsemble, DataType = "Magic")
GametesEnsemble = add_column(GametesEnsemble, DataType = "Gametes")


#Read in all the metrics data for weighted ensemble approach 
irisWeighted <- read_tsv("irisEnsemblePredictionsMetrics.tsv")
breastWeighted <- read_tsv("breastEnsemblePredictionsMetrics.tsv")
horseColicWeighted <- read_tsv("horse_colicEnsemblePredictionsMetrics.tsv")
#magicWeighted <- read_tsv("magicEnsemblePredictionsMetrics.tsv")
#GametesWeighted <- read_tsv("Gametes_EpistasisEnsemblePredictionsMetrics.tsv")

#Add a DataType Column
irisWeighted = add_column(irisWeighted, DataType = "Iris")
breastWeighted = add_column(breastWeighted, DataType = "Breast")
horseColicWeighted = add_column(horseColicWeighted, DataType = "HorseColic")
#magicWeighted = add_column(magicWeighted, DataType = "Magic")
#GametesWeighted = add_column(GametesWeighted, DataType = "Gametes")


## --------------------- Combining all the data sets --------------- ##


combinedBasic = rbind(irisMetrics, horseColicMetrics)
combinedBasic = rbind(combinedBasic, magicMetrics)
combinedBasic = rbind(combinedBasic, GametesMetrics)
combinedBasic = rbind(combinedBasic, breastMetrics)

combinedEnsemble = rbind(irisEnsemble, horseColicEnsemble)
combinedEnsemble = rbind(combinedEnsemble, magicEnsemble)
combinedEnsemble = rbind(combinedEnsemble, GametesEnsemble)
combinedEnsemble = rbind(combinedEnsemble, breastEnsemble)

#combinedWeighted = rbind(irisWeighted, horseColicWeighted)
#combinedWeighted = rbind(combinedWeighted, magicWeighted)
#combinedWeighted = rbind(combinedWeighted, GametesWeighted)
#combinedWeighted = rbind(combinedWeighted, breastWeighted)

combinedMega = rbind(combinedBasic, combinedEnsemble)
#combinedMega = rbind(combinedMega, combinedWeighted)


combinedMega %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") %>%
  mutate(TypesofMetrics = replace(TypesofMetrics, TypesofMetrics == "average_precision", "Average Precision")) -> combinedMega

## --------------------------- Second attempt ------------------------------- ###

view(combinedMega)

combinedMega %>%
  filter(TypesofMetrics == "roc_auc") %>%
  ggplot(aes(x = TypesofMetrics, y = Score)) + 
  geom_boxplot(color = "black", fill = "red", alpha=0.3) +
  geom_jitter(aes(color = "red")) +  
  xlab("Type of Metric") + 
  theme_bw(base_size = 18) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1.15)) + 
  theme(legend.position="none") + 
  facet_grid(.~ Classifier) 


combinedMega %>%
  filter(TypesofMetrics == "roc_auc") %>%
  ggplot(aes(x = Classifier, y = Score)) + 
  geom_boxplot(color = "black", fill = "blue", alpha=0.3) +
  geom_jitter(aes(color = "blue")) +  
  xlab("Classification Method") + 
  ylab("AUROC Score") +
  theme_bw(base_size = 18) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1.15)) + 
  theme(legend.position="none") + 
  facet_grid(.~ DataType) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5))  


combinedMega %>%
  filter(TypesofMetrics == "roc_auc") %>%
  ggplot(aes(x = DataType, y = Score)) + 
  geom_boxplot(color = "black", fill = "purple", alpha=0.3) +
  geom_jitter(aes(color = "purple")) +  
  xlab("Classification Method") + 
  ylab("AUROC Score") +
  theme_bw(base_size = 18) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1.15)) + 
  theme(legend.position="none") + 
  facet_grid(.~ Classifier) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5))  




## ------------------- Creating the boxplot with a jitter ontop ------------------#



combinedMega %>%
  filter(DataType == "Iris") -> filterIris
combinedMega %>%
  filter(DataType == "Breast") -> filterBreast
combinedMega %>%
  filter(DataType == "HorseColic") -> filterHorseColic
combinedMega %>%
  filter(DataType == "Magic") -> filterMagic
combinedMega %>%
  filter(DataType == "Gametes") -> filterGametes

ggplot(NULL, aes(x = TypesofMetrics, y = Score) ) + 
  geom_boxplot(data = filterIris, color = "black", fill = "red", alpha=0.3) +
  geom_boxplot(data = filterBreast, color = "black", fill = "orange", alpha=0.3) +
  geom_boxplot(data = filterHorseColic, color = "black", fill = "yellow", alpha=0.3) +
  geom_boxplot(data = filterMagic, color = "black", fill = "blue", alpha=0.3) +
  geom_boxplot(data = filterGametes, color = "black", fill = "purple", alpha=0.3) 

combinedMega %>%
  filter(DataType == "Iris") %>%
  ggplot(aes(x = TypesofMetrics, y = Score)) + 
  geom_boxplot(color = "black", fill = "red", alpha=0.3) +
  geom_jitter(aes(color = "red")) +  
  xlab("Type of Metric") + 
  theme_bw(base_size = 18) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1.15)) + 
  theme(legend.position="none") #-> irisBox

combinedMega %>%
  filter(DataType == "Breast") %>%
  ggplot(aes(x = TypesofMetrics, y = Score, fill = "#f46d43")) + 
  geom_boxplot(color = "black", fill = "orange", alpha=0.3) +
  geom_jitter(aes(color = "orange")) +  
  xlab("Type of Metric") + 
  theme_bw(base_size = 18) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) + 
  theme(legend.position="none") #-> breastBox

combinedMega %>%
  filter(DataType == "HorseColic") %>%
  ggplot(aes(x = TypesofMetrics, y = Score, fill = "#fdae61")) + 
  geom_boxplot(color = "black", fill = "yellow", alpha=0.3) +
  geom_jitter(aes(color = "yellow")) +  
  xlab("Type of Metric") + 
  theme_bw(base_size = 18) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) + 
  theme(legend.position="none") #-> horseColicBox

combinedMega %>%
  filter(DataType == "Magic") %>%
  ggplot(aes(x = TypesofMetrics, y = Score, fill = "#74add1")) + 
  geom_boxplot(color = "black", fill = "blue", alpha=0.3) +
  geom_jitter(aes(color = "blue")) +  
  xlab("Type of Metric") + 
  theme_bw(base_size = 18) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) + 
  theme(legend.position="none") #-> magicBox

combinedMega %>%
  filter(DataType == "Gametes") %>%
  ggplot(aes(x = TypesofMetrics, y = Score)) + 
  geom_boxplot(color = "black", fill = "purple", alpha=0.3) +
  geom_jitter(aes(color = "purple")) +  
  xlab("Type of Metric") + 
  theme_bw(base_size = 18) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) + 
  theme(legend.position="none") #-> GametesBox

#FiX ME NOT WOKRING
#ggarrange(irisBox, breastBox, horseColicBox, magicBox,  GametesBox,
#          labels = c("Iris", "Breast", "Horse Colic", "Magic", "Gametes"),
#          ncol = 5) #, nrow = 2

#ggplot_add() +
#  GametesBox + magicBox + horseColicBox + breastBox + irisBox


combinedMega %>%
  ggplot(aes(x = TypesofMetrics, y = Score)) + 
  geom_boxplot() + 
  geom_jitter(aes(color = DataType), size = 4, shape = 18) +  
  scale_color_manual(values=redBlueCB) + 
  xlab("Type of Metric") + 
  theme_bw(base_size = 18) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1.1)) 
  #theme(legend.position="none")
ggsave("MetricsEachIteration.pdf", width = 9, height = 6.5, units = "in")




box_Iterations <- ggplot(NULL, aes(x = TypesofMetrics, y = Score)) + 
  xlab("Type of Metric") + 
  theme_bw(base_size = 18) + 
  geom_boxplot(data = filter(combinedMega,DataType == "Iris")) + 
  geom_boxplot(data = filter(combinedMega,DataType == "Breast")) + 
  geom_boxplot(data = filter(combinedMega,DataType == "HorseColic")) + 
  geom_boxplot(data = filter(combinedMega,DataType == "Magic")) + 
  geom_boxplot(data = filter(combinedMega,DataType == "Gametes"))  
  
box_Iterations ##Maybe a jitter plot would be best? 



########################################################## AlgorithmsRanked.R ########################################################3

#Rank the algorithms/methods for each data set

## also has the box plot for accuracy scores for each data set and the 
## roc_auc score for each data set

library(tidyverse)

## colorblind friendly palette
redBlueCB = c("#d73027", "#f46d43", "#fdae61", "#74add1", "#4575b4")

#Read in all the metrics data for basic Classifiers, LCA, and sklearn
irisMetrics <- read_tsv("irisClassificationsMetrics.tsv")
breastMetrics <- read_tsv("breastClassificationsMetrics.tsv")
horseColicMetrics <- read_tsv("horse_colicClassificationsMetrics.tsv")
magicMetrics <- read_tsv("magicClassificationsMetrics.tsv")
GametesMetrics <- read_tsv("Gametes_EpistasisClassificationsMetrics.tsv")

#Add a DataType Column
irisMetrics = add_column(irisMetrics, DataType = "Iris")
breastMetrics = add_column(breastMetrics, DataType = "Breast")
horseColicMetrics = add_column(horseColicMetrics, DataType = "HorseColic")
magicMetrics = add_column(magicMetrics, DataType = "Magic")
GametesMetrics = add_column(GametesMetrics, DataType = "Gametes")


#Read in all the metrics data for basic ensemble approach 
irisEnsemble <- read_tsv("irisEnsemblePredictionsMetrics.tsv")
breastEnsemble <- read_tsv("breastEnsemblePredictionsMetrics.tsv")
horseColicEnsemble <- read_tsv("horse_colicEnsemblePredictionsMetrics.tsv")
magicEnsemble <- read_tsv("magicEnsemblePredictionsMetrics.tsv")
GametesEnsemble <- read_tsv("Gametes_EpistasisEnsemblePredictionsMetrics.tsv")

#Add a DataType Column
irisEnsemble = add_column(irisEnsemble, DataType = "Iris")
breastEnsemble = add_column(breastEnsemble, DataType = "Breast")
horseColicEnsemble = add_column(horseColicEnsemble, DataType = "HorseColic")
magicEnsemble = add_column(magicEnsemble, DataType = "Magic")
GametesEnsemble = add_column(GametesEnsemble, DataType = "Gametes")


#Read in all the metrics data for weighted ensemble approach 
irisWeighted <- read_tsv("irisWeightedEnsemblePredictionsMetrics.tsv")
breastWeighted <- read_tsv("breastWeightedEnsemblePredictionsMetrics.tsv")
horseColicWeighted <- read_tsv("horse_colicWeightedEnsemblePredictionsMetrics.tsv")
#magicWeighted <- read_tsv("magicWeightedEnsemblePredictionsMetrics.tsv")
#GametesWeighted <- read_tsv("Gametes_EpistasisWeightedEnsemblePredictionsMetrics.tsv")

#Add a DataType Column
irisWeighted = add_column(irisWeighted, DataType = "Iris")
breastWeighted = add_column(breastWeighted, DataType = "Breast")
horseColicWeighted = add_column(horseColicWeighted, DataType = "HorseColic")
#magicWeighted = add_column(magicWeighted, DataType = "Magic")
#GametesWeighted = add_column(GametesWeighted, DataType = "Gametes")


#------------ Find the mean accuracy score for all the interations -----------#

## Basic Classifiers ## ____________________________________

irisMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score")  -> irisMetrics

breastMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> breastMetrics

horseColicMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> horseColicMetrics

magicMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> magicMetrics

GametesMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> GametesMetrics


## Basic Ensemble ## _____________________________________________


irisEnsemble %>% 
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> irisEnsemble

breastEnsemble %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> breastEnsemble

horseColicEnsemble %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> horseColicEnsemble

magicEnsemble %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> magicEnsemble


GametesEnsemble %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> GametesEnsemble



## Weighted Ensemble ## _______________________________________________

irisWeighted %>% 
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> irisWeighted

breastWeighted %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> breastWeighted

horseColicWeighted %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> horseColicWeighted

magicWeighted %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> magicWeighted


GametesWeighted %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> GametesWeighted



## --------------------- Combining all the data sets Ranked based on Accuracy --------------- ##

combinedIris = rbind(irisMetrics, irisEnsemble) 
#combinedIris = rbind(combineIris,irisWeighted)

combinedIris = filter(combinedIris, TypesofMetrics == "Accuracy")
combinedIris$Rank = rank(desc(combinedIris$Score), ties.method = "min") 

combinedBreast = rbind(breastMetrics, breastEnsemble)
#combinedBreast = rbind(combinedBreast, breastWeighted)

combinedBreast = filter(combinedBreast, TypesofMetrics == "Accuracy")
combinedBreast$Rank = rank(desc(combinedBreast$Score), ties.method = "min") 

combinedHorseColic = rbind(horseColicMetrics, horseColicEnsemble)
#combineHorseColic = rbind(combineHorseColic, horseColicWeighted)

combinedHorseColic = filter(combinedHorseColic, TypesofMetrics == "Accuracy")
combinedHorseColic$Rank = rank(desc(combinedHorseColic$Score), ties.method = "min") 

combinedMagic = rbind(magicMetrics, magicEnsemble)
#combinedMagic = rbind(combinedMagic, magicWeighted)

combinedMagic = filter(combinedMagic, TypesofMetrics == "Accuracy")
combinedMagic$Rank = rank(desc(combinedMagic$Score), ties.method = "min") 

combinedGametes = rbind(GametesMetrics, GametesEnsemble)
#combinedGametes = rbind(combinedGametes, GametesWeighted)

combinedGametes = filter(combinedGametes, TypesofMetrics == "Accuracy")
combinedGametes$Rank = rank(desc(combinedGametes$Score), ties.method = "min") 


combinedMega = rbind(combinedIris, combinedBreast) 
combinedMega = rbind(combinedMega, combinedHorseColic)
combinedMega = rbind(combinedMega, combinedMagic)
combinedMega = rbind(combinedMega, combinedGametes)

view(combinedMega)

## --------------------- Combining all the data sets Ranked based on roc_auc --------------- ##


combinedIrisR = rbind(irisMetrics, irisEnsemble) 
#combinedIrisR = rbind(combineIrisR,irisWeighted)

combinedIrisR = filter(combinedIrisR, TypesofMetrics == "roc_auc")
combinedIrisR$Rank = rank(desc(combinedIrisR$Score), ties.method = "min") 

combinedBreastR = rbind(breastMetrics, breastEnsemble)
#combinedBreastR = rbind(combinedBreastR, breastWeighted)

combinedBreastR = filter(combinedBreastR, TypesofMetrics == "roc_auc")
combinedBreastR$Rank = rank(desc(combinedBreastR$Score), ties.method = "min") 

combinedHorseColicR = rbind(horseColicMetrics, horseColicEnsemble)
#combineHorseColicR = rbind(combineHorseColicR, horseColicWeighted)

combinedHorseColicR = filter(combinedHorseColicR, TypesofMetrics == "roc_auc")
combinedHorseColicR$Rank = rank(desc(combinedHorseColicR$Score), ties.method = "min") 

combinedMagicR = rbind(magicMetrics, magicEnsemble)
#combinedMagicR = rbind(combinedMagicR, magicWeighted)

combinedMagicR = filter(combinedMagicR, TypesofMetrics == "roc_auc")
combinedMagicR$Rank = rank(desc(combinedMagicR$Score), ties.method = "min") 

combinedGametesR = rbind(GametesMetrics, GametesEnsemble)
#combinedGametesR = rbind(combinedGametesR, GametesWeighted)

combinedGametesR = filter(combinedGametesR, TypesofMetrics == "roc_auc")
combinedGametesR$Rank = rank(desc(combinedGametesR$Score), ties.method = "min") 


combinedMegaR = rbind(combinedIrisR, combinedBreastR) 
combinedMegaR = rbind(combinedMegaR, combinedHorseColicR)
combinedMegaR = rbind(combinedMegaR, combinedMagicR)
combinedMegaR = rbind(combinedMegaR, combinedGametesR)

view(combinedMegaR)

### ------------------- combine to see the accuracy as a box and whisker plot -----------------###
combinedBasic = rbind(irisMetrics, horseColicMetrics)
combinedBasic = rbind(combinedBasic, magicMetrics)
combinedBasic = rbind(combinedBasic, GametesMetrics)
combinedBasic = rbind(combinedBasic, breastMetrics)

combinedEnsemble = rbind(irisEnsemble, horseColicEnsemble)
combinedEnsemble = rbind(combinedEnsemble, magicEnsemble)
combinedEnsemble = rbind(combinedEnsemble, GametesEnsemble)
combinedEnsemble = rbind(combinedEnsemble, breastEnsemble)

#combinedWeighted = rbind(irisWeighted, horseColicWeighted)
#combinedWeighted = rbind(combinedWeighted, magicWeighted)
#combinedWeighted = rbind(combinedWeighted, GametesWeighted)
#combinedWeighted = rbind(combinedWeighted, breastWeighted)

combinedSuper = rbind(combinedBasic, combinedEnsemble)
#combinedMega = rbind(combinedSuper, combinedWeighted)

##-------------------------- Making the graphs ------------------------------##

##The ranks are based on the Accuracy score for each algorithm 
combinedMega %>%
  ggplot(aes(x=Classifier, y=Rank)) + 
  geom_boxplot() + 
  geom_jitter(aes(color = DataType), size = 4, shape = 18) +
  theme_bw(base_size = 18) + 
  xlab("Classification Method (Lower is Better)") +
  ylab("Accuracy Rank") + 
  scale_color_manual(values=redBlueCB) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 8.75)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5))
ggsave("AlgorithmsRanked.pdf", width = 9, height = 6.5, units = "in")

##The ranks are based on the roc_auc score for each algorithm 
combinedMega %>%
  ggplot(aes(x=Classifier, y=Rank)) + 
  geom_boxplot() + 
  geom_jitter(aes(color = DataType), size = 4, shape = 18) +
  theme_bw(base_size = 18) + 
  xlab("Classification Method (Lower is Better)") +
  ylab("Area Under Roc_auc Curve") + 
  scale_color_manual(values=redBlueCB) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 8.75)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5))
ggsave("AlgorithmsRankedbyRoc_auc.pdf", width = 9, height = 6.5, units = "in")


#This graph shows the accuracy score for each classification method for all five data sets
combinedSuper %>%
  filter(TypesofMetrics == "Accuracy") %>%
  ggplot(aes(x=Classifier, y=Score)) + 
  geom_boxplot() + 
  geom_jitter(aes(color = DataType), size = 4, shape = 15) + 
  theme_bw(base_size = 18) + 
  ylab("Accuracy Score") + 
  xlab("Classification Method") +
  scale_color_manual(values=redBlueCB) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5))  
ggsave("BoxPlotAccuracyScore.pdf", width = 9, height = 6.5, units = "in")


#This graph shows the roc score for each classification method for all five data sets
combinedSuper %>%
  filter(TypesofMetrics == "roc_auc") %>%
  ggplot(aes(x=Classifier, y=Score)) + 
  geom_boxplot() + 
  geom_jitter(aes(color = DataType), size = 4, shape = 15) + 
  theme_bw(base_size = 18) + 
  ylab("Area Under Roc_auc Curve") + 
  xlab("Classification Method") +
  scale_color_manual(values=redBlueCB) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5))  
ggsave("BoxPlotroc_aucScore.pdf", width = 9, height = 6.5, units = "in")








