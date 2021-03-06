% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/auto_forecast.R
\name{add_leads}
\alias{add_leads}
\title{Create leaded variables}
\usage{
add_leads(data, vars_leads, suffix)
}
\arguments{
\item{data}{A tbl with variables in columns.}

\item{vars_leads}{list with variables names and disired leads}

\item{suffix}{Character string with suffix for leaded variables. Default is "_l".}

}

\value{
An object of class tibble (tbl) with leaded variables.
}
\description{
Given a tibble (or data frame) and a list with variables names and disired leads, the function creates a tibble with the leaded variables.
}

\examples{
\dontrun{

library(tidyverse)
library(tstools)

data <- tibble(Date = seq.Date(from = as.Date("2012-01-01"),
                               to = as.Date("2018-06-01"),
                               by = "month"),
               V1 = rnorm(mean = 0, sd = 1, n = 78),
               V2 = rnorm(mean = 1, sd = 2, n = 78),
               V3 = rnorm(mean = 5, sd = 1, n = 78))

data_leads <- add_leads(data, list("V1" = 1:3, "V2" = 2, "V3" = c(1,7)), suffix = "_l")
              }
}
\author{
J. Renato Leripio
}
