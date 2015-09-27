library(rvest)
library(stringr)
library(plyr)

setwd("C:\\Users\\Friedrike\\Documents\\GitHub\\datadive")

scrape_page <- function(html_file){
  #load and parse html
  html <- read_html(html_file, encoding = "UTF-8")
  
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
  
  #target number of supporters
  target_support <- html %>%
    html_nodes(xpath = "//div[@class = 'ziel percentage']") %>%
    html_text(trim =  T) 
  
  #status of petition
  status <- html %>%
    html_nodes(xpath = "//strong[contains(text(), 'Status')]/parent::div") %>%
    html_text(trim = T)
  
  
  #petition text
  petition_text <- html %>%
    html_nodes(xpath = "//div[@class = 'col2']/descendant::div[@class = 'text']") %>%
    html_text(trim =  T)
  
  results <- cbind(title, from, to, region, category, supporters_total, supporters_germany, status, target_support, petition_text)
}

#load html file names
htmls <- list.files(path="data/html_files", full.names = TRUE, recursive=FALSE)

#apply function to html_files
data <- ldply(htmls, scrape_page)
rm(htmls)

#write data to directory 
write(data, "data/closed_petitions.RData")

