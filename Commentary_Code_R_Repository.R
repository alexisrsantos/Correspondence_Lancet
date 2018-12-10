#load the library tidyverse
library(tidyverse)

#Path for Alexis Santos Dropbox
data<-read.csv("PATH HERE/Data.csv")

###################################################
#Calculate the descriptive statistics for Panel A##
###################################################

# Here, we produce the 95% Confidence Interval
month_average95 <- data %>%
  filter(Year < 2017) %>%
  summarize(Mean = mean(Sept_Feb_Deaths), s = sd(Sept_Feb_Deaths)) %>%
  mutate(Lower = Mean - qt(0.975, 6) * s/sqrt(7),
         Upper = Mean + qt(0.975, 6) * s/sqrt(7))

# Here, we produce the 99% Confidence Interval
month_average99 <- data %>%
  filter(Year < 2017) %>%
  summarize(Mean = mean(Sept_Feb_Deaths), s = sd(Sept_Feb_Deaths)) %>%
  mutate(Lower = Mean - qt(0.985, 6) * s/sqrt(7),
         Upper = Mean + qt(0.985, 6) * s/sqrt(7))

# Show month average and 95% C.I. 
month_average95

# Show month average and 99% C.I.
month_average99

#GWU Predicted Deaths for the Census Model
GWU_Pred<-15417

#Difference between GWU Pred and lower limit of both CIs 
GWU_Pred-month_average95$Lower  

GWU_Pred-month_average99$Lower  

#Difference between GWU Pred and mean of the C.I. (means are the same)
GWU_Pred-month_average95$Mean

#GWU Predicted Deaths for Displacement Model
GWU_Pred_Displacement<-13633

#Difference between GWU Pred and lower limit of the C.I. 
GWU_Pred_Displacement-month_average95$Lower 

GWU_Pred_Displacement-month_average99$Lower  

#Difference between GWU Pred and mean of the C.I. (means are the same)
GWU_Pred_Displacement-month_average95$Mean

##############################
### Here we create Panel A ###
##############################

# Get the libraries we need (for all the figures)
library("grid")
library("gridExtra")
library("dplyr")
library("scales")
library("cowplot")
library("gridExtra")

data_fig<-read.csv("PATH HERE/figure_1.csv")

data_fig$Source<-as.character(data_fig$Source) #Code as Characters
data_fig$Excess<-as.character(data_fig$Excess) #Code as Characters

expected_deaths <- ggplot(data = data_fig, aes(x = Source, y = Center, color = Source))+
  geom_point(size = 4) + scale_color_brewer(name = "",palette="Set1")+
  geom_errorbar(aes(ymin=LL, ymax=UL), width = 0.1)+
  geom_text(label = as.character(data_fig$Center), size = 4, vjust = -1.2, nudge_x = 0.2)+
  geom_text(label = as.character(data_fig$Excess), size = 3, vjust = 1.5, nudge_x = 0.2)+
  theme_classic()+ ylim(13000,17000)+
  theme(legend.title=element_text(size = 9),
    legend.position ="bottom", 
    legend.justification ="center")+
    labs(title = "Panel A: Deaths between September and February in Puerto Rico, 2010-2018", subtitle = "Santos-Burgoa (2018), Sept 2017-Feb 2018, 2010-2017 Confidence Intervals, and Excess (Parentheses)", y = "Deaths", x ="")
    
expected_deaths #Show Panel A

###################################
###Pre Hurricane Figure - Panel B##
###################################

#Calculate the Confidence Intervals
month_average95 <- data %>%
  filter(Year < 2017) %>%
  summarize(Mean = mean(Jan_Aug_Deaths), s = sd(Jan_Aug_Deaths)) %>%
  mutate(Lower = Mean - qt(0.975, 6) * s/sqrt(7),
         Upper = Mean + qt(0.975, 6) * s/sqrt(7))

month_average99 <- data %>%
  filter(Year < 2017) %>%
  summarize(Mean = mean(Jan_Aug_Deaths), s = sd(Jan_Aug_Deaths)) %>%
  mutate(Lower = Mean - qt(0.985, 6) * s/sqrt(7),
         Upper = Mean + qt(0.985, 6) * s/sqrt(7))

month_average95 # Show month average and 95% C.I. 

month_average99 # Show month average and 99% C.I.

# This data is used in Panel B (already included in the excel)

######################################
# Create a figure from Correspondence#
######################################

data_fig<-read.csv("PATH HERE/figure_1b.csv")

data_fig$Source<-as.character(data_fig$Source) #Again, make Source a character

expected_deathspre <- ggplot(data = data_fig, aes(x = Source, y = Center, color = Source))+
  geom_point(size = 4) + scale_color_brewer(name = "",palette="Set1")+
  geom_errorbar(aes(ymin=LL, ymax=UL), width = 0.1)+
  geom_text(label = as.character(data_fig$Center), size = 4, vjust = -1.2, nudge_x = 0.2)+
  theme_classic()+ ylim(19000,20500)+
  theme(legend.title=element_text(size = 9),
        legend.position ="bottom", 
        legend.justification ="center")+
  labs(title = "Panel B: Deaths between January and August in Puerto Rico, 2010-2017", subtitle = "2010-2016 95% and 99% Confidence Intervals and Observed (January - August 2017)", y = "Deaths", x ="")

expected_deathspre #Show Panel B

####################################
#Create the figure with two pannels#
####################################

require(ggpubr) #Get the library for the creation of the figure

figure<-ggarrange(expected_deaths,expected_deathspre,ncol=1,nrow=2,labels=c("A","B"))

figure #Show the figure

# Supplementary Figure A
data_fig_b<-read.csv("PATH HERE/figure_1_b.csv")

data_fig_b$Source<-as.character(data_fig_b$Source) #As character

expected_deaths2 <- ggplot(data = data_fig_b, aes(x = Source, y = Central, color = Source))+
  geom_point(size = 4) + #scale_color_brewer(name ="",palette="Spectral")+
  geom_errorbar(aes(ymin=LL, ymax=UL), width = 0.1)+
  geom_text(label = as.character(data_fig_b$Central), size = 3, vjust = -1.2, nudge_x = 0.2)+
  theme_classic()+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),legend.title=element_blank(),
        legend.position ="bottom", 
        legend.justification ="center")+
  labs(title = "Supplementary Panel A: Vital Statistics Estimates Produced since September 2017", subtitle = "Compilation of excess deaths estimates produced after Hurricane Maria using Vital Statistics", y = "Excess Deaths", x ="")

expected_deaths2 #Show the Figure

##################################################################
###Meta Analysis of all the estimates, but not the GWU Scenarios##
##################################################################

meta_scenarios <- data_fig_b %>%
  filter(Central < 2000 & Central !=1191) %>%
  summarize(Mean = mean(Central), s = sd(Central)) %>%
  mutate(Lower = Mean - qt(0.975, 9) * s/sqrt(10),
         Upper = Mean + qt(0.975, 9) * s/sqrt(10))

meta_scenarios #Shows the central estimate and the 95% range
