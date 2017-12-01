#' Save an error into the output database
#'
#' Environment variables:
#'
#' - Execution context:
#'      JOB_ID : ID of the job
#'      NODE : Node used for the execution of the script
#'      RESULT_TABLE: Name of the result table, defaults to 'job_result'
#'      OUT_DBI_DRIVER : Class name of the DBI driver for output data
#'      OUT_DB_NAME    : Database name for the database connection for output data
#'      OUT_DB_HOST    : Host name for the database connection for output data
#'      OUT_DB_PORT    : Port number for the database connection for output data
#'      OUT_DB_USER    : User for the database connection for output data
#'      OUT_DB_PASSWORD: Password for the database connection for output data
#'      OUT_DB_SCHEMA  : Optional schema by default for the database connection for output data
#'      OUTPUT_FILE    : File containing the output of R
#'      ERROR_FILE     : File containing the errors of R
#' @param error The error to record.
#' @param outputFile File containing the output of R, default to the value of environment variable OUTPUT_FILE.
#' @param errorFile File containing the error of R, default to the value of environment variable ERROR_FILE.
#' @param jobId ID of the job, defaults to the value of environment parameter JOB_ID
#' @param node Node used for the execution of the script, defaults to the value of environment parameter NODE
#' @param resultTable Name of the result table, defaults to the value of environment parameter RESULT_TABLE
#' @param fn Hint about the function used to produce the data
#' @param conn The connection to the database, default to global variable out_conn
#' @export
saveError <- function(
  error       = "An error occurred",
  outputFile  = Sys.getenv("OUTPUT_FILE", "/unknown/file"),
  errorFile   = Sys.getenv("ERROR_FILE", "/unknown/file"),
  jobId       = Sys.getenv("JOB_ID"),
  node        = Sys.getenv("NODE"),
  resultTable = Sys.getenv("RESULT_TABLE", "job_result"),
  fn          = "R",
  conn) {

  if (missing(conn)) {
    if (!exists("out_conn") || is.null(out_conn)) {
      conn <- connect2outdb();
    } else {
      conn <- out_conn;
    }
  }
  shape <- "error";
  data <- "";

  if (file.exists(outputFile)) {
    if ("outFile" %in% ls(globalenv())) {
      f <- outFile;
    } else {
      f <- file(outputFile, open="at");
      if (sink.number(type = "output") == 0) {
        sink(f, type="output", append=T);
      }
    }
    # Capture some diagnostics
    cat("DIAGNOSTICS\n");
    cat("-----------\n");
    sessionInfo();
    options();
    Sys.getenv();
    sink(NULL, type="output");
    flush(f);
    close(f);
    print(readLines(outputFile))
    data <- paste(c("OUT", "-----", readLines(outputFile)), collapse="\n");
  }
  if (file.exists(errorFile)) {
    sink(NULL, type="message");
    if ("errFile" %in% ls(globalenv())) {
      f <- errFile;
      flush(f);
      close(f);
    }
    data <- paste(c(data, "ERROR", "-----", readLines(errorFile)), collapse="\n");
  }

  sql <- paste(
    "INSERT INTO", resultTable, "(job_id, node, error, data, shape, function) values (",
    DBI::dbQuoteString(conn, jobId), ",",
    DBI::dbQuoteString(conn, node), ",",
    DBI::dbQuoteString(conn, error), ",",
    DBI::dbQuoteString(conn, data), ",",
    DBI::dbQuoteString(conn, shape), ",",
    DBI::dbQuoteString(conn, fn), ")")

  DBI::dbSendStatement(conn, sql)

# Disconnect from the databases
disconnectdbs();
}
