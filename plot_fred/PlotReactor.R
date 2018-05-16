
# Reinitialize the session
rm(list=ls(all=TRUE))

# 2013-03-31 dinclaux@insa-toulouse.fr

# This script generates an overview of data from the robot or 96-well plates. 
# To save an image of the HTML file, open it and print it to PDF.
# Only change Cultures (rownames), Values and Strains (for symbol) column.
# For Strain column, line 45 should be amended.

#########################################################
### Installing and loading required packages          ###
#########################################################
if (!require("XLConnect")) {
  install.packages("XLConnect", dependencies = TRUE)
  library(XLConnect)
}

if (!require("plotly")) {
  install.packages("plotly", dependencies = TRUE)
  library(plotly)
}

if (!require("grDevices")) {
  install.packages("grDevices", dependencies = TRUE)
  library(grDevices)
}
if (!require("htmlwidgets")) {
  install.packages("htmlwidgets", dependencies = TRUE)
  library(htmlwidgets)
}

#############################################################
### number of wells                                       ###
#############################################################

nb <- 72 # number between 1 and 96

#############################################################
### Reading in data and transform it into matrix format   ###
#############################################################
  
setwd("~/Labo/Donn?es/Script/plot_fred")
data = readWorksheetFromFile("donn?estot.xlsx", sheet = "script", header = TRUE )
data <- data[c(1:nb),]
data$Strains<-as.factor(data$Strains)
if (!is.null(levels(data$Strains))){
   logo <- factor(data$Strains, levels = c("wt","Dnak"), labels= c("0","15")) # define symbol https://plot.ly/r/reference/#scatter-marker-symbol
   logo1 <- as.numeric(as.character(logo))
} else {
  logo1 = rep(0,nrow(data))
}

rnames <- data[,1]  # assign labels in column 1 to "rnames"
mat <- as.matrix(data[,2:7])
rownames(mat) <- rnames  # assign row names


#########################################################
### Customizing and plotting bioreactors             ###
#########################################################

# custom palette
pal <- colorRampPalette(c("brown","yellow"))(n = 10) 

# custom text
t <- list(
  family = "sans serif",
  size = 12,
  color = toRGB("black")
)

# plot text
p<- plot_ly(data,
            x=data$x, 
            y=data$z, # (y) is different for text position
            text = NA,
            name = "",
            showlegend = FALSE,
            mode = "none",
            textfont = F,
            textposition = "middle center", # text position,
            showlegend= NA,
            width = 1500,   # windows size (x)
            height = 900  # windows size (y)
)

# plot markers
p<-add_trace(p,
             x=data$x,
             y=data$y,
             name = "",
             showlegend = FALSE,
             mode= "markers",
             size = data$taille,
             color = data$Values, # value color
             colors = pal,
             marker = list(colorbar=list(title="", # colorbar title 
                                         len = 0.8,
                                         lenmode = pal,
                                         titleside ="right"),# colorbar title position  "right" | "top" | "bottom"
                           opacity = 0.9,
                           outliercolor = "black",
                           symbol=logo1,
                           cmin = 0,
                           cmax = 100,
                           line = list(color = "black",
                                       widh = 4)), 
             fillcolor = "grey"
 )

# Title
p1<- layout(p,
            title = "",
            xaxis = list(title = NA,
                         showgrid = FALSE,
                         showticklabels = FALSE),
            yaxis = list(title = NA,
                         showgrid = FALSE,
                         showticklabels = FALSE),
            margin = list(autoexpand = TRUE,
                          b = 80, # Sets the bottom margin (in px)
                          i = 80, # Sets the left margin (in px)
                          r = 80, # Sets the right margin (in px)
                          t = 80) # Sets the top margin (in px)
  )    


p1