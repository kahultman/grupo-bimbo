# Feature engineering
source("Final/base_scripts.R")
setwd("/Volumes/Half_Dome/datasets/grupo-bimbo/")
load("products.Rdata")
load("train1.Rdata")
library(ggplot2)
library(dplyr)


# Divide training data by 4 using product numbers
train1$product <- as.integer(train1$product)
summary(train1$product)

# Add lag demand to training data. 

x <- train1 %>% filter(product < 88)
x <- x %>% select(-dummy, -ind)
y <- train1 %>% filter(product >=88 & product <336)
z <- train1 %>% filter(product >=336 & product <1265)
w <- train1 %>% filter(product>=1265)

y <- add_lag(y)
newtrain <- rbind(x,y)
rm(x)
rm(y)
rm(train1)

z <- add_lag(z)
newtrain <- rbind(newtrain, z)
w <- add_lag(w)
newtrain <- rbind(newtrain, w)

save(newtrain, file = "newtrain.Rdata")


############### Client Features

# find client order totals for each week and total demand per week

weeklyclientorders <- train1 %>% 
  group_by(client, week) %>% 
  summarise(orders = n(), weeklydemand = sum(demand))

plot(log(weeklyclientorders$orders), log(weeklyclientorders$weeklydemand))

# There seem to be two very different groupings of clients. 
weeklyclientorders <- mutate(weeklyclientorders, mega = (ifelse(weeklydemand>1000000, TRUE, FALSE)))
weeklyclientorders %>% filter(mega == FALSE) %>% ggplot(aes(orders, weeklydemand)) + geom_point()
# There is actually just one client that is large with 6 weeks of data


# Let's look at the large client 653378
load("clients.Rdata")

weeklyclientorders[weeklyclientorders$mega == TRUE,]

clients[clients$client == 653378,]


################# Product Features ################

library(stringr)
load("products.Rdata")
products

# Weight
products$weight <- str_match(products$product_name, " (\\d+)g ")[,2]
# Pieces
products$pieces <- str_match(products$product_name, " (\\d+)p")[,2] # matches both ##p and ##pct values
products$pieces[is.na(products$pieces)] <- 1

# Brands
products$brands <- str_match(products$product_name, " (\\w+) \\d+$")[,2]

# Product Names
products$fullproductnames <- products$product_name
products$product_name <- str_match(products$product_name, "^(\\D+) \\d+")[,2]
products$product_name <- tolower(products$product_name)

# Create some binary columns on product type
products$ispan <- grepl("pan", products$product_name, fixed = TRUE)
products$istortilla <- grepl("tortilla|tortillinas", products$product_name)
products$istostada <- grepl("tostada", products$product_name)
products$isbimbollos <- grepl("bimbollos", products$product_name)

products$category <- ifelse(grepl("pan", products$product_name), "pan",
                            ifelse(grepl("tortilla|tortillina", products$product_name), "tortilla",
                                   ifelse(grepl("tostada|tostado", products$product_name), "tostada",
                                          ifelse(grepl("bollo", products$product_name), "bollos", "other"))))


save(products, file = "productsnew.Rdata")

#View(select(products, product_name, category))
table(products$category)

############################# Combine to new train set

load("newtrain.Rdata")
newtrain

## Use log transformed values for demand
logtrain <- newtrain

logtrain$demand <- log1p(logtrain$demand)
logtrain$lag1 <- log1p(logtrain$lag1)
logtrain$lag2 <- log1p(logtrain$lag2)
logtrain$lag3 <- log1p(logtrain$lag3)

# get rid of variables that won't be in test set. 
logtrain$sales_units <- NULL
logtrain$sales <- NULL
logtrain$returns <- NULL
logtrain$returns_units <- NULL



logtrain <- left_join(logtrain, products, by = "product") %>% 
  select(-istortilla, -istostada, -isbimbollos, -fullproductnames, -ispan, -product_name, -earliest_week)
save(logtrain, file = "logtrain.Rdata")
