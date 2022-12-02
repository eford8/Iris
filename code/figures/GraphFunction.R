library(tidyverse)
library(ggrepel)
library(scales)

metricsData = read_tsv("Metrics.tsv", show_col_types = FALSE)
view(metricsData)

metricsData %>%
  mutate(Classifier = case_when(Classifier == "AverageProb" ~ "MeanProb", 
                                TRUE ~ Classifier)) -> metricsData

light_blue_and_yellow_friendly = c("#74add1", "#abd9e9", "#fee090", "#fdae61", "#f46d43")



median_graph_func = function(dataType, dataName) {
  
  metricsData %>%
    filter(DataName == dataType) %>%
    group_by(Classifier) %>%
    summarise(Median_Time = median(Time)) -> timeData
  
  metricsData %>%
    filter(DataName == dataType) %>%
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
                                   Classifier == "AutoSklearn: Ensemble from a list" ~ "Auto/Emsemble from list", 
                                   Classifier == "AutoSklearn: Pick one from all algorithms" ~ "Auto/Pick one from all",
                                   Classifier == "AutoSklearn: Unrestricted ensemble" ~ "Auto/Ensemble from all", 
                                   TRUE ~ Classifier)) -> joinedData
  #view(joinedData)
  
  median_colors <- data.frame(xmin = c(0.4, 0.60, 0.60, 0.8, 0.8), xmax = c(0.60, 0.8, 0.8, 1.0, 1.0), 
                              ymin = c(0, 30, 0, 30, 0), ymax = c(400, 400, 30, 400, 30),
                              fillings = factor(c("Poor predictive ability", "Slow, moderate predictive ability",
                                                  "Fast, moderate predictive ability",  "Slow, high predictive ability",
                                                  "Fast, high predictive ability"), levels = c( "Fast, high predictive ability", 
                                                  "Slow, high predictive ability", "Fast, moderate predictive ability", 
                                                  "Slow, moderate predictive ability", "Poor predictive ability")))
 
   graph_name = paste0(dataName, "_Median_Time_vs_Median_AUROC_by_Classifier.jpeg")
   graph_title = paste0("Dataset: ", dataName)
   
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
     scale_fill_manual(values = light_blue_and_yellow_friendly) +
     ggtitle(graph_title)
   ggsave(graph_name, width = 12, height = 6.5, units = "in") #jpeg
   
  
}

median_graph_func("iris", "Iris")



median_graph_func("breast", "Breast")
median_graph_func("horse_colic", "Horse Colic") 
median_graph_func("Gametes_Epistasis", "Gametes Epistasis")
median_graph_func("hypothyroid", "Hypothyroid")
median_graph_func("magic", "Magic")
