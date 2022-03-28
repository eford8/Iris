library(tidyverse)

#Read in all the basic Classifications Data
iris <- read_tsv("irisClassifications.tsv")
breast <- read_tsv("breastClassifications.tsv")
horseColic <- read_tsv("horse_colicClassifications.tsv")
magic <- read_tsv("magicClassifications.tsv")
Gametes <- read_tsv("Gametes_EpistasisClassifications.tsv")


#Make classifier facets horizontal instead of vertical
Gametes %>%
  filter(Iteration == "1") %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Classifier)) +
  facet_grid(Classifier~.) + 
  theme_bw(base_size = 18) + 
  theme(legend.position = "none") +
  ggtitle("Gametes Epistasis Classifications") +
  scale_color_brewer(palette = "Dark2") + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") 
ggsave("HorizontalGametesEpistasisClassifications.pdf", width = 9, height = 6.5, units = "in")

##Facet_wrap by classifier
##But color by the Target 
Gametes %>%
  filter(Iteration == "1") %>%
  mutate(Target = replace(Target, Target == 0, "Outcome One")) %>%
  mutate(Target = replace(Target, Target == 1, "Outcome Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Target))) +
  facet_wrap(~Classifier) + 
  theme_bw(base_size = 18) + 
  labs(color="Target") +
  ggtitle("Gametes Epistasis Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") 
ggsave("FacetByClassifierColorbyTargetGametesEpistasisClassifications.pdf", width = 9, height = 6.5, units = "in")

##Facet_wrap by classifier
##But color by the Target 
iris %>%
  filter(Classifier != "LCA") %>%
  filter(Classifier != "AutoSklearn") %>%
  mutate(Target = replace(Target, Target == 0, "Virginica")) %>%
  mutate(Target = replace(Target, Target == 1, "Versicolor")) %>%
  rename(Species = Target) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Species))) +
  facet_wrap(~Classifier) + 
  theme_bw(base_size = 18) + 
  labs(color="Species") +
  ggtitle("Iris Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") 
ggsave("FacetByClassifierColorbyTargetIrisClassifications.pdf", width = 9, height = 6.5, units = "in")


#Facet by two targets
#Color by Target
Gametes %>%
  filter(Iteration == "1") %>%
  mutate(Target = replace(Target, Target == 0, "Class One")) %>%
  mutate(Target = replace(Target, Target == 1, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Target))) +
  
  #facet_wrap(~Classifier, ncol = 2) + 
  #facet_wrap(~Classifier) + 
  #facet_grid(~Classifier, margins = TRUE) + 
  
  # Split in vertical direction
  #facet_grid(Classifier ~.) + 
  
  # Split in horizontal direction
  facet_grid(.~ Classifier) + 
  
  # Facet by two variables
  # Rows are Classifier and columns are Target
  facet_grid(Classifier ~ Target) + 

  # Facet by two variables: reverse the order of the 2 variables
  # Rows are Target and columns are Classifier
  #facet_grid(Target ~ Classifier) + 
  
  theme_bw(base_size = 16) + 
  labs(color="Target") +
  ggtitle("Gametes Epistasis Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") +
  theme(legend.position="none")
ggsave("SixBoxesGametesEpistasisClassifications.pdf", width = 9, height = 6.5, units = "in")

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
  ggtitle("Iris Classifications (Five Iterations)") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") + 
  theme(legend.position="none")
ggsave("SixBoxesGametesEpistasisClassifications.pdf", width = 9, height = 6.5, units = "in")

magic %>%
  filter(Iteration == "1") %>%
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
  ggtitle("Magic Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") +
  theme(legend.position="none") 
ggsave("SixBoxesMagicClassifications1Itertranspoints.pdf", device = "pdf",  width = 9, height = 6.5, units = "in")

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
  ggtitle("Iris Classifications (Five Iterations)") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") + 
  theme(legend.position="none")



# -------------  METRICS ---------------- #

