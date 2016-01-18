#' Save the results into the output database
#'
#' Environment variables:
#' 
#' - Execution context:
#'      JOB_ID : ID of the job
#'      NODE : Node used for the execution of the script
#'      OUT_FORMAT : Hint for the exact shape of the Json stored in the database.
#'        Current values are INTERMEDIATE_RESULTS, PRESENTATION
#'      RESULT_TABLE: Name of the result table, defaults to 'job_result'
#'      OUT_JDBC_DRIVER : class name of the JDBC driver for output results
#'      OUT_JDBC_JAR_PATH : path to the JDBC driver jar for output results
#'      OUT_JDBC_URL : JDBC connection URL for output results
#'      OUT_JDBC_USER : User for the database connection for output results
#'      OUT_JDBC_PASSWORD : Password for the database connection for output results
#' @param results The results to store in the database. The following types are supported: data frame, matrix, string.
#' @param jobId ID of the job, defaults to the value of environment parameter JOB_ID
#' @param node Node used for the execution of the script, defaults to the value of environment parameter NODE
#' @param resultTable Name of the result table, defaults to the value of environment parameter RESULT_TABLE
#' @export
saveResults <- function(results, jobId, node, resultTable) {

    if (!exists("out_conn") || is.null(in_conn)) {
        connect2outdb();
    }

    if (missing(jobId)) {
      jobId <- Sys.getenv("JOB_ID");
    }
    if (missing(node)) {
      node <- Sys.getenv("NODE");
    }
    if (missing(resultTable)) {
      resultTable <- Sys.getenv("RESULT_TABLE", "job_result");
    }

    shape <- "generic";
    if (is.data.frame(results)) {
        if (Sys.getenv("OUT_FORMAT", "") == "INTERMEDIATE_RESULTS") {
            shape <- "r_dataframe_intermediate";
            json <- toJSON(results, auto_unbox=TRUE, digits=8, Date = "ISO8601");
        } else {
            shape <- "r_dataframe_columns";
            json <- toJSON(results, dataframe="columns", digits=8, Date = "ISO8601");
        }
    } else if (is.matrix(results) ) {
        shape <- "r_matrix";
        json <- toJSON(results, matrix="rowmajor", digits=8);
    } else if (is.character(results) ) {
        shape <- "string";
        json <- results;
    } else {
        shape <- "r_other"
        json <- toJSON(results, digits=8, Date = "ISO8601");
    }

    RJDBC::dbSendUpdate(out_conn, paste("INSERT INTO", resultTable, "(job_id, node, data, shape) values (?, ?, ?, ?)"), jobId, node, toString(json), shape);

    # Disconnect from the databases
    disconnectdbs();

}