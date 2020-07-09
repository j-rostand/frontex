library(gridExtra)
library(FactoMineR)
library(ggplot2)
library(XML)
source("/webhome/analyse/html/packages/pem.R")
source("/webhome/analyse/html/packages/ggplot.CA.R")
source("/webhome/analyse/html/packages/Complement.R")
library(tikzDevice)
library(extrafont)
tableau<-read.csv("/webhome/analyse/html/documents/study2074965897/frontex-table-lexicale-annees.csv", header=TRUE, row.names=1, sep="\t",  na.strings="NA",  dec=".", strip.white=TRUE, blank.lines.skip=TRUE, encoding="UTF-8")
namestbl<- gsub("([.]|[X]|[,])", "\ ", names(tableau))
names(tableau)<-namestbl
AFC<-tableau
AFC<-apply(AFC, 2, function(x) ifelse(is.na(x), 0, x))
AFC<-t(AFC)
tbl<-AFC
AFC<-tbl
AFC.ca <- CA(AFC, ncp=10, graph=FALSE)
p<-Myggplot.CA(AFC.ca, 1, 2, titre="Analyse factorielle des correspondances du corpus des communiqués de presse de l'agence Frontex", SeuilCol=0.5, SeuilLigne=6.25, SeuilPem=FALSE)
source("/webhome/analyse/html/packages/Complement.R")
chxcolor<-choixcolor(AFC.ca$eig[,1], var1=1, var2=2, col1="red",  col2="black")
library(RSVGTipsDevice)
devSVGTips(file = "description_des_facteurs.svg", toolTipMode=1, width = 10, height = 8, bg = "white", fg ="black", toolTipFontSize=8, onefile=TRUE)
barplot(AFC.ca$eig[,1], col=chxcolor)
dev.off()

tikz("/webhome/analyse/html/documents/study2074965897//TikzAFC_1et_2_au_Seuil_de_contribution_6.250.5_en_colonne_en_ligne.tex", sanitize=TRUE, verbose=FALSE, engine="xetex")
options(tikzSanitizeCharacters=c("%","$","}","{","^","_","#","&", "*"), tikzReplacementCharacters=c('\\%','\\$','\\}','\\{','\\^{}','\\_{}','\\#','\\&','\\*'))

p
dev.off()
