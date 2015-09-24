
#' @export
connect2outdb <- function() {
    # Export global out_conn and out_drv

    if (Sys.getenv("IN_JDBC_DRIVER") != Sys.getenv("OUT_JDBC_DRIVER")
        || Sys.getenv("IN_JDBC_JAR_PATH") !=  Sys.getenv("OUT_JDBC_JAR_PATH")) {

        out_drv <<- RJDBC::JDBC(Sys.getenv("OUTJDBC_DRIVER"),
            Sys.getenv("OUT_JDBC_JAR_PATH"), identifier.quote = "`")
    } else {
        out_drv <<- in_drv
    }

    if (Sys.getenv("IN_JDBC_URL") != Sys.getenv("OUT_JDBC_URL")
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
