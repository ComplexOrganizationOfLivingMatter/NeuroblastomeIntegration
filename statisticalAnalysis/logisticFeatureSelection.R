logisticFeatureSelection <-
  function(significantAndClinicChars,
           initialInfoDicotomized,
           dependentCategory,
           usedMethod) {
    
    if (usedMethod == "method1") {
      require(leaps)
      require(mvoutlier)
      library(bestglm)
      library(mplot)
      lbw.for.best.logistic <-
        cbind(significantAndClinicChars, initialInfoDicotomized[1:nrow(initialInfoDicotomized), dependentCategory])
      res.best.logistic <-
        bestglm(
          Xy = lbw.for.best.logistic,
          family = binomial,
          # binomial family for logistic
          IC = "AIC",
          # Information criteria for
          TopModels = 10,
          method = "exhaustive"
        )
      
      res.best.logistic$BestModels
      res.best.logistic$Subsets
      summary.bestglm <- res.best.logistic$BestModels
      
      
      
      anovaRes <- anova(res.best.logistic$BestModel, test = 'Chisq')
      anovaRes$`Pr(>Chi)`[2]
      
      
      
      return (res.best.logistic);
      
    } else if (usedMethod == "method2") {
      
      
      xnam <- paste0("x", 1:length(significantAndClinicChars))
      
      colnames(significantAndClinicChars) <- xnam
      newFormulaWithoutNames <-
       paste(dependentCategory, "~", paste(xnam, collapse = "+"))
      
      completeData <- cbind(
        significantAndClinicChars,
        initialInfoDicotomized[1:nrow(initialInfoDicotomized), dependentCategory]
      )
      
      # Weird variables were not allowed, so we need to transform them into variables without spaces.
      # We decided to transform them into x and the number of column (x1, x2, ...)
      glmulti.logistic.out <-
        glmulti(
          y = dependentCategory,
          xr = colnames(significantAndClinicChars),
          data = as.data.frame(completeData),
          level = 1,
          # No interaction considered
          method = "h",
          # Exhaustive approach
          crit = "aic",
          # AIC as criteria
          confsetsize = 5,
          # Keep 5 best models
          plotty = F,
          report = F,
          # No plot or interim reports
          fitfunction = "glm",
          # glm function
          family = binomial
        )
      
      #Best model
      summary(glmulti.logistic.out@objects[[1]])
      #5 best models
      glmulti.logistic.out@formulas

      #http://www.metafor-project.org/doku.php/tips:model_selection_with_glmulti
      plot(glmulti.logistic.out, type="s")
      
      
      
      return (glmulti.logistic.out);
    } else if (usedMethod == "method3"){
      
    }
  }