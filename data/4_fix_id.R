library(foreign)

data <- read.csv(
  "C:/Users/Friedrike/Documents/GitHub/datadive/data/4_liste_in_zeichnung_clean.csv",
  header = T, stringsAsFactors = F)

data$id <- 1:356

write.csv(data, "C:/Users/Friedrike/Documents/GitHub/datadive/data/4_liste_in_zeichnung_clean.csv")
