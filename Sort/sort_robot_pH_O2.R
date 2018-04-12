# Reinitialize the session
rm(list=ls(all=TRUE))

library(reshape2)

# Go to the working directory
setwd("~/Labo/Données/Script/robot")

data <- read.csv(file = "20161103-094008_OD.csv", sep = "\t", header = FALSE, dec = ".",stringsAsFactors = FALSE )
data <- data[3:nrow(data),-1]

data[,2:ncol(data)] <- as.numeric(unlist(data[,2:ncol(data)]))

to_keepPH <- c(TRUE, rep(c(TRUE, FALSE), (ncol(data)-1)/2))
to_keepO2 <- c(TRUE, rep(c(FALSE, TRUE), (ncol(data)-1)/2))

dataPH <- (data[,to_keepPH])
dataO2 <- (data[,to_keepO2])


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

dataPH[,1] <- (my_time[,1]-my_time[1,1]) + ((my_time[,2]-my_time[1,2])/60) + ((my_time[,3]-my_time[1,3])/3600)
dataO2[,1] <- (my_time[,1]-my_time[1,1]) + ((my_time[,2]-my_time[1,2])/60) + ((my_time[,3]-my_time[1,3])/3600)

colnames(dataPH) <- c("Time",sprintf("R%d", 1:(ncol(dataPH)-1)))
colnames(dataO2) <- c("Time",sprintf("R%d", 1:(ncol(dataO2)-1)))

write.table(dataO2, file = "data_O2.txt",
            sep = "\t",
            dec = ",",
            row.names = FALSE)
write.table(dataPH, file = "data_pH.txt",
            sep = "\t",
            dec = ",",
            row.names = FALSE)