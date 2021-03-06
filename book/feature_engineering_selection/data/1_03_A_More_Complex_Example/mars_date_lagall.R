library(caret)
library(sessioninfo)
library(earth)
library(doParallel)
cl <- makePSOCKcluster(parallel::detectCores() - 2)
registerDoParallel(cl)

# ------------------------------------------------------------------------------

# Load pre-made data
load("../../Data_Sets/Chicago_trains/chicago.RData")

# ------------------------------------------------------------------------------

pred_vars <- c(var_sets$dates, var_sets$lag14, var_sets$other_lag)
  
set.seed(4194)
mars_date_lagall <- train(s_40380 ~ .,
                          data = training[, c("s_40380", pred_vars)],
                          method = "earth",
                          tuneLength = 20,
                          metric = "RMSE",
                          maximize = FALSE,
                          trControl = ctrl)

mars_date_lagall$finalModel$call <- NULL
mars_date_lagall$finalModel$x <- NULL

save(mars_date_lagall, file = "mars_date_lagall.RData")

# ------------------------------------------------------------------------------

session_info()

if(!interactive()) 
  q("no")