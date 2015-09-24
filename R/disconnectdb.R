#' Disconnect from the databases
#' @export
disconnectdb <- function() {
    if (Sys.getenv("IN_JDBC_URL") != Sys.getenv("OUT_JDBC_URL")
        && exists("out_conn") && !is.null(out_conn)) {
      RJDBC::dbDisconnect(out_conn)
    }
    if (exists("in_conn") && !is.null(in_conn)) {
      RJDBC::dbDisconnect(in_conn)
    }

    in_conn <<- NULL
    out_conn <<- NULL
}
