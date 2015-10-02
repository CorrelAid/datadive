# CorrelAid
# Projekt: Dataa Dive
# Die Liste der laufenden Petitionen scrapen
# Coders: Arndt Leininer <a.leininger@phd.hertie-school.org>
# Zuletzt verändert am: 27.09.2015

# Dieser Code erstellt eine Liste aller laufenden Petitionen auf openpetition.de
# Dazu wird https://www.openpetition.de/liste/in_zeichnung gescrapt
# Die Liste ist in 16 (27.09.2015) Seiten aufgeteilt weshalb zunächst
# diese Seiten heruntergeladen werden
# Anschließend wird aus allen Seiten mittels xpath der Name der Petition und
# der Link zur Petitionsseite extrahiert.
# Diese werden in einem data.frame gespeichert und als csv gespeichert.
# Mittels dieser Tabelle werden im nächsten Schritt die einzelnen HTML-Seiten
# heruntergeladen

# First w define a working directory, the path needs to be changed depending
# on the machine used
setwd('~/CorrelAidRepos/datadive/')

# Loading the R packages neccessary to execute the tasks ahead.
packages <- c("stringr", "XML", "maptools", "RCurl", "ggplot2", "sp", "spdep",
              "rgdal", "reshape", "stringr", "dplyr")
for (p in packages) {
  if (p %in% installed.packages()[,1]) require(p, character.only=T)
  else {
    install.packages(p)
    require(p, character.only=T)
  }
}

# ------------------------------------------------------------------------------
# Link zur Liste der Petition setzen und Anzahl der Seiten auslesen
# ------------------------------------------------------------------------------

URL <- 'https://www.openpetition.de/liste/in_zeichnung' # URL zur ersten Seite
file <- 'data/listen/liste_in_zeichnung_1.html' # Pfad wo HTML-Seite gespeichert
# wird

download.file(URL, file)  # Datei wird heruntergeladen

parsed_doc <- htmlParse(file)  # Einlesen des HTML Codes

# Diesr Code liest den Text des Links zur letzten Seiten ein
# So wird identifiziert wieviele Seiten die Liste der Petitionen umfasst
num_pages <-
  xpathSApply(parsed_doc, "//p[@class = 'pager']/a[last()]", fun = xmlValue)

num_pages <- as.integer(num_pages)

# ------------------------------------------------------------------------------
# Alle Seiten herunterladen
# ------------------------------------------------------------------------------

# Dieser ruft einzeln https://www.openpetition.de/liste/in_zeichnung?seite=*p*
# auf und speichert die vom Server generierte HTML-Seite
# *p* ist die Seitenzahl
# Die Schleife läuft bis die max. Seitenzahl (aus dem vorherigen Schritt)
# erreicht ist

for(p in 2:num_pages){
  url <- paste0(URL, '?seite=', as.character(p))
  content <- getURL(url)
  dest_path <- paste0('data/listen/liste_in_zeichnung_', as.character(p), '.html')
  write(content, dest_path)
}

# ------------------------------------------------------------------------------
# Liste aus Seite auslesen
# ------------------------------------------------------------------------------

# Leerer data.frame der die Liste der Petitionen von allen Seiten enthalten wird
petitions <- data.frame()

# Die Loop durchläuft alle HTML-Seiten der Liste und liest die Petitionen aus
# und fügt diese zu einer Liste zusammen

for(p in 1:num_pages) {

  # Datei einlesen -------------------------------------------------------------

  file <- paste0('data/listen/liste_in_zeichnung_', as.character(p), '.html')

  parsed_doc <- htmlParse(file)

  # Datei auslesen -------------------------------------------------------------

  # Liest die Titel der Petionen aus der Liste aus
  name <- xpathSApply(parsed_doc, "//ul[@class = 'petitionen-liste']//h2/a",
                       fun = xmlValue)

  # name säubern
  name <- gsub('\n|\t|\t ', '', name)

  # Liest die Links zu den Petitionen aus der Liste aus
  url <- xpathSApply(parsed_doc, "//ul[@class = 'petitionen-liste']//h2/a",
                      xmlGetAttr, 'href')
  
 
  tmp <- data.frame(name, url)

  # Neue Seiten an Liste der Petitionen anhängen

  petitions <- rbind(petitions, tmp)

}

#manche URLs enthalten schon absoluten Pfad, andere nur relativen Pfad
petitions$url <- as.character(petitions$url)

petitions1 <- petitions %>%
  filter(str_detect(url, "http://")) %>%
  mutate(url = str_replace_all(url, "http", "https"))
  
petitions2 <- petitions %>%
  filter(str_detect(url, "http://") == F) %>%
  mutate(url =  paste0('https://www.openpetition.de', url))

petitions <- rbind(petitions1, petitions2)

write.csv(petitions, 'data/1_liste_in_zeichnung.csv', row.names = F)

rm(list = ls())


