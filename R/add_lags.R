#' Create tibble with lagged variables
#'
#' add_lags() creates a tibble with lagged variables
#' @param data A tbl with variables in columns.
#' @param vars_lags A list with variables names and number of lags.
#' @return A tbl with lagged variables.
#' @importFrom dplyr, purrr, plyr
#' @examples
#' # Generate tbl with three variables.
#'
#' data <- tibble(Date = seq.Date(from = as.Date("2012-01-01"),
#'                                to = as.Date("2018-06-01"),
#'                                by = "month"),
#'
#'                V1 = rnorm(mean = 0, sd = 1, n = 78),
#'                V2 = rnorm(mean = 1, sd = 2, n = 78),
#'                V3 = rnorm(mean = 5, sd = 1, n = 78))
#'
#' # Create lags 1,2,3 for V1; 2 for V2; and 1,7 for V3.
#'
#' library(tidyverse)
#' library(tstools)
#'
#' data_lagged <- add_lags(data, list("V1" = 1:3, "V2" = 2, "V3" = c(1,7)))


## Criar função para aplicar as operações sobre o tbl

add_lags <- function(data, vars_lags, suffix = "_l"){

   `:=` <- NULL

  ## Função auxiliar para criar lag

  mutate_lag <- function(data, x, k, suf = suffix) {

    x <- dplyr::quo(!! dplyr::sym(x))

    x_name <- paste0(dplyr::quo_name(x), suf, k)

    dplyr::mutate(data,
                  !! x_name := dplyr::lag(!! x, k)
    )
  }

  vars_aux <- names(vars_lags) %>% as.list()

  lags_aux <- purrr::map(.x = vars_lags, .f = length)

  vars_exp <- purrr::map2(.x = vars_aux, .y = lags_aux, .f = rep) %>% purrr::flatten()

  lags_exp <- vars_lags %>% purrr::flatten()

  purrr::map2(.x = vars_exp, .y = lags_exp, .f = mutate_lag, data = data) %>%

    purrr::reduce(dplyr::left_join, by = colnames(data))

}
