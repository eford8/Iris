library(tidyverse)
library(ggrepel)
library(scales)

metricsData = read_tsv("Metrics.tsv", show_col_types = FALSE)
view(metricsData)

metricsData %>%
  mutate(Classifier = case_when(Classifier == "AverageProb" ~ "MeanProb", 
                                TRUE ~ Classifier)) -> metricsData


blue_red_cd_friendly = c("#d73027", "#f46d43", "#fdae61", "#abd9e9", "#74add1")
blue_brown_cb_friendly = c("#01665e", "#35978f",  "#80cdc1", "#dfc27d", "#8c510a")
light_blue_and_yellow_friendly = c("#74add1", "#abd9e9", "#fee090", "#fdae61", "#f46d43")


##---------------------Median-------------------------------####
metricsData %>%
  group_by(Classifier) %>%
  summarise(Median_Time = median(Time)) -> timeData

metricsData %>%
  group_by(Classifier) %>%
  summarise(Median_Roc_auc = median(roc_auc)) -> rocData

joinedData = inner_join(timeData, rocData, by = "Classifier")

joinedData %>%
  mutate(PredictionType = case_when(str_starts(Classifier, "AutoSklearn") ~ "AutoSklearn Ensemble",
         str_detect(Classifier, "Prob") ~ "Basic Ensemble", 
         str_detect(Classifier, "Vote") ~ "Basic Ensemble", 
         Classifier == "DESClustering" | Classifier == "KNORAE" | Classifier == "METADES" | Classifier == "LCA" ~ "DESlib Ensemble", 
         Classifier == "KNeighbors" | Classifier == "LogisticRegression" | Classifier =="RandomForest" | Classifier == "SVC" ~ "Basic")) %>%
  mutate(PredictionType = factor(PredictionType, levels = c("Basic", "Basic Ensemble", "DESlib Ensemble", "AutoSklearn Ensemble" )))-> joinedData

joinedData %>%
  mutate(Classifier = case_when( Classifier == "AutoSklearn: Pick one from a list" ~ "Auto/Pick one from list", 
                                 Classifier == "AutoSklearn: Ensemble from a list" ~ "Auto/Ensemble from list", 
                                 Classifier == "AutoSklearn: Pick one from all algorithms" ~ "Auto/Pick one from all",
                                 Classifier == "AutoSklearn: Unrestricted ensemble" ~ "Auto/Ensemble from all", 
                                 TRUE ~ Classifier)) -> joinedData

median_colors <- data.frame(xmin = c(0.6, 0.60, 0.60, 0.8, 0.8),
                          xmax = c(0.60, 0.8, 0.8, 1.0, 1.0), 
                          ymin = c(0, 30, 0, 30, 0),
                          ymax = c(200, 200, 30, 200, 30),
                          fillings = factor(c("Poor predictive ability", "Slow, moderate predictive ability",
                                              "Fast, moderate predictive ability",  "Slow, high predictive ability",
                                              "Fast, high predictive ability"), levels = c( "Fast, high predictive ability", 
                                                                                            "Slow, high predictive ability",
                                                                                            "Fast, moderate predictive ability",
                                                                                            "Slow, moderate predictive ability",
                                                                                            "Poor predictive ability")))


breast_colors <- data.frame(xmin = c(0.4, 0.6, 0.6, 0.8, 0.8),
                            xmax = c(0.6, 0.8, 0.8, 1.0, 1.0), 
                            ymin = c(0, 30, 0, 30, 0),
                            ymax = c(400, 400, 30, 400, 30),
                            fillings = factor(c("Poor predictive ability", "Slow, moderate predictive ability",
                                                "Fast, moderate predictive ability",  "Slow, high predictive ability",
                                                "Fast, high predictive ability"), levels = c( "Fast, high predictive ability", 
                                                                                              "Slow, high predictive ability",
                                                                                              "Fast, moderate predictive ability",
                                                                                              "Slow, moderate predictive ability",
                                                                                              "Poor predictive ability")))

ggplot() +
  geom_rect(data = breast_colors, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fillings)) +
  geom_point(data = joinedData, aes(x = Median_Roc_auc, y = Median_Time, shape = PredictionType), size = 3, fill = "black") + 
  geom_text_repel(data = joinedData, aes(x = Median_Roc_auc, y = Median_Time, label = Classifier)) + 
  xlab("AUROC (median)") + 
  ylab("Time (median) in seconds") + 
  scale_shape_manual(values = c(15, 19, 17, 23)) + 
  scale_y_sqrt(limits = c(0, 400)) +
  scale_x_continuous(limits=c(0.4, 1)) +
  coord_cartesian(expand = FALSE) + 
  labs(shape = "", fill = "") + 
  #ggtitle("Time vs AUROC for All Non-gene Expression Datasets") +
  scale_fill_manual(values = light_blue_and_yellow_friendly) +
  theme_bw(base_size = 18) 
#ggsave("Light_blue_Median_Time_vs_Median_AUROC_by_Classifier.jpeg", width = 9, height = 7, units = "in") #jpeg
ggsave("Light_blue_Median_Time_vs_Median_AUROC_by_Classifier.png", width = 12, height = 6.5, units = "in")  #jpeg, 12, 6.5


##---------------------Mean-------------------------------####
metricsData %>%
  group_by(Classifier) %>%
  summarise(Mean_Time = mean(Time)) -> meanTimeData

metricsData %>%
  group_by(Classifier) %>%
  summarise(Mean_Roc_auc = mean(roc_auc)) -> meanRocData

meanJoinedData = inner_join(meanTimeData, meanRocData, by = "Classifier")

colors_cb_friend = c("#01665e", "#35978f",  "#80cdc1", "#dfc27d", "#8c510a")
mean_colors <- data.frame(xmin = c(0.6, 0.65, 0.65, 0.8, 0.8),
                          xmax = c(0.65, 0.8, 0.8, 1.0, 1.0), 
                          ymin = c(0, 30, 0, 30, 0),
                          ymax = c(200, 200, 30, 200, 30),
                          fillings = factor(c("Poor predictive ability", "Slow, moderate predictive ability",
                                       "Fast, moderate predictive ability",  "Slow, high predictive ability",
                                       "Fast, high predictive ability"), levels = c( "Fast, high predictive ability", 
                                                                                     "Slow, high predictive ability",
                                                                                     "Fast, moderate predictive ability",
                                                                                     "Slow, moderate predictive ability",
                                                                                     "Poor predictive ability")))

ggplot() +
  geom_rect(data = mean_colors, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fillings)) +
  geom_point(data = meanJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time)) + 
  geom_text_repel(data = meanJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time, label = Classifier)) + 
  xlab("AUROC (mean)") + 
  ylab("Time (mean) in seconds") + 
  scale_y_sqrt(limits = c(0, 200)) +
  theme_bw() + 
  scale_x_continuous(limits=c(0.6, 1)) +
  coord_cartesian(expand = FALSE) + 
  labs(fill = "") + 
  scale_fill_manual(values = cb_friendly) 
ggsave("Mean_Time_vs_Mean_AUROC_by_Classifier.pdf", width = 9, height = 6.5, units = "in") #jpeg

##---------------------Median - iris -------------------------------####

metricsData %>%
  filter(DataName == "iris") %>%
  group_by(Classifier) %>%
  summarise(Median_Time = median(Time)) -> timeData

metricsData %>%
  filter(DataName == "iris") %>%
  group_by(Classifier) %>%
  summarise(Median_Roc_auc = median(roc_auc)) -> rocData

joinedData = inner_join(timeData, rocData, by = "Classifier")
#view(joinedData)

joinedData %>%
  mutate(PredictionType = case_when(str_starts(Classifier, "AutoSklearn") ~ "AutoSklearn Ensemble",
                                    str_detect(Classifier, "Prob") ~ "Basic Ensemble", 
                                    str_detect(Classifier, "Vote") ~ "Basic Ensemble", 
                                    Classifier == "DESClustering" | Classifier == "KNORAE" | Classifier == "METADES" | Classifier == "LCA" ~ "DESlib Ensemble", 
                                    Classifier == "KNeighbors" | Classifier == "LogisticRegression" | Classifier =="RandomForest" | Classifier == "SVC" ~ "Basic")) %>%
  mutate(PredictionType = factor(PredictionType, levels = c("Basic", "Basic Ensemble", "DESlib Ensemble", "AutoSklearn Ensemble" )))-> joinedData