#Read in all the metrics data for basic Classifications
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
irisEnMetrics <- read_tsv("irisEnsemblePredictionsMetrics.tsv")
breastEnMetrics <- read_tsv("breastEnsemblePredictionsMetrics.tsv")
horseColicEnMetrics <- read_tsv("horse_colicEnsemblePredictionsMetrics.tsv")
magicEnMetrics <- read_tsv("magicEnsemblePredictionsMetrics.tsv")
GametesEnMetrics <- read_tsv("Gametes_EpistasisEnsemblePredictionsMetrics.tsv")

#Add a DataType Column
irisEnMetrics = add_column(irisEnMetrics, DataType = "Iris")
breastEnMetrics = add_column(breastEnMetrics, DataType = "Breast")
horseColicEnEnMetrics = add_column(horseColicEnMetrics, DataType = "HorseColic")
magicEnMetrics = add_column(magicEnMetrics, DataType = "Magic")
GametesEnMetrics = add_column(GametesEnMetrics, DataType = "Gametes")


irisEnMetrics %>% 
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> irisEnMetrics

breastEnMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> breastEnMetrics

horseColicEnMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> horseColicEnMetrics

magicEnMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> magicEnMetrics

  
GametesEnMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> GametesEnMetrics



## Basic Classifier Metrics 
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

GametesMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> GametesMetrics

magicMetrics %>%
  group_by(Classifier, DataType) %>%
  summarize(Accuracy = mean(Accuracy), 
            f1_score = mean(f1_score), 
            f1_weighted = mean(f1_weighted), 
            average_precision = mean(average_precision),
            roc_auc = mean(roc_auc)) %>%
  pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") -> magicMetrics


combinedM = rbind(irisMetrics, horseColicMetrics)
combinedM = rbind(combinedM, magicMetrics)
combinedM = rbind(combinedM, GametesMetrics)
combinedM = rbind(combinedM, breastMetrics)

view(combinedM)

redBlueCB = c("#d73027", "#f46d43", "#fdae61", "#74add1", "#4575b4")

combinedM %>%
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


##FIX MEE
##Swith the datyType and Metrics?? 
combinedM %>%
  filter(Classifier != "LCA") %>%
  filter(Classifier != "AutoSklearn") %>%
  ggplot(aes(x=DataType, y=TypesOfMetrics, fill = DataType)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  theme_bw(base_size = 15) + 
  ggtitle("Metrics for Basic Classifiers") +
  #facet_grid(.~ TypesOfMetrics) +
  #facet_grid(Classifier ~ DataType) + 
  scale_fill_manual(values=redBlueCB) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) + 
  theme(legend.position="none") +
  xlab("Metrics") +
  theme(plot.title=element_text(hjust=0.5)) 
#ggsave("MetricsforBasicClassifiersBarPlot.pdf", width = 9, height = 6.5, units = "in")






##Make a line graph with the y-axis the roc_score
combinedM %>%
  #pivot_longer(Accuracy:roc_auc, names_to = "TypesofMetrics", values_to = "Score") %>%
  filter(TypesofMetrics == "roc_auc") %>%
  filter(Classifier != "AutoSklearn") %>%
  filter(Classifier != "LCA") %>%
  #filter(Iteration == "1") %>%
  ggplot(aes(x = Classifier, y = Score , color = DataType, group = 1)) + 
  scale_color_manual(values=c("#e41a1c", "#e41a1c", "#e41a1c", "#e41a1c", "#e41a1c")) + #values=redBlueCB
  facet_grid(~DataType) + 
  geom_line() + 
  geom_point() + 
  xlab("Basic Classifer") + 
  ylab("roc_auc score") + 
  theme_bw(base_size = 18) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) + 
  theme(legend.position="none") + 
  #scale_x_continuous(expand = c(0, 0), limits = c(0, NA)) + 
  #scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +
  theme(plot.title=element_text(hjust=0.5)) 

#ggsave("MetricsLineBasicClassifiersOneIteration.pdf", width = 9, height = 6.5, units = "in")


# ----------- Make a line plot with basic classifier and basic ensemble metrics ------ #

