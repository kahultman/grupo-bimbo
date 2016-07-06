
setwd("Q:\\DOL EBSA\\C5\\Data Mining")
path_in <- "Q:\\DOL EBSA\\C5\\Data Mining"

library(dplyr)
library(data.table)
library(ggplot2)

load("train2.Rda")
load("validate.Rda")
load("products.Rda")

#Subset training2 data to 1,000 (presorted)
train2_samp <- train2 %>% 
  arrange(product, week, client, depot) %>%
  slice(1:100000)

#Prep data to make Excplicit zeros with dummy variable to match later
#Determine what's the earliest week for each product by client and depot
combinations <- train2_samp %>%
  group_by(product, client, depot) %>%
  summarise(earliest_week=min(week),
            dummy=1)
#Create list of weeks
dates <- train2_samp %>%
  group_by(week) %>%
  summarise(dummy=1)

#combine combinations and dates using dummy variable (all possible combinatons including missing rows)
combinations_dates <- combinations %>%
  left_join(dates, by="dummy") %>%
  filter(week>=earliest_week) #CAN CHANGE DURING TESTING: only keep weeks starting with earliest sales (assuming no sale before first sale)

#Left join sample train2 back on - switch N/A's to 0's
combinations_full <- combinations_dates %>%
  left_join(train2_samp, by=c("product", "week", "client", "depot")) 

combinations_full$demand[is.na(combinations_full$demand)] <- 0

#create lag demand for modeling
combinations_full_model <- combinations_full %>%
  group_by(product, client, depot) %>%
  mutate(lag_demand=lag(demand))

#Create basic linear model first (can test different variables out - trial and error)
lm_model <- lm(demand ~ lag_demand + product + week + returns, data=combinations_full_model)
summary(lm_model)
lm_model_predictions <- predict(lm_model, newdata=combinations_full_model)


#XGBoost (Gradient Boosting Tree Induction) Model
install.packages("xgboost")
library(xgboost)

#Create dataset for XGBoost with only variables we want to use in model
#CAN ONLY DO THIS WITH NON-MISSING VALUES
combinations_full_model2 <- combinations_full_model %>%
  select(demand, lag_demand, product, week, returns) %>%
  na.omit(.)

xgboost_data <- model.matrix(~ lag_demand + product + week + returns, combinations_full_model2)
dim(xgboost_data)
gb_model <- xgboost(xgboost_data,label = combinations_full_model2$demand, max.depth = 2,
                    eta = 1, nthread = 2, nround = 2, objective = "reg:linear")
summary(gb_model)

#Can use model with predict function like in lm_model. Just need to make a matrix with training data
gb_model_predictions <- predict(gb_model, matrix)