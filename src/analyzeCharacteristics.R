#Developed by Pablo Vicente-Munuera

library(ggplot2)

characteristics <- read.csv(file = "../Results/graphletsCount/NuevosCasos/RET/NDUMP2/characteristicsRETWithNamesNoHeader.csv", header = FALSE)

characteristicsMatrix <- as.matrix(characteristics[,3:length(characteristics)])

characteristicsMatrix[is.nan(characteristicsMatrix)] <- 0

normalizeCharactericsMatrix <- (characteristicsMatrix / max(characteristicsMatrix))


tsneCoordinates <- tsne(normalizeCharactericsMatrix, perplexity = 100, max_iter = 1000)

qplot(tsneCoordinates[,1], tsneCoordinates[,2], colour=characteristics$V2)

characteristicsPCA <- prcomp(normalizeCharactericsMatrix)
qplot(characteristicsPCA$x[,1], characteristicsPCA$x[,2], colour=characteristics$V2)