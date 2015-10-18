#DataDive
#Gruppe Openpetition Data

setwd("G:/openpetition")

#Öffne alle CSV Dateien gleichzeitig
temp = list.files(pattern="*.csv")
for (i in 1:length(temp)) assign(temp[i], read.csv(temp[i], header=F))
