# Ensemble 
library(dplyr)
source("base_scripts.R")
setwd("/Volumes/Half_Dome/datasets/grupo-bimbo/")
clrm <- read.csv("submit_cond_mean_validate.csv")
xgb <- read.csv("gb_model_predictions_validate.csv")

head(xgb)


# change clrm predictions to 'clrmpred'
clrm$clrmpred <- clrm$pred
clrm$pred <- NULL

# change xgb predictions column to 'xgbpred'
xgb$xgbpred <- xgb$prediction #change to whatever is needed

combined <- clrm %>% left_join(xgb) # not sure if I need to add by = until I see the xbg file

combined <- mutate(ens0 = 0.1*clrm$pred + 0.9*xbg$pred,
                   ens1 = 0.2*clrm$pred + 0.8*xbg$pred,
                   ens2 = 0.3*clrm$pred + 0.7*xbg$pred,
                   ens3 = 0.4*clrm$pred + 0.6*xbg$pred,
                   ens4 = 0.5*clrm$pred + 0.5*xbg$pred,
                   ens5 = 0.6*clrm$pred + 0.4*xbg$pred,
                   ens6 = 0.7*clrm$pred + 0.3*xbg$pred,
                   ens7 = 0.8*clrm$pred + 0.2*xbg$pred,
                   ens8 = 0.9*clrm$pred + 0.1*xbg$pred,
                   ens9 = 0.95*clrm$pred + 0.05*xbg$pred)

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
             RMSLE(combined$en9, combined$demand))

plot(xresults, yresults)