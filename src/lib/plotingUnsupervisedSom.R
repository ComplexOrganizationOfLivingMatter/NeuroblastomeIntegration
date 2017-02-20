som.prep.df <- function(som.model, obs.classes, scaled) {
  require(reshape2)
  lev <- factor(obs.classes)
  df <- data.frame(cbind(unit=som.model$unit.classif, class=as.integer(lev)))
  # create table
  df2 <- data.frame(table(df))
  df2 <- dcast(df2, unit ~ class, value.var="Freq")
  df2$unit <- as.integer(df2$unit)
  # calc sum
  df2$sum <- rowSums(df2[,-1])
  # calc fraction borders of classes in each node
  tmp <- data.frame(cbind(X0=rep(0,nrow(df2)), 
                          t(apply(df2[,-1], 1, function(x) {
                            cumsum(x[1:(length(x)-1)]) / x[length(x)]
                          }))))
  df2 <- cbind(df2, tmp)
  df2 <- melt(df2, id.vars=which(!grepl("^\\d$", colnames(df2))))
  df2 <- df2[,-ncol(df2)]
  # define border for each classs in each node
  tmp <- t(apply(df2, 1, function(x) {
    c(x[paste0("X", as.character(as.integer(x["variable"])-1))], 
      x[paste0("X", as.character(x["variable"]))])
  }))
  tmp <- data.frame(tmp, stringsAsFactors=FALSE)
  tmp <- sapply(tmp, as.numeric)
  colnames(tmp) <- c("ymin", "ymax")
  df2 <- cbind(df2, tmp)
  # scale size of pie charts
  if (is.logical(scaled)) {
    if (scaled) {
      df2$xmax <- log2(df2$sum)
    } else {
      df2$xmax <- df2$sum
    }
  }
  df2 <- df2[,c("unit", "variable", "ymin", "ymax", "xmax")]
  colnames(df2) <- c("unit", "class", "ymin", "ymax", "xmax")
  # replace classes with original levels names
  df2$class <- levels(lev)[df2$class]
  return(df2)
}

som.draw <- function(som.model, obs.classes, scaled=FALSE) {
  # scaled - make or not a logarithmic scaling of the size of each node
  require(ggplot2)
  require(grid)
  g <- som.model$grid
  df <- som.prep.df(som.model, obs.classes, scaled)
  df <- cbind(g$pts, df[,-1])
  df$class <- factor(df$class)
  g <- ggplot(df, aes(fill=class, ymax=ymax, ymin=ymin, xmax=xmax, xmin=0)) +
    geom_rect() +
    coord_polar(theta="y") +
    facet_wrap(x~y, ncol=g$xdim, nrow=g$ydim) + 
    theme(axis.ticks = element_blank(), 
          axis.text.y = element_blank(),
          axis.text.x = element_blank(),
          panel.margin = unit(0, "cm"),
          strip.background = element_blank(),
          strip.text = element_blank(),
          plot.margin = unit(c(0,0,0,0), "cm"),
          panel.background = element_blank(),
          panel.grid = element_blank())
  return(g)
}
