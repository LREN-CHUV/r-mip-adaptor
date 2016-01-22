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
#' @param outFormat Format requested for the output, default to value of environment parameter OUT_FORMAT
#' @param shape Hint about the shape of the data
#' @param conn The connection to the database, default to global variable out_conn
#' @export
saveResults <- function(results, jobId, node, resultTable, outFormat, shape, conn) {

    if (missing(jobId)) {
      jobId <- Sys.getenv("JOB_ID");
    }
    if (missing(node)) {
      node <- Sys.getenv("NODE");
    }
    if (missing(resultTable)) {
      resultTable <- Sys.getenv("RESULT_TABLE", "job_result");
    }
    if (missing(outFormat)) {
      outFormat <- Sys.getenv("OUT_FORMAT", "PRESENTATION");
    }
    if (missing(shape)) {
      shape <- switch(outFormat,
         INTERMEDIATE_RESULTS = "r_other_intermediate",
         "r_other");

      if (is.data.frame(results)) {
        shape <- switch(outFormat,
            INTERMEDIATE_RESULTS = "r_dataframe_intermediate",
            "r_dataframe_columns");
      } else if (is.matrix(results) ) {
          shape <- "r_matrix";
      } else if (is.character(results) ) {
          shape <- "string";
      }
    }
    if (missing(conn)) {
        if (!exists("out_conn") || is.null(out_conn)) {
            conn <- connect2outdb();
        } else {
            conn <- out_conn;
        }
    }

    json <- switch(shape,
          string =                   results,
          r_dataframe_intermediate = toJSON(results, auto_unbox=TRUE, digits=8, Date = "ISO8601"),
          r_dataframe_columns =      toJSON(results, dataframe="columns", digits=8, Date = "ISO8601"),
          r_matrix =                 toJSON(results, matrix="rowmajor", digits=8, Date = "ISO8601"),
          r_other_intermediate =     toJSON(results, auto_unbox=TRUE, digits=8, Date = "ISO8601"),
          toJSON(results, dataframe="columns", digits=8, Date = "ISO8601"));

    RJDBC::dbSendUpdate(conn, paste("INSERT INTO", resultTable, "(job_id, node, data, shape) values (?, ?, ?, ?)"), jobId, node, toString(json), shape);

    # Disconnect from the databases
    disconnectdbs();

}