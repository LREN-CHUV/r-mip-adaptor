#' Disconnect from the databases
#' @export
disconnectdb <- function() {
    if (Sys.getenv("IN_JDBC_URL") != Sys.getenv("OUT_JDBC_URL")
        && out_conn != null) {
      RJDBC::dbDisconnect(out_conn)
    }
    if (in_conn != null) {
      RJDBC::dbDisconnect(in_conn)
    }

    in_conn <- NULL
    out_conn <- NULL
}
