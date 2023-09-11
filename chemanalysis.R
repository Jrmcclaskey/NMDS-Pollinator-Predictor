#Imports data to be utilized in graphical representation
library(tidyverse)
library(tidyr)
library(dplyr) 
library(magrittr) 
library(ggplot2) 
library(vegan)  #package for NMDS

urlfile="https://raw.githubusercontent.com/VinaugerLab/BCHM4354_2022/main/Dataset_R_2022.csv"
Raw.data<-as.data.frame(read_csv(url(urlfile)) )

#data Subsets
Poll.data <-Raw.data%>%
  filter(Chemical == "Pollinator")#just pollinators
Color.data <- Raw.data%>%
  filter(Chemical == "color")#just colors
Chem.data <- Raw.data%>%
  filter(Chemical != "color")%>%
  filter(Chemical != "Pollinator")#Just chem data
SpeciesA.surv<- Raw.data[,c(1:6,27:31,36:40)]%>%
  gather(key = Variables, value = Values, 2:16)%>%#subsets all data for Plant A survivors
  filter(Chemical != "color")%>%#these two lines are optional to isolate chemicals
  filter(Chemical != "Pollinator")#just chem data

#reshape Color.data to long format
Color.data.count <- Color.data %>%
  pivot_longer(cols = -Chemical, names_to = "Plant", values_to = "Color")

#group by color and count occurrences
Color.count <- Color.data.count %>%
  group_by(Color) %>%
  count()
data_colors <- c("green" = "#036A0B", 
                 "pink" = "#F78BF7", 
                 "white" = "white",
                 "pale_green" = "palegreen",
                 "orange" = "#FAAC34",
                 "yellow" = "yellow"
)

ggplot(Color.count, aes(x = Color, y = n, fill = Color)) +
  geom_bar(stat = "identity", color = "black", size = 0.5) +
  scale_fill_manual(values = data_colors) +
  xlab("Color") +
  ylab("Count") +
  theme_minimal()

#reshape Poll.data to long format
Poll.data.count <- Poll.data %>%
  pivot_longer(cols = -Chemical, names_to = "Plant", values_to = "Color")

#group by pollinator and count instances
Poll.count <- Poll.data.count %>%
  group_by(Color) %>%
  count()
ggplot(Poll.count, aes(x = Color, y = n, fill = Color)) +
  geom_bar(stat = "identity", color = "black", size = 0.5) +
  xlab("Pollinator") +
  ylab("Count") +
  theme_minimal()


#nmds dataset
nmds.data <- as.data.frame(Chem.data[-1])
nmds.data <- apply(nmds.data, 2, as.numeric)
set.seed(123) 
chem.nmds <- metaMDS(nmds.data)
chem.nmds

#set nmds as a dataframe
data.scores <- scores(chem.nmds)
data.scores_df <- data.frame(Species = rownames(data.scores$species),
                             data.scores$species,
                             row.names = NULL)

#reshape color to long format
Color.data_long <- t(Color.data)
Color.data_long <- as.data.frame(Color.data_long)
colnames(Color.data_long) <- as.character(unlist(Color.data_long[1,]))
Color.data_long <- Color.data_long[-1,]

#reshape pollinator to long format
poll.data_long <- t(Poll.data)
poll.data_long <- as.data.frame(poll.data_long)
colnames(poll.data_long) <- as.character(unlist(poll.data_long[1,]))
poll.data_long <- poll.data_long[-1,]

#add pollinator and color to dataframe
data.scores_df$Color <- Color.data_long
data.scores_df$Color <- as.factor(data.scores_df$Color)
data.scores_df$Pollinator <- poll.data_long
data.scores_df$Pollinator <- as.factor(data.scores_df$Pollinator)

#makes NMDS graph to analyze data
xx = ggplot(data.scores_df, aes(x = NMDS1, y = NMDS2)) + 
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







