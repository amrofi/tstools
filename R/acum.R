#' Accumulated percentage in 'n' periods.
#'
#' acum() transforms variables in percentage in variables in accumulated percentage.
#' @param data A tbl with variables in columns.
#' @param n Number of periods to accumulate.
#' @param exclude Vector of variables to left aside.
#' @return A tbl with variables in accumulated percentage form.
#' @importFrom dplyr RcppRoll
#' @examples
#' \dontrun{
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
#' data_acum <- acum(data, 12, "Date")
#' }


acum <- function(data, n, exclude = NULL){

  `.` <- NULL

  acum_aux <- function(x, n){

    factor <- (1+(x/100))

    prod <- RcppRoll::roll_prodr(factor, n = n)

    final <- (prod-1)*100

    return(final)

  }

  data_acum <- data %>%

  {if (is.null(exclude)) dplyr::mutate_all(.,dplyr::funs(acum_aux), n) else dplyr::mutate_at(., dplyr::vars(-exclude),
                                                                                             dplyr::funs(acum_aux), n)}

  return(data_acum)

}

