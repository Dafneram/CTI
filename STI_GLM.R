setwd("C:/DAFNE/Svensk F�geltaxering/Databases and TRIM/STD 1998-2015 Hela Sverige Ej fj�ll")

Slope <- read.csv("Slope STD 1998-2015 Hela Sverige Ej fj�ll.csv", sep=";", dec=",")
STI    <- read.csv("STI.csv", sep=",", dec=",")
colnames(STI)<-c("art","EurolistLatin","STIeur")

Skogsf�glar <- list("Bergfink","Bj�rktrast","Bl�mes","Bofink","Domherre","Dubbeltrast","Entita","Grans�ngare","Gr� flugsnappare","Gr�spett","Gr�ng�ling","Gr�nsiska","Gr�ns�ngare","G�rdsmyg","G�ktyta","Halsbandsflugsnappare","H�rms�ngare","J�rnsparv","J�rpe","Korp","Kungsf�gel","Lappmes","Lavskrika","L�vs�ngare","Mindre flugsnappare","Mindre hackspett","Mindre korsn�bb","Morkulla","N�ktergal","N�tkr�ka","N�tskrika","N�tv�cka","Orre","R�dhake","R�dstj�rt","R�dvingetrast","Sidensvans","Skogsduva","Skogssn�ppa","Spillkr�ka","Stenkn�ck","Stj�rtmes","St�rre hackspett","St�rre korsn�bb","Svarth�tta","Svartmes","Svartvit flugsnappare","Talgoxe","Talltita","Taltrast","Tj�der","Tofsmes","Tret�spett","Tr�dg�rdss�ngare","Tr�dkrypare","Tr�dl�rka","Tr�dpipl�rka","Videsparv")
Specialists <- list("Tj�der","J�rpe","Skogsduva","Gr�ng�ling","Mindre hackspett","Tret�spett","N�tkr�ka","Lavskrika","Stj�rtmes","Svartmes","Tofsmes","Lappmes","Entita","Talltita","Tr�dkrypare","Domherre")
Generalists <- list("Bergfink","Bj�rktrast","Bl�mes","Bofink","Dubbeltrast","Grans�ngare","Gr� flugsnappare","Gr�spett","Gr�nsiska","Gr�ns�ngare","G�rdsmyg","G�ktyta","Halsbandsflugsnappare","H�rms�ngare","J�rnsparv","Korp","Kungsf�gel","L�vs�ngare","Mindre flugsnappare","Mindre korsn�bb","Morkulla","N�ktergal","N�tskrika","N�tv�cka","Orre","R�dhake","R�dstj�rt","R�dvingetrast","Sidensvans","Skogssn�ppa","Spillkr�ka","Stenkn�ck","St�rre hackspett","St�rre korsn�bb","Svarth�tta","Svartvit flugsnappare","Talgoxe","Taltrast","Tr�dg�rdss�ngare","Tr�dl�rka","Tr�dpipl�rka","Videsparv")

SS <- merge(STI, Slope, by="art")

SS$group <- ifelse(SS$arthela %in% Generalists,"Generalists",
            ifelse(SS$arthela %in% Specialists,"Specialists",
                   "Non-forest birds"))
SS$group<-factor(SS$group, levels = c("Generalists","Specialists","Non-forest birds"))

SS$SEinv<-(1/SS$SE)
SS$EurolistLatin<-NULL
SS$art<-NULL

hist(SS$Slope)

SS.lm <- lm(Slope ~ STIeur + group , data=SS) #, weights = SEinv
summary(SS.lm)
plot(SS.lm)

tapply(SS$SEinv, SS$group, summary)

tapply(SS$STIeur, SS$group, summary)

STI.aov<-aov(STIeur ~ group, data=SS)
posthoc<-TukeyHSD(x=STI.aov, 'group', conf.level=0.95)

tiff("STI_poster.tiff",width = 4, height = 3, units="in", res=1000)
ggplot(SS, aes(STIeur, Slope, shape=group, color=group))+
  geom_point(size=2)+
  geom_abline(intercept= 0.9547, slope= 0.0034, size=0.3, color="gray72")+
  geom_abline(intercept= 0.9737, slope= 0.0034, size=0.3, color="darkolivegreen")+
  geom_abline(intercept= 0.9724, slope= 0.0034, size=0.3, color="black")+
  annotate(geom="text",x=6.7, y=1.002,label="Generalists", angle=6, size=3)+
  annotate(geom="text",x=6.6, y=0.99,label="Specialists", angle=6, size=3)+
  annotate(geom="text",x=6.9, y=0.974,label="Non-forest birds", angle=6, size=3)+
  theme_bw(base_size = 10)+
  theme(axis.title.y=element_text(margin=margin(0,10,0,0), size=9),
        axis.title.x=element_text(margin=margin(8,0,0,0),size=9),
        legend.justification=c(0,1.1), 
        legend.position=c(0,1.1),
        legend.background = element_rect(fill="transparent"),
        legend.title=element_blank(),
        legend.key = element_blank())+
  scale_x_continuous(limits= c(6,16),breaks=seq(6, 16, 2))+
  scale_shape_manual(values=c(2,3,1))+
  scale_color_manual(values=c("darkolivegreen","black","gray72"))+
  xlab("STI")+
  ylab("Population trend")
dev.off()



plot(SS$STIeur[SS$group=="A"], SS$Slope[SS$group=="A"], col=2, xlab="STI", ylab="STD trend(Slope)")
points(SS$STIeur[SS$group=="G"], SS$Slope[SS$group=="G"], col=1)
points(SS$STIeur[SS$group=="S"], SS$Slope[SS$group=="S"], col=4)

