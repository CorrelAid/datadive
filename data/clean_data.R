library(foreign)
library(plyr)
library(stringr)

#clean data

#set wd
setwd("~/datadive")

#load dataset
petitions <- read.csv("data/liste_in_zeichnung.csv", header = T, stringsAsFactors = F)

#Encoding
for(i in 1:ncol(petitions)){
  if(is.character(petitions[, i])){
    Encoding(petitions[, i]) <- "UTF-8"
  }else{
  }}

#clean variable petition_text with stringr


#write csv
write.csv(petitions, "data/liste_in_zeichnung.csv")
