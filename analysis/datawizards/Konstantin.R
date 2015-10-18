#DataDive
#Gruppe Openpetition Data

load("C:/Users/CorrealAid/Documents/GitHub/datadive/data/openpetition/cnames.RData")

setwd("G:/openpetition")

#Öffne alle CSV Dateien gleichzeitig
temp = list.files(pattern="*.csv")
for (i in 1:length(temp)) assign(temp[i], read.csv(temp[i], header=F, stringsAsFactors=F))

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

View(signer)

signer$bundesland <- as.numeric(signer$verwaltung_id_bundesland)


#Code für Graphiken
names.matrix <-matrix(c("Pfadfinder", "World Vision", "Shell 2010"),nrow=3,ncol=1)

df.table.mig.rep <- rbind(pbn.conf.corr,wv.conf[1,],shell10.conf[1,])
df.table.mig.rep <- cbind(names.matrix, df.table.mig.rep)
df.table.mig.rep <- data.frame(df.table.mig.rep)
colnames(df.table.mig.rep) <- c("name", "mean", "l.conf", "h.conf")
df.table.mig.rep

df.table.mig.rep$mean <- as.numeric(as.character(df.table.mig.rep$mean))
df.table.mig.rep$l.conf <- as.numeric(as.character(df.table.mig.rep$l.conf))
df.table.mig.rep$h.conf <- as.numeric(as.character(df.table.mig.rep$h.conf))

limits <- aes(ymax = df.table.mig.rep$h.conf, ymin=df.table.mig.rep$l.conf)

migrants.rep <- ggplot(df.table.mig.rep, 
                       aes(x=df.table.mig.rep$name, 
                           y=df.table.mig.rep$mean, 
                           fill=df.table.mig.rep$name)) +
  geom_bar(stat="identity") +
  ggtitle("Repräsentativität der Pfadfindern nach Migrationshintergrund") +
  xlab("Studien") + ylab("Anteil Migranten") + 
  scale_fill_manual(name="Studien", values = CAcol)+
  scale_y_continuous(limits=c(0,0.30),breaks=c(0,0.05,0.1,0.15,0.2,0.25,0.30))+
  geom_errorbar(limits, width=0.25)+
  theme_classic()
