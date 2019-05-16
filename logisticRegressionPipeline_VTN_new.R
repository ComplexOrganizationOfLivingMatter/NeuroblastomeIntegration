#Based on the pipeline of Juan Francisco Martín-Rodríguez

rm(list = setdiff(ls(), lsf.str()))

#Source functions
debugSource('D:/Pablo/FeatureSelection/FeatureSelection/src/dicotomizeVariables.R',
            echo = TRUE)
debugSource('D:/Pablo/FeatureSelection/FeatureSelection/src/univariateAnalysis.R',
            echo = TRUE)
debugSource('D:/Pablo/FeatureSelection/FeatureSelection/src/logisticFeatureSelection.R', echo = T)

library(rcompanion)
require(lmtest)

#Import data
library(readxl)
initialInfo <-
  read_excel(
    "E:/Pablo/Neuroblastoma/Results/capturingFeatures/Human/NuevosCasos/Analysis/NewClinicClassification_NewControls_ToCompareSubjective_HomogeneousPattern_15_03_2018.xlsx"
  )

dependentCategory <- "RiskCalculated" #"Instability" or "RiskCalculated"

missingValues <- initialInfo$`VTN++ - Sorting` == 0 & initialInfo$`VTN++ - Iteration` == 0;

initialIndex <- 41

#outputFile <- paste("outputResults", dependentCategory, format(Sys.time(), "%d-%m-%Y"),".txt", sep='_')

#sink(temporaryFileObj <- textConnection("outputFileText", "w"), split=TRUE)


## First step: Dicotomize variables
print("-------------First step: Dicotomize variables---------------")
#Option 1: Younden's Index
#initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "MaxSpSe")

#Option 2: Median
# initialInfoDicotomized <-
#   dicotomizeVariables(initialInfo,
#                       initialIndex,
#                       "RiskCalculated",
#                       dependentCategory,
#                       "Median")

#Option 3: third quartile
#initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "3rdQuartile")

#Option 4: Divide by quartiles
initialInfoDicotomized <-
  dicotomizeVariables(initialInfo,
                      initialIndex,
                      dependentCategory,
                      "NoRisk",
                      "Quartiles")

initialInfoDicotomized$`VTN - Homogeneous_Heterogeneous pattern` <- initialInfo$`VTN - Homogeneous_Heterogeneous pattern`;
initialInfo[initialInfoDicotomized$`VTN - Homogeneous_Heterogeneous pattern` == 999, "VTN - Homogeneous_Heterogeneous pattern"] <- NA;
initialInfoDicotomized$`VTN++ - Sorting`[missingValues] <- 999;
initialInfoDicotomized$`VTN++ - Iteration`[missingValues] <- 999;
initialInfoDicotomized$`VTN++ - MST`[missingValues] <- 999;
initialInfo$`VTN++ - Sorting`[missingValues] <- 0;
initialInfo$`VTN++ - Iteration`[missingValues] <- 0;
initialInfo$`VTN++ - MST`[missingValues] <- 0;

initialInfo <- initialInfo[is.na(initialInfoDicotomized[, dependentCategory]) == 0,];
initialInfoDicotomized <- initialInfoDicotomized[is.na(initialInfoDicotomized[, dependentCategory]) == 0,];
riskCalculatedLabels <- initialInfoDicotomized[, dependentCategory]
if (dependentCategory == "Instability") {
  riskCalculatedLabels[riskCalculatedLabels != 'High' & riskCalculatedLabels != 'Medium'] <- 'NoHigh'
  riskCalculatedLabels[riskCalculatedLabels == 'High' | riskCalculatedLabels == 'Medium'] <- 'High'
  initialInfoDicotomized[, dependentCategory] <-
    as.numeric(initialInfoDicotomized[, dependentCategory] == 'High' | initialInfoDicotomized[, dependentCategory] == 'Medium')
  # riskCalculatedLabels[riskCalculatedLabels != 'High'] <- 'NoHigh'
  # initialInfoDicotomized[, dependentCategory] <-
  #   as.numeric(initialInfoDicotomized[, dependentCategory] == 'High')
} else {
  initialInfoDicotomized[, dependentCategory]  <-
    as.numeric(initialInfoDicotomized[, dependentCategory] == 'HighRisk')
}

