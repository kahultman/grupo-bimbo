multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

RMSLE <- function(prediction, actual){
  sqerror <- (log(prediction + 1) - log(actual + 1))^2
  epsilon <- sqrt(sum(sqerror) / length(sqerror))
  return(epsilon)
}


add_lag <- function(x){
  
  x <- x %>% 
    mutate(ind = 1) #Create indicator to identify original observations
  
  #Prep data to make Excplicit zeros with dummy variable to match later
  #Determine what's the earliest week for each product by client and depot
  groupings <- x %>%
    group_by(product, client, depot) %>%
    summarise(earliest_week=min(week),
              dummy=1)
  
  #Create list of weeks
  fulldates <- data.frame(week=sort(unique(x$week)), dummy=1)
  
  #combine combinations and dates using dummy variable (all possible combinatons including missing rows)
  groupings <- groupings %>%
    left_join(fulldates, by="dummy") %>%
    filter(week>=earliest_week) #Only keep weeks starting with earliest sales (assuming no sale before first sale)
  
  #Left join train data back on
  x <- groupings %>%
    left_join(x, by=c("product", "week", "client", "depot")) 
  
  #create lag demand
  x <- x %>% 
    group_by(product, client, depot) %>%
    arrange(week) %>% 
    mutate(lag1=lag(demand), lag2=lag(demand, n=2), lag3=lag(demand, n=3)) %>% 
    filter(ind == 1) %>% 
    select(-dummy, -ind)
  
  # N/As to 0
  x[is.na(x)] <- 0
  
  return(x)
}