iris_colors <- data.frame(xmin = c(0.6, 0.65, 0.65, 0.8, 0.8),
                            xmax = c(0.65, 0.8, 0.8, 1.2, 1.2), 
                            ymin = c(0, 30, 0, 30, 0),
                            ymax = c(200, 200, 30, 200, 30),
                            fillings = factor(c("Poor predictive ability", "Slow, moderate predictive ability",
                                                "Fast, moderate predictive ability",  "Slow, high predictive ability",
                                                "Fast, high predictive ability"), levels = c( "Fast, high predictive ability", 
                                                                                              "Slow, high predictive ability",
                                                                                              "Fast, moderate predictive ability",
                                                                                              "Slow, moderate predictive ability",
                                                                                              "Poor predictive ability")))

ggplot() +
  geom_rect(data = iris_colors, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fillings)) +
  geom_point(data = joinedData, aes(x = Median_Roc_auc, y = Median_Time, shape = PredictionType)) + 
  geom_text_repel(data = joinedData, aes(x = Median_Roc_auc, y = Median_Time, label = Classifier)) + 
  xlab("AUROC (median)") + 
  ylab("Time (median) in seconds") + 
  scale_y_sqrt(limits = c(0, 200)) +
  theme_bw(base_size = 18) +
  scale_x_continuous(limits=c(0.6, 1.2)) +
  coord_cartesian(expand = FALSE) + 
  labs(shape = "Prediction Type", fill = "") + 
  ggtitle("Dataset: Iris") +
  scale_fill_manual(values = light_blue_and_yellow_friendly) 
ggsave("Iris_Median_Time_vs_Median_AUROC_by_Classifier.jpeg", width = 9, height = 6.5, units = "in") #jpeg


##---------------------Median - breast -------------------------------####
metricsData %>%
  filter(DataName == "breast") %>%
  group_by(Classifier) %>%
  summarise(Mean_Time = median(Time)) -> breastTimeData

metricsData %>%
  filter(DataName == "breast") %>%
  group_by(Classifier) %>%
  summarise(Mean_Roc_auc = median(roc_auc)) -> breastRocData

breastJoinedData = inner_join(breastTimeData, breastRocData, by = "Classifier")
#view(breastJoinedData)

breastJoinedData %>%
  mutate(PredictionType = case_when(str_starts(Classifier, "AutoSklearn") ~ "AutoSklearn Ensemble",
                                    str_detect(Classifier, "Prob") ~ "Basic Ensemble", 
                                    str_detect(Classifier, "Vote") ~ "Basic Ensemble", 
                                    Classifier == "DESClustering" | Classifier == "KNORAE" | Classifier == "METADES" | Classifier == "LCA" ~ "DESlib Ensemble", 
                                    Classifier == "KNeighbors" | Classifier == "LogisticRegression" | Classifier =="RandomForest" | Classifier == "SVC" ~ "Basic")) %>%
  mutate(PredictionType = factor(PredictionType, levels = c("Basic", "Basic Ensemble", "DESlib Ensemble", "AutoSklearn Ensemble" )))-> breastJoinedData


breast_colors <- data.frame(xmin = c(0.4, 0.65, 0.65, 0.8, 0.8),
                            xmax = c(0.65, 0.8, 0.8, 1.0, 1.0), 
                            ymin = c(0, 30, 0, 30, 0),
                            ymax = c(400, 400, 30, 400, 30),
                            fillings = factor(c("Poor predictive ability", "Slow, moderate predictive ability",
                                                "Fast, moderate predictive ability",  "Slow, high predictive ability",
                                                "Fast, high predictive ability"), levels = c( "Fast, high predictive ability", 
                                                                                              "Slow, high predictive ability",
                                                                                              "Fast, moderate predictive ability",
                                                                                              "Slow, moderate predictive ability",
                                                                                              "Poor predictive ability")))


ggplot() +
  geom_rect(data = breast_colors, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fillings)) +
  geom_point(data = breastJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time, shape = PredictionType)) + 
  geom_text_repel(data = breastJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time, label = Classifier)) + 
  xlab("AUROC (median)") + 
  ylab("Time (median) in seconds") + 
  scale_y_sqrt(limits = c(0, 400)) +
  theme_bw(base_size = 18) + 
  scale_x_continuous(limits=c(0.4, 1)) +
  coord_cartesian(expand = FALSE) + 
  labs(shape = "Prediction Type", fill = "") + 
  scale_fill_manual(values = light_blue_and_yellow_friendly) +
  ggtitle("Dataset: Breast")
