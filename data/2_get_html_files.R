library(foreign)
library(RCurl)
library(stringr)

#set working directory
setwd('~/datadive')

#load petitions
petitions <- read.csv("data/1_liste_in_zeichnung.csv", header = T, stringsAsFactors = F)

#create new directory
dir.create("data/html_files")

#download html files, create id variable
for(i in 1:length(petitions$url)){
  content <- getURL(petitions$url[i])
  write(content, str_c("data/html_files/", i, ".html"))
  petitions$id[i] <- i
  Sys.sleep(0.2)
}

write.csv(petitions, "data/2_liste_in_zeichnung_withid.csv", row.names = F)

rm(list = ls())
