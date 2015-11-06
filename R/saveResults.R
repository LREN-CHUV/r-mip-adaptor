#' Save the results into the output database
#'
#' Environment variables:
#' 
#' - Execution context:
#'      JOB_ID : ID of the job
#'      NODE : Node used for the execution of the script
#'      RESULT_TABLE: name of the result table, defaults to 'job_result'
#'      OUT_JDBC_DRIVER : class name of the JDBC driver for output results
#'      OUT_JDBC_JAR_PATH : path to the JDBC driver jar for output results
#'      OUT_JDBC_URL : JDBC connection URL for output results
#'      OUT_JDBC_USER : User for the database connection for output results
#'      OUT_JDBC_PASSWORD : Password for the database connection for output results
#' @param results The results to store in the database. The following types are supported: data frame, matrix, string.
#' @export
saveResults <- function(results) {

    if (!exists("out_conn") || is.null(in_conn)) {
        connect2outdb();
    }

    job_id       <- Sys.getenv("JOB_ID");
    node         <- Sys.getenv("NODE");
    result_table <- Sys.getenv("RESULT_TABLE", "job_result");

    if (is.data.frame(results)) {
        json <- toJSON(results, dataset="columns");
    } else if (is.matrix(results) ) {
        json <- toJSON(results, matrix="rowmajor");
    } else if (is.character(results) ) {
        json <- results;
    } else {
        json <- toJSON(results);
    }

    dbresults <- data.frame(job_id = job_id, node = node, timestamp = as.numeric(Sys.time()) * 1000,
                 data = json);

    RJDBC::dbWriteTable(out_conn, result_table, dbresults, overwrite=FALSE, append=TRUE, row.names = FALSE)

    # Disconnect from the databases
    disconnectdbs()

}