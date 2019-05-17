#' Accumulated percentage in 'n' periods.
#'
#' acum_p() transforms variables in percentage in variables in accumulated percentage.
#' @param data A numeric vector
#' @param n Number of periods to accumulate.
#' @return A vector with variable in accumulated percentage form.
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
#'                V1 = rnorm(mean = 0, sd = 1, n = 78),
#'                V2 = rnorm(mean = 1, sd = 2, n = 78),
#'                V3 = rnorm(mean = 5, sd = 1, n = 78))
#'
#' data_acum <- dplyr::mutate(V1_acum12 = acum_p(V1, 12))
#' }

acum_p <- function(data, n){

    factor <- (1+(data/100))

    prod <- RcppRoll::roll_prodr(factor, n = n)

    final <- (prod-1)*100

    return(final)

}