#T-Test
#Normality test -> if non-signifincant pvalue, then it has a normal distribution
shapiro.test(initialInfo$`VTN+ - Sorting`) 
shapiro.test(initialInfo$`VTN+ - Iteration`) 
shapiro.test(initialInfo$`VTN+ - MST`) 
shapiro.test(initialInfo$`VTN++ - Sorting`) 
shapiro.test(initialInfo$`VTN++ - Iteration`) 
shapiro.test(initialInfo$`VTN++ - MST`)
#shapiro.test(initialInfoDicotomized$RiskCalculated)

# wilcox.test(initialInfo$`VTN+ - Sorting` ~ initialInfoDicotomized$Instability)
# wilcox.test(initialInfo$`VTN+ - Iteration` ~ initialInfoDicotomized$Instability)
# wilcox.test(initialInfo$`VTN+ - MST` ~ initialInfoDicotomized$Instability)
# 
# wilcox.test(initialInfo$`VTN++ - Sorting` ~ initialInfoDicotomized$Instability)
# wilcox.test(initialInfo$`VTN++ - Iteration` ~ initialInfoDicotomized$Instability)
# wilcox.test(initialInfo$`VTN++ - MST` ~ initialInfoDicotomized$Instability)
# 
# #Low
# vlues <- na.omit(initialInfo[initialInfoDicotomized$Instability == 0, "VTN+ - MST"]);
# mean(as.numeric(vlues$`VTN+ - MST`))
# sd(as.numeric(vlues$`VTN+ - MST`))
# 
# #High
# vlues <- na.omit(initialInfo[initialInfoDicotomized$Instability == 1, "VTN+ - MST"]);
# mean(as.numeric(vlues$`VTN+ - MST`))
# sd(as.numeric(vlues$`VTN+ - MST`))
# 
# #Low
# vlues <- na.omit(initialInfo[initialInfoDicotomized$Instability == 0, "VTN++ - MST"]);
# mean(as.numeric(vlues$`VTN++ - MST`))
# sd(as.numeric(vlues$`VTN++ - MST`))
# 
# #High
# vlues <- na.omit(initialInfo[initialInfoDicotomized$Instability == 1, "VTN++ - MST"]);
# mean(as.numeric(vlues$`VTN++ - MST`))
# sd(as.numeric(vlues$`VTN++ - MST`))

wilcox.test(initialInfo$`VTN+ - Sorting` ~ initialInfoDicotomized$RiskCalculated)
wilcox.test(initialInfo$`VTN+ - Iteration` ~ initialInfoDicotomized$RiskCalculated)
wilcox.test(initialInfo$`VTN+ - MST` ~ initialInfoDicotomized$RiskCalculated)

wilcox.test(initialInfo$`VTN++ - Sorting` ~ initialInfoDicotomized$RiskCalculated)
wilcox.test(initialInfo$`VTN++ - Iteration` ~ initialInfoDicotomized$RiskCalculated)
wilcox.test(initialInfo$`VTN++ - MST` ~ initialInfoDicotomized$RiskCalculated)

#Low
vlues <- na.omit(initialInfo[initialInfoDicotomized$RiskCalculated == 0, "VTN - Homogeneous_Heterogeneous pattern"]);
mean(as.numeric(vlues$`VTN - Homogeneous_Heterogeneous pattern`))
sd(as.numeric(vlues$`VTN - Homogeneous_Heterogeneous pattern`))

