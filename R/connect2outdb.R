#' Connect to the output database
#'
#' Environment variables:
#' 
#' - Execution context:
#'      OUT_JDBC_DRIVER : class name of the JDBC driver for output results
#'      OUT_JDBC_JAR_PATH : path to the JDBC driver jar for output results
#'      OUT_JDBC_URL : JDBC connection URL for output results
#'      OUT_JDBC_USER : User for the database connection for output results
#'      OUT_JDBC_PASSWORD : Password for the database connection for output results
#' @export
connect2outdb <- function() {
    # Export global out_conn and out_drv

    if (!exists("in_drv") || is.null(in_drv)
        || Sys.getenv("IN_JDBC_DRIVER") != Sys.getenv("OUT_JDBC_DRIVER")
        || Sys.getenv("IN_JDBC_JAR_PATH") !=  Sys.getenv("OUT_JDBC_JAR_PATH")) {

        out_drv <<- RJDBC::JDBC(Sys.getenv("OUTJDBC_DRIVER"),
            Sys.getenv("OUT_JDBC_JAR_PATH"), identifier.quote = "`")
    } else {
        out_drv <<- in_drv
    }

    if (!exists("in_conn") || is.null(in_conn)
        || Sys.getenv("IN_JDBC_URL") != Sys.getenv("OUT_JDBC_URL")
        || Sys.getenv("IN_JDBC_USER") != Sys.getenv("OUT_JDBC_USER")
        || Sys.getenv("IN_JDBC_PASSWORD") != Sys.getenv("OUT_JDBC_PASSWORD")) {

        out_conn <<- RJDBC::dbConnect(out_drv, Sys.getenv("OUT_JDBC_URL"),
            Sys.getenv("OUT_JDBC_USER"), Sys.getenv("OUT_JDBC_PASSWORD"))
    } else {
        out_conn <<- in_conn
    }

    out_schema <- Sys.getenv("OUT_SCHEMA", "")

    if (out_schema != "") {
        RJDBC::dbSendUpdate(out_conn,
            paste("SET search_path TO '", out_schema, "'", sep = ""))
    }
}