combinedEnM = rbind(combinedM, breastEnMetrics)
#combinedEnM = rbind(combinedEnM, irisEnMetrics)
combinedEnM = rbind(combinedEnM, horseColicEnMetrics)
combinedEnM = rbind(combinedEnM, magicEnMetrics)
combinedEnM = rbind(combinedEnM, GametesEnMetrics)

view(combinedEnM)

combinedEnM %>%
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

combinedEnM %>%
  filter(TypesofMetrics == "roc_auc") %>%
  #filter(Classifier != "AutoSklearn") %>%
  #filter(Classifier != "LCA") %>%
  ggplot(aes(x = Classifier, y = Score , color = DataType, group = 1)) + 
  scale_color_manual(values=c("#e41a1c", "#e41a1c", "#e41a1c", "#e41a1c", "#e41a1c")) + #values=redBlueCB
  facet_grid(~DataType) + 
  geom_line() + 
  geom_point() + 
  xlab("Basic Classifer") + 
  ylab("roc_auc score") + 
  theme_bw(base_size = 18) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) + 
  theme(legend.position="none") + 
  theme(plot.title=element_text(hjust=0.5)) 
ggsave("MetricsLineSixClassifiers.pdf", width = 9, height = 6.5, units = "in")


#--------------------------------------------------------------------------------------------------------------#
library(tidyverse)

#Read in all the basic Classifications Data
iris <- read_tsv("irisClassifications_1.tsv")
breast <- read_tsv("breastClassifications_1.tsv")
horseColic <- read_tsv("horse_colicClassifications_1.tsv")
magic <- read_tsv("magicClassifications_1.tsv")
#Gametes <- read_tsv("Gametes_EpistasisClassifications.tsv")

#Read in Weighted Classifications
irisW <- read_tsv("irisWeightedClassifications_1.tsv")
breastW <- read_tsv("breastWeightedClassifications_1.tsv")
horseColicW <- read_tsv("horse_colicWeightedClassifications_1.tsv")
magicW <- read_tsv("magicWeightedClassifications_1.tsv")
#GametesW <- read_tsv()


#Read in data with Ensemble Predictions with Weights 
irisEPW <- read_tsv("irisEnsemblePredicationsWithWeights_1.tsv")
breastEPW <- read_tsv("breastEnsemblePredicationsWithWeights_1.tsv")
horseColicEPW <- read_tsv("Horse_colicEnsemblePredicationsWithWeights_1.tsv")
#magicEPW <- read_tsv(magicEnsemblePredicationsWithWeights_1.tsv)
#GametesEPW <- read_tsv(GametesEnsemblePredicationsWithWeights_1.tsv)

view(irisEPW)


## -------Six box type graphs--------  ##


iris %>%
  #filter(Classifier != "LCA") %>%
  #filter(Classifier != "AutoSklearn") %>%
  mutate(Target = replace(Target, Target == 0, "Virginica")) %>%
  mutate(Target = replace(Target, Target == 1, "Versicolor")) %>%
  rename(Species = Target) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Species, levels=c("Virginica","Versicolor" ))), size = 2) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ factor(Species, levels=c("Virginica","Versicolor" ))) + 
  theme_bw(base_size = 18) + 
  labs(color="Species") +
  ggtitle("Iris Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") + 
  theme(legend.position="none") + 
  theme(plot.title=element_text(hjust=0.5))
#ggsave("IrisClassificationsOneIteration.pdf", width = 9, height = 6.5, units = "in")

breast %>%
  #filter(Classifier != "LCA") %>%
  #filter(Classifier != "AutoSklearn") %>%
  mutate(Target = replace(Target, Target == 0, "Class One")) %>%
  mutate(Target = replace(Target, Target == 1, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Target)) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ Target) + 
  theme_bw(base_size = 12) + 
  labs(color="Target") +
  ggtitle("Breast Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") + 
  theme(legend.position="none") + 
  theme(plot.title=element_text(hjust=0.5))
#ggsave("BreastClassificationsOneIteration.pdf", width = 9, height = 6.5, units = "in")