#High
vlues <- na.omit(initialInfo[initialInfoDicotomized$RiskCalculated == 1, "VTN - Homogeneous_Heterogeneous pattern"]);
mean(as.numeric(vlues$`VTN - Homogeneous_Heterogeneous pattern`))
sd(as.numeric(vlues$`VTN - Homogeneous_Heterogeneous pattern`))


characteristicsAll <-
  initialInfoDicotomized[, initialIndex:length(initialInfoDicotomized[1,])]

characteristicsWithoutClinic <-
  initialInfoDicotomized[, c(initialIndex:(length(initialInfoDicotomized[1,]) -
                                           9), length(initialInfoDicotomized[1,]))]

characteristicsOnlyClinic <-
  initialInfoDicotomized[, (length(initialInfoDicotomized[1,]) - 8):(length(initialInfoDicotomized[1,])-1)]
#Removing histoCat
characteristicsOnlyClinic <- characteristicsOnlyClinic[, -3]


characteristicsWithoutClinicVTN <-
  characteristicsWithoutClinic[, grepl("VTN" , colnames(characteristicsWithoutClinic))]

#Only our new features
if (dependentCategory == "Instability") {
  characteristicsWithoutClinicVTN <- characteristicsWithoutClinicVTN[, 1:48]; #/32 for high vs no high
} else {
  characteristicsWithoutClinicVTN <- characteristicsWithoutClinicVTN[, 1:48];
}

# library(xlsx)
# write.xlsx(characteristicsWithoutClinicVTN, 'file.xlsx', sheetName="Sheet1")

colNamesOfFormula <-
  paste(colnames(characteristicsWithoutClinicVTN), collapse = '` + `')

initialFormula <-
  as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep =
                     ''))
initialGLM <-
  glm(initialFormula, data = initialInfoDicotomized, family = binomial(logit))

print("Initial glm with all the variables")
print(summary(initialGLM))

"Anova chi square"
anovaRes <-
  anova(glm(initialFormula, data = initialInfoDicotomized, family = binomial(logit)),
        test = 'Chisq')
print(anovaRes$`Pr(>Chi)`[2])

initialNagelkerke <- nagelkerke(initialGLM)


print('-----------------------------')

## Second step: Univariate analysis to remove non-significant variables

print("-------------Second step: Univariate analysis to remove non-significant variables---------------")

bestVTNMorphometricsFeatures <- c(109, 108, 110, 112, 118, 119, 120, 122);

#P-Values for categories:
#RiskCalculated = 0.011
#Instability = 0.05 or 0.00001
if (dependentCategory == "Instability") {
  #Removed by collinearities:
  # - 122 - H-Score -> 15.2
  # - 108 - VTN - Percentage of stained area negative cells
  # - 110 - VTN - Percantege of stained area VN EXTRAC +
  # - 112 - VTN - Percentage of stained area INTRAC ++
  bestVTNMorphometricsFeatures <- c(109, 118, 119, 120)
  pValueThreshold <- 0.0003
  #pValueThreshold <- 0.0002
} else {
  pValueThreshold <- 0.011
}

pvaluesChars <-
  univariateAnalysis(initialInfoDicotomized, initialIndex, dependentCategory, characteristicsWithoutClinicVTN, pValueThreshold)

which(pvaluesChars < pValueThreshold)
#ToSave
significantCharNames <- colnames(characteristicsWithoutClinicVTN[, pvaluesChars < pValueThreshold])

outputFile <- paste("significantList_", dependentCategory, '_', format(Sys.time(), "%d-%m-%Y"), ".RData", sep='');
saveRDS(list(significantCharNames, pvaluesChars), file = outputFile)

significantCharacteristics <- characteristicsWithoutClinicVTN[,pvaluesChars < pValueThreshold];

significantAndClinicChars <-
  cbind(significantCharacteristics, characteristicsOnlyClinic)
colNamesOfFormula <-
  paste(names(significantAndClinicChars), collapse = '` + `')

formula <-
  as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep = ''))

allSignificantGLM <-
  glm(formula, data = initialInfoDicotomized, family = binomial(logit))

print('Regression with significant variables')
print(summary(allSignificantGLM))

anovaRes <-
  anova(glm(formula, data = initialInfoDicotomized, family = binomial(logit)),
        test = 'Chisq')
print(anovaRes$`Pr(>Chi)`[2])

initialNagelkerke <- nagelkerke(allSignificantGLM)

print('-----------------------------')

## Third step: Multiple logistic regression with all the variables
#https://rstudio-pubs-static.s3.amazonaws.com/2897_9220b21cfc0c43a396ff9abf122bb351.html

print("-------------Third step: Multiple logistic regression with all the variables---------------")

#Method 1: bestglm

library(mplot)

#We have also added an independent standard Gaussian random variable to the
#model matrix as a redundant variable (RV). This provides a baseline to help
#determine which inclusion probabilities are "significant" in the sense that
#they exhibit a different behaviour to the RV curve.
vis.glm = vis(allSignificantGLM, B = 150, redundant = TRUE, nbest = 5, cores = 8); #nbest also ="all"

outputFile <- paste("results/multiple_LogisticRegression_", dependentCategory, '_', format(Sys.time(), "%d-%m-%Y"), ".RData", sep='');


"Vis output"
print(vis.glm, min.prob = 0.2)
png(paste('boostrapVariablesProbability', dependentCategory, format(Sys.time(), "%d-%m-%Y"), '.png', sep = '_'), width = 1200, height = 500)
plot(vis.glm, interactive = T, which="vip")
dev.off()
colnames(vis.glm$res.single.pass)
#plot(vis.glm, interactive = FALSE, which="boot", highlight = 'X.VTN...Objs.mm2.negative.cells.') #HighLight to change the reference variable
plot(vis.glm, interactive = F, which="lvk", highlight = 'INRG_EDAD')

res.best.logistic <-
  logisticFeatureSelection(significantAndClinicChars,
                           initialInfoDicotomized,
                           dependentCategory,
                           "method1")

appearancesPerVariable <- rapply(res.best.logistic$BestModels[, 1:(ncol(res.best.logistic$BestModels)-1)], function(columnValues){
  sum(columnValues)
})

png(paste('results/barPlotOfOccurrences_Method1', dependentCategory, format(Sys.time(), "%d-%m-%Y"), '.png', sep = '_'), width = 1000, height = 700)
par(mar=c(15,4,4,2)) 
barplot(appearancesPerVariable/10,
        ylab = "Occurrences",
        col = terrain.colors(ncol(res.best.logistic$BestModels)-1),
        cex.names = 0.7,
        las=2)
dev.off()

bestCharacteristics_Method1 = res.best.logistic$BestModel$model[1:nrow(res.best.logistic$BestModel$model), 2:ncol(res.best.logistic$BestModel$model)]

#-------------RiskCalculated----------------#
#Refined, because we found these similarities:
# 2) MYCN and SCAs. Removing SCAs
# 3) VTN++ - eulerNumberPerFilledCell and VTN - Ratio of Strong-Positive pixels to total pixels ???? #This collinearity is low
#   3.1) We tested which to remove if any. We should remove the latter, because the first is more informative.
# 4) Histocat and Histodif. Removing HistoDif
# bestCharacteristics_Method1 <-
#   bestCharacteristics_Method1[, c(1, 3, 4, 6, 8)]

#Method2: glmulti
library(glmulti)
glmulti.logistic.out <-
  logisticFeatureSelection(significantAndClinicChars,
                           initialInfoDicotomized,
                           dependentCategory,
                           "method2")

png(paste('results/Model-averaged_importanceOfTerms', dependentCategory, format(Sys.time(), "%d-%m-%Y"), '.png', sep = '_'), width = 1000, height = 700)
plot(glmulti.logistic.out, type='s', cex.names = 1.3)
title(xlab = 'Importance')#, ylab = 'Independent variables')
dev.off()

