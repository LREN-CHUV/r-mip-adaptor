#' Fetch data from the input database
#'
#' Environment variables:
#' 
#' - Input Parameters:
#'      PARAM_query  : SQL query producing the dataframe to analyse
#' - Execution context:
#'      IN_FORMAT : Hint for the exact shape of the data stored in the database.
#'        Possible values are INTERMEDIATE_RESULTS, OTHER
#'      IN_JDBC_DRIVER : class name of the JDBC driver for input data
#'      IN_JDBC_JAR_PATH : path to the JDBC driver jar for input data
#'      IN_JDBC_URL : JDBC connection URL for input data
#'      IN_JDBC_USER : User for the database connection for input data
#'      IN_JDBC_PASSWORD : Password for the database connection for input data
#'      IN_JDBC_SCHEMA : Optional schema by default for the database connection for input data
#' @param query The SQL query to execute on the input database, defaults to the value of environment parameter PARAM_query
#' @param inFormat Hint for the exact shape of the data stored in the database. Possible values are INTERMEDIATE_RESULTS, OTHER. Defaults to the value of environment parameter IN_FORMAT
#' @export
fetchData <- function(query, inFormat) {
    if (missing(query)) {
        query <- Sys.getenv("PARAM_query");
    }
    if (missing(inFormat)) {
        inFormat <- Sys.getenv("IN_FORMAT", "OTHER");
    }

    if (!exists("in_conn") || is.null(in_conn)) {
        connect2indb();
    }

    # Fetch the data
    y <- RJDBC::dbGetQuery(in_conn, query);

    if (inFormat == "INTERMEDIATE_RESULTS") {
        yjson <- lapply(y[,'data'], fromJSON)
        if (y[1, "shape"] == "r_dataframe_intermediate") {
            y <- lapply(yjson, as.data.frame)
        }
        if (length(y) == 1) {
            y <- y[[1]]
        }
    }

    return (y)
}