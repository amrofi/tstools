tst_ur <- function(data, type = list(kpss = "kpss", pp = "pp", adf = "adf"), alpha = 0.05, exclude = NULL){

testes <- as.list(type)

testes <- purrr::set_names(testes, type)

ur_map <- function(x) purrr::map(testes, function(y){forecast::ndiffs(x, alpha = alpha, y)})

series_ndiffs <- data %>%

  {if (is.null(exclude)) dplyr::select(.,colnames(data)) else dplyr::select(.,-exclude)} %>%

  purrr::map(.f = ur_map) %>%

  plyr::ldply(bind_rows) %>%

  dplyr::mutate(Dif = ifelse(eval(parse(text=unlist(testes) %>% paste(collapse = "+"))) >= length(testes), "YES", "NO"))

series_labs <- series_ndiffs %>%

  dplyr::filter(Dif == "YES") %>%

  dplyr::select(.id)

dif <- function(x){x-dplyr::lag(x)}

series_dif <- data %>%

  dplyr::mutate_at(vars(series_labs$.id), funs(dif))

return(series_dif)

}

