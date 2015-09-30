library(rvest)
library(stringr)
library(plyr)
library(foreign)

setwd('~/datadive')

#function to scrape information from individual pages 
scrape_page <- function(html_file){
  #load and parse html
  html <- read_html(html_file, encoding = "UTF-8")
  
  #id
  id <- str_extract(html_file, "\\d{1,}")
  
  #title
  title <- html %>%
    html_nodes(xpath = "//div[@class = 'col2']/descendant::h2") %>%
    .[1] %>%
    html_text(trim = T)
  
  #who wrote petition
  from <- html %>%
    html_nodes(xpath = "//li[@class = 'petent']") %>%
    html_text(trim = T)
  
  #to whom it is directed
  to <- html %>%
    html_nodes(xpath = "//li[starts-with(./@class, 'empfaenger')]") %>%
    html_text(trim = T)
  
  #region 
  region <- html %>%
    html_nodes(xpath = "//li[@class = 'region']/descendant::span") %>%
    html_text(trim = T) 
  
  #category of petition
  category <- html %>%
    html_nodes(xpath = "//strong[contains(text(), 'Kategorie')]/parent::div") %>%
    html_text(trim = T)
  
  #total number of supporters
  supporters_total <- html %>%
    html_nodes(xpath = "//li[@class = 'unterstuetzer']/descendant::strong") %>%
    html_text(trim = T) %>%
    .[1]
  
  #number of supporters in Germany
  supporters_germany <- html %>%
    html_nodes(xpath = "//li[@class = 'unterstuetzer']/descendant::strong") %>%
    html_text(trim = T) %>%
    .[2]
  
  #percentage of target support acquired
  perc_reached <- html %>%
    html_nodes(xpath = "//div[@class = 'ziel percentage']") %>%
    html_text(trim =  T) 
  
  #target support
  target_support <- html %>%
    html_nodes(xpath = "//div[@class = 'ziel']") %>%
    html_text(trim =  T) 
  
  #status of petition
  status <- html %>%
    html_nodes(xpath = "//strong[contains(text(), 'Status')]/parent::div") %>%
    html_text(trim = T)
  
  #days left
  days_left <- html %>%
    html_nodes(xpath = "//li[@class = 'restzeit']/descendant::span") %>%
    html_text(trim = T) 
    
  #petition text
  petition_text <- html %>%
    html_nodes(xpath = "//div[@class = 'col2']/descendant::div[@class = 'text']") %>%
    html_text(trim =  T)
  
  results <- cbind(id, title, from, to, region, category, status, target_support, perc_reached, supporters_total, supporters_germany, petition_text)
}

#load petition dataset
petitions <- read.csv("data/2_liste_in_zeichnung_withid.csv", header = T, stringsAsFactors = F)

#load htmls of individual pages
htmls <-list.files(path="data/html_files", full.names = TRUE, recursive=FALSE)

#apply function to htmls
data_individualpages <- ldply(htmls, scrape_page)
rm(htmls)

#merge to petitions
petitions <- merge(petitions, data_individualpages, by = c("id"))
rm(data_individualpages)

#write
write.csv(petitions, "data/3_liste_in_zeichnung_scraped.csv", row.names = F)
