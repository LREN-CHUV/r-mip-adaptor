#'
#' Connect to the output database
#'
#' Environment variables:
#' - Execution context:
#'      IN_DBI_DRIVER   : Class name of the DBI driver for input data, default to 'PostgreSQL'
#'      IN_DB_NAME      : Database name for the database connection for input data
#'      IN_DB_HOST      : Host name for the database connection for input data
#'      IN_DB_PORT      : Port number for the database connection for input data
#'      IN_DB_USER      : User for the database connection for input data
#'      OUT_DBI_DRIVER  : Class name of the DBI driver for output data
#'      OUT_DB_NAME     : Database name for the database connection for output data
#'      OUT_DB_HOST     : Host name for the database connection for output data
#'      OUT_DB_PORT     : Port number for the database connection for output data
#'      OUT_DB_USER     : User for the database connection for output data
#'      OUT_DB_PASSWORD : Password for the database connection for output data
#'      OUT_DB_SCHEMA   : Optional default schema used to locate tables for the output data
#'
#' @param indrv Class name of the DBI driver, defaults to the value of environment parameter IN_DB_DRIVER
#' @param indbname Database name, defaults to the value of environment parameter IN_DB_NAME
#' @param inhost Host name, defaults to the value of environment parameter IN_DBI_HOST
#' @param inport Port number, defaults to the value of environment parameter IN_DB_PORT
#' @param inuser User, defaults to the value of environment parameter IN_DB_USER
#' @param outdrv Class name of the DBI driver, defaults to the value of environment parameter OUT_DB_DRIVER
#' @param outdbname Database name, defaults to the value of environment parameter OUT_DB_NAME
#' @param outhost Host name, defaults to the value of environment parameter OUT_DB_HOST
#' @param outport Port number, defaults to the value of environment parameter OUT_DB_PORT
#' @param outuser User, defaults to the value of environment parameter OUT_DB_USER
#' @param outpassword Password, defaults to the value of environment parameter OUT_DB_PASSWORD
#' @param outschema Optional schema by default, defaults to the value of environment parameter OUT_DB_SCHEMA

#' @export
connect2outdb <- function(
  indrv = Sys.getenv("IN_DBI_DRIVER", "PostgreSQL"),
  indbname = Sys.getenv("IN_DB_NAME"),
  inhost = Sys.getenv("IN_DB_HOST"),
  inport = Sys.getenv("IN_DB_PORT"),
  inuser = Sys.getenv("IN_DB_USER"),
  outdrv = Sys.getenv("OUT_DBI_DRIVER", "PostgreSQL"),
  outdbname = Sys.getenv("OUT_DB_NAME"),
  outhost = Sys.getenv("OUT_DB_HOST"),
  outport = Sys.getenv("OUT_DB_PORT"),
  outuser = Sys.getenv("OUT_DB_USER"),
  outpassword = Sys.getenv("OUT_DB_PASSWORD"),
  outschema = Sys.getenv("OUT_DB_SCHEMA", ""))
{

  if (exists("out_conn") && !is.null(out_conn))
    return (out_conn);

  # Export global out_conn and out_drv

    if (!exists("in_drv") || is.null(in_drv)
        || indrv != outdrv) {
        out_drv <<- DBI::dbDriver(indrv)
    } else {
        out_drv <<- in_drv
    }

    if (!exists("in_conn") || is.null(in_conn)
        || inhost != outhost
        || inport != outport
        || indbname != outdbname
        || inuser != outuser) {

        out_conn <<- DBI::dbConnect(
          drv = out_drv,
          dbname = outdbname,
          host = outhost,
          port = outport,
          user = outuser,
          password = outpassword)

        if (outschema != "") {
            DBI::dbSendStatement(out_conn, paste("SET search_path TO '", outschema, "'", sep = ""));
        }

    } else {
        out_conn <<- in_conn;
    }

    return (out_conn);
}
