
#' @export
connect2outdb <- function(in_drv, in_conn) {

    drv <- JDBC(Sys.getenv("IN_JDBC_DRIVER"), Sys.getenv("IN_JDBC_JAR_PATH"),
                identifier.quote = "`")
    conn <- RJDBC::dbConnect(drv, Sys.getenv("IN_JDBC_URL"),
        Sys.getenv("IN_JDBC_USER"), Sys.getenv("IN_JDBC_PASSWORD"))
    in_schema <- Sys.getenv("IN_SCHEMA", "")

    if (in_schema != "") {
        RJDBC::dbSendUpdate(conn, paste("SET search_path TO '", in_schema, "'",
                                 sep = ""))
    }

    if (Sys.getenv("IN_JDBC_DRIVER") != Sys.getenv("OUT_JDBC_DRIVER")
        || Sys.getenv("IN_JDBC_JAR_PATH") !=  Sys.getenv("OUT_JDBC_JAR_PATH")) {

        out_drv <- RJDBC::JDBC(Sys.getenv("OUTJDBC_DRIVER"),
            Sys.getenv("OUT_JDBC_JAR_PATH"), identifier.quote = "`")
    } else {
        out_drv <- in_drv
    }

    if (Sys.getenv("IN_JDBC_URL") != Sys.getenv("OUT_JDBC_URL")
        || Sys.getenv("IN_JDBC_USER") != Sys.getenv("OUT_JDBC_USER")
        || Sys.getenv("IN_JDBC_PASSWORD") != Sys.getenv("OUT_JDBC_PASSWORD")) {

        out_conn <- RJDBC::dbConnect(out_drv, Sys.getenv("OUT_JDBC_URL"),
            Sys.getenv("OUT_JDBC_USER"), Sys.getenv("OUT_JDBC_PASSWORD"))
    } else {
        out_conn <- in_conn
    }

    out_schema <- Sys.getenv("OUT_SCHEMA", "")

    if (out_schema != "") {
        RJDBC::dbSendUpdate(out_conn,
            paste("SET search_path TO '", out_schema, "'", sep = ""))
    }

    return(data.frame(drv = out_drv, conn = out_conn))
}
