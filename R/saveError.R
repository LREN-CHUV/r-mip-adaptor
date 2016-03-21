#' Save an error into the output database
#'
#' Environment variables:
#' 
#' - Execution context:
#'      JOB_ID : ID of the job
#'      NODE : Node used for the execution of the script
#'      RESULT_TABLE: Name of the result table, defaults to 'job_result'
#'      OUT_JDBC_DRIVER : class name of the JDBC driver for output results
#'      OUT_JDBC_JAR_PATH : path to the JDBC driver jar for output results
#'      OUT_JDBC_URL : JDBC connection URL for output results
#'      OUT_JDBC_USER : User for the database connection for output results
#'      OUT_JDBC_PASSWORD : Password for the database connection for output results
#'      OUTPUT_FILE : File containing the output of R
#'      ERROR_FILE : File containing the errors of R
#' @param error The error to record.
#' @param outputFile File containing the output of R, default to the value of environment variable OUTPUT_FILE.
#' @param errorFile File containing the error of R, default to the value of environment variable ERROR_FILE.
#' @param jobId ID of the job, defaults to the value of environment parameter JOB_ID
#' @param node Node used for the execution of the script, defaults to the value of environment parameter NODE
#' @param resultTable Name of the result table, defaults to the value of environment parameter RESULT_TABLE
#' @param fn Hint about the function used to produce the data
#' @param conn The connection to the database, default to global variable out_conn
#' @export
saveError <- function(error, outputFile, errorFile, jobId, node, resultTable, fn, conn) {

    if (missing(error)) {
      error <- "An error occurred";
    }
    if (missing(outputFile)) {
      outputFile <- Sys.getenv("OUTPUT_FILE", "/unknown/file");
    }
    if (missing(errorFile)) {
      errorFile <- Sys.getenv("ERROR_FILE", "/unknown/file");
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
    if (missing(fn)) {
        fn <- "R";
    }
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


    RJDBC::dbSendUpdate(conn, paste("INSERT INTO", resultTable, "(job_id, node, error, data, shape, function) values (?, ?, ?, ?, ?, ?)"), jobId, node, error, data, shape, fn);

    # Disconnect from the databases
    disconnectdbs();

}