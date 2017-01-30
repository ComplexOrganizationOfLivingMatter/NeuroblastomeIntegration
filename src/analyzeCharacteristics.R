#Developed by Pablo Vicente-Munuera

#--------------------------- GDDA ---------------------------#

source('E:/Pablo/Neuroblastoma/NeuroblastomeIntegration/src/analyzeCharacteristicsGDDA.R')

startingColumn <- 3
characteristics <- analyzeCharacteristicsGDDA("../Results/graphletsCount/NuevosCasos/Characteristics_GDDA_AgainstControl_Inestability_30_01_2017.csv", startingColumn);

tsneCoordinates <- tsne(characteristics[, startingColumn:length(characteristics)], perplexity = 30)
qplot(tsneCoordinates[,1], tsneCoordinates[,2], colour=characteristics[, 2])

pcaCoordenates <- prcomp(characteristics[, startingColumn:length(characteristics)])
qplot(pcaCoordenates$x[, "PC1"], pcaCoordenates$x[, "PC2"], colour=characteristics[, 2])

for (num in startingColumn:(length(characteristics)-1)){
  for (num2 in (startingColumn + 1) :(length(characteristics)-1)){
    if (num != num2){
      gplot <- qplot(characteristics[, num], characteristics[, num2], colour=characteristics[, 2])
      
      filename2 <- paste('qplot', as.character(num), '_', as.character(num2), sep = "")
      
      ggsave(paste(filename2, '.pdf', sep=""), gplot, width = 6, height = 8)
      
      print(gplot)
      dev.off()
      
      
      #png(filename = filename2, width = 600, height = 800, res = 300)
      
      #print(gplot) 
      
      #dev.off()
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
