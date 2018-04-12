# Reinitialize the session
rm(list=ls(all=TRUE))

library(reshape2)

# Go to the working directory
setwd("~/Labo/Données/Script/Robot/robot")
OD = 4
Biomass = 0.38

data <- read.csv(file = "Example.csv", sep = "\t", header = FALSE, dec = ".",stringsAsFactors = FALSE )
data <- data[3:nrow(data),-1]

data[,2:ncol(data)] <- as.numeric(unlist(data[,2:ncol(data)]))

to_keep <- c(TRUE, rep(c(TRUE, FALSE), (ncol(data)-1)/2))
data <- (data[,to_keep])


data[,2:ncol(data)] <- data[,2:ncol(data)]*OD*Biomass

my_time <- colsplit(data[,1], ":",c("Heures", "Minutes", "Secondes")) 


dif <- function(x){
  y <- x[2:length(x)] - x[1:length(x)-1]
  return(y)
}


i=FALSE
while (i==FALSE){
difference <- dif(my_time[,1])
bool <- c(1,difference) < 0
my_time[bool,1] <- my_time[bool,1]+ 24
if (sum(dif(my_time[,1])<0)==0){
  i=TRUE
}
}

data[,1] <- (my_time[,1]-my_time[1,1]) + ((my_time[,2]-my_time[1,2])/60) + ((my_time[,3]-my_time[1,3])/3600)
colnames(data) <- c("Time",sprintf("R%d", 1:(ncol(data)-1)))

write.table(data, file = "data.txt",
            sep = "\t",
            dec = ",",
            row.names = FALSE)