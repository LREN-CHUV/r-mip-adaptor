#'
#' Disconnect from the databases
#'
#' Environment variables:
#' - Execution context:
#'      IN_DB_NAME   : Database name for the database connection for input data
#'      IN_DB_HOST   : Host name for the database connection for input data
#'      IN_DB_PORT   : Port number for the database connection for input data
#'      OUT_DB_NAME  : Database name for the database connection for output results
#'      OUT_DB_HOST  : Host name for the database connection for output results
#'      OUT_DB_PORT  : Port number for the database connection for output results
#' @param indbname Database name, defaults to the value of environment parameter IN_DB_NAME
#' @param inhost Host name, defaults to the value of environment parameter IN_DB_HOST
#' @param inport Port number, defaults to the value of environment parameter IN_DB_PORT
#' @param outdbname Database name, defaults to the value of environment parameter OUT_DB_NAME
#' @param outhost Host name, defaults to the value of environment parameter OUT_DB_HOST
#' @param outport Port number, defaults to the value of environment parameter OUT_DB_PORT
#' @export
disconnectdbs <- function(
  indbname = Sys.getenv("IN_DB_NAME"),
  inhost = Sys.getenv("IN_DB_HOST"),
  inport = Sys.getenv("IN_DB_PORT"),
  outdbname = Sys.getenv("OUT_DB_NAME"),
  outhost = Sys.getenv("OUT_DB_HOST"),
  outport = Sys.getenv("OUT_DB_PORT"))
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
