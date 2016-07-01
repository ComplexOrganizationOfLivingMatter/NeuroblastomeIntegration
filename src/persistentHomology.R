
library("TDA", lib.loc="~/R/win-library/3.1")
library("R.matlab", lib.loc="~/R/win-library/3.1")

pathname <- file.path("../Datos/Data/Casos/CASO 1. Y01_01B16459B/CoreA/Adjacency/distanceMatrix14_01B16459A_OCT4_Positivos_Y01.mat")

distMat <- readMat(pathname)

maxdimension <- 2;
maxscale <- 1;

diag <- ripsDiag(distMat$distanceBetweenObjects, maxdimension, maxscale, dist = "euclidean", library = "GUDHI",
         location = FALSE, printProgress = T)
plot(diag[["diagram"]])

maxKDE <- maxPersistence(kde, parametersKDE, X, lim = lim, by = by,
                         bandFUN = "bootstrapBand", B = B, alpha = alpha,
                         parallel = FALSE, printProgress = TRUE)
print(summary(maxKDE))