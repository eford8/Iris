library(tidyverse)
library(ggrepel)
library(scales)


metricsGSE2109Breast = read_tsv("MetricsGSE2109BreastAll2.tsv", show_col_types = FALSE)
view(metricsGSE2109Breast)

breastHistology = filter(metricsGSE2109Breast, DataName == "GSE2109_BreastHistology")
breastPathological_ER = filter(metricsGSE2109Breast, DataName == "GSE2109_BreastPathological_ER")
breastPathological_HER2_Neu = filter(metricsGSE2109Breast, DataName == "GSE2109_BreastPathological_HER2_Neu")

metricsGSE2109ColonAll = read_tsv("MetricsGSE2109ColonAll.tsv")
view(metricsGSE2109ColonAll)

colon_Pathological_M = filter(metricsGSE2109ColonAll, DataName == "GSE2109_ColonPathological_M")
colon_Histology = filter(metricsGSE2109ColonAll, DataName == "GSE2109_ColonHistology")
colon_Family_History_of_Cancer = filter(metricsGSE2109ColonAll, DataName == "GSE2109_ColonFamily_History_of_Cancer")

metricsGSE2109ColonALL = read_tsv("MetricsGSE2109ColonALL.tsv")
view(metricsGSE2109ColonALL)

colon_Pathological_M_ALL = filter(metricsGSE2109ColonALL, DataName == "GSE2109_ColonPathological_M")
colon_Histology_ALL = filter(metricsGSE2109ColonALL, DataName == "GSE2109_ColonHistology")
colon_Family_History_of_Cancer_ALL = filter(metricsGSE2109ColonALL, DataName == "GSE2109_ColonFamily_History_of_Cancer")

metricsGSE2109Breast  %>%
  group_by(Classifier) %>%
  summarise(Median_Time = median(Time)) -> timeData

metricsGSE2109Breast %>%
  group_by(Classifier) %>%
  summarise(Median_Roc_auc = median(roc_auc)) -> rocData

joinedData = inner_join(timeData, rocData, by = "Classifier")

joinedData %>%
  mutate(PredictionType = case_when(str_starts(Classifier, "Auto") ~ "AutoSklearn Ensemble",
                                    str_detect(Classifier, "Prob") ~ "Basic Ensemble", 
                                    str_detect(Classifier, "Vote") ~ "Basic Ensemble", 
                                    Classifier == "DESClustering" | Classifier == "KNORAE" | Classifier == "METADES" | Classifier == "LCA" ~ "DESlib Ensemble", 
                                    Classifier == "KNeighbors" | Classifier == "LogisticRegression" | Classifier =="RandomForest" | Classifier == "SVC" ~ "Basic")) %>%
  mutate(PredictionType = factor(PredictionType, levels = c("Basic", "Basic Ensemble", "DESlib Ensemble", "AutoSklearn Ensemble" )))-> joinedData

view(joinedData)

median_colors <- data.frame(xmin = c(0.4, 0.60, 0.60, 0.8, 0.8), xmax = c(0.60, 0.8, 0.8, 1.0, 1.0), 
                            ymin = c(0, 30, 0, 30, 0), ymax = c(400, 400, 30, 400, 30),
                            fillings = factor(c("Poor predictive ability", "Slow, moderate predictive ability",
                                                "Fast, moderate predictive ability",  "Slow, high predictive ability",
                                                "Fast, high predictive ability"), levels = c( "Fast, high predictive ability", 
                                                                                              "Slow, high predictive ability", "Fast, moderate predictive ability", 
                                                                                              "Slow, moderate predictive ability", "Poor predictive ability")))

ggplot() +
  geom_rect(data = median_colors, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fillings)) +
  geom_point(data = joinedData, aes(x = Median_Roc_auc, y = Median_Time, shape = PredictionType), size = 3, fill = "black") + 
  geom_text_repel(data = joinedData, aes(x = Median_Roc_auc, y = Median_Time, label = Classifier)) + 
  xlab("AUROC (median)") + 
  ylab("Time (median) in seconds") + 
  scale_shape_manual(values = c(15, 19, 17, 23)) + 
  scale_y_sqrt(limits = c(0, 400)) +
  theme_bw(base_size = 18) + 
  scale_x_continuous(limits=c(0.4, 1)) +
  coord_cartesian(expand = FALSE) + 
  labs(shape = "", fill = "") + 
  scale_fill_manual(values = light_blue_and_yellow_friendly) 
  #ggtitle("Colon Gene Expression Data: Colon Family History of Cancer")
ggsave("Breast_Gene_Expression_Data_ALL.png", width = 12, height = 6.5, units = "in") #jpeg

