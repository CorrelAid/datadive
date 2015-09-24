# CorrelAid
# Projekt: DataDive
# Scraping Code für das Data Dive Projekt: openpetition.de
# Coders: Arndt Leininger <a.leininger@phd.hertie-school.org>
# Zuletzt verändert am: 24.09.2015

# First w define a working directory, the path needs to be changed depending
# on the machine used
setwd('~/CorrelAidRepos/datadive/')

# Loading the R packages neccessary to execute the tasks ahead.
packages <- c("stringr", "XML", "maptools", "RCurl", "ggplot2", "sp", "spdep",
              "rgdal", "reshape")
for (p in packages) {
  if (p %in% installed.packages()[,1]) require(p, character.only=T)
  else {
    install.packages(p)
    require(p, character.only=T)
  }
}

#Create a new folder in the data folder in the working directory.
# This folder will be used to save the downloaded signer lists
# dir.create("data/petitionen")

#Individual petitions on openpetition.de are stored in one of 4 categories.
# Petitions marked as "closed" can no longer be signed. Their success in unclear.
# Petitions marked as "successful" haven been declared successful by the
# organizer of the petition. Petitions marked as "under review" are closed
# and submited to the actor that is addressed by the petition. The last category
# are petitions that are  open to be signed. The following script will be
# organized along these categories.

# ------------------------------------------------------------------------------
# Downloading the signers of closed petitions##
# ------------------------------------------------------------------------------

# Niklas, I suggest we only scrape closed petitions; teams could then use the
# code to also get other petitions

URL <- "https://www.openpetition.de/liste/closed"

