#' Create tibble with leaded variables
#'
#' add_leads() creates a tibble with leaded variables
#' @param data A tbl with variables in columns.
#' @param vars_leads A list with variables names and number of leads.
#' @return A tbl with leaded variables.
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
#' # Create leads 1,2,3 for V1; 2 for V2; and 1,7 for V3.
#'
#' library(tidyverse)
#' library(tstools)
#'
#' data_leads <- add_leads(data, list("V1" = 1:3, "V2" = 2, "V3" = c(1,7)))


## Criar função para aplicar as operações sobre o tbl

add_leads <- function(data, vars_leads, suffix = "_l"){

  `:=` <- NULL

  ## Função auxiliar para criar lead

  mutate_lead <- function(data, x, k, suf = suffix) {

    x <- dplyr::quo(!! dplyr::sym(x))

    x_name <- paste0(dplyr::quo_name(x), suf, k)

    dplyr::mutate(data,
                  !! x_name := dplyr::lead(!! x, k)
    )
  }

  vars_aux <- names(vars_leads) %>% as.list()

  leads_aux <- purrr::map(.x = vars_leads, .f = length)

  vars_exp <- purrr::map2(.x = vars_aux, .y = leads_aux, .f = rep) %>% purrr::flatten()

  leads_exp <- vars_leads %>% purrr::flatten()

  purrr::map2(.x = vars_exp, .y = leads_exp, .f = mutate_lead, data = data) %>%

    purrr::reduce(dplyr::left_join, by = colnames(data))

}
