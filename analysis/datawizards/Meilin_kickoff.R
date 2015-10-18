load("/Users/Meilin/Desktop/datadive2/data/openpetition/cnames.RData")
load("/Users/Meilin/Desktop/samples_op/signer_oht.RData")

browse signer

signer <- signer_data_oht
colnames(signer) <- cnames$signer

table(signer$referer)

str(signer$signed_date) 
summary(signer)
view(signer)
head(signer)

signer$signed_date <- as.factor(signer$signed_date)
signer$date = signer$signed_date[5]

install.packages("lubridate")
library(lubridate)
signer$date <- as.Date(signer$signed_date)
signer$wday <- wday(signer$date, label=TRUE)

sumsunday <- table(signer$wday)[1] 
summonday <- table(signer$wday)[2]
sumtuesday <- table(signer$wday)[3]
sumwednesday <- table(signer$wday)[4]
sumthursday <- table(signer$wday)[5]
sumfriday <- table(signer$wday)[6]
sumsaturday <- table(signer$wday)[7]

install.packages("Hmisc")
library(Hmisc)
conf1 <- binconf(sumsunday,100000)
conf2 <- binconf(summonday,100000)
conf3 <- binconf(sumtuesday,100000)
conf4 <- binconf(sumwednesday,100000)
conf5 <- binconf(sumthursday,100000)
conf6 <- binconf(sumfriday,100000)
conf7 <- binconf(sumsaturday,100000)

#Code für Graphiken
names.matrix <-matrix(c("Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"),nrow=7,ncol=1)

df.table <- rbind(conf1, conf2, conf3, conf4, conf5, conf6, conf7)
df.table <- cbind(names.matrix, df.table)
df.table <- data.frame(df.table)
colnames(df.table) <- c("name", "mean", "l.conf", "h.conf")
df.table

df.table$name <- factor(df.table$name, levels = df.table$name, ordered = T)
df.table$mean <- as.numeric(as.character(df.table$mean))
df.table$l.conf <- as.numeric(as.character(df.table$l.conf))
df.table$h.conf <- as.numeric(as.character(df.table$h.conf))

limits <- aes(ymax = df.table$h.conf, ymin=df.table$l.conf)

CAcol <- c("#3863a2", "#92de3f", "#f04451","#3863a2", "#92de3f", "#f04451","#3863a2")


wochentag <- 
  ggplot(df.table, 
                       aes(x=df.table$name, 
                           y=df.table$mean, 
                           fill=df.table$name)) +
  geom_bar(stat="identity") +
  ggtitle("Petitionsteilnahme nach Wochentag") +
  xlab("Wochentag") + ylab("Anteil Teilnahme") + 
  scale_fill_manual(name="Wochentag", values = CAcol)+
  scale_y_continuous(limits=c(0,0.30),breaks=c(0,0.05,0.1,0.15,0.2,0.25,0.30))+
  geom_errorbar(limits, width=0.25)+
  theme_classic()
