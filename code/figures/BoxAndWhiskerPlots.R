library(tidyverse)

metricsData = read_tsv("Metrics.tsv", show_col_types = FALSE)
view(metricsData)

metricsData %>%
  mutate(Classifier = case_when(Classifier == "AverageProb" ~ "MeanProb", 
                                TRUE ~ Classifier)) -> metricsData
metricsData %>%
  mutate(Classifier = case_when(Classifier ==  "AutoSklearn: Pick one from all algorithms" ~ "Auto/Pick one from all", 
                                Classifier == "AutoSklearn: Pick one from a list" ~ "Auto/Pick one from list",
                                Classifier == "AutoSklearn: Ensemble from a list" ~ "Auto/Ensemble from list",
                                Classifier == "AutoSklearn: Unrestricted ensemble" ~ "Auto/Ensemble from all",
                                TRUE ~ Classifier)) -> metricsData
     
metricsData %>%
  mutate(Classifier = factor(Classifier, levels = c("Auto/Pick one from list",
                                                    "Auto/Ensemble from list",
                                                    "Auto/Pick one from all", 
                                                    "Auto/Ensemble from all",
                                                    "DESClustering", 
                                                    "METADES", 
                                                    "KNORAE", 
                                                    "LCA",  
                                                    "MajorityVote", "ExtremeProb", "MeanProb",
                                                    "LogisticRegression", 
                                                    "SVC", "KNeighbors",
                                                    "RandomForest" ))) -> metricsData

metricsData %>%
  mutate(DataName = case_when(DataName == "iris" ~ "Iris", 
                              DataName == "breast" ~ "Breast", 
                              DataName == "horse_colic" ~ "Horse Colic", 
                              DataName == "Gametes_Epistasis" ~ "Gametes Epistasis", 
                              DataName == "hypothyroid" ~ "Hypothyroid", 
                              DataName == "magic" ~ "Magic")) -> metricsData
  

light_blue_and_yellow_friendly = c("#74add1", "#abd9e9", "#fee090", "#fdae61", "#f46d43")
red_and_blue_friendly = c("#a50026","#abd9e9" , "#f46d43", "#fee090", "#d73027", "#4575b4")


point_shapes = c(15, 16, 17, 18, 16, 15)

ggplot(data = metricsData, aes(x = Classifier, y = roc_auc)) + 
  geom_boxplot(lwd=2) + 
  geom_jitter(aes(color=DataName, shape = DataName), size=5, alpha=0.9) +
  coord_flip() + 
  theme_bw(base_size=30) + #24
  scale_color_manual(values = red_and_blue_friendly) +
  scale_shape_manual(values = point_shapes) + 
  ggtitle("AUROC score variation among datasets") +
  xlab("") + 
  ylab("AUROC") + 
  labs(color = "Dataset", shape = "Dataset")
ggsave("AUROC_score_variation_among_datasets.png", width = 24, height = 13, units = "in") #jpeg
