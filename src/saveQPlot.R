saveQPlot <- function(infoFile, gplot, height = 1024, width = 1024, directory = '../Results/graphletsCount/NuevosCasos/Analysis/') {
  
  filename2 <- paste(directory, 'qplot', infoFile, sep = "")
  
  ggsave(paste(filename2, '.pdf', sep=""), gplot, width = width/100, height = height/100)
  
  png(paste(filename2, '.png', sep=""), width = width, height = height, res = 150)
  
  print(gplot) 
  
  dev.off()
}