ggsave("Breast_Median_Time_vs_median_AUROC_by_Classifier.jpeg", width = 9, height = 6.5, units = "in") #jpeg


##---------------------Median - horse_colic -------------------------------####

metricsData %>%
  filter(DataName == "horse_colic") %>%
  group_by(Classifier) %>%
  summarise(Mean_Time = median(Time)) -> horse_colicTimeData

metricsData %>%
  filter(DataName == "horse_colic") %>%
  group_by(Classifier) %>%
  summarise(Mean_Roc_auc = median(roc_auc)) -> horse_colicRocData

horse_colicJoinedData = inner_join(horse_colicTimeData, horse_colicRocData, by = "Classifier")

horse_colicJoinedData %>%
  mutate(PredictionType = case_when(str_starts(Classifier, "AutoSklearn") ~ "AutoSklearn Ensemble",
                                    str_detect(Classifier, "Prob") ~ "Basic Ensemble", 
                                    str_detect(Classifier, "Vote") ~ "Basic Ensemble", 
                                    Classifier == "DESClustering" | Classifier == "KNORAE" | Classifier == "METADES" | Classifier == "LCA" ~ "DESlib Ensemble", 
                                    Classifier == "KNeighbors" | Classifier == "LogisticRegression" | Classifier =="RandomForest" | Classifier == "SVC" ~ "Basic")) %>%
  mutate(PredictionType = factor(PredictionType, levels = c("Basic", "Basic Ensemble", "DESlib Ensemble", "AutoSklearn Ensemble" )))-> horse_colicJoinedData


horse_colic_colors <- data.frame(xmin = c(0.4, 0.65, 0.65, 0.8, 0.8),
                            xmax = c(0.65, 0.8, 0.8, 1.0, 1.0), 
                            ymin = c(0, 30, 0, 30, 0),
                            ymax = c(400, 400, 30, 400, 30),
                            fillings = factor(c("Poor predictive ability", "Slow, moderate predictive ability",
                                                "Fast, moderate predictive ability",  "Slow, high predictive ability",
                                                "Fast, high predictive ability"), levels = c( "Fast, high predictive ability", 
                                                                                              "Slow, high predictive ability",
                                                                                              "Fast, moderate predictive ability",
                                                                                              "Slow, moderate predictive ability",
                                                                                              "Poor predictive ability")))


ggplot() +
  geom_rect(data = horse_colic_colors, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fillings)) +
  geom_point(data = horse_colicJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time, shape = PredictionType)) + 
  geom_text_repel(data = horse_colicJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time, label = Classifier)) + 
  xlab("AUROC (median)") + 
  ylab("Time (median) in seconds") + 
  scale_y_sqrt(limits = c(0, 400)) +
  theme_bw(base_size = 18) + 
  scale_x_continuous(limits=c(0.4, 1)) +
  coord_cartesian(expand = FALSE) + 
  labs(shape = "Prediction Type", fill = "") + 
  scale_fill_manual(values = light_blue_and_yellow_friendly) +
  ggtitle("Dataset: Horse Colic")
ggsave("horse_colic_Median_Time_vs_Median_AUROC_by_Classifier.jpeg", width = 9, height = 6.5, units = "in") #jpeg



##--------------------- Median - Gametes_Epistasis -------------------------------####

metricsData %>%
  filter(DataName == "Gametes_Epistasis") %>%
  group_by(Classifier) %>%
  summarise(Mean_Time = median(Time)) -> Gametes_EpistasisTimeData

metricsData %>%
  filter(DataName == "Gametes_Epistasis") %>%
  group_by(Classifier) %>%
  summarise(Mean_Roc_auc = median(roc_auc)) -> Gametes_EpistasisRocData

Gametes_EpistasisJoinedData = inner_join(Gametes_EpistasisTimeData, Gametes_EpistasisRocData, by = "Classifier")
#view(Gametes_EpistasisJoinedData)

