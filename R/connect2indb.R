#'
#' Connect to the input database
#'
#' Environment variables:
#' - Execution context:
#'      IN_DBI_DRIVER  : Class name of the DBI driver for input data, default to 'PostgreSQL'
#'      IN_DATABASE    : Database name for the database connection for input data
#'      IN_HOST        : Host name for the database connection for input data
#'      IN_PORT        : Port number for the database connection for input data
#'      IN_USER        : User for the database connection for input data
#'      IN_PASSWORD    : Password for the database connection for input data
#'      IN_SCHEMA      : Optional default schema used to locate tables for the input data
#' @param drv Class name of the DBI driver, defaults to the value of environment parameter IN_DBI_DRIVER
#' @param dbname Database name, defaults to the value of environment parameter IN_DATABASE
#' @param host Host name, defaults to the value of environment parameter IN_HOST
#' @param port Port number, defaults to the value of environment parameter IN_PORT
#' @param user User, defaults to the value of environment parameter IN_USER
#' @param password Password, defaults to the value of environment parameter IN_PASSWORD
#' @param schema Optional schema by default, defaults to the value of environment parameter IN_SCHEMA
#' @export

connect2indb <- function(
  drv       = Sys.getenv("IN_DBI_DRIVER", "PostgreSQL"),
  dbname    = Sys.getenv("IN_DATABASE"),
  host      = Sys.getenv("IN_HOST"),
  port      = Sys.getenv("IN_PORT"),
  user      = Sys.getenv("IN_USER"),
  password  = Sys.getenv("IN_PASSWORD"),
  schema    = Sys.getenv("IN_SCHEMA", ""))
{
  if (exists("in_conn") && !is.null(in_conn))
    return (in_conn);

  # Export global in_conn and in_drv
  in_drv  <<- DBI::dbDriver(drv)
  in_conn <<- DBI::dbConnect(drv = in_drv, dbname=dbname, host=host, port=port, user=user, password=password);

  if (schema != "") {
    DBI::dbSendStatement(in_conn, paste("SET search_path TO '", schema, "'", sep = ""));
  }

  return (in_conn);
}
