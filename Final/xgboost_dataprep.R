#Create function to create all new variables
prepare_data <- function(x){
  
  x <- x %>% 
    mutate(ind = 1)
  
  #Add brand variable to sample data
  val_join <- left_join(x, products2, by="product") %>%
    mutate(returns_bin=ifelse(returns_units>0,1,0)) %>%
    mutate(demand_bin=ifelse(demand>0,1,0))
  
  #Prep data to make Excplicit zeros with dummy variable to match later
  #Determine what's the earliest week for each product by client and depot
  combinations2 <- val_join %>%
    group_by(product, client, depot) %>%
    summarise(earliest_week=min(week),
              dummy=1)
  #Create list of weeks
  dates2 <- val_join %>%
    group_by(week) %>%
    summarise(dummy=1)
  
  #combine combinations and dates using dummy variable (all possible combinatons including missing rows)
  combinations_dates2 <- combinations2 %>%
    left_join(dates2, by="dummy") %>%
    filter(week>=earliest_week) #CAN CHANGE DURING TESTING: only keep weeks starting with earliest sales (assuming no sale before first sale)
  
  #Left join sample train2 back on - switch N/A's to 0's
  combinations_full2 <- combinations_dates2 %>%
    left_join(x, by=c("product", "week", "client", "depot")) 
  
  combinations_full2$demand[is.na(combinations_full2$demand)] <- 0
  
  #create lag demand for modeling
  combinations_full_model2 <- combinations_full2 %>%
    group_by(product, client, depot) %>%
    mutate(lag_demand=lag(demand), lag_demand2=lag(demand, n=2), lag_demand3=lag(demand, n=3))
  
  #Create dataset for XGBoost with only variables we want to use in model
  #CAN ONLY DO THIS WITH NON-MISSING VALUES
  final_data2 <- combinations_full_model2 %>% 
    filter(ind == 1) %>%                      # keep only original observations
    select(demand, lag_demand, lag_demand2, lag_demand3, product, week, returns)
  
  #This needs to be decided how to handle N/A's
  final_data2[is.na(final_data2)] <- 0
  
  return(final_data2)
}

# Add features
# 
# Weight
# pieces
# Weight/piece
# Brand
# 