
# 2013-05-26 dinclaux@insa-toulouse.fr


#########################################################
### Installing and loading required packages          ###
#########################################################

if (!require("XLConnect")) {
  install.packages("XLConnect", dependencies = TRUE)
  library(XLConnect)
}

#############################################################
### Reading in data and transform it into matrix format   ###
#############################################################

setwd("D:/Documents/Données/Script/plot_fred")
data = readWorksheetFromFile("donnéestot.xlsx", sheet = "script", header = TRUE )