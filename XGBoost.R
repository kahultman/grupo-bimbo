#Run training data through add_lag function
train_validate <- add_lag(train)

#Split into train and validate datasets

train_val1 <- train_validate %>%
  filter(week<=7)

train_val2 <- train_validate %>%
  filter(week>7)

#------------------------------------------------------------------------------------
library(xgboost)

#xgboost_data <- model.matrix(~ lag_demand + product + week + returns, train_val1)
xgboost_data <- train_val1[c("lag_demand", "lag_demand2", "lag_demand3")] %>%
  as.matrix()

xgboost_labels <- train_val1$demand

gb_model <- xgboost(xgboost_data,label = xgboost_labels, max.depth = 6,
                    eta = 1, nthread = 2, nround = 20, objective = "reg:linear")


xgboost_data2 <- train_val2[c("lag_demand", "lag_demand2", "lag_demand3")] %>%
  as.matrix()

xgboost_labels2 <- train_val2$demand

gb_model_predictions_validate <- predict(gb_model, xgboost_data2)

# there might be negatives; change to 0
gb_model_predictions_validate[gb_model_predictions_validate < 0] <- 0


#--------------------------------------------------------------------------------
#RMSLE
sqerror <- (log(gb_model_predictions_validate + 1) - log(train_val2$demand + 1))^2
epsilon <- sqrt(sum(sqerror) / length(sqerror))
epsilon

#--------------------------------------------------------------------------------
#Visual (Commented out because the data are too large)
# plot(gb_model_predictions_validate, train_val2$demand)
# ggplot() + 
#   geom_jitter(aes(gb_model_predictions_validate, train_val2$demand), alpha = 0.25)