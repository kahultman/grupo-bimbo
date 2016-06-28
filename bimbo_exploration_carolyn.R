#Exploratory Analysis - Carolyn Meier

setwd("C:\\Users\\carolyn.meier\\Desktop\\Data")
path_in <- "C:\\Users\\carolyn.meier\\Desktop\\Data"

setwd("Q:\\DOL EBSA\\C5\\Data Mining")
path_in <- "Q:\\DOL EBSA\\C5\\Data Mining"

library(dplyr)
library(data.table)
library(ggplot2)
#library(plyr)

load("train2.Rda")
load("validate.Rda")

#-------------------------------------------------------------------------------
#Relationship Sales Units/Return Units/Sales/Returns/Demands

sales_units <-train2$sales_units
sales <-train2$sales
return_units <-train2$returns_units
returns <-train2$returns

#relationship between some key variables - Kind of what we expected
#0.727
cor(sales_units, sales)
#0.053
cor(sales_units, return_units)
#0.056
cor(sales_units, returns)
#0.879
cor(return_units, returns)

#3% of records have returns
mean(train2$returns_units>0)

#If there's a return, we know the true demand for that client/week
returns_trends <- train2 %>%
  group_by(product, client) %>%
  summarise(count_overall=n(),
            count_pos_returns=sum(returns_units>0)) %>%
  ungroup %>%
  mutate(pcnt_returns=count_pos_returns/count_overall) %>%
  arrange(desc(pcnt_returns), desc(count_overall))

#Rerun at just product level - focus on products with HIGH counts
returns_trends_pro <- train2 %>%
  group_by(product) %>%
  summarise(count_overall=n(),
            count_pos_returns=sum(returns_units>0)) %>%
  ungroup %>%
  mutate(pcnt_returns=count_pos_returns/count_overall) %>%
  arrange(desc(pcnt_returns), desc(count_overall))

#Are there any specific products that show up a lot in the top?
count_pro <- returns_trends %>%
  filter(pcnt_returns > .9) %>%
  group_by(product) %>%
  tally() %>%
  arrange(desc(n))

#Pick one product (35651) and focus on their demand
trends_35651 <- returns_trends %>%
  filter(product=="35651") 
#Merge on full data
trends_35651 <- left_join(trends_35651, train2, by = c("product", "client"))
#Is there consistency for demand by week?
trends_35651_week <- trends_35651 %>%
  group_by(week) %>%
  summarise(count_overall=n(),
            m_demand <- mean(demand),
            med_demand <- median(demand),
            sd_deman <- sd(demand),
            min_demand <- min(demand),
            max_demand <- max(demand))

#Is there consistency for demand by client?
trends_35651_client <- trends_35651 %>%
  group_by(client) %>%
  summarise(count_overall=n(),
            m_demand <- mean(demand),
            med_demand <- median(demand),
            sd_deman <- sd(demand),
            min_demand <- min(demand),
            max_demand <- max(demand))

#Are there patterns to products over time? - Look at products with highest counts
time_trend_pro <- returns_trends_pro %>%
  filter(count_overall > 10000 & pcnt_returns > .8) %>%
  left_join(train2, by=c("product"="product"))

#Doesn't show too much significance
ggplot(time_trend_pro, aes(week, returns_units, group=client)) +
  geom_line(alpha=.5) +
  coord_cartesian(ylim=c(0, 50))








#Are there certain products that generally don't/do have retunrs?
returns_trends <- train2 %>% 
  group_by(product, week) %>%
  summarise(avg_sales_units = mean(sales_units), avg_sales = mean(sales), avg_returns_units = mean(returns_units), avg_returns = mean(returns))


#Sort data by product & week
returns_trends <- returns_trends %>%
  arrange(product, week)

#Create some flags
#No Sale Flag
returns_trends <- returns_trends %>%
  mutate(no_sale = ifelse(avg_sales_units==0, 1, 0))

#Flag where return is zero, but demand was potentially higher than supply
returns_trends <- returns_trends %>%
  mutate(potential_more_demand = ifelse(avg_returns_units==0 & avg_sales_units!=0, 1, 0))

count(returns_trends$no_sale)
count(returns_trends$potential_more_demand)

#Roll this up to the product level - are there any with no sales or potential high demand?
returns_trends_prod <- returns_trends %>%
  group_by(product)%>%
  summarise(no_sale_pro=sum(no_sale), pot_more_dem_pro=sum(potential_more_demand), n())

returns_trends_prod <- returns_trends_prod %>%
  mutate(no_prod_sale = ifelse(no_sale_pro==0, 1,0)) %>%
  mutate(potential_more_demand = ifelse())