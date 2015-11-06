#' Fetch data from the input database
#'
#' Environment variables:
#' 
#' - Input Parameters:
#'      PARAM_query  : SQL query producing the dataframe to analyse
#' - Execution context:
#'      IN_JDBC_DRIVER : class name of the JDBC driver for input data
#'      IN_JDBC_JAR_PATH : path to the JDBC driver jar for input data
#'      IN_JDBC_URL : JDBC connection URL for input data
#'      IN_JDBC_USER : User for the database connection for input data
#'      IN_JDBC_PASSWORD : Password for the database connection for input data
#' @param query The SQL query to execute on the input database, defaults to the value of environment parameter PARAM_query
#' @export
querydb <- function(query) {
	if (missing(query)) {
		query <- Sys.getenv("PARAM_query");
	}

	if (!exists("in_conn") || is.null(in_conn)) {
		connect2indb();
	}

	# Fetch the data
    y <- RJDBC::dbGetQuery(in_conn, query);

    return (y)
}