horseColic %>%
  #filter(Classifier != "LCA") %>%
  #filter(Classifier != "AutoSklearn") %>%
  mutate(Target = replace(Target, Target == 1, "Class One")) %>%
  mutate(Target = replace(Target, Target == 2, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Target)) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ Target) + 
  theme_bw(base_size = 16) + 
  labs(color="Target") +
  ggtitle("Horse Colic Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") + 
  theme(legend.position="none") + 
  theme(plot.title=element_text(hjust=0.5))
#ggsave("HorseColicClassificationsOneIteration.pdf", width = 9, height = 6.5, units = "in")
  
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
  theme_bw(base_size = 16) + 
  labs(color="Target") +
  ggtitle("Magic Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") + 
  theme(legend.position="none") + 
  theme(plot.title=element_text(hjust=0.5))
#ggsave("MagicClassificationsOneIteration.pdf", width = 9, height = 6.5, units = "in")


Gametes %>%
  filter(Iteration == "1") %>%
  mutate(Target = replace(Target, Target == 0, "Class One")) %>%
  mutate(Target = replace(Target, Target == 1, "Class Two")) %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = factor(Target))) +
  facet_grid(.~ Classifier) + 
  facet_grid(Classifier ~ Target) + 
  theme_bw(base_size = 16) + 
  labs(color="Target") +
  ggtitle("Gametes Epistasis Classifications") +
  scale_color_manual(values = c("purple", "green")) + 
  ylab("Original Row Number") + 
  xlab("Prediction Score") +
  theme(legend.position="none")
#ggsave("SixBoxesGametesEpistasisClassifications.pdf", width = 9, height = 6.5, units = "in")



#_________________________________________________________________________________________________________________#

library(tidyverse)

Gametes = Gametes_EpistasisClassifications

print(Gametes)

#Graph with three columns for the three basic classifiers 
Gametes %>%
  filter(Iteration == "1") %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Classifier)) +
  facet_wrap(~Classifier) + 
  theme_bw() + 
  theme(legend.position = "none") +
  ggtitle("Gametes Epistasis Classifications") +
  scale_color_brewer(palette = "Dark2")

Gametes %>%
  filter(Iteration == "1") %>%
  filter(Classifier == "KNeighbors") %>%
  filter(OriginalRow <= 100) %>%
  arrange(Target) %>%
  ggplot(aes(x = OriginalRow, y= PredictionScore)) + 
  geom_point(aes(color = Classifier)) +
  geom_point(aes(x = OriginalRow, y = Target)) +
  geom_line(aes(x = OriginalRow, y= PredictionScore), color = "red") + 
  #facet_wrap(~Classifier) + 
  theme_bw() + 
  theme(legend.position = "none") +
  ggtitle("Gametes Epistasis Classifications") +
  scale_color_brewer(palette = "Dark2")

Gametes %>%
  filter(Iteration == "1") %>%
  ggplot(aes(x = OriginalRow, y = PredictionScore)) + 
  geom_point(aes(color = Classifier)) +
  facet_grid(~factor(Target, levels=c('1', '0')), scales = 'free' ) +
  theme_bw() + 
  ggtitle("Gametes Epistasis Classifications Seperated by Target") +
  xlab("Orginal Row Number") +
  ylab("Prediction Score") + 
  labs(color = "Basic Classifier") +
  scale_color_brewer(palette = "Dark2")

irisEnsemble = irisEnsemblePredictions
irisWithWeights = irisEnsemblePredictionsWithWeightsTesting

irisClassifications %>%
  filter(Classifier != "LCA") %>%
  filter(Classifier != "AutoSklearn") %>%
  ggplot(aes(x = OriginalRow, y = PredictionScore)) + 
  geom_point(aes(color = Classifier)) +
  facet_grid(~factor(Target, levels=c('1', '0')), scales = 'free' ) +
  theme_bw() + 
  ggtitle("Iris Classifications (Step One)") +
  xlab("Orginal Row Number") +
  ylab("Prediction Score") + 
  labs(color = "Basic Classifier") +
  scale_color_brewer(palette = "Dark2") #-> StepOne

