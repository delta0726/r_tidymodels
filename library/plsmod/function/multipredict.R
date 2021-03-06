# Title     : pls
# Objective : TODO
# Created by: Owner
# Created on: 2020/8/31
# URL       : https://plsmod.tidymodels.org/reference/pls.html



# ＜ポイント＞
# -



# ＜構文＞
# - S3 method for `_mixo_pls`
#   multi_predict(object, new_data, num_comp = NULL, type = NULL, ...)
#
# - S3 method for `_mixo_spls`
#   multi_predict(object, new_data, num_comp = NULL, type = NULL, ...)



# ＜引数＞
# - num_terms：各PLS負荷に影響を与えることが許可されている予測子の数。
# - num_comp ：保持するPLSコンポーネントの数。




# 1.準備 ---------------------------------------------------------------------

library(tidyverse)
library(plsmod)
library(modeldata)


# データ準備
data(meats, package = "modeldata")


# データ確認
meats %>% as_tibble()
meats %>% glimpse()




# 2.モデル構築 ---------------------------------------------------------------------



mv_meats <-
  pls(num_comp = 20, num_terms = 10) %>%
  set_engine("mixOmics") %>%
  set_mode("regression") %>%
  fit_xy(x = meats[-(1:5), 1:100], y = meats[-(1:5), 101:103])


mv_meats %>% print()
mv_meats %>% tidy()



pred_vals <- mv_meats %>% multi_predict(meats[1:5, 1:100], num_comp = 1:10)
# Predictions over components nested within sample rows
pred_vals#> # A tibble: 5 x 1
#>   .pred
#>   <list>
#> 1 <tibble [10 × 4]>
#> 2 <tibble [10 × 4]>
#> 3 <tibble [10 × 4]>
#> 4 <tibble [10 × 4]>
#> 5 <tibble [10 × 4]>
# For first sample:
pred_vals$.pred[[1]]#> # A tibble: 10 x 4
#>    num_comp .pred_water .pred_fat .pred_protein
#>  *    <int>       <dbl>     <dbl>         <dbl>
#>  1        1        65.6      15.2          18.1
#>  2        2        63.5      18.0          17.4
#>  3        3        63.9      17.6          17.4
#>  4        4        63.3      18.7          16.9
#>  5        5        62.8      19.1          16.7
#>  6        6        61.8      19.9          16.8
#>  7        7        63.7      18.4          17.2
#>  8        8        63.7      18.6          17.3
#>  9        9        63.4      18.8          17.2
#> 10       10        63.5      18.6          17.3



