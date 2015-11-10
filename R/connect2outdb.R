#'
#' Connect to the output database
#'
#' Environment variables:
#' - Execution context:
#'      IN_JDBC_DRIVER : Class name of the JDBC driver for input data
#'      IN_JDBC_JAR_PATH : Path to the JDBC driver jar for input data
#'      IN_JDBC_URL : JDBC connection URL for input data
#'      IN_JDBC_USER : User for the database connection for input data
#'      OUT_JDBC_DRIVER : Class name of the JDBC driver for output results
#'      OUT_JDBC_JAR_PATH : Path to the JDBC driver jar for output results
#'      OUT_JDBC_URL : JDBC connection URL for output results
#'      OUT_JDBC_USER : User for the database connection for output results
#'      OUT_JDBC_PASSWORD : Password for the database connection for output results
#'      OUT_JDBC_SCHEMA : Optional schema by default for the database connection for output data
#' @param inJdbcDriver Class name of the JDBC driver for input data, defaults to the value of environment parameter IN_JDBC_DRIVER
#' @param inJarPath Path to the JDBC driver jar for input data, defaults to the value of environment parameter IN_JDBC_JAR_PATH
#' @param inUrl JDBC connection URL for input data, defaults to the value of environment parameter IN_JDBC_URL
#' @param inUser User for the database connection for input data, defaults to the value of environment parameter IN_JDBC_USER
#' @param outJdbcDriver Class name of the JDBC driver for output data, defaults to the value of environment parameter OUT_JDBC_DRIVER
#' @param outJarPath Path to the JDBC driver jar for output data, defaults to the value of environment parameter OUT_JDBC_JAR_PATH
#' @param outUrl JDBC connection URL for output data, defaults to the value of environment parameter OUT_JDBC_URL
#' @param outUser User for the database connection for output data, defaults to the value of environment parameter OUT_JDBC_USER
#' @param outPassword Password for the database connection for output data, defaults to the value of environment parameter OUT_JDBC_PASSWORD
#' @param outSchema Optional schema by default for the database connection for output data, defaults to the value of environment parameter OUT_JDBC_SCHEMA
#' @export
connect2outdb <- function(inJdbcDriver, inJarPath, inUrl, inUser, outJdbcDriver, outJarPath, outUrl, outUser, outPassword, outSchema) {
    # Export global out_conn and out_drv

    if (missing(inJdbcDriver)) {
      inJdbcDriver <- Sys.getenv("IN_JDBC_DRIVER");
    }
    if (missing(inJarPath)) {
      inJarPath <- Sys.getenv("IN_JDBC_JAR_PATH");
    }
    if (missing(inUrl)) {
      inUrl <- Sys.getenv("IN_JDBC_URL");
    }
    if (missing(inUser)) {
      inUser <- Sys.getenv("IN_JDBC_USER");
    }
    if (missing(outJdbcDriver)) {
      outJdbcDriver <- Sys.getenv("OUT_JDBC_DRIVER");
    }
    if (missing(outJarPath)) {
      outJarPath <- Sys.getenv("OUT_JDBC_JAR_PATH");
    }
    if (missing(outUrl)) {
      outUrl <- Sys.getenv("OUT_JDBC_URL");
    }
    if (missing(outUser)) {
      outUser <- Sys.getenv("OUT_JDBC_USER");
    }
    if (missing(outPassword)) {
      outPassword <- Sys.getenv("OUT_JDBC_PASSWORD");
    }
    if (missing(outSchema)) {
      outSchema <- Sys.getenv("OUT_JDBC_SCHEMA", "");
    }

    if (!exists("in_drv") || is.null(in_drv)
        || inJdbcDriver != outJdbcDriver
        || inJarPath !=  outJarPath) {

        out_drv <<- RJDBC::JDBC(outJdbcDriver, outJarPath, identifier.quote = "`");
    } else {
        out_drv <<- in_drv;
    }

    if (!exists("in_conn") || is.null(in_conn)
        || inUrl != outUrl
        || inUser != outUser) {

        out_conn <<- RJDBC::dbConnect(out_drv, outUrl, outUser, outPassword);

        if (outSchema != "") {
            RJDBC::dbSendUpdate(out_conn,paste("SET search_path TO '", outSchema, "'", sep = ""));
        }

    } else {
        out_conn <<- in_conn;
    }

}
