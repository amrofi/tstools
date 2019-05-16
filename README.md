# tstools
This repository is intended to gather my personal utilities designed for time series analysis. Maybe in the near future I will put them together into a single package.

## 1. add_lags 

This function relies on tidyverse to create lagged time series in a general way. More specifically, given a tibble (or data frame) and a list with variables names and disired lags, the function creates a tibble with the lagged variables.

For example: 

```r
data <- tibble(Date = seq.Date(from = as.Date("2012-01-01"),
                               to = as.Date("2018-06-01"), 
                               by = "month"),
               V1 = rnorm(mean = 0, sd = 1, n = 78),
               V2 = rnorm(mean = 1, sd = 2, n = 78),
               V3 = rnorm(mean = 5, sd = 1, n = 78))

```

### Create lags 1,2,3 for V1; 2 for V2; and 1,7 for V3.

```r
data_lagged <- add_lags(data, list("V1" = 1:3, "V2" = 2, "V3" = c(1,7)), suffix = "_l")
```

The output is a tibble with lags 1,2,3 from V1, 2 from V2 and 1,7 from V3. 

## 2. auto_dif

This function relies on forecast::ndiffs to automatically apply first difference to non-stationary series. Given a tibble with time series in columns, the function returns a tibble with the non-stationary data in first differences while stationary data are kept unchanged.

### Usage

```r

library(tidyverse)

mu <- list(-2, 0, 2, 4, 6)
sigma <- list(1, 2, 3, 4, 5)
series <- purrr::map2_dfc(mu, sigma, rnorm, n = 100) %>% dplyr::mutate_at(vars(V1,V3), funs(cumsum))

series_dif <- auto_dif(series)

```
