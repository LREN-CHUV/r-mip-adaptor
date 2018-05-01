#'
#' Disconnect from the databases
#'
#' Environment variables:
#' - Execution context:
#'      IN_DATABASE  : Database name for the database connection for input data
#'      IN_HOST      : Host name for the database connection for input data
#'      IN_PORT      : Port number for the database connection for input data
#'      OUT_DATABASE : Database name for the database connection for output results
#'      OUT_HOST     : Host name for the database connection for output results
#'      OUT_PORT     : Port number for the database connection for output results
#' @param indbname Database name, defaults to the value of environment parameter IN_DATABASE
#' @param inhost Host name, defaults to the value of environment parameter IN_HOST
#' @param inport Port number, defaults to the value of environment parameter IN_PORT
#' @param outdbname Database name, defaults to the value of environment parameter OUT_DATABASE
#' @param outhost Host name, defaults to the value of environment parameter OUT_HOST
#' @param outport Port number, defaults to the value of environment parameter OUT_PORT
#' @export
disconnectdbs <- function(
  indbname = Sys.getenv("IN_DATABASE"),
  inhost = Sys.getenv("IN_HOST"),
  inport = Sys.getenv("IN_PORT"),
  outdbname = Sys.getenv("OUT_DATABASE"),
  outhost = Sys.getenv("OUT_HOST"),
  outport = Sys.getenv("OUT_PORT"))
{

  if (
    indbname != outdbname &&
    inhost != outhost &&
    inport != outport &&
    exists("out_conn") && !is.null(out_conn)) {
    DBI::dbDisconnect(out_conn);
  }

  if (exists("in_conn") && !is.null(in_conn)) {
    DBI::dbDisconnect(in_conn);
  }

  in_conn <<- NULL;
  out_conn <<- NULL;
}
