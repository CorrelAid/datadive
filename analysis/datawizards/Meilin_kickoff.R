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
binconf(sumsunday,100000)
binconf(summonday,100000)
binconf(sumtuesday,100000)
binconf(sumwednesday,100000)
binconf(sumthursday,100000)
binconf(sumfriday,100000)
binconf(sumsaturday,100000)

