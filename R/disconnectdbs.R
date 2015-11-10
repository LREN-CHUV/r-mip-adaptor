#'
#' Disconnect from the databases
#'
#' Environment variables:
#' - Execution context:
#'      IN_JDBC_URL : JDBC connection URL for input data
#'      OUT_JDBC_URL : JDBC connection URL for output results
#' @param inUrl JDBC connection URL for input data, defaults to the value of environment parameter IN_JDBC_URL
#' @param outUrl JDBC connection URL for output data, defaults to the value of environment parameter OUT_JDBC_URL
#' @export
disconnectdbs <- function(inUrl, outUrl) {

    if (missing(inUrl)) {
      inUrl <- Sys.getenv("IN_JDBC_URL");
    }
    if (missing(outUrl)) {
      outUrl <- Sys.getenv("OUT_JDBC_URL");
    }

    if (inUrl != outUrl && exists("out_conn") && !is.null(out_conn)) {
      RJDBC::dbDisconnect(out_conn);
    }
    if (exists("in_conn") && !is.null(in_conn)) {
      RJDBC::dbDisconnect(in_conn);
    }

    in_conn <<- NULL;
    out_conn <<- NULL;
}
