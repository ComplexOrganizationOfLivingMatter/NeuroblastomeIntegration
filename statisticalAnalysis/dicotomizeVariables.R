dicotomizeVariables <-
  function(initialInfo,
           initialIndex,
           columnStatus,
           healthyTag,
           cutoffMethod) {
    initialInfoDicotomized <- initialInfo
    columnsUsed <- initialIndex:(length(initialInfo[1, ]) - 8)
    
    if (cutoffMethod == 'Median') {
      initialInfoDicotomized[, columnsUsed] <-
        mapply(
          initialInfo[, columnsUsed],
          FUN = function(column)
            as.numeric(column < median(column))
        )
      
    } else if (cutoffMethod == '3rdQuartile') {
      initialInfoDicotomized[, columnsUsed] <-
        mapply(
          initialInfo[, columnsUsed],
          FUN = function(column)
            as.numeric(column < quantile(column, 0.75))
        )
      
    } else if (cutoffMethod == 'Quartiles') {
      #Note that this option gets 4 categories, instead of dichotomize
      initialInfoDicotomized[, columnsUsed] <-
        mapply(
          initialInfo[, columnsUsed],
          FUN = function(column)
            findInterval(column, c(-Inf,
                                   quantile(
                                     column, probs = c(0.25, .5, .75)
                                   ), Inf))
        )
    } else {
      ## Option using ROC curve
      
      library(OptimalCutpoints)
      cutoffValues = c()
      
      for (numColumn in columnsUsed) {
        #You have several methods to use instead of Youden
        youdenValue <-
          optimal.cutpoints(
            X = colnames(initialInfo[, numColumn]),
            status = columnStatus,
            tag.healthy = healthyTag,
            methods = cutoffMethod,
            data = as.data.frame(initialInfo)
          )
        cutoffValues[numColumn] <-
          youdenValue$MaxSpSe$Global$optimal.cutoff$cutoff
        
        #print(numColumn)
        #print(cutoffValues[numColumn])
        
        #Perform the cutoff
        initialInfoDicotomized[, numColumn] <-
          as.numeric(initialInfo[, numColumn] > cutoffValues[numColumn])
        
      }
    }
    
    return (initialInfoDicotomized)
  }