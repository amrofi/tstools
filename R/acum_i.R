#' Accumulated variation of an index in "n" periods relative to the "n" preview periods.
#'
#' acum_i() transforms variables in percentage in variables in accumulated percentage.
#' @param data A tbl with variables in columns.
#' @param n Number of periods to accumulate.
#' @param exclude Vector of variables to left aside.
#' @return A tbl with variables in accumulated percentage form.
#' @importFrom dplyr RcppRoll
#' @examples
#' \dontrun{
#' # Generate tbl with three variables.
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
#' data_acum <- acum_i(data, 12, "Date")
#' }


acum_i <- function(data, n, exclude = NULL){

  `.` <- NULL

  acum_aux <- function(x, n){

    data_ma_n <- RcppRoll::roll_meanr(x, n)

    data_lag_n <- dplyr::lag(data_ma_n, n)

    data_acum_n = (((data_ma_n/data_lag_n)-1)*100)

    return(data_acum_n)

  }

  data_acum_i <- data %>%

  {if (is.null(exclude)) dplyr::mutate_all(., dplyr::funs(acum_aux), n) else dplyr::mutate_at(., dplyr::vars(-exclude), dplyr::funs(acum_aux), n)}

  return(data_acum_i)

}
