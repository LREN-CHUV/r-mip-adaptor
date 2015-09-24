#' Disconnect from the databases
#' @export
disconnectdb <- function(in_conn, out_conn) {
    if (Sys.getenv("IN_JDBC_URL") != Sys.getenv("OUT_JDBC_URL")) {
        RJDBC::dbDisconnect(out_conn)
    }
    RJDBC::dbDisconnect(in_conn)
}
