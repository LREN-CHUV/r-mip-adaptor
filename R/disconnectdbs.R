#'
#' Disconnect from the databases
#'
#' Environment variables:
#' - Execution context:
#'      IN_DBI_DBNAME : Database name for the database connection for input data
#'      IN_DBI_HOST   : Host name for the database connection for input data
#'      IN_DBI_PORT   : Port number for the database connection for input data
#'      OUT_DBI_DBNAME: Database name for the database connection for output results
#'      OUT_DBI_HOST  : Host name for the database connection for output results
#'      OUT_DBI_PORT  : Port number for the database connection for output results
#' @param indbname Database name, defaults to the value of environment parameter IN_DBI_DBNAME
#' @param inhost Host name, defaults to the value of environment parameter IN_DBI_HOST
#' @param inport Port number, defaults to the value of environment parameter IN_DBI_PORT
#' @param outdbname Database name, defaults to the value of environment parameter OUT_DBI_DBNAME
#' @param outhost Host name, defaults to the value of environment parameter OUT_DBI_HOST
#' @param outport Port number, defaults to the value of environment parameter OUT_DBI_PORT
#' @export
disconnectdbs <- function(
  indbname = Sys.getenv("IN_DBI_DBNAME"),
  inhost = Sys.getenv("IN_DBI_HOST"),
  inport = Sys.getenv("IN_DBI_PORT"),
  outdbname = Sys.getenv("OUT_DBI_DBNAME"),
  outhost = Sys.getenv("OUT_DBI_HOST"),
  outport = Sys.getenv("OUT_DBI_PORT"))
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
