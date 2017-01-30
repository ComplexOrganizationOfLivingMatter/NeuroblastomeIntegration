#Developed by Pablo Vicente-Munuera

#--------------------------- GDDA ---------------------------#

source('E:/Pablo/Neuroblastoma/NeuroblastomeIntegration/src/analyzeCharacteristicsGDDA.R')
source('E:/Pablo/Neuroblastoma/NeuroblastomeIntegration/src/saveQPlot.R')

startingColumn <- 3
characteristics <- analyzeCharacteristicsGDDA("../Results/graphletsCount/NuevosCasos/Analysis/Characteristics_GDDA_AgainstControl_Inestability_0sInsteadOf-1s_30_01_2017.csv", startingColumn);
#characteristics <- analyzeCharacteristicsGDDA("../Results/graphletsCount/NuevosCasos/Analsys/Characteristics_GDDA_AgainstControl_UHR_30_01_2017.csv", startingColumn);
#characteristics <- characteristics[characteristics[, startingColumn - 1] == "Media" | characteristics[, startingColumn - 1] == "Alta", ]

tsneCoordinates <- tsne(characteristics[, startingColumn:length(characteristics)], perplexity = 30)
gplot <- qplot(tsneCoordinates[,1], tsneCoordinates[,2], colour=characteristics[, 2])
saveQPlot('tsne_Perplexity30', gplot)

pcaCoordenates <- prcomp(characteristics[, startingColumn:length(characteristics)])
gplot <- qplot(pcaCoordenates$x[, "PC1"], pcaCoordenates$x[, "PC2"], colour=characteristics[, 2])
saveQPlot('PCA', gplot)

for (num in startingColumn:(length(characteristics) - 1)){
  for (num2 in (num + 1) :(length(characteristics))){
    if (num != num2){
      gplot <- qplot(characteristics[, num], characteristics[, num2], colour=characteristics[, 2])
      
      saveQPlot(paste(num, num2, sep = "_"), gplot)
    }
  }
}


# ------- Feature selection ----------#

library("caret")

## Load early to get the warnings out of the way:
library("randomForest")
library("ipred")
library("gbm")

control <- rfeControl(functions = rfFuncs, method = "boot", verbose = FALSE, returnResamp = "final", number = 50)

profile.1 <- rfe(normalizeCharactericsMatrix, characteristics$Inestability, rfeControl = control)
cat( "rf     : Profile 1 predictors:", predictors(profile.1), fill = TRUE )
