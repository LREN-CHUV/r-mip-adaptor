
#' @export
connect2indb <- function() {

    drv <- RJDBC::JDBC(Sys.getenv("IN_JDBC_DRIVER"),
                Sys.getenv("IN_JDBC_JAR_PATH"), identifier.quote = "`")
    conn <- RJDBC::dbConnect(drv, Sys.getenv("IN_JDBC_URL"),
                      Sys.getenv("IN_JDBC_USER"),
                      Sys.getenv("IN_JDBC_PASSWORD"))
    in_schema <- Sys.getenv("IN_SCHEMA", "")

    if (in_schema != "") {
        RJDBC::dbSendUpdate(conn, paste("SET search_path TO '",
                                 in_schema, "'", sep = ""))
    }

    return(data.frame(drv = drv, conn = conn))
}
