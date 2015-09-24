
#' @export
connect2indb <- function() {
    # Export global in_conn and in_drv

    in_drv <<- RJDBC::JDBC(Sys.getenv("IN_JDBC_DRIVER"),
                Sys.getenv("IN_JDBC_JAR_PATH"), identifier.quote = "`")
    in_conn <<- RJDBC::dbConnect(in_drv, Sys.getenv("IN_JDBC_URL"),
                      Sys.getenv("IN_JDBC_USER"),
                      Sys.getenv("IN_JDBC_PASSWORD"))
    in_schema <- Sys.getenv("IN_SCHEMA", "")

    if (in_schema != "") {
        RJDBC::dbSendUpdate(in_conn, paste("SET search_path TO '",
                                 in_schema, "'", sep = ""))
    }
}
