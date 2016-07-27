#Use this code as an import/prelim data cleaning on bimbo data

knitr::opts_chunk$set(echo = TRUE)

#setwd("C:\\Users\\carolyn.meier\\Desktop\\Data")
#path_in <- "C:\\Users\\carolyn.meier\\Desktop\\Data"

setwd("Q:\\DOL EBSA\\C5\\Data Mining")
path_in <- "Q:\\DOL EBSA\\C5\\Data Mining"

library(dplyr)
library(tidyr)
library(data.table)
library(stringr)

#-------------------------------------------------------------------------------
#Only have to run this part once
#DO NOT RUN AGAIN!
install.packages("dplyr")
install.packages("tidyr")
install.packages("data.table")
install.packages("feather")
install.packages("ggplot2")
install.packages("xgboost")


#Import Data
train <- read.csv(file.path(path_in, "train.csv"), header=TRUE)
train <- tbl_df(train)
test <- read.csv(file.path(path_in, "test.csv"), header=TRUE)
test <- tbl_df(test)
clients <- tbl_df(read.csv(file.path(path_in,"cliente_tabla.csv")))
products <- tbl_df(read.csv(file.path(path_in,"producto_tabla.csv")))
town_state <- tbl_df(read.csv(file.path(path_in,"town_state.csv")))

#Rename Column Names to English
colnames(train) <- c("week", "depot", "channel", "route", "client", "product", "sales_units", "sales", "returns_units", "returns", "demand")
colnames(test) <- c("id", "week", "depot", "channel", "route", "client", "product")
colnames(clients) <- c("client", "client_name")
colnames(products) <- c("product", "product_name")
colnames(town_state) <- c("depot", "town", "state")

#-------------------------------------------------------------------------------
#Updates to Products dataset

#Create brands variable in products dataset
brand_list <- function(x) {
  tokens <- strsplit(as.character(x), " ")[[1]]
  tokens[length(tokens) - 1]
}

brands <- data.frame(brandname=unlist(lapply(as.character(products$product_name), brand_list)))
products2 <- cbind(products, brands)
products2$product <- as.character(products2$product)

#-------------------------------------------------------------------------------
#Split training data up
train2 <- train %>% filter(week <= 7)

train2 %>% 
  group_by(week) %>%
  summarise(Number = n())


validate <- train %>% filter(week > 7)

validate %>% 
  group_by(week) %>%
  summarise(Number = n())

#-------------------------------------------------------------------------------
#set data types
train2
train2$depot <- as.factor(train2$depot)
train2$channel <- as.factor(train2$channel)
train2$client <- as.factor(train2$client)
train2$product <- as.factor(train2$product)
train2$route <- as.factor(train2$route)

#train1
train$depot <- as.factor(train$depot)
train$channel <- as.factor(train$channel)
train$client <- as.factor(train$client)
train$product <- as.factor(train$product)
train$route <- as.factor(train$route)

#validate
validate$depot <- as.factor(validate$depot)
validate$channel <- as.factor(validate$channel)
validate$client <- as.factor(validate$client)
validate$product <- as.factor(validate$product)
validate$route <- as.factor(validate$route)

#clients
clients$client <- as.factor(clients$client)

#products
products$product <- as.factor(products$product)

#town_state
town_state$depot <- as.factor(town_state$depot)

#test
test$depot <- as.factor(test$depot)
test$channel <- as.factor(test$channel)
test$client <- as.factor(test$client)
test$product <- as.factor(test$product)
test$route <- as.factor(test$route)

#-------------------------------------------------------------------------------
# Save originals as R dataframes
save(clients, file = "clients.Rda")
save(products, file = "products.Rda")
save(town_state, file = "town_state.Rda")
save(test, file = "test.Rda")
save(train, file = "train.Rda")
save(train2, file = "train2.Rda")
save(validate, file = "validate.Rda")
save(products2, file = "products2.Rda")

#-------------------------------------------------------------------------------
list.files()

load("test.Rda")
load("train.Rda")
load("town_state.Rda")
load("products.Rda")
load("clients.Rda")
load("train2.Rda")
load("validate.Rda")
load("products2.Rda")