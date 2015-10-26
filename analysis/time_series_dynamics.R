library(dplyr)

setwd("C:/Users/Friedrike/Documents/GitHub/datadive")


all_sig <- read.csv("data/statistik_und_karten/5_ganzer_zeitraum.csv", 
                    header = T, stringsAsFactors = F)

petitions <- read.csv("data/4_liste_in_zeichnung_clean.csv", 
                      header = T, stringsAsFactors = F)

petitions <- petitions %>%
  select(id, target_support, category)

petitions <- left_join(all_sig, petitions)

petitions$perc <- petitions$sig_total / petitions$target_support * 100

petitions$date <- as.Date(petitions$date)

petitions <- petitions %>%
  group_by(id) %>%
  mutate(first_day = as.Date(first(date)))

petitions$day_diff <- as.numeric(petitions$date - petitions$first_day)


pet_sum <- petitions %>%
  group_by(day_diff) %>%
  summarise(mean_perc_reached = mean(perc))
library(ggplot2)

ggplot(pet_sum, aes(x=day_diff, y=mean_perc_reached))+
  geom_point(color = "#A0D565")+
  geom_smooth(color = "#3863A2", size = 2, se = F)+
  scale_x_continuous("Tage seit erstem Eintrag", breaks = seq(0, 260, 30))+
  scale_y_continuous("Mittlere erreichte Prozente")+
  theme_bw()+
  labs(title = "Durchschnittlicher Zeitverlauf von in Zeichnung befindenden Petitionen \n")+
  ggsave("figures/dynamics.png")


plot


plot <- ggplot(pet_sum, aes(x=day_diff, y=per))+
  geom_point()+
  geom_smooth()
plot
