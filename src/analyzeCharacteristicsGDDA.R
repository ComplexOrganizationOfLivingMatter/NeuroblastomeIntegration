analyzeCharacteristicsGDDA <- function(fullPathFile, startingColumnCharacteristics) {
  
  library("tsne", lib.loc="~/R/win-library/3.1")
  library(ggplot2)
  
  characteristics <- read.csv(file = fullPathFile)
  
  characteristicsMatrix <- as.matrix(characteristics[1:length(characteristics[,1]), startingColumnCharacteristics:length(characteristics)])
  
  characteristicsMatrix[is.nan(characteristicsMatrix)] <- 0
  
  colMax <- function(data) apply(data, 2, max)
  maxCharacteristics <- as.matrix(colMax(abs(characteristicsMatrix)))
  
  normalizeCharactericsMatrix <- sweep(characteristicsMatrix, 2, maxCharacteristics, '/')
  characteristicsNormalized <- characteristics
  characteristicsNormalized[,3:length(characteristics)] <- normalizeCharactericsMatrix
  
  return(characteristicsNormalized)
}