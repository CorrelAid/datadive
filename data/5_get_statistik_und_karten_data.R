library(rvest)
library(jsonlite)
library(RCurl)
library(foreign)
library(plyr)
library(dplyr)
library(stringr)

#1. Load dataset, select variables 
#2. Download HTML files
#3. Read in HTML files, extract links to pages containing json 
#4. Read in json from URL 
  #4.1. For the Full Graph ("Unterschriften im Petitionszeitraum")
  #4.2. For the Last Days Graph ("Gesammelte Unterschriften pro Tag in den letzten zwei Wochen")
#5. Write csv files

#1. Load dataset, select variables 
  petitions <- read.csv("data/4_liste_in_zeichnung_clean.csv", stringsAsFactors = F)
   
  #we only need a minimal subset for this script, only keep obs with stat_url
  petitions_stats <- petitions %>%
    select(id, stat_url) %>%
    filter(!is.na(stat_url))
  
  rm(petitions)

#2. Download HTML files
  #create directory to put html files in 
  dir.create("data/html_files_stat")
  #downloading the HTML files and reading them in with readLines later is more efficient 
  #than using readLines on the URLs directly
  
  for(i in 1:length(petitions_stats$stat_url)){
    content <- getURL(petitions_stats$stat_url[i])
    write(content, str_c("data/html_files_stat/", petitions_stats$id[i], ".html"))
    Sys.sleep(0.2)
  }
  rm(i)

#3. Read in HTML files, extract links to pages containing json 
  #load htmls, create data frame
  htmls <- list.files("data/html_files_stat", full.names = T)
  #we might get more htmls than observations in petitions_stats. The reason is that there might be files from
  #a previous execution of the code. The merge later takes care of this. 
  
  temp <- data.frame(html = htmls)
  
  #extract id variable from html path
  temp$id <- unlist(str_extract_all(temp$html, "\\d{1,}"))
  
  #merge to petitions_stats
  petitions_stats <- merge(petitions_stats, temp, by = c("id"))
  petitions_stats$html <- as.character(petitions_stats$html)

  rm(htmls, temp, content)

  #function to get links to Json pages 
  get_jsonlinks <- function(html, id){
    rawHTML <- paste(readLines(html), collapse=" ")
    jsonurls <- unlist(str_extract_all(rawHTML, "var jsonUrl = '.+?'"))
    jsonurls_cleaned <- str_replace_all(jsonurls, "var jsonUrl = '(.+?)'", "\\1")
    
    #there are two Json pages of interest: 
      #1. the Json underlying the Full Graph ("Unterschriften im Petitionszeitraum") -> _gf suffix from now on
      #2. the Json underlying the Last Days Graph ("Gesammelte Unterschriften pro Tag in den letzten zwei Wochen") -> _gld suffix 
    
    #extract both from jsonurls_cleaned and create data.frame with id variable
    json_gf <- paste0("https://www.openpetition.de", jsonurls_cleaned[1])
    json_gld <- paste0("https://www.openpetition.de", jsonurls_cleaned[2])
    id <- id
    cbind(id, json_gf, json_gld)
  }
  
  #apply function
  temp <- mdply(select(petitions_stats, html, id), get_jsonlinks)

  #merge temp to petitions_stats
  petitions_stats <- merge(petitions_stats, temp, by = c("id"))

  rm(temp)
  
  #convert json_gf & json_gld to character
  petitions_stats$json_gf <- as.character(petitions_stats$json_gf)
  petitions_stats$json_gld <- as.character(petitions_stats$json_gld)

#4. Read in json from URL 
#we need two different extraction functions because the structure of the Json differs depending on the graph type
  
  #4.1. For the Full Graph ("Unterschriften im Petitionszeitraum")
    #function to extract json graph full
    getjson_gf <- function(url, id){
      #read Lines
      raw <- readLines(url)
      #get Json content
      json_raw <- fromJSON(raw)
      #extract values and convert to dataframe
      temp1 <- data.frame(json_raw[1,,])
      colnames(temp1) <- c("date", "sig_total")
      
      temp2 <- data.frame(json_raw[2,,])
      colnames(temp2) <- c("date", "sig_quorum")
      
      json_df <- merge(temp1, temp2)
      return(cbind(json_df, id))
    }

    #apply function - json graph_full
    json_gf_df <- mdply(select(petitions_stats, url = json_gf, id), getjson_gf)

  #4.2. For the Last Days Graph ("Gesammelte Unterschriften pro Tag in den letzten zwei Wochen")
    #function to extract json graph last days
    getjson_gld <- function(url, id){
      #read Lines
      raw <- readLines(url)
      #get Json content
      json_raw <- fromJSON(raw)
      #transpose and convert to dataframe
      json_df <- data.frame(t(json_raw))
      colnames(json_df) <- c("new_sig_total", "new_sig_quorum", "date")
      return(cbind(json_df, id))
    }
    
    #apply function: json graph last days
    json_gld_df <- mdply(select(petitions_stats, url = json_gld, id), getjson_gld)

#5. Write csv files
    dir.create("data/statistik_und_karten")
    
    write.csv(select(json_gf_df, -url), "data/statistik_und_karten/5_ganzer_zeitraum.csv", row.names = F)
    write.csv(select(json_gld_df, -url), "data/statistik_und_karten/5_letzte_2_wochen.csv", row.names = F)
    
#clean workspace
    rm(list = ls())
    