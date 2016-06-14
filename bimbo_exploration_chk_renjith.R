#install.packages("feather", type = 'source')
#install.packages("data.table")
#library(feather)
setwd("D:/r/wd/bimbo")
library(data.table)
train_dt <- fread("data/train.csv")
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

