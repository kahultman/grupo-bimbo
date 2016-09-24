# Trying glm now

setwd("/Volumes/Half_Dome/datasets/grupo-bimbo/")
load("logtrain.Rdata")



library(caret)


ctrl <- trainControl(method = "cv", number = 6, selectionFunction = "RMSLE")

in_train <- createDataPartition(logtrain$demand, p=0.75, list = FALSE)

tglm <- train(demand ~ product + client + depot + lag1 + lag2 + lag3, 
             data = logtrain,
             method = "glm", 
             metric = "RMSLE", 
             trControl = ctrl, 
             subset = in_train, 
             verbose = FALSE)

logtrain
