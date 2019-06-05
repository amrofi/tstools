# tstools
This repository is intended to gather my personal utilities designed for time series analysis. 
It is a development version, therefore it is important to always install the lastest release.

## Installing from github:

```r

devtools::install_github("leripio/tstools")

library(tstools)

```

## 1. add_lags 

This function relies on tidyverse to create lagged time series in a general way. More specifically, given a tibble (or data frame) and a list with variables names and disired lags, the function creates a tibble with the lagged variables.

### Usage

```r

library(tidyverse)
library(tstools)

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

## 2. add_leads (suggestion by Cláudio Shikida)

The same as add_lags but for leads

### Usage

```r

data_leaded <- add_leads(data, list("V1" = 1:3, "V2" = 2, "V3" = c(1,7)), suffix = "_l")

```

The output is a tibble with lags 1,2,3 from V1, 2 from V2 and 1,7 from V3. 

## 3. auto_dif

This function relies on forecast::ndiffs to automatically apply first difference to non-stationary series. Given a tibble with time series in columns, the function returns a tibble with the non-stationary data in first differences while stationary data are kept unchanged.

Note that only first differences are taken, even if series are integrated of order > 1. So it is advisable to look at "series_ndiffs" to assess the results from the unit root tests and, if necessary, run the function again until all the series are I(0).

### Usage

```r

library(tidyverse)
library(tstools)

mu <- list(-2, 0, 2, 4, 6)
sigma <- list(1, 2, 3, 4, 5)
series <- purrr::map2_dfc(mu, sigma, rnorm, n = 100) %>% dplyr::mutate_at(vars(V1,V3), funs(cumsum))

series_dif <- auto_dif(series)

```
## 4. acum_p

Given a numeric vector in percentage the function computes the accumulated percentage in n periods.

### Usage

```r

library(tidyverse)
library(tstools)

data <- tibble(Date = seq.Date(from = as.Date("2012-01-01"),
                               to = as.Date("2018-06-01"),
                               by = "month"),
               V1 = rnorm(mean = 0, sd = 1, n = 78),
               V2 = rnorm(mean = 1, sd = 2, n = 78),
               V3 = rnorm(mean = 5, sd = 1, n = 78))

data_acum <- dplyr::mutate(data, V1_acum12 = tstools::acum_p(V1, 12))

```

## 5. acum_i

Given a numeric vector in index form the function computes the accumulated percentage in n periods relative to the previous n periods.

### Usage

```r

library(tidyverse)
library(tstools)

data <- tibble(Date = seq.Date(from = as.Date("2012-01-01"),
                               to = as.Date("2018-06-01"),
                               by = "month"),

               Index = rep(100, 78) + cumsum(rnorm(mean = 0, sd = 1, n = 78)))



data_acum <- dplyr::mutate(data, Index_acum12 = tstools::acum_i(Index, 12))

```
