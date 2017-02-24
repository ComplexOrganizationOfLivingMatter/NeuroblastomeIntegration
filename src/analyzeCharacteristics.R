#Developed by Pablo Vicente-Munuera

#--------------------------- GDDA ---------------------------#

source('D:/Pablo/Neuroblastoma/NeuroblastomeIntegration/src/analyzeCharacteristicsGDDA.R')
source('D:/Pablo/Neuroblastoma/NeuroblastomeIntegration/src/saveQPlot.R')
source('D:/Pablo/Neuroblastoma/NeuroblastomeIntegration/src/lib/plotingUnsupervisedSom.R')
library("kohonen", lib.loc="~/R/win-library/3.3")
library("plot3D");
library("plot3Drgl");
#library("som")

startingColumn <- 3
#characteristics <- analyzeCharacteristicsGDDA("../Results/graphletsCount/NuevosCasos/Analysis/Characteristics_GDDA_AgainstControl_Inestability_0sInsteadOf-1s_30_01_2017.csv", startingColumn);
characteristics <- analyzeCharacteristicsGDDA("../Results/graphletsCount/NuevosCasos/Analysis/Characteristics_GDDA_AgainstControl_InestabilityWithWeights_24_02_2017.csv", startingColumn);

#characteristics <- analyzeCharacteristicsGDDA("../Results/graphletsCount/NuevosCasos/Analysis/testOverfitting_07_02_2017.csv", startingColumn);
characteristics <- characteristics[characteristics[, startingColumn - 1] == "Baja" | characteristics[, startingColumn - 1] == "Media", ]

#https://cran.r-project.org/web/packages/kohonen/kohonen.pdf

# classesCharacteristics <- classvec2classmat(t(characteristics[, startingColumn - 1]))
# #som2 <- bdk(as.matrix(characteristics[, c(3, 5, 7)]), grid = somgrid(xdim = 2, ydim = 2, topo = c("rectangular", "hexagonal")), classesCharacteristics);
# som2 <- bdk(as.matrix(characteristics[, startingColumn:length(characteristics)]), grid = somgrid(xdim = 1, ydim = 2, topo = c("rectangular", "hexagonal")), classesCharacteristics);
# plot(som2)
# 
# 
# som.wines <- som(Xtraining, grid = somgrid(5, 5, "hexagonal"))
# som.prediction <- predict(som.wines, newdata = Xtest,
#                           trainX = Xtraining,
#                           trainY = factor(wine.classes[training]))
# table(wine.classes[-training], som.prediction$prediction)

classesCharacteristics <- classvec2classmat(t(characteristics[, startingColumn - 1]))
somInfo <- som(scale(characteristics[, startingColumn:length(characteristics)]), grid = somgrid(3, 4, "rectangular"))
#plot(somInfo)

som.draw(somInfo, characteristics[, startingColumn - 1])

characteristics$classification <- p

tsneCoordinates <- tsne(characteristics[, startingColumn:length(characteristics)], perplexity = 30, k = 3, max_iter = 200)
gplot <- qplot(tsneCoordinates[,1], tsneCoordinates[,2], colour=characteristics[, 2])
scatter3Drgl(tsneCoordinates[,1], tsneCoordinates[,2], tsneCoordinates[,3], colvar = as.numeric(characteristics[, 2], plot = TRUE))
saveQPlot('tsne_Perplexity20', gplot)

pcaCoordenates <- prcomp(characteristics[, startingColumn:length(characteristics)])
gplot <- qplot(pcaCoordenates$x[, "PC1"], pcaCoordenates$x[, "PC2"], colour=characteristics[, 2])
scatter3Drgl(pcaCoordenates$x[, "PC1"], pcaCoordenates$x[, "PC2"], pcaCoordenates$x[, "PC3"], colvar = as.numeric(characteristics[, 2], plot = TRUE))
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
