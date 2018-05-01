#' DBI connection management
#'
#' @import RPostgreSQL
#' @import jsonlite
#' @aliases r-mip-adaptor package-r-mip-adaptor
#' @title HBP - Database connections
#' @name rmipadaptor

SHAPES <- list(
  ERROR = "text/plain+error",
  PFA = "application/pfa+json",
  PFA_YAML = "application/pfa+yaml",
  TABULAR_DATA_RESOURCE = "application/vnd.dataresource+json",
  HTML = "text/html",
  SVG = "image/svg+xml",
  PNG = "image/png;base64",
  HIGHCHARTS = "application/vnd.highcharts+json",
  VISJS = "application/vnd.visjs+javascript",
  PLOTLY = "application/vnd.plotly.v1+json",
  VEGA = "application/vnd.vega+json",
  VEGALITE = "application/vnd.vegalite+json",
  JSON = "application/json",
  TEXT = "text/plain"
)
