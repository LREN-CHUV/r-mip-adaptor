#' Fetch data from the input database
#'
#' Environment variables:
#'
#' - Input Parameters:
#'      PARAM_query  : SQL query producing the dataframe to analyse
#' - Execution context:
#'      IN_FORMAT : Hint for the exact shape of the data stored in the database.
#'        Possible values are PARTIAL_RESULTS, TABULAR_DATA
#'      IN_DBI_DRIVER  : Class name of the DBI driver for input data
#'      IN_DATABASE    : Database name for the database connection for input data
#'      IN_HOST        : Host name for the database connection for input data
#'      IN_PORT        : Port number for the database connection for input data
#'      IN_USER        : User for the database connection for input data
#'      IN_PASSWORD    : Password for the database connection for input data
#'      IN_SCHEMA      : Optional schema by default for the database connection for input data
#' @param query The SQL query to execute on the input database, defaults to the value of environment parameter PARAM_query
#' @param inFormat Hint for the exact shape of the data stored in the database. Possible values are PARTIAL_RESULTS, OTHER. Defaults to the value of environment parameter IN_FORMAT
#' @param conn The connection to the database, default to global variable in_conn
#' @export
fetchData <- function(
  query = Sys.getenv("PARAM_query"),
  inFormat = Sys.getenv("IN_FORMAT", "TABULAR_DATA"),
  conn) {

  if (missing(conn)) {
    if (!exists("in_conn") || is.null(in_conn)) {
      conn <- connect2indb();
    } else {
      conn <- in_conn;
    }
  }

  # Fetch the data
  y <- DBI::dbGetQuery(conn, query);

  if (inFormat == "PARTIAL_RESULTS") {
    if (nrow(y) == 0) {
      stop("No data found");
    }

    y <- switch(y[1, "shape"],
                "r_dataframe_intermediate" = lapply(lapply(y[,'data'], fromJSON), as.data.frame),
                "error" = stop(y[,'error']),
                lapply(y[,'data'], fromJSON)
    );
    if (length(y) == 1) {
      y <- y[[1]];
    }
  }

  return (y)
}