irisEnsemble %>%
  ggplot(aes(x = OriginalRow, y = PredictionScore)) + 
  geom_point(aes(color = Classifier)) +
  facet_grid(~factor(Target, levels=c('1', '0')), scales = 'free' ) +
  theme_bw() + 
  ggtitle("Iris Ensemble Predictions (Step Two)") +
  xlab("Orginal Row Number") +
  ylab("Prediction Score") + 
  labs(color = "Basic Ensemble") +
  scale_color_brewer(palette = "Dark2") #-> StepTwo

irisWithWeights %>%
  ggplot(aes(x = OriginalRow, y = PredictionScore)) + 
  geom_point(aes(color = Classifier)) +
  facet_grid(~factor(Target, levels=c('1', '0')), scales = 'free' ) +
  theme_bw() + 
  ggtitle("Iris Ensemble with Weights (Step Three)") +
  xlab("Orginal Row Number") +
  ylab("Prediction Score") + 
  labs(color = "Basic Ensemble 
  with Weights") +
  scale_color_brewer(palette = "Dark2") ##-> StepThree



irisEnsemble %>% 
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Classifier)) +
  facet_wrap(~Classifier) + 
  theme_bw() + 
  theme(legend.position = "none") +
  ggtitle("Iris Ensemble Predictions with Five Iterations") +
  scale_color_brewer(palette = "Dark2")

irisWithWeights %>% 
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Classifier)) +
  facet_wrap(~Classifier) + 
  theme_bw() + 
  theme(legend.position = "none") +
  ggtitle("Iris Ensemble Predictions with Weights") +
  scale_color_brewer(palette = "Dark2")

irisEnsemble %>% 
  filter(Classifier == "AvgPrediction") %>%
  ggplot(aes(x = Target, y= OriginalRow)) + 
  geom_point() +
  theme_bw()

irisEnsemble %>% 
  filter(Classifier == "AvgPrediction") %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point() +
  theme_bw()

irisEnsemble %>% 
  filter(Classifier == "AvgPrediction") %>%
  ggplot(aes(x = Prediction, y= OriginalRow)) + 
  geom_point() +
  theme_bw()


irisEnsemble %>% 
  filter(Classifier == "AvgPrediction") %>%
  pivot_longer(c(PredictionScore, Prediction, Target), names_to = "names", values_to = "Pred" ) %>%
  ggplot(aes(x = Pred, y= OriginalRow)) + 
  geom_point(aes(color = names)) +
  theme_bw() + 
  ggtitle("Iris Ensemble Predictions for AvgPrediction") +
  xlab("Predictions") + 
  ylab("Original Row Number") + 
  labs(color = "Predication Type") +
  scale_color_brewer(palette = "Dark2")


irisWithWeights %>% 
  filter(Classifier == "AverageProb") %>%
  pivot_longer(c(PredictionScore, Prediction, Target), names_to = "names", values_to = "Pred" ) %>%
  ggplot(aes(x = Pred, y= OriginalRow)) + 
  geom_point(aes(color = names)) +
  theme_bw() + 
  ggtitle("Iris with Weights AverageProb") +
  xlab("Predictions") + 
  ylab("Original Row Number") + 
  labs(color = "Predication Type") +
  scale_color_brewer(palette = "Dark2")


##Second batch of graphs 
Gametes %>%
  filter(Iteration == "1") %>%
  ggplot(aes(x = OriginalRow, y= PredictionScore)) + 
  geom_point(aes(color = Classifier)) +
  #facet_wrap(~Classifier) + 
  theme_bw() + 
  theme(legend.position = "none") +
  ggtitle("Gametes Epistasis Classifications") +
  scale_color_brewer(palette = "Dark2")


irisEnsemble %>% 
  #filter(Iteration == "1") %>%
  filter(Classifier == "AvgPrediction") %>%
  arrange(Target) %>%
  ggplot(aes(x = OriginalRow, y= PredictionScore)) + 
  geom_point(aes(color = Classifier)) +
  geom_point(aes(x = OriginalRow, y = Target)) +
  #geom_line(aes(x = OriginalRow, y= PredictionScore), color = "red") + 
  #facet_wrap(~Classifier) + 
  theme_bw() + 
  theme(legend.position = "none") +
  ggtitle("Iris Basic Ensemble") +
  scale_color_brewer(palette = "Dark2")

