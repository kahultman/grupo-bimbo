# Ensemble 
library(dplyr)
source("base_scripts.R")
setwd("/Volumes/Half_Dome/datasets/grupo-bimbo/")
clrm <- read.csv("submit_cond_mean_validate.csv")
xgb <- read.csv("gb_model_predictions_validate.csv")

clrm$clrmpred <- clrm$pred
clrm$pred <- NULL

# change xgb predictions to 'xgb'


combined <- clrm %>% left_join(xgb)

combined <- mutate(ens0 = 0.1*clrm + 0.9*xgb,
                   ens1 = 0.2*clrm + 0.8*xgb,
                   ens2 = 0.3*clrm + 0.7*xgb,
                   ens3 = 0.4*clrm + 0.6*xgb,
                   ens4 = 0.5*clrm + 0.5*xgb,
                   ens5 = 0.6*clrm + 0.4*xgb,
                   ens6 = 0.7*clrm + 0.3*xgb,
                   ens7 = 0.8*clrm + 0.2*xgb,
                   ens8 = 0.9*clrm + 0.1*xgb,
                   ens9 = 0.95*clrm + 0.05*xgb)

xresults <- c(.1, .2, .3, .4, .5, .6, .7, .8, .9, .95)
yresults <- c(RMSLE(combined$en0, combined$demand),
             RMSLE(combined$en1, combined$demand),
             RMSLE(combined$en2, combined$demand),
             RMSLE(combined$en3, combined$demand),
             RMSLE(combined$en4, combined$demand),
             RMSLE(combined$en5, combined$demand),
             RMSLE(combined$en6, combined$demand),
             RMSLE(combined$en7, combined$demand),
             RMSLE(combined$en8, combined$demand),
             RMSLE(combined$en9, combined$demand),

plot(xresults, yresults)