#' Test and treat non-stationary data
#'
#' auto_dif() tests for the presence of a unit root in each variable (column) and then performs differentiation in non-stationary variables.
#' @param data A tbl with variables in columns.
#' @param type Vector with tests to perform. Available: c("kpss", "pp, "adf")
#' @param alpha Significance level for the tests.
#' @param exclude Variables to drop from evaluation.
#' @return A tbl with the non-stationary variables in differences.
#' @importFrom dplyr, purrr, plyr
#' @examples
#'\dontrun{
#'#' # Generate tbl with five variables and two of them non-stationary (V1 and V3).
#'
#'library(tidyverse)
#'
#'mu <- list(-2, 0, 2, 4, 6)
#'sigma <- list(1, 2, 3, 4, 5)
#'
#'series <- purrr::map2_dfc(mu, sigma, rnorm, n = 100) %>% dplyr::mutate_at(vars(V1,V3), funs(cumsum))
#'
#'series_dif <- auto_dif(series, type = list("kpss", "pp"))
#'}

auto_dif <- function(data, type = c("kpss", "adf", "pp"), alpha = 0.05, exclude = NULL){

  Dif <- `.id` <- `.` <- NULL

  tests <- as.list(type)

  tests <- purrr::set_names(tests, type)

  ur_map <- function(x) purrr::map(tests, function(y){forecast::ndiffs(x, alpha = alpha, y)})

  series_ndiffs <- data %>%

  {if (is.null(exclude)) dplyr::select(.,colnames(data)) else dplyr::select(.,-exclude)} %>%

    purrr::map(.f = ur_map) %>%

    plyr::ldply(dplyr::bind_rows) %>%

    dplyr::mutate(Dif = ifelse(eval(parse(text=unlist(tests) %>% paste(collapse = "+"))) >= length(tests), "YES", "NO"))

  series_labs <- series_ndiffs %>%

    dplyr::filter(Dif == "YES") %>%

    dplyr::select(.id)

  dif <- function(x){x-dplyr::lag(x)}

  series_dif <- data %>%

    dplyr::mutate_at(dplyr::vars(series_labs$.id), dplyr::funs(dif))

  return(list("series_dif" = series_dif, "series_ndiffs" = series_ndiffs))

}

