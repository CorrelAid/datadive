#DataDive
#Gruppe Openpetition Data

load("C:/Users/CorrealAid/Documents/GitHub/datadive/data/openpetition/cnames.RData")

setwd("G:/openpetition")

#Öffne alle CSV Dateien gleichzeitig
temp = list.files(pattern="*.csv")
for (i in 1:length(temp)) assign(temp[i], read.csv(temp[i], header=F))

clist <- c("argument", "email_forard_sent", "history", "petition", "question", "representative", "representative_response", "vote", "zeichnomat")

colnames(argument.csv) <- cnames$argument
colnames(email_forward_sent.csv) <- cnames$email_forward_sent
colnames(history.csv) <- cnames$history
colnames(petition.csv) <- cnames$petition
colnames(question.csv) <- cnames$question
colnames(representative.csv) <- cnames$representative
colnames(representative_response.csv) <- cnames$representative_response

setwd("G:/samples_op")

load("G:/samples_op/signer_oht.RData")

signer <- signer_data_oht

colnames(signer) <- cnames$signer