Gametes_EpistasisJoinedData %>%
  mutate(PredictionType = case_when(str_starts(Classifier, "AutoSklearn") ~ "AutoSklearn Ensemble",
                                    str_detect(Classifier, "Prob") ~ "Basic Ensemble", 
                                    str_detect(Classifier, "Vote") ~ "Basic Ensemble", 
                                    Classifier == "DESClustering" | Classifier == "KNORAE" | Classifier == "METADES" | Classifier == "LCA" ~ "DESlib Ensemble", 
                                    Classifier == "KNeighbors" | Classifier == "LogisticRegression" | Classifier =="RandomForest" | Classifier == "SVC" ~ "Basic")) %>%
  mutate(PredictionType = factor(PredictionType, levels = c("Basic", "Basic Ensemble", "DESlib Ensemble", "AutoSklearn Ensemble" )))-> Gametes_EpistasisJoinedData


Gametes_Epistasis_colors <- data.frame(xmin = c(0.4, 0.65, 0.65, 0.8, 0.8),
                            xmax = c(0.65, 0.8, 0.8, 1.0, 1.0), 
                            ymin = c(0, 30, 0, 30, 0),
                            ymax = c(400, 400, 30, 400, 30),
                            fillings = factor(c("Poor predictive ability", "Slow, moderate predictive ability",
                                                "Fast, moderate predictive ability",  "Slow, high predictive ability",
                                                "Fast, high predictive ability"), levels = c( "Fast, high predictive ability", 
                                                                                              "Slow, high predictive ability",
                                                                                              "Fast, moderate predictive ability",
                                                                                              "Slow, moderate predictive ability",
                                                                                              "Poor predictive ability")))


ggplot() +
  geom_rect(data = Gametes_Epistasis_colors, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fillings)) +
  geom_point(data = Gametes_EpistasisJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time, shape = PredictionType)) + 
  geom_text_repel(data = Gametes_EpistasisJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time, label = Classifier)) + 
  xlab("AUROC (median)") + 
  ylab("Time (median) in seconds") + 
  scale_y_sqrt(limits = c(0, 400)) +
  theme_bw(base_size = 18) + 
  scale_x_continuous(limits=c(0.4, 1)) +
  coord_cartesian(expand = FALSE) + 
  labs(shape = "Prediction Type", fill = "") + 
  scale_fill_manual(values = light_blue_and_yellow_friendly) +
  ggtitle("Dataset: Gametes_Epistasis")
ggsave("Gametes_Epistasis_Median_Time_vs_Median_AUROC_by_Classifier.jpeg", width = 9, height = 6.5, units = "in") #jpeg


##--------------------- Median - magic -------------------------------####

metricsData %>%
  filter(DataName == "magic") %>%
  group_by(Classifier) %>%
  summarise(Mean_Time = median(Time)) -> magicTimeData

metricsData %>%
  filter(DataName == "magic") %>%
  group_by(Classifier) %>%
  summarise(Mean_Roc_auc = median(roc_auc)) -> magicRocData

magicJoinedData = inner_join(magicTimeData, magicRocData, by = "Classifier")
#view(magicJoinedData)

magicJoinedData %>%
  mutate(PredictionType = case_when(str_starts(Classifier, "AutoSklearn") ~ "AutoSklearn Ensemble",
                                    str_detect(Classifier, "Prob") ~ "Basic Ensemble", 
                                    str_detect(Classifier, "Vote") ~ "Basic Ensemble", 
                                    Classifier == "DESClustering" | Classifier == "KNORAE" | Classifier == "METADES" | Classifier == "LCA" ~ "DESlib Ensemble", 
                                    Classifier == "KNeighbors" | Classifier == "LogisticRegression" | Classifier =="RandomForest" | Classifier == "SVC" ~ "Basic")) %>%
  mutate(PredictionType = factor(PredictionType, levels = c("Basic", "Basic Ensemble", "DESlib Ensemble", "AutoSklearn Ensemble" )))-> magicJoinedData


magic_colors <- data.frame(xmin = c(0.4, 0.65, 0.65, 0.8, 0.8),
                                       xmax = c(0.65, 0.8, 0.8, 1.0, 1.0), 
                                       ymin = c(0, 30, 0, 30, 0),
                                       ymax = c(400, 400, 30, 400, 30),
                                       fillings = factor(c("Poor predictive ability", "Slow, moderate predictive ability",
                                                           "Fast, moderate predictive ability",  "Slow, high predictive ability",
                                                           "Fast, high predictive ability"), levels = c( "Fast, high predictive ability", 
                                                                                                         "Slow, high predictive ability",
                                                                                                         "Fast, moderate predictive ability",
                                                                                                         "Slow, moderate predictive ability",
                                                                                                         "Poor predictive ability")))

