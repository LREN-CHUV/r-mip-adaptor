context("Local");

library(rmipadaptor);

test_that("We save the fact that there was an error", {
    job_id <- "E01";
    Sys.setenv(JOB_ID = job_id);
    Sys.setenv(NODE = "local");
    Sys.setenv(PARAM_query = "select * from brain_feature");
    Sys.setenv(OUT_FORMAT = "PARTIAL_RESULTS");
    Sys.setenv(ERROR_FILE = "/tmp/errors.txt");
    Sys.setenv(OUTPUT_FILE = "/tmp/output.txt");

    errFile <- file(Sys.getenv("ERROR_FILE"), open="wt");
    outFile <- file(Sys.getenv("OUTPUT_FILE"), open="wt");

    sink(errFile, type="message");
    sink(outFile, type="output");

    tryCatch({
        thisfunctiondoesnotexist();
      },
      error = function(e) {
        saveError(error=e);
      }
    );

    sink(NULL, type="message");
    sink(NULL, type="output");

    out_conn <- connect2outdb();

    # Get the results
    results <- DBI::dbGetQuery(out_conn, paste("select * from job_result where job_id =", DBI::dbQuoteString(out_conn, job_id)));
    data <- results[1,'data'];
    error <- results[1,'error'];

    expect_match(error, '.*thisfunctiondoesnotexist.*');

    print("[ok]");
});