saveRDS(list(vis.glm, glmulti.logistic.out, res.best.logistic), file = outputFile)

#Method 3: stepAIC?

#Before found collinearities
# #For Option 3: 3rd Quartile
# bestCharacteristics_Method2 <- significantAndClinicChars[,c(1, 2, 8, 10:16)]
# #Refined, because we found these similarities:
# # 1) VTN - Total cells and H-Score. Removin H-Score
# # 2) MYCN and SCAs. Removing SCAs
# # 3) VTN - Total cells and VTN++ - meanQuantityOfBranchesFilledPerCell ???? #This collinearity is low
# # 4) Histocat and Histodif. Removing HistoDif
# bestCharacteristics_Method2 <- significantAndClinicChars[,c(1, 8, 11:13, 16)]
#For Option 4: Quartiles
bestCharacteristics <-
  significantAndClinicChars[, c(3, 10:11, 13:14)]
#Refined, because we found these similarities:
# 1) MYCN and SCAs. Removing MYCN
# 2) We may want to add 9 (ratio of strong pixels), 
# however, exists a bit of collinearity between euler number per filled cell and 9. 
# Moreover, it does not add any value to the logistic regression. Thus, rejected.
bestCharacteristics <-
  significantAndClinicChars[, c(3, 10:11, 14)]

#-------------END----------------#

#-------------INSTABILITY----------------#

#High vs Rest
#Removing collinearities:
bestCharacteristics <-
  significantAndClinicChars[, c(2, 5, 10, 12:13)]

#High and medium vs Low and very low
#Removing: Estadio due to collinearities (10)
#Removing: 11q it didn't appear in the first method
bestCharacteristics <- significantAndClinicChars[, c(4, 12:14)]




#-------------END----------------#

print('-----------------------------')

## Forth step: Check collinearity and confusion/interaction

print("-------------Forth step: Check collinearity and confusion/interaction---------------")

# Collinearity

library(car)
colNamesOfFormula <-
  paste(colnames(cbind(bestCharacteristics)), collapse = '` + `')

finalFormula <-
  as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep =
                     ''))
print('Checking collinearity:')
print(vif(glm(finalFormula, data = initialInfoDicotomized, family = binomial(logit))))

library(glmnet)
glmmod <- glmnet(as.matrix(bestCharacteristics), y=initialInfoDicotomized$Instability , alpha=1, family="binomial")
plot(glmmod, xvar="lambda")

#https://stackoverflow.com/questions/30566788/legend-label-errors-with-glmnet-plot-in-r
lbs_fun <- function(fit, ...) {
  L <- length(fit$lambda)
  y <- fit$beta[, L]
  labs <- names(y)
  #text(x, y, labels=labs, ...)
  legend('topright', legend=labs, col=1:6, lty=1) # only 6 colors
}
lbs_fun(glmmod)

library(glmmLasso)
glmLasso.results <- glmmLasso(finalFormula, NULL, data = initialInfoDicotomized, family = binomial(logit), lambda = 3) #lambda should change

print('-----------------------------')

# Confusion and Interaction
print("Confusion and interaction")
#https://www.statmethods.net/stats/frequencies.html
mytable <- xtabs(finalFormula, data = initialInfoDicotomized)
#ftable(mytable) # print table
print(summary(mytable)) # chi-square test of indepedence

print('-----------------------------')

## Fifth step: Calculate the relative importance of each predictor within the model

print("-------------Fifth step: Calculate the relative importance of each predictor within the model---------------")

# library(relaimpo) #Only for linear models... Not Logistic regression
# calc.relimp(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), rela=T)
# #Boostrapping
# boot <- boot.relimp(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), rank = TRUE,
#                     diff = TRUE, rela = TRUE)
# booteval.relimp(boot)
# plot(booteval.relimp(boot,sort=TRUE))

