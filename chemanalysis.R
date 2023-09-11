#Imports data to be utilized in graphical representation
library(tidyverse)
library(tidyr)
library(dplyr) 
library(magrittr) 
library(ggplot2) 
library(vegan)  #package for NMDS

urlfile="https://raw.githubusercontent.com/VinaugerLab/BCHM4354_2022/main/Dataset_R_2022.csv"
Raw.data<-as.data.frame(read_csv(url(urlfile)) )

Long.data<-Raw.data%>%
  gather(key = Variables, value = Values, 2:121)#Converts to Long Format

#Data Subsets
Poll.data <-Long.data%>%
  filter(Chemical == "Pollinator")#just pollinators
Color.data <- Long.data%>%
  filter(Chemical == "color")#just colors
Chem.data <- Long.data%>%
  filter(Chemical != "color")%>%
  filter(Chemical != "Pollinator")#Just chem data
SpeciesA.surv<- Raw.data[,c(1:6,27:31,36:40)]%>%
  gather(key = Variables, value = Values, 2:16)%>%#subsets all data for Plant A survivors
  filter(Chemical != "color")%>%#these two lines are optional to isolate chemicals
  filter(Chemical != "Pollinator")#just chem data

#PCA biplot
chem.name <- Raw.data[1:47,1]   #gives just chemical names
chem.eval <- Raw.data[1:47,]   #includes chemical name column and all numeric values
pca.data <- chem.eval[,2:121] #removes chemical name column, ONLY numeric
pca.data <- t(pca.data)
pca.data.num <- apply(pca.data, 2, as.numeric)  
colnames(pca.data.num) <- t(chem.name)
PCA <- prcomp(pca.data.num)
par(mar = c(1, 1, 1, 1))  
biplot(PCA) 

#nmds plot
m.chem <- as.matrix(pca.data.num)
set.seed(123)   #always use the same seed to make the same graph as below
nmds <- metaMDS(m.chem)
nmds
plot(nmds)
ordiplot(nmds, type="n")   #adds labels seen in 2nd graph
orditorp(nmds, display="species",col="red",air=0.01)
orditorp(nmds, display="sites",cex=1.25,air=0.01)

#Manipulation of NMDS data
data.scores = as.data.frame(scores(nmds))
data.scores$Color = Color.data$Values
data.scores$Pollinator = Poll.data$Values

xx = ggplot(data.scores, aes(x = NMDS1, y = NMDS2)) + 
  geom_point(size = 4, aes( shape = Pollinator, color = Color))+ 
  theme(axis.text.y = element_text(color = "black", size = 12, face = "bold"), 
        axis.text.x = element_text(color = "black", face = "bold", size = 12), 
        legend.text = element_text(size = 12, face ="bold", color ="black"), 
        legend.position = "right", axis.title.y = element_text(face = "bold", size = 14), 
        axis.title.x = element_text(face = "bold", size = 14, color = "black"), 
        legend.title = element_text(size = 14, color = "black", face = "bold"), 
        panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 1.2),
        legend.key=element_blank()) + 
  labs(x = "NMDS1", color = "Color", y = "NMDS2", shape = "Pollinator") +
  scale_color_manual(values = c("#167B1E", "#CF4420", "#9FED13", "#FC08CD", "#BEBEBE", "#FBFF15"))
xx

#Manipulation of NMDS data part 2 electric boogaloo
data.scores = as.data.frame(scores(nmds))
data.scores$Species = Color.data$Variables
data.scores$Pollinator = Poll.data$Values

xy = ggplot(data.scores, aes(x = NMDS1, y = NMDS2)) + 
  geom_point(size = 4, aes( shape = Color, color = Pollinator))+ 
  theme(axis.text.y = element_text(color = "black", size = 12, face = "bold"), 
        axis.text.x = element_text(color = "black", face = "bold", size = 12), 
        legend.text = element_text(size = 12, face ="bold", color ="black"), 
        legend.position = "right", axis.title.y = element_text(face = "bold", size = 14), 
        axis.title.x = element_text(face = "bold", size = 14, color = "black"), 
        legend.title = element_text(size = 14, color = "black", face = "bold"), 
        panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 1.2),
        legend.key=element_blank()) + 
  labs(x = "NMDS1", color = "Pollinator", y = "NMDS2", shape = "Color") +
  scale_color_manual(values = c("#167B1E", "#CF4420", "#9FED13", "#FC08CD", "#BEBEBE", "#FBFF15"))
xy
#color count
Color.count <- Color.data[-c(26:39),]%>% #-c is to avoid double counting plants
  group_by(Values) %>% 
  count()
  ggplot(Color.count, aes(x=Values,  y=n)) + geom_bar(stat="identity")

#Pollinator Count
Poll.count <-Poll.data[-c(26:39),]%>%#-c is to avoid double counting plants
  group_by(Values) %>% 
  count()
  ggplot(Poll.count, aes(x=Values,  y=n)) + geom_bar(stat="identity")

