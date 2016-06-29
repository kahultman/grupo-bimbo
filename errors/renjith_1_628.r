> library(data.table)
> library(dplyr)
> setwd("d:/r/wd/bimbo")
> train <-  fread("D:/MDS/project/git/grupo-bimbo/Renjith/tdata", header = TRUE)
Error in fread("D:/MDS/project/git/grupo-bimbo/Renjith/tdata", header = TRUE) : 
  Unable to open file after 5 attempts (error 5): D:/MDS/project/git/grupo-bimbo/Renjith/tdata
> train <-  fread("D:/MDS/project/git/grupo-bimbo/Renjith/tdata/ttrain.csv", header = TRUE)
> test <-  fread("D:/MDS/project/git/grupo-bimbo/Renjith/tdata/ttest.csv", header = TRUE)
> head(train)
   week depot channel route client product sales_units sales returns_units returns demand
1:    3   100    1000   123    500     900           5    25             1       5      4
2:    3   100    1000   123    500     901           6    30             0       0      6
3:    4   100    1000   123    500     900           4    25             2       5      2
4:    5   100    1000   123    500     900           3    25             1       5      2
5:    6   100    1000   123    500     900           2    25             0       5      2
6:    7   100    1000   123    500     900           4    25             0       5      4
> sapply(train,class)
         week         depot       channel         route        client       product   sales_units         sales returns_units       returns 
    "integer"     "integer"     "integer"     "integer"     "integer"     "integer"     "integer"     "integer"     "integer"     "integer" 
       demand 
    "integer" 
> median <- train[, median(demand)]
> median
[1] 3
> test
   week depot channel route client product
1:    8   100    1000   123    500     900
2:    9   100    1000   123    500     901
> test <-  fread("D:/MDS/project/git/grupo-bimbo/Renjith/tdata/ttest.csv", header = TRUE)
> test
   week depot channel route client product
1:    8   100    1000   123    500     900
2:    8   100    1000   123    500     901
3:    9   100    1000   123    500     900
4:    9   100    1000   123    500     901
> setwd("d:/r/wd/bimbo")
> library(data.table)
> library(dplyr)
> setwd("d:/r/wd/bimbo")
> train <- fread("data/source/train.csv", header = TRUE)
Read 74180464 rows and 11 (of 11) columns from 2.980 GB file in 00:03:10
> colnames(train) <- c("week", "depot", "channel", "route", "client", "product", "sales_units", "sales", "returns_units", "returns", "demand")
> head(train)
   week depot channel route client product sales_units sales returns_units returns demand
1:    3  1110       7  3301  15766    1212           3 25.14             0       0      3
2:    3  1110       7  3301  15766    1216           4 33.52             0       0      4
3:    3  1110       7  3301  15766    1238           4 39.32             0       0      4
4:    3  1110       7  3301  15766    1240           4 33.52             0       0      4
5:    3  1110       7  3301  15766    1242           3 22.92             0       0      3
6:    3  1110       7  3301  15766    1250           5 38.20             0       0      5
> sapply(train,class)
         week         depot       channel         route        client       product   sales_units         sales returns_units       returns 
    "integer"     "integer"     "integer"     "integer"     "integer"     "integer"     "integer"     "numeric"     "integer"     "numeric" 
       demand 
    "integer" 
> train$client <- as.numeric(train$client)
> train$product <- as.numeric(train$product)
> train$demand <- as.numeric(train$demand)
> median <- train[, median(demand)]
> median
[1] 3
> median_Prod <- train[, median(demand), by = product]
> setnames(median_Prod,"V1","M2")
> median_Client_Prod <- train[, median(demand),by = .(product, client)]
> head(median_Client_Prod)
   product client  V1
1:    1212  15766 4.0
2:    1216  15766 2.5
3:    1238  15766 2.0
4:    1240  15766 4.0
5:    1242  15766 2.0
6:    1250  15766 8.0
> setnames(median_Client_Prod,"V1","M3")
> head(median_Client_Prod)
   product client  M3
1:    1212  15766 4.0
2:    1216  15766 2.5
3:    1238  15766 2.0
4:    1240  15766 4.0
5:    1242  15766 2.0
6:    1250  15766 8.0
> median_Client_Prod_Depot <- train[, median(demand),by = .(product, client, depot)]
> setnames(median_Client_Prod_Depot,"V1","M4")
> test <- fread("data/source/test.csv", header = TRUE)
Read 6999251 rows and 7 (of 7) columns from 0.234 GB file in 00:00:06
> colnames(test) <- c("id", "week", "depot", "channel", "route", "client", "product")
> test$client <- as.numeric(test$client)
> test$product <- as.numeric(test$product)
> submit <- left_join(test, median_Client_Prod_Depot, by = c("client", "depot", "product"))
> head(submit)
  client depot product      id week channel route M4
1     26  2061   34206 1547831   11       2  7212 89
2     26  2061   34210 6667200   10       2  7212 39
3     26  2061   34785 1592616   10       2  7212 21
4     26  2061   34785 6825659   11       2  7212 21
5     26  2061   34786 3909690   10       2  7212 74
6     26  2061   35142 3659672   10       2  7212 35
> submit$M3 <- left_join(test, median_Client_Prod , by = c("client", "product"))$M3
> head(submit)
  client depot product      id week channel route M4 M3
1     26  2061   34206 1547831   11       2  7212 89 10
2     26  2061   34210 6667200   10       2  7212 39 NA
3     26  2061   34785 1592616   10       2  7212 21 89
4     26  2061   34785 6825659   11       2  7212 21 39
5     26  2061   34786 3909690   10       2  7212 74 21
6     26  2061   35142 3659672   10       2  7212 35 21
> median_Client_Prod[median_Client_Prod$product = 34210 ]
Error: unexpected '=' in "median_Client_Prod[median_Client_Prod$product ="
> median_Client_Prod[median_Client_Prod$product == 34210 ]
      product  client    M3
   1:   34210   22703 288.0
   2:   34210   22535  79.0
   3:   34210   16052  23.0
   4:   34210   22550  39.0
   5:   34210   20892  83.0
  ---                      
2218:   34210  152086   6.5
2219:   34210  152099   5.0
2220:   34210 4680108 154.0
2221:   34210 2323279   0.0
2222:   34210 4730496 240.0
> median_Client_Prod[median_Client_Prod$product == 34210 & median_Client_Prod$client == 26  ]
   product client M3
1:   34210     26 39
> sapply(test, class)
       id      week     depot   channel     route    client   product 
"integer" "integer" "integer" "integer" "integer" "numeric" "numeric" 
> rm(submit)