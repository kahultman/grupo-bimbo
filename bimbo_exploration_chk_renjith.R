#install.packages("feather", type = 'source')
#install.packages("data.table")
#library(feather)
#install.packages("dplyr")
setwd("D:/r/wd/bimbo")
library(data.table)
library(dplyr)

train_dt <- fread("data/train.csv")
product_table <- fread("data/producto_tabla.csv")
str(train_dt)
typeof(train_dt)
train_dt[1:3,]
class(train_dt)
dim(train_dt)
colnames(train_dt) <- c("week","depot","channel","route","client","product",
                        "sales_units","sales","returns_units", "returns", "demand")
colnames(train_dt)

train_dt[, .(week, count = .N), by = week ]
train_dt[, .(count= .N), by = .(week) ]

# Exploring using dplyr
d1 <- tbl_df(train_dt)
d1
glimpse(train_dt)
glimpse(product_table)
d1 %>%
  summarise(total_records = n(),
            n_weeks = n_distinct(week))

d1 %>%
  group_by(week) %>%
  summarise(total_sales_units = sum(sales_units),
            max_returns = max(returns_units),
            total_return_units = sum(returns_units),
            unique_prdts = n_distinct(product)) %>%
  arrange(week)
train_dt[returns_units == 250000]
product_table[Producto_ID == 3509]
#create data table for weeks 3,4,5,6 and 7
train_wk34567 <- train_dt[week %in% c(3,4,5,6,7)]

#create data table for 8 and 9
train_wk89 <- train_dt[week %in% c(8,9)]