# #Other option of seeing the relative importance
# library(relimp)
# allNumChars <- 1:length(bestCharacteristics)+1
# res.relimp <- relimp(
#   glm(finalFormula, data = initialInfoDicotomized, family = binomial(logit)),
#   set1 = allNumChars[-1],
#   set2 = allNumChars
# )
# res.relimp

#https://www.researchgate.net/post/How_do_I_calculate_age_contribution_of_a_predictor_variable_for_logistic_regression_Have_used_varImp_function_but_it_does_not_give_percentage
#In logistic regression, the log likelihood statistic can be used for comparison of nested models.
#So, run the full model (all IVs), and note the -2LL value (in general, smaller is better for this value).
#Then, run successive models, each omitting one of the IVs.  The omit-one run which results in the largest
# increase in log likelihood indicates the (omitted) IV that contributed most (given the other IVs) to the model.
#There are no guarantees, of course, that the same sequence of 'impact' would be observed in another sample.



colNamesOfFormula <-
  paste(colnames(bestCharacteristics), collapse = '` + `')

finalFormula <-
  as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep =
                     ''))

library(logistf)

finalGLM <-
  glm(finalFormula, data = initialInfoDicotomized, family = binomial(logit))

#finalGLM <- logistf(finalFormula, data = initialInfoDicotomized, family = binomial(logit))

"Final logistic regression"
print(summary(finalGLM))

"---"
"Anova chi square"
anovaRes <-
  anova(glm(finalFormula, data = initialInfoDicotomized, family = binomial(logit)),
        test = 'Chisq')
print(anovaRes$`Pr(>Chi)`[2])

"Odds ratio"
print(exp(coefficients(finalGLM)))
library(MASS)
exp(confint.default(finalGLM))

#prob=predict(finalGLM,type="response")
prob = finalGLM$predict;

thresh <- 0.5
riskCalculatedLabels <- as.data.frame(riskCalculatedLabels)
if (dependentCategory == 'Instability'){
  YhatFac <-
    cut(prob,
        breaks = c(-Inf, thresh, Inf),
        labels = c("NoHigh", "High"))
  
  cTab <- table(YhatFac, factor(riskCalculatedLabels[, dependentCategory], levels = c("NoHigh", "High")))  
} else {
  YhatFac <-
    cut(prob,
        breaks = c(-Inf, thresh, Inf),
        labels = c("NoRisk", "HighRisk"))
  
  cTab <- table(YhatFac, factor(riskCalculatedLabels[, dependentCategory], levels = c("NoRisk", "HighRisk")))
}

"Confussion matrix"
print(addmargins(cTab))

library(caret)
print("Specificity (NoRisk)")
print(sensitivity(cTab))
print("Sensitivity (HighRisk)")
print(specificity(cTab))

#Roc curve
library(pROC)
library(plotROC)

#Yeahp, Real values first, predicter second.

tiff(paste('rocCurve', dependentCategory, format(Sys.time(), "%d-%m-%Y"), '.tif', sep = '_'), width = 4, height = 4, units = 'in', res = 300)
roc(riskCalculatedLabels[, dependentCategory], prob, plot = T, ylim = c(0, 1), xlim = c(1, 0), smooth = T)
#plot_roc(roc, 0.7, 1, 2)
#ggplot(g, aes(d = D, m = M1)) + geom_roc(n.cuts = 50, labels = FALSE)
#plot(g)
dev.off()

referenceGLM <- nagelkerke(finalGLM)

results.glmWithoutActualChar <- c()
results.glmWithoutActualChar.negelker <- c()

results.comparisonWithReference <- c()

