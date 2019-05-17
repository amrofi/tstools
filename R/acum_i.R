#' Accumulated variation of an index in "n" periods relative to the "n" preview periods.
#'
#' acum_i() transforms variables in percentage in variables in accumulated percentage.
#' @param data A numeric vector.
#' @param n Number of periods to accumulate.
#' @return A numeric vector in accumulated percentage form.
#' @importFrom dplyr RcppRoll
#' @examples
#' \dontrun{
#' # Generate tbl with an numeric index variable
#'
#' library(tidyverse)
#' library(tstools)
#'
#' data <- tibble(Date = seq.Date(from = as.Date("2012-01-01"),
#'                                to = as.Date("2018-06-01"),
#'                                by = "month"),
#'
#'                Index = rep(100, 78) + cumsum(rnorm(mean = 0, sd = 1, n = 78)))
#'
#'
#' data_acum <- dplyr::mutate(data, Index_acum12 = acum_i(Index, 12))
#' }


  acum_i <- function(data, n){

    data_ma_n <- RcppRoll::roll_meanr(data, n)

    data_lag_n <- dplyr::lag(data_ma_n, n)

    data_acum_n = (((data_ma_n/data_lag_n)-1)*100)

    return(data_acum_n)

  }
