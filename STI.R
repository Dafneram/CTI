setwd("C:/Users/Dafne/Desktop/Svensk F�geltaxering/Databases and TRIM")
library(ggplot2)
library(lmodel2)

STI    <- read.csv("STI.csv", sep=",", dec=",")
colnames(STI)<-c("art","Eurolistlatin","STIeur")
Slope  <- read.csv("Slope STD 1998-2015 Hela Sverige Ej fj�ll.csv", sep=";", dec=",")
Skogsf�glar <- list("Bergfink","Bj�rktrast","Bl�mes","Bofink","Domherre","Dubbeltrast","Entita","Grans�ngare","Gr� flugsnappare","Gr�spett","Gr�ng�ling","Gr�nsiska","Gr�ns�ngare","G�rdsmyg","G�ktyta","Halsbandsflugsnappare","H�rms�ngare","J�rnsparv","J�rpe","Korp","Kungsf�gel","Lappmes","Lavskrika","L�vs�ngare","Mindre flugsnappare","Mindre hackspett","Mindre korsn�bb","Morkulla","N�ktergal","N�tkr�ka","N�tskrika","N�tv�cka","Orre","R�dhake","R�dstj�rt","R�dvingetrast","Sidensvans","Skogsduva","Skogssn�ppa","Spillkr�ka","Stenkn�ck","Stj�rtmes","St�rre hackspett","St�rre korsn�bb","Svarth�tta","Svartmes","Svartvit flugsnappare","Talgoxe","Talltita","Taltrast","Tj�der","Tofsmes","Tret�spett","Tr�dg�rdss�ngare","Tr�dkrypare","Tr�dl�rka","Tr�dpipl�rka","Videsparv")
Specialists <- list("Tj�der","J�rpe","Skogsduva","Gr�ng�ling","Mindre hackspett","Tret�spett","N�tkr�ka","Lavskrika","Stj�rtmes","Svartmes","Tofsmes","Lappmes","Entita","Talltita","Tr�dkrypare","Domherre")
Generalists <- list("Bergfink","Bj�rktrast","Bl�mes","Bofink","Dubbeltrast","Grans�ngare","Gr� flugsnappare","Gr�spett","Gr�nsiska","Gr�ns�ngare","G�rdsmyg","G�ktyta","Halsbandsflugsnappare","H�rms�ngare","J�rnsparv","Korp","Kungsf�gel","L�vs�ngare","Mindre flugsnappare","Mindre korsn�bb","Morkulla","N�ktergal","N�tskrika","N�tv�cka","Orre","R�dhake","R�dstj�rt","R�dvingetrast","Sidensvans","Skogssn�ppa","Spillkr�ka","Stenkn�ck","St�rre hackspett","St�rre korsn�bb","Svarth�tta","Svartvit flugsnappare","Talgoxe","Taltrast","Tr�dg�rdss�ngare","Tr�dl�rka","Tr�dpipl�rka","Videsparv")


C <- merge(STI, Slope, by="art")
C <-C[,c(1,3,4,5)]

lm.all<-lm(Slope~STIeur, data=C)
lm.58 <-lm(Slope~STIeur, data=subset(C,arthela %in% Skogsf�glar))
lm.16 <-lm(Slope~STIeur, data=subset(C,arthela %in% Specialists))
lm.42 <-lm(Slope~STIeur, data=subset(C,arthela %in% Generalists))
lm.allmin58<-lm(Slope~STIeur, data=subset(C,!(arthela %in% Skogsf�glar)))


rma.all <- lmodel2(Slope~STIeur, data=C)
rma.58  <- lmodel2(Slope~STIeur, data=subset(C,arthela %in% Skogsf�glar))
rma.16  <- lmodel2(Slope~STIeur, data=subset(C,arthela %in% Specialists))
rma.42  <- lmodel2(Slope~STIeur, data=subset(C,arthela %in% Generalists))
rma.allmin58  <- lmodel2(Slope~STIeur, data=subset(C,!(arthela %in% Skogsf�glar)))

tiff("rmaS.tiff",width = 2.79, height = 2, units="in", res=1000)
ggplot(C, aes(x=STIeur, y=Slope)) + 
#  geom_point(size=1) +
#  geom_abline(intercept= rma.all$regression.results[3,2], slope= rma.all$regression.results[3,3])+
#  geom_point(data=subset(C,!(arthela %in% Skogsf�glar)), size=1, color="black")+ 
#  geom_abline(intercept= rma.allmin58$regression.results[3,2], slope= rma.allmin58$regression.results[3,3],color="black")+
#  geom_point(data=subset(C,arthela %in% Skogsf�glar), size=1, color="blue")+ 
#  geom_abline(intercept= rma.58$regression.results[3,2], slope= rma.58$regression.results[3,3],color="blue")+
#  geom_point(data=subset(C,arthela %in% Generalists), size=1, color="black")+ 
#  geom_abline(intercept= rma.42$regression.results[3,2], slope= rma.42$regression.results[3,3],color="black")+
  geom_point(data=subset(C,arthela %in% Specialists), size=1, color="black")+ 
  geom_abline(intercept= rma.16$regression.results[3,2], slope= rma.16$regression.results[3,3],color="black")+
  scale_y_continuous(limits= c(0.92, 1.17),breaks=seq(0.9, 1.2, 0.1))+
  scale_x_continuous(limits= c(6, 16))+
  theme_bw(base_size = 9)+
  ggtitle("Specialists")
dev.off()

  annotate("text", label="Forest birds: y=0.01213x+0.8605",x = 10, y = 1.14)+
  annotate("text", label="Specialists: y=0.0077x+0.9186",x = 10, y = 1.15)+
  annotate("text", label="Generalists: y=0.0146x+0.8269",x = 10, y = 1.13)+
  annotate("text", label="All Swedish birds: y=0.01561x+0.8045",x = 9.7, y = 1.12)+
  annotate("text", label="All Swedish birds excl. forest: y=0.01607x+0.7918",x = 9.2, y = 1.11)

tiff("regressionNF.tiff",width = 2.79, height = 2, units="in", res=1000)
ggplot(C, aes(x=STIeur, y=Slope)) + 
#  geom_point(size=1) +
#  geom_abline(intercept= coef(lm.all)[1], slope= lm.all$regression.results[3,3])+
  geom_point(data=subset(C,!(arthela %in% Skogsf�glar)), size=1, color="black")+ 
  geom_abline(intercept= coef(lm.allmin58)[1], slope= coef(lm.allmin58)[2],color="black")+
#  geom_point(data=subset(C,arthela %in% Skogsf�glar), size=1, color="blue")+ 
#  geom_abline(intercept= coef(lm.58)[1], slope= coef(lm.58)[2],color="blue")+
#  geom_point(data=subset(C,arthela %in% Generalists), size=1, color="black")+ 
#  geom_abline(intercept= coef(lm.42)[1], slope= coef(lm.42)[2],color="black")+
#  geom_point(data=subset(C,arthela %in% Specialists), size=1, color="black")+ 
#  geom_abline(intercept= coef(lm.16)[1], slope= coef(lm.16)[2],color="black")+
  scale_y_continuous(limits= c(0.92, 1.17),breaks=seq(0.9, 1.2, 0.1))+
  scale_x_continuous(limits= c(6, 16))+
  theme_bw(base_size = 9)+
  ggtitle("Non-forest birds")
  dev.off()