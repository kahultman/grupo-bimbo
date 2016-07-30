# a priori market basket analysis - what products are most similar?

library(dplyr)
library(arules)
setwd("/Volumes/Half_Dome/datasets/grupo-bimbo/")
load("train1.Rdata")
load("products.Rdata")


# Start with a small subset of the data


train_sub <- filter(train1, week >= 9)
train_sub$product <- as.character(train_sub$product)

train_sub

trans <- train_sub %>% 
  group_by(client, week) %>% 
  summarise(basket = list(product))

basket <- trans$basket

transactionfile <- file("transactions9.txt")
writeLines(unlist(lapply(basket, paste, collapse=" ")), con = transactionfile)
close(transactionfile)



basket <- read.transactions("transactions9.txt", format = "basket", sep = " ", rm.duplicates = TRUE)

summary(basket)
inspect(basket[1:5])

popular <- filter(products, product %in% c(1240, 1242, 2233, 1250, 1284))

s <- basket[,itemFrequency(basket)>0.05]
basket_jac <- dissimilarity(s, which = "transactions")
plot(hclust(basket_jac, method = "ward"))


# combine test and train

setwd("/Volumes/Half_Dome/datasets/grupo-bimbo/")
load("train1.Rdata")
load("test.Rdata")

colnames(test)
colnames(train1)

library(dplyr)

train1 <- mutate(train1, id = NA)
test <- mutate(test, demand = NA)
train1$sales_units <- NULL
train1$sales <- NULL
train1$returns <- NULL
train1$returns_units <- NULL

combined <- rbind(test, train1)
str(combined)

source("Add_Lag_keith.R")
