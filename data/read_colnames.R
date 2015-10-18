# ditt könnta allet ignorieren, unten weiterlesen

library(stringr)

# setwd('/home/arndt/CorrelAidRepos/datadive')

sql <- readLines('data/openpetition/openpetition-schema.sql')

table_names <- c('argument', 'email_forward_sent', 'history', 'petition', 'question', 'representative', 'representative_response', 'signer', 'vote', 'zeichnomat')

cnames <- list()

for (i in 1:10) {

bstring <- paste0('CREATE TABLE `', table_names[i], '` (')

ifelse(table_names[i] == 'question' | table_names[i] == 'zeichnomat',
       estring <- paste0('  PRIMARY KEY (`', table_names[i], '_id`)'),
       estring <- paste0('  PRIMARY KEY (`', table_names[i], '_id`),'))


names <- sql[which(sql == bstring):which(sql == estring)]

names <- names[2:(length(names)-1)]

names <- str_extract(names, '`\\w+`')

names <- gsub('`|`', '', names)

cnames[[table_names[i]]] <- names

}

save(list = 'cnames', file = 'data/openpetition/cnames.RData')

# Und so könnt ihr dann Namen zuweisen

zeichnomat <- read.csv('data/openpetition/zeichnomat.csv', stringsAsFactors = F)

names(zeichnomat) <- cnames$zeichnomat
