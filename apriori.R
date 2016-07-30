# a priori market basket analysis - what products are most similar?

library(dplyr)
library(arules)
setwd("/Volumes/Half_Dome/datasets/grupo-bimbo/")
load("train1.Rdata")
load("products.Rdata")
load("clients.Rdata")


head(clients)
head(train1)


# Start with a small subset of the data

train1$client <- as.numeric(train1$client)
train_sub <- filter(train1, client >= 326305 )
train_sub$client <- as.factor(train_sub$client)
train_sub$product <- as.character(train_sub$product)

train_sub

trans <- train_sub %>% 
  group_by(client, week) %>% 
  summarise(basket = list(product))

basket <- trans$basket

transactionfile <- file("transactions.txt")
writeLines(unlist(lapply(basket, paste, collapse=" ")), con = transactionfile)
close(transactionfile)

#write(trans, file = "transactions.txt", sep = ",")

basket <- read.transactions("transactions.txt", format = "basket", sep = " ", rm.duplicates = TRUE)

summary(basket)
inspect(basket[1:5])

popular <- filter(products, product %in% c(1278, 1240, 1242, 1284, 1250, 384, 345, 329, 302, 300, 9640))

# do full dataset

trans2 <- train1 %>% 
  group_by(client, week) %>% 
  summarise(basket = list(product))

transactionfile <- file("transactions2.txt")
writeLines(unlist(lapply(trans2$basket, paste, collapse=" ")), con = transactionfile)
close(transactionfile)

basket2 <- read.transactions("transactions2.txt", format = "basket", sep = " ", rm.duplicates = TRUE)

