library(rvest)
library(stringr)
library(plyr)
library(foreign)
library(dplyr)


#load petition dataset
petitions <- read.csv("data/2_liste_in_zeichnung_withid.csv", header = T, stringsAsFactors = F)

#load htmls of individual pages
htmls <-list.files(path="data/html_files", full.names = TRUE, recursive=FALSE)

#create data frame
html_df <- data.frame(html = htmls)
html_df$id <- as.integer(str_extract(html_df$html, "\\d{1,}"))
html_df$html <- as.character(html_df$html)
#we may get more htmls than observations in petitions - this is due to earlier executions of the script
#where there were more observations in petitions

#join to petitions
petitions <- inner_join(petitions, html_df)

rm(html_df)


#function to scrape information from individual pages 
scrape_page <- function(html_file, url){
  #load and parse html
  html <- read_html(html_file, encoding = "UTF-8")
 
  id <- as.integer(str_extract(html, "\\d{1,}"))
  
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
  
  #catch category for empty cases (bc HTML is english)
  if(length(category)==0){
    category <- html %>%
      html_nodes(xpath = "//strong[contains(text(), 'Topic')]/parent::div") %>%
      html_text(trim = T)
  }
  
  #total number of supporters
  supporters_total <- html %>%
    html_nodes(xpath = "//li[@class = 'unterstuetzer']/descendant::strong") %>%
    html_text(trim = T) %>%
    .[1]
  
  #number of supporters relevant for Quorum
  supporters_for_quorum <- html %>%
    html_nodes(xpath = "//li[@class = 'unterstuetzer']/descendant::strong") %>%
    html_text(trim = T) %>%
    .[2]
  
  #percentage of target support acquired
  perc_reached <- html %>%
    html_nodes(xpath = "//div[@class = 'ziel percentage']") %>%
    html_text(trim =  T) 
  
  #target support
  target_support <- html %>%
    html_nodes(css = "div[class='ziel']") %>%
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
  
  #link to Statistik & Karten page
    stat_url <- html %>%
      html_nodes(xpath = "//a[contains(text(), 'Statistik')]") %>%
      html_attr("href")
  
    #catch link if not caught by previous code (bc HTML is english)
    if(length(stat_url)==0){
      stat_url <- html %>%
        html_nodes(xpath = "//a[contains(text(), 'Maps')]") %>%
        html_attr("href")
    }
    
    #until now not a complete link, how to complete depends on the original URL (e.g. .de or .eu)
    suffix <- str_replace(url, ".+?openpetition(.+?)/petition.+", "\\1")
    stat_url <- paste0("https://www.openpetition", suffix, stat_url)
    
  results <- cbind(id, title, from, to, region, category, status, target_support, perc_reached, supporters_total, supporters_for_quorum, petition_text, stat_url)
}

#apply function to htmls
petitions <- mdply(select(petitions, html = html, url = url), scrape_page)

#write
write.csv(petitions, "data/3_liste_in_zeichnung_scraped.csv", row.names = F)

rm(list = ls())