irisEnsemble %>% 
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Classifier)) +
  facet_wrap(~Target) + 
  theme_bw() + 
  ggtitle("Iris Ensemble Predictions with Five Iterations") +
  scale_color_brewer(palette = "Dark2")


horse_colic = horse_colicClassifications

horse_colic%>%
  filter(Iteration == "1") %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Classifier)) +
  facet_wrap(~Classifier) + 
  theme_bw() + 
  ggtitle("Iris Ensemble Predictions with Five Iterations") +
  scale_color_brewer(palette = "Dark2")

horse_colic%>%
  filter(Iteration == "1") %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Classifier)) +
  facet_wrap(~Target) + 
  theme_bw() + 
  ggtitle("Iris Ensemble Predictions with Five Iterations") +
  scale_color_brewer(palette = "Dark2")


horse_colic%>%
  filter(Iteration == "1") %>%
  filter(Target == "1") %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Classifier)) +
  facet_wrap(~Classifier) + 
  theme_bw() + 
  ggtitle("Iris Ensemble Predictions with Five Iterations") +
  scale_color_brewer(palette = "Dark2")

horse_colic%>%
  filter(Iteration == "1") %>%
  filter(Target == "2") %>%
  ggplot(aes(x = PredictionScore, y= OriginalRow)) + 
  geom_point(aes(color = Classifier)) +
  facet_wrap(~Classifier) + 
  theme_bw() + 
  ggtitle("Iris Ensemble Predictions with Five Iterations") +
  scale_color_brewer(palette = "Dark2")

##COMEPARING THE METRICS FOR IRIS CLASSIFICATIONS 
irisMetrics %>% 
  pivot_longer(Accuracy:roc_auc, names_to = "TypeofMetric", values_to = "Values") %>%
  ggplot(aes(x = TypeofMetric, y = Values)) + 
  geom_point(aes(color = Classifier)) + 
  facet_wrap(~Classifier) + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  scale_color_brewer(palette = "Dark2") + 
  theme(legend.position = "none") + 
  ggtitle("Iris Metrics for Five Interations") 

##Graphs for Basic Classification of all datasets

horse_colic%>%
  filter(Iteration == "1") %>%
  filter(Classifier != "LCA") %>%
  filter(Classifier != "AutoSklearn") %>%
  ggplot(aes(x = OriginalRow, y = PredictionScore)) + 
  geom_point(aes(color = Classifier)) +
  facet_grid(~Target, scales = 'free' ) +
  theme_bw() + 
  ggtitle("Horse Colic Classification") +
  xlab("Original Row Number") +
  ylab("Prediction Score") + 
  labs(color = "Basic Classifier") +
  scale_color_brewer(palette = "Dark2")


magicClassifications %>% 
  filter(Iteration == "1") %>%
  filter(OriginalRow <= 1000 | OriginalRow >= 18000) %>%
  ggplot(aes(x = OriginalRow, y = PredictionScore)) + 
  geom_point(aes(color = Classifier)) +
  facet_grid(~Target, scales = 'free' ) +
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  ggtitle("Magic Classification") +
  xlab("Original Row Number") +
  ylab("Prediction Score") + 
  labs(color = "Basic Classifier") +
  scale_color_brewer(palette = "Dark2")

breastClassifications %>%
  filter(Iteration == "1") %>%
  filter(Classifier != "LCA") %>%
  filter(Classifier != "AutoSklearn") %>%
  ggplot(aes(x = OriginalRow, y = PredictionScore)) + 
  geom_point(aes(color = Classifier)) +
  facet_grid(~Target, scales = 'free' ) +
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  ggtitle("Breast Classification") +
  xlab("Original Row Number") +
  ylab("Prediction Score") + 
  labs(color = "Basic Classifier") +
  scale_color_brewer(palette = "Dark2")


 


