#Exploratory Analysis - Carolyn Meier

library(dplyr)
library(data.table)

setwd("P:\\Personal\\Data Mining")

# Using fread function to speed things up with the train.csv file
train <- fread("train.csv", header = TRUE)
train <- tbl_df(train)
test <- fread("test.csv", header = TRUE)
test <- tbl_df(test)

# Using standard read.csv for smaller data sets
clients <- tbl_df(read.csv("cliente_tabla.csv"))
products <- tbl_df(read.csv("producto_tabla.csv"))
town_state <- tbl_df(read.csv("town_state.csv"))


colnames(train) <- c("week", "depot", "channel", "route", "client", "product", "sales_units", "sales", "returns_units", "returns", "demand")

colnames(test) <- c("id", "week", "depot", "channel", "route", "client", "product")

