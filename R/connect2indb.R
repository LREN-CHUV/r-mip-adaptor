#'
#' Connect to the input database
#'
#' Environment variables:
#' - Execution context:
#'      IN_JDBC_DRIVER : Class name of the JDBC driver for input data
#'      IN_JDBC_JAR_PATH : Path to the JDBC driver jar for input data
#'      IN_JDBC_URL : JDBC connection URL for input data
#'      IN_JDBC_USER : User for the database connection for input data
#'      IN_JDBC_PASSWORD : Password for the database connection for input data
#'      IN_JDBC_SCHEMA : Optional schema by default for the database connection for input data
#' @param jdbcDriver Class name of the JDBC driver for input data, defaults to the value of environment parameter IN_JDBC_DRIVER
#' @param jarPath Path to the JDBC driver jar for input data, defaults to the value of environment parameter IN_JDBC_JAR_PATH
#' @param url JDBC connection URL for input data, defaults to the value of environment parameter IN_JDBC_URL
#' @param user User for the database connection for input data, defaults to the value of environment parameter IN_JDBC_USER
#' @param password Password for the database connection for input data, defaults to the value of environment parameter IN_JDBC_PASSWORD
#' @param schema Optional schema by default for the database connection for input data, defaults to the value of environment parameter IN_JDBC_SCHEMA
#' @export
connect2indb <- function(jdbcDriver, jarPath, url, user, password, schema) {

    if (missing(jdbcDriver)) {
      jdbcDriver <- Sys.getenv("IN_JDBC_DRIVER");
    }
    if (missing(jarPath)) {
      jarPath <- Sys.getenv("IN_JDBC_JAR_PATH");
    }
    if (missing(url)) {
      url <- Sys.getenv("IN_JDBC_URL");
    }
    if (missing(user)) {
      user <- Sys.getenv("IN_JDBC_USER");
    }
    if (missing(password)) {
      password <- Sys.getenv("IN_JDBC_PASSWORD");
    }
    if (missing(schema)) {
      schema <- Sys.getenv("IN_JDBC_SCHEMA", "");
    }

    # Export global in_conn and in_drv

    in_drv <<- RJDBC::JDBC(jdbcDriver, jarPath, identifier.quote = "`");
    in_conn <<- RJDBC::dbConnect(in_drv, url, user=user, password=password);

    if (schema != "") {
        RJDBC::dbSendUpdate(in_conn, paste("SET search_path TO '", schema, "'", sep = ""));
    }
}
