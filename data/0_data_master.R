#set working directory
#IMPORTANT!! set your own working directory first to where "datadive" lives (e.g. GitHub) and then source this file
setwd(paste(getwd(),"/datadive",sep=""))

#source scrape_listen - scrape html files with the overview lists over the petitions
source("data/1_scrape_liste.R")

#source get_html_files - load html files onto PC 
source("data/2_get_html_files.R")

#source scrape_page - get data from individual petition websites
source("data/3_scrape_page.R")

#source clean_data - clean data
source("data/4_clean_data.R")

#get Statistik und Karten data
source("data/5_get_statistik_und_karten_data.R")
