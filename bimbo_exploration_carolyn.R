#Exploratory Analysis - Carolyn Meier

setwd("C:\\Users\\carolyn.meier\\Desktop\\Data")
path_in <- "C:\\Users\\carolyn.meier\\Desktop\\Data"

library(dplyr)
library(data.table)
library(ggplot2)

load("train2.Rda")
load("validate.Rda")

#-------------------------------------------------------------------------------
#Relationship Sales Units/Return Units/Sales/Returns/Demands

sales_units <-train2$sales_units
sales <-train2$sales
return_units <-train2$returns_units
returns <-train2$returns

#relationship between some key variables - Kind of what I expected
#0.727
cor(sales_units, sales)
#0.0534
cor(sales_units, return_units)
#0.056
cor(sales_units, returns)
#0.879
cor(return_units, returns)

#Are there certain products that generally don't/do have retunrs?
returns_sales_trends <- train2 %>% 
  group_by(product, week) %>%
  summarise(avg_sales_units = mean(sales_units), avg_sales = mean(sales), avg_returns_units = mean(return_units), avg_returns = mean(returns))

