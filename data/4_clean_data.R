library(foreign)
library(plyr)
library(stringr)
library(dplyr)

#clean data

#set wd
setwd("~/datadive")

#load dataset
petitions <- read.csv("data/3_liste_in_zeichnung_scraped.csv", header = T, stringsAsFactors = F)

#inspect dataset for types etc. / which variables could be numeric, but are still character?
str(petitions)

#Encoding
for(i in 1:ncol(petitions)){
  if(is.character(petitions[, i])){
    Encoding(petitions[, i]) <- "UTF-8"
  }else{
  }}
rm(i)

#remove name variable
petitions <- petitions %>%
  select(-name)

#modify from variable
petitions <- petitions %>%
  mutate(from = str_replace(from, "Von: (.+)", "\\1"))

#mofidy target_support variable
petitions <- petitions %>%
  mutate(target_support = str_replace_all(target_support, "\\n", "")) %>%
  mutate(target_support = str_replace_all(target_support, "\\t", "")) %>%
  mutate(target_support = str_replace_all(target_support, "(\\d{1,}\\.{1,}\\d{1,}).+", "\\1")) %>%
  mutate(target_support = str_replace_all(target_support, "\\.", "")) %>%
  mutate(target_support = as.numeric(target_support))

#clean variable petition_text with stringr
petitions <- petitions %>%
  mutate(petition_text = str_replace_all(petition_text, "\\n", "")) %>%
  mutate(petition_text = str_replace_all(petition_text, "\\t", ""))


#write csv
write.csv(petitions, "data/4_liste_in_zeichnung_clean.csv", row.names = F)