for (numChar in 1:length(bestCharacteristics)) {
  actualDF <- bestCharacteristics
  actualDF <- actualDF[-numChar]
  colNamesOfFormula <- paste(colnames(actualDF), collapse = '` + `')
  
  finalFormula <-
    as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep =
                       ''))
  actualGLM <-
    glm(finalFormula, data = initialInfoDicotomized, family = binomial(logit))
  actualNagelkerke <- nagelkerke(actualGLM)
  
  results.glmWithoutActualChar[numChar] <- actualNagelkerke
  results.glmWithoutActualChar.negelker[numChar] <-
    actualNagelkerke$Pseudo.R.squared.for.model.vs.null[3]
  # comparison <- lrtest(finalGLM, actualGLM)
  # results.comparisonWithReference[numChar] <- comparison$LogLik[2];
  #anova(my.mod1, my.mod2, test="LRT")
}

#Opening file to export
png(paste('barPlotOfImportance', dependentCategory, format(Sys.time(), "%d-%m-%Y"), '.png', sep = '_'), width = 500, height = 1000)
par(mar=c(20,4,4,2))
barplot(
  referenceGLM$Pseudo.R.squared.for.model.vs.null[3] - results.glmWithoutActualChar.negelker,
  names.arg = colnames(bestCharacteristics),
  ylab = "Change in Nagelkerke R^2",
  col = terrain.colors(5),
  cex.names = 0.9,
  ylim = c(0, 0.2),
  las = 2
)
title(paste0("Relative importance for ", dependentCategory))
dev.off()

riskWithAgeLowerOf18Months <- initialInfoDicotomized[bestCharacteristics_Method2[2] == 1,dependentCategory]
featureWithLowAge <- bestCharacteristics_Method2[bestCharacteristics_Method2[2] == 1, c(1, 3, 4)]

glm.results <- glm(RiskCalculated ~ `VTN++ - eulerNumberPerFilledCell`, family = binomial(logit), data = cbind(riskWithAgeLowerOf18Months, featureWithLowAge))

summary(glm.results)


## ADDITIONAL STEPS The VN numerical continuous variables derived from the
#morphometric analysis that did not follow a normal distribution were related to
#the INRG prognostic categories using the non-parametric Mann-Whitney and
#Kruskal-Wallis tests

characteristicsWithoutClinicVTN <-
  characteristicsWithoutClinic[, grepl("VTN" , colnames(characteristicsWithoutClinic))]

#Only our new features
characteristicsWithoutClinicVTN <- characteristicsWithoutClinicVTN[, 1:32];

significantCharacteristics <- characteristicsWithoutClinicVTN[,pvaluesChars[1:32] < 0.05];
significantCharacteristics <- characteristicsWithoutClinic[, bestVTNMorphometricsFeatures]

colClasses <- rep("list", length(significantCharacteristics))

wilcoxResults <- read.table(text = "",
                            colClasses = colClasses,
                            col.names = colnames(significantCharacteristics));
numClinic <- 1
numChar <- 1

for (varClinic in colnames(characteristicsOnlyClinic)) {
  numChar <- 1
  for (significantChar in colnames(significantCharacteristics)){
    #wilcox.test(as.formula(paste0(varClinic, " ~ `",significantChar, "`")), data = initialInfo)
    testPerformed <- wilcox.test(as.numeric(unlist(characteristicsOnlyClinic[,varClinic])), as.numeric(unlist(initialInfoDicotomized[,significantChar])))
    #testPerformed <- kruskal.test(as.formula(paste0(varClinic, " ~ `",significantChar, "`")), data = initialInfoDicotomized)
    wilcoxResults[numClinic, numChar] <- testPerformed$p.value
    numChar <- numChar + 1
  }
  
  numClinic <- numClinic + 1
}
row.names(wilcoxResults) <- colnames(characteristicsOnlyClinic)



sink()
close(temporaryFileObj)
out<-capture.output(outputFileText, file = outputFile, split = T)


vlues <- na.omit(initialInfo[initialInfo$RiskCalculated == "HighRisk", 'VTN++ - stdPercentageOfFibrePerCell']);
mean(as.numeric(vlues$`VTN++ - stdPercentageOfFibrePerCell`))
sd(as.numeric(vlues$`VTN++ - stdPercentageOfFibrePerCell`))

