univariateAnalysis <-
  function(initialInfoDicotomized,
           initialIndex,
           dependentCategory,
           characteristicsWithoutClinicVTN, 
           pValueThreshold) {
    require(rms)
    
    #http://rstudio-pubs-static.s3.amazonaws.com/2989_ceae90d128554c728d5388439adf0661.html
    
    univariateAnalysisPvalues <-
      lapply(colnames(characteristicsWithoutClinicVTN),
             
             function(var) {
               formula    <-
                 as.formula(paste(dependentCategory, " ~ `", var, '`', sep = ''))
               res.logist <-
                 glm(formula, data = initialInfoDicotomized, family = binomial(logit))
               anovaRes <-
                 anova(res.logist, test =
                         'Chisq')
               anovaRes$`Pr(>Chi)`[2]
             })
    
    univariateAnalysisPvalues[is.na(univariateAnalysisPvalues)] = 1
    
    
    significantCharacteristics <-
      characteristicsWithoutClinicVTN[, univariateAnalysisPvalues < pValueThreshold]
    
    return(univariateAnalysisPvalues)
    
  }