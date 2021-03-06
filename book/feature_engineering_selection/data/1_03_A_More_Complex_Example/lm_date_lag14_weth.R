library(caret)
library(sessioninfo)
library(doParallel)
cl <- makePSOCKcluster(parallel::detectCores() - 2)
registerDoParallel(cl)

# ------------------------------------------------------------------------------

# Load pre-made data
load("../../Data_Sets/Chicago_trains/chicago.RData")

# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------

pred_vars <- c(var_sets$dates, var_sets$lag14, var_sets$weather)

set.seed(4194)
lm_date_lag14_weth <- train(s_40380 ~ .,
                            data = training[, c("s_40380", pred_vars)],
                            method = "lm",
                            metric = "RMSE",
                            maximize = FALSE,
                            model = FALSE,
                            trControl = ctrl)

attr(lm_date_lag14_weth$finalModel$terms, ".Environment") <- emptyenv()

save(lm_date_lag14_weth, file = "lm_date_lag14_weth.RData")

# ------------------------------------------------------------------------------

session_info()

if(!interactive()) 
  q("no")