library(foreign)
library(plyr)
library(stringr)
library(dplyr)

#clean data

#load dataset
petitions <- read.csv("data/3_liste_in_zeichnung_scraped.csv", header = T, colClasses = "character")

#inspect dataset for types etc. / which variables could be numeric, but are still character?
str(petitions)

#Encoding
for(i in 1:ncol(petitions)){
  if(is.character(petitions[, i])){
    Encoding(petitions[, i]) <- "UTF-8"
  }else{
  }}
rm(i)



#cleaning of individual variables
  #id 
  petitions$id <- as.integer(petitions$id)
  
  #url -> nothing to do here
  
  #from
  petitions <- petitions %>%
    mutate(from = str_replace(from, "Von: (.+)", "\\1"))
  
  #to 
  
  #region
  
  #category
  petitions <- petitions %>%
    mutate(category = str_replace(category, "Kategorie:(.+)", "\\1")) %>%
    mutate(category = str_replace_all(category, "\n|\t", "")) %>%
    mutate(category = str_trim(category))
  
  #status 
  
  #target_support
  petitions <- petitions %>%
    mutate(target_support = str_replace_all(target_support, "\\n", "")) %>%
    mutate(target_support = str_replace_all(target_support, "\\t", "")) %>%
    mutate(target_support = str_replace_all(target_support, "(\\d{1,}\\.{1,}\\d{1,}).+", "\\1")) %>%
    mutate(target_support = str_replace_all(target_support, "(\\d{1,}).+", "\\1")) %>%
    mutate(target_support = str_replace_all(target_support, "\\.", "")) %>%
    mutate(target_support = as.integer(target_support))
  
  #perc_reached 
  
  #supporters_total
  petitions <- petitions %>%
    mutate(supporters_total = str_replace_all(supporters_total, "\\.", "")) %>%
    mutate(supporters_total = as.integer(supporters_total))
  
  #supporters_for_quorum
  petitions <- petitions %>%
    mutate(supporters_for_quorum = str_replace_all(supporters_for_quorum, "\\.", "")) %>%
    mutate(supporters_for_quorum = as.integer(supporters_for_quorum))
  
  #petition_text
  petitions <- petitions %>%
    mutate(petition_text = str_replace_all(petition_text, "\\n", "")) %>%
    mutate(petition_text = str_replace_all(petition_text, "\\t", ""))
  
  #stat_url -> nothing to do here
  petitions$stat_url <- as.character(petitions$stat_url)

#write csv
write.csv(petitions, "data/4_liste_in_zeichnung_clean.csv", row.names = F)

rm(list = ls())
