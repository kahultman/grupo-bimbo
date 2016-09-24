# a priori market basket analysis - what products are most similar?

library(dplyr)
library(arules)
setwd("/Volumes/Half_Dome/datasets/grupo-bimbo/")
load("train1.Rdata")
load("products.Rdata")
load("clients.Rdata")
load("products.Rdata")


# Start with a small subset of the data
set.seed(35)
clientsample <- sample_n(clients, 10000)
  


train_sub <- filter(train1, week >= 9, client %in% clientsample$client)
train_sub$product <- as.character(train_sub$product)



trans <- train_sub %>% 
  group_by(client, week) %>% 
  summarise(basket = list(product))

basket <- trans$basket

transactionfile <- file("transactions9s.txt")
writeLines(unlist(lapply(basket, paste, collapse=" ")), con = transactionfile)
close(transactionfile)

basket <- read.transactions("transactions9s.txt", format = "basket", sep = " ", rm.duplicates = TRUE)

summary(basket)
inspect(basket[1:5])

s <- basket[,itemFrequency(basket)>0.05]
basket_jac <- dissimilarity(s, which = "transactions")
plot(hclust(basket_jac, method = "ward.D"))
clusters <- hclust(basket_jac, method = "ward.D")
clustercut <- cutree(clusters, 5)
plot(clustercut)


itemFrequencyPlot(basket, support = 0.1, horiz = TRUE)
?itemFrequencyPlot
itemFrequency(basket)

image(sample(basket, 1000))

basketrule <- apriori(basket, parameter = list(support = 0.1, confidence = 0.8, minlen = 2))

basketrule
summary(basketrule)
inspect(basketrule)


products[products$product %in% c(1109,1150,2233,1146),]
products[products$product %in% c(3631, 1109),]
