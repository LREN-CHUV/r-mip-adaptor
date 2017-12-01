#' Save the results into the output database
#'
#' Environment variables:
#'
#' - Execution context:
#'      JOB_ID        : ID of the job
#'      NODE          : Node used for the execution of the script
#'      OUT_FORMAT    : Hint for the exact shape of the Json stored in the database.
#'        Current values are PARTIAL_RESULTS, PRESENTATION
#'      RESULT_TABLE: Name of the result table, defaults to 'job_result'
#'      OUT_DBI_DRIVER: Class name of the DBI driver for output data
#'      OUT_DB_NAME   : Database name for the database connection for output data
#'      OUT_DB_HOST   : Host name for the database connection for output data
#'      OUT_DB_PORT   : Port number for the database connection for output data
#'      OUT_DB_USER   : User for the database connection for output data
#'      OUT_DB_PASSWORD: Password for the database connection for output data
#'      OUT_DB_SCHEMA : Optional schema by default for the database connection for output data
#'      FUNCTION: Name of the function executed
#' @param results The results to store in the database. The following types are supported: data frame, matrix, string.
#' @param jobId ID of the job, defaults to the value of environment parameter JOB_ID
#' @param node Node used for the execution of the script, defaults to the value of environment parameter NODE
#' @param resultTable Name of the result table, defaults to the value of environment parameter RESULT_TABLE
#' @param outFormat Format requested for the output, default to value of environment parameter OUT_FORMAT
#' @param shape Hint about the shape of the data. The following shapes are supported: string, pfa_json, pfa_yaml,
#'              svg, plotly, highcharts, html, r_dataframe_intermediate, r_dataframe_columns, r_matrix, r_other_intermediate
#' @param fn Hint about the function used to produce the data,  defaults to the value of environment parameter FUNCTION
#' @param conn The connection to the database, default to global variable out_conn
#' @export

saveResults <- function(
  results,
  jobId       = Sys.getenv("JOB_ID"),
  node        = Sys.getenv("NODE"),
  resultTable = Sys.getenv("RESULT_TABLE", "job_result"),
  outFormat   = Sys.getenv("OUT_FORMAT", "PRESENTATION"),
  shape,
  fn          = Sys.getenv("FUNCTION", "R"),
  conn)
{
 if (missing(shape)) {
    shape <- switch(outFormat,
                    PARTIAL_RESULTS = "r_other_intermediate",
                    "r_other");

    if (is.data.frame(results)) {
      shape <- switch(outFormat,
                      PARTIAL_RESULTS = "r_dataframe_intermediate",
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

  serialized_results <- switch(shape,
                 string =                   results,
                 pfa_json =                 results,
                 pfa_yaml =                 results,
                 svg =                      results,
                 plotly =                   results,
                 highcharts =               results,
                 html =                     results,
                 r_dataframe_intermediate = toJSON(results, auto_unbox=TRUE, digits=8, Date = "ISO8601"),
                 r_dataframe_columns =      toJSON(results, dataframe="columns", digits=8, Date = "ISO8601"),
                 r_matrix =                 toJSON(results, matrix="rowmajor", digits=8, Date = "ISO8601"),
                 r_other_intermediate =     toJSON(results, auto_unbox=TRUE, digits=8, Date = "ISO8601"),
                 toJSON(results, dataframe="columns", digits=8, Date = "ISO8601"));

  sql <-paste(
    "INSERT INTO", resultTable,"(job_id, node, data, shape, function) values (",
  DBI::dbQuoteString(conn, jobId), ",", DBI::dbQuoteString(conn, node), ",", DBI::dbQuoteString(conn, toString(serialized_results)), ",", DBI::dbQuoteString(conn, shape), ",", DBI::dbQuoteString(conn, fn), ")")

  DBI::dbSendStatement(
    conn,
    sql);

  # Disconnect from the databases
  disconnectdbs();
}
