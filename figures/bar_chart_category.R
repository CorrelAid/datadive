library(foreign)
library(ggplot2)
library(dplyr)

petitions <- read.csv("data/4_liste_in_zeichnung_clean.csv", header = T)

#create data frame with mean for each category 
group_means_df <- petitions %>%
  tbl_df() %>%
  group_by(category) %>%
  summarise(mean_supporters_total = mean(supporters_total, na.rm = T)) %>%
  filter(!is.na(category))


#create plot
ggplot(group_means_df, aes(x = category, y = mean_supporters_total))+
  geom_bar(stat = "identity", position = "dodge") + 
  scale_x_discrete("")+
  scale_y_continuous("mean total support")+
  ggtitle("Mean total support by category of petition")+
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  ggsave("figures/mean_support_by_category.png")
  
rm(list = ls())