ggplot() +
  geom_rect(data = magic_colors, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fillings)) +
  geom_point(data = magicJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time, shape = PredictionType)) + 
  geom_text_repel(data = magicJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time, label = Classifier)) + 
  xlab("AUROC (median)") + 
  ylab("Time (median) in seconds") + 
  scale_y_sqrt(limits = c(0, 400)) +
  theme_bw(base_size = 18) + 
  scale_x_continuous(limits=c(0.4, 1)) +
  coord_cartesian(expand = FALSE) + 
  labs(shape = "Prediction Type", fill = "") + 
  scale_fill_manual(values = light_blue_and_yellow_friendly) +
  ggtitle("Dataset: Magic")
ggsave("Magic_Median_Time_vs_Median_AUROC_by_Classifier.jpeg", width = 9, height = 6.5, units = "in") #jpeg


##--------------------- Median- Hypothyroid -------------------------------####

metricsData %>%
  filter(DataName == "hypothyroid") %>%
  group_by(Classifier) %>%
  summarise(Mean_Time = median(Time)) -> hypoTimeData

metricsData %>%
  filter(DataName == "hypothyroid") %>%
  group_by(Classifier) %>%
  summarise(Mean_Roc_auc = median(roc_auc)) -> hypoRocData

hypoJoinedData = inner_join(hypoTimeData, hypoRocData, by = "Classifier")
#view(hypoJoinedData)

hypoJoinedData %>%
  mutate(PredictionType = case_when(str_starts(Classifier, "AutoSklearn") ~ "AutoSklearn Ensemble",
                                    str_detect(Classifier, "Prob") ~ "Basic Ensemble", 
                                    str_detect(Classifier, "Vote") ~ "Basic Ensemble", 
                                    Classifier == "DESClustering" | Classifier == "KNORAE" | Classifier == "METADES" | Classifier == "LCA" ~ "DESlib Ensemble", 
                                    Classifier == "KNeighbors" | Classifier == "LogisticRegression" | Classifier =="RandomForest" | Classifier == "SVC" ~ "Basic")) %>%
  mutate(PredictionType = factor(PredictionType, levels = c("Basic", "Basic Ensemble", "DESlib Ensemble", "AutoSklearn Ensemble" )))-> hypoJoinedData

hypo_colors <- data.frame(xmin = c(0.4, 0.65, 0.65, 0.8, 0.8),
                           xmax = c(0.65, 0.8, 0.8, 1.0, 1.0), 
                           ymin = c(0, 30, 0, 30, 0),
                           ymax = c(400, 400, 30, 400, 30),
                           fillings = factor(c("Poor predictive ability", "Slow, moderate predictive ability",
                                               "Fast, moderate predictive ability",  "Slow, high predictive ability",
                                               "Fast, high predictive ability"), levels = c( "Fast, high predictive ability", 
                                                                                             "Slow, high predictive ability",
                                                                                             "Fast, moderate predictive ability",
                                                                                             "Slow, moderate predictive ability",
                                                                                             "Poor predictive ability")))


ggplot() +
  geom_rect(data = hypo_colors, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fillings)) +
  geom_point(data = hypoJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time, shape = PredictionType)) + 
  geom_text_repel(data = hypoJoinedData, aes(x = Mean_Roc_auc, y = Mean_Time, label = Classifier)) + 
  xlab("AUROC (median)") + 
  ylab("Time (median) in seconds") + 
  scale_y_sqrt(limits = c(0, 400)) +
  theme_bw(base_size = 18) + 
  scale_x_continuous(limits=c(0.4, 1)) +
  coord_cartesian(expand = FALSE) + 
  labs(shape = "Prediction Type", fill = "") + 
  scale_fill_manual(values = light_blue_and_yellow_friendly) +
  ggtitle("Dataset: Hypothyroid")
ggsave("Hypothyroid_Median_Time_vs_Median_AUROC_by_Classifier.jpeg", width = 9, height = 6.5, units = "in") #jpeg
  

 
