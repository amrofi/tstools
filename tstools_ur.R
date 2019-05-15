#' Test and treat non-stationary data
#'
#' tst_ur() tests for the presence of a unit root in each variable (column) and then performs differentiation in non-stationary variables.
#' @param data A tbl variables in columns.
#' @param type Vector with tests to perform. Available: c("kpss", "pp, "adf")
#' @param alpha Significance level for the tests.
#' @param exclude Variables to left aside from testing.
#' @return A tbl with non-stationary variables in differences.
#' @examples
#' # Generate tbl with five variables and two of them non-stationary (V1 and V3).
#'
#'mu <- list(-2, 0, 2, 4, 6)
#'sigma <- list(1, 2, 3, 4, 5)
#'series <- purrr::map2_dfc(mu, sigma, rnorm, n = 100) %>% dplyr::mutate_at(vars(V1,V3), funs(cumsum))
#'
#'series_dif <- tst_ur(series, type = c("kpss", "pp"))

tst_ur <- function(data, type = list(kpss = "kpss", pp = "pp", adf = "adf"), alpha = 0.05, exclude = NULL){

## Adequação do argumento para tipo de teste

testes <- as.list(type)

testes <- set_names(testes, type)

## Início da função

ur_map <- function(x) purrr::map(testes, function(y){forecast::ndiffs(x, alpha = alpha, y)})

series_ndiffs <- data %>%

  {if (is.null(exclude)) dplyr::select(.,colnames(data)) else dplyr::select(.,-exclude)} %>%

  purrr::map(.f = ur_map) %>%

  plyr::ldply(bind_rows) %>%

  dplyr::mutate(Diferenciar = ifelse(eval(parse(text=unlist(testes) %>% paste(collapse = "+"))) >= length(testes), "SIM", "NÃO"))

series_labs <- series_ndiffs %>%

  dplyr::filter(Diferenciar == "SIM") %>%

  dplyr::select(.id)

dif <- function(x){x-dplyr::lag(x)}

series_dif <- data %>%

  dplyr::mutate_at(vars(series_labs$.id), funs(dif))

return(series_dif)

}

