#Developed by Pablo Vicente-Munuera

library("tsne", lib.loc="~/R/win-library/3.1")
library(ggplot2)

characteristics <- read.csv(file = "../Results/graphletsCount/NuevosCasos/RET/characteristicsRETGCD11NormalizedWithClinicalData.csv")

characteristicsMatrix <- as.matrix(characteristics[1:length(characteristics[,1]),5:length(characteristics)])

characteristicsMatrix[is.nan(characteristicsMatrix)] <- 0

colMax <- function(data) apply(data, 2, max)
maxCharacteristics <- as.matrix(colMax(abs(characteristicsMatrix)))

normalizeCharactericsMatrix <- sweep(characteristicsMatrix, 2, maxCharacteristics, '/')


write.csv(file = "../Results/graphletsCount/NuevosCasos/RET/characteristicsRETGCD11Normalized.csv", normalizeCharactericsMatrix)

tsneCoordinates <- tsne(normalizeCharactericsMatrix, perplexity = 10)
qplot(tsneCoordinates[,1], tsneCoordinates[,2], colour=characteristics$Age..months.)


dataMatrix = read.delim(file = "../Results/graphletsCount/NuevosCasos/RET/NDUMP2/TotalGraphletsPerAlgorithm/Iteration/gcd11.txt")
distanceMatrix <- as.matrix(dataMatrix[, 2:length(dataMatrix)])
names <- sort(dataMatrix$X);
distanceMatrix <- distanceMatrix[order(dataMatrix$X), order(dataMatrix$X)]



qplot(normalizeCharactericsMatrix[,"DifferenceIteration1"]*normalizeCharactericsMatrix[,"Iteration1"], normalizeCharactericsMatrix[, "Iter2Sorting"]*normalizeCharactericsMatrix[,"Difference1Sorting"], colour=characteristics$Inestability)

#--------------------------- GDDA ---------------------------#
characteristics <- read.csv(file = "../Results/graphletsCount/NuevosCasos/RET/characteristicsRETGDDAWithClinicalData.csv")

characteristicsMatrix <- as.matrix(characteristics[1:length(characteristics[,1]),5:length(characteristics)])

characteristicsMatrix[is.nan(characteristicsMatrix)] <- 0

colMax <- function(data) apply(data, 2, max)
maxCharacteristics <- as.matrix(colMax(abs(characteristicsMatrix)))

normalizeCharactericsMatrix <- sweep(characteristicsMatrix, 2, maxCharacteristics, '/')
write.csv(file = "../Results/graphletsCount/NuevosCasos/RET/characteristicsRETGDDANormalized.csv", normalizeCharactericsMatrix)

tsneCoordinates <- tsne(characteristicsMatrix, perplexity = 30)
qplot(tsneCoordinates[,1], tsneCoordinates[,2], colour=characteristics$Inestability)

pcaCoordenates <- prcomp(normalizeCharactericsMatrix, scale.=TRUE, center = TRUE)
qplot(pcaCoordenates$x[, "PC1"], pcaCoordenates$x[, "PC2"], colour=characteristics$Inestability)



qplot(normalizeCharactericsMatrix[,"DifferenceIteration1"]*normalizeCharactericsMatrix[,"Iteration1"], normalizeCharactericsMatrix[, "Iter2Sorting"]*normalizeCharactericsMatrix[,"Difference1Sorting"], colour=characteristics$Inestability)
qplot(normalizeCharactericsMatrix[,"DifferenceIteration1"]*normalizeCharactericsMatrix[,"Iteration1"], normalizeCharactericsMatrix[, "Iter1Sorting"]*normalizeCharactericsMatrix[,"Difference1Sorting"], colour=characteristics$Inestability)


differencesSorting <- normalizeCharactericsMatrix[, 6:9]
differencesIteration <- normalizeCharactericsMatrix[, 63:length(normalizeCharactericsMatrix[, 1])]

rowMax <- function(data) apply(data, 1, max)
maxDifferencesSorting <- rowMax(abs(differencesSorting))
maxDifferencesIteration <- rowMax(abs(differencesIteration))

which(differencesIteration[1,] == maxDifferencesIteration[1]) #do for all the rows!
