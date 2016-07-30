#Create function to create all new variables
add_lag <- function(x){
  
  x <- x %>% 
    mutate(ind = 1) #Create indicator to identify original observations

  #Prep data to make Excplicit zeros with dummy variable to match later
  #Determine what's the earliest week for each product by client and depot
  combinations2 <- x %>%
    group_by(product, client, depot) %>%
    summarise(earliest_week=min(week),
              dummy=1)
  #Create list of weeks
  dates2 <- x %>%
    group_by(week) %>%
    summarise(dummy=1)
  
  #combine combinations and dates using dummy variable (all possible combinatons including missing rows)
  combinations_dates2 <- combinations2 %>%
    left_join(dates2, by="dummy") %>%
    filter(week>=earliest_week) #Only keep weeks starting with earliest sales (assuming no sale before first sale)
  
  #Left join train data back on
  combinations_full2 <- combinations_dates2 %>%
    left_join(x, by=c("product", "week", "client", "depot")) 
  
  #Switch N/A's to 0's
  combinations_full2$demand[is.na(combinations_full2$demand)] <- 0
  
  #create lag demand for modeling
  combinations_full_model2 <- combinations_full2 %>%
    arrange(product, client, depot, week) %>%
    group_by(product, client, depot) %>%
    mutate(lag_demand=lag(demand), lag_demand2=lag(demand, n=2), lag_demand3=lag(demand, n=3))
  
  #Create dataset for XGBoost with only variables we want to use in model
  #CAN ONLY DO THIS WITH NON-MISSING VALUES
  final_data2 <- combinations_full_model2 %>% 
    filter(ind == 1) %>%                      # keep only original observations
    select(demand, lag_demand, lag_demand2, lag_demand3, product, week, ind)
  
  #This needs to be decided how to handle N/A's
  final_data2[is.na(final_data2)] <- 0
  
  return(final_data3)
}
