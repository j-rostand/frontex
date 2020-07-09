library(cluster)
library(JLutils)
library(RSVGTipsDevice)
library(FactoMineR)
source("/webhome/analyse/html/packages/ggplot.CA.R")
source("/webhome/analyse/html/packages/Complement.R")
tableau<-read.csv("/webhome/analyse/html/documents/study106694652/coordAFCtoClassif.csv", header=TRUE, row.names=1, sep="\t",  na.strings="NA",  dec=".", strip.white=TRUE, blank.lines.skip=TRUE, encoding="UTF-8")
namestbl<- gsub("([.]|[X]|[,])", "\ ", names(tableau))
names(tableau)<-namestbl
tableau2 <- tableau[,c(1:2)]
agn1<-agnes(tableau, diss= F, metric = "euclidian", stand = F, method="ward")
devSVGTips(file = "CHAgnesManhattanWardBanner.svg", toolTipMode=1, width = 10, height = 8, bg = "white", fg ="black", toolTipFontSize=8, onefile=TRUE)
plot(agn1, main="Classement hierarchiques des coordonnees", which.plots=1)
dev.off()
Sautinertie<-sort(agn1$height, decreasing=TRUE)
devSVGTips(file = "CHAgnesManhattanWardSautInertie.svg", toolTipMode=1, width = 10, height = 8, bg = "white", fg ="black", toolTipFontSize=8, onefile=TRUE)
plot(Sautinertie, type = "s", xlab = "Nombre de classes",  ylab = "Inertie")
dev.off()
devSVGTips(file = "CHAgnesManhattanWardDendogramme.svg", toolTipMode=1, width = 10, height = 8, bg = "white", fg ="black", toolTipFontSize=8, onefile=TRUE)
plot(agn1, main="Classement hierarchiques des coordonnees", which.plots=2, xax.pretty=TRUE, cex=0.4,hang=-1)
cutagn<-as.hclust(agn1)
groups <- cutree(cutagn, h=2)
rect.hclust(cutagn, h=2, border="red")
dev.off()
veccol<-rainbow(nrow(data.frame(table(as.data.frame(groups)))))
colColonne=groups
couleur<-rep(1:length(colColonne))
for(i in 1:length(veccol))
{colColonne[colColonne==i] <- veccol[i]}
tab.g<-data.frame(groups,tableau[, 1], tableau[, 2], rownames(tableau), colColonne)
colnames(tab.g)<-c("groupe", "x","y","label","color")
fileLgn<-"/webhome/analyse/html/documents/study106694652//AFCtab_lgn_facteurs.csv"
fileCol<-"/webhome/analyse/html/documents/study106694652//AFCtab_col_facteurs.csv"
filedesc<-"/webhome/analyse/html/documents/study106694652//tab_facteurs.csv"
header=F
CAHClassif<-ImportClassificationToCodeR(tab.g, fileLgn, fileCol,filedesc, header, type="ClassificationCAH")
filename<-"CHAgnesManhattanWardPlanfactorielle.svg"
p<-Myggplot.CA(CAHClassif, 1, 2, titre="", SeuilCol=0, SeuilLigne=0, SeuilPem=FALSE, classification=TRUE, LabelSize.row=9)
p
savePlot(filename, p, plotWidth=20, plotHeight=17, type="ggsave")
tab_groupe<-data.frame(x=tableau[, 1],y=tableau[ ,2], groupe=groups, color=colColonne)
write.table(tab_groupe, file="groupe_produit_CH.csv", sep = "	")
write.infile(agn1, file="ch_result.csv", sep = ";")
