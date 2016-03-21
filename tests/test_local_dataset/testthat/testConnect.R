context("Local");

library(hbpjdbcconnect);

test_that("We can read data from the local database and store it back as results that can be aggregated on the Federation", {
    job_id <- "001";
    Sys.setenv(JOB_ID = job_id);
    Sys.setenv(NODE = "local");
    Sys.setenv(PARAM_query = "select * from brain_feature");
    Sys.setenv(OUT_FORMAT = "INTERMEDIATE_RESULTS");

    d <- fetchData();

    expect_equal(nrow(d), 3);
    expect_equal(ncol(d), 3);
    expect_equal(d[1, "feature_name"], "Hippocampus_L");

    saveResults(d);

    connect2outdb();

    # Get the results
    results <- RJDBC::dbGetQuery(out_conn, "select * from job_result where job_id = ?", job_id);
    data <- results[1,'data'];

    expect_equal(data, "[{\"id\":\"10247\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0083559},{\"id\":\"10247\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0084571},{\"id\":\"10011\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0090518}]");

    # Read the results back as if we were on the Federation

    Sys.setenv(PARAM_query = paste("select * from job_result where job_id=",job_id,"", sep="'"));
    Sys.setenv(IN_FORMAT = "INTERMEDIATE_RESULTS");
    recovered <- fetchData(conn = out_conn);
    Sys.setenv(IN_FORMAT = "OTHER");

    expect_equal(recovered, d);

    print("[ok]");
});

test_that("We can read data from the local database and store it back as results ready to be used on the frontend", {
    job_id <- "002";
    Sys.setenv(JOB_ID = job_id);
    Sys.setenv(NODE = "local");
    Sys.setenv(PARAM_query = "select * from brain_feature");
    Sys.setenv(IN_FORMAT = "OTHER");
    Sys.setenv(OUT_FORMAT="PRESENTATION");

    d <- fetchData();

    expect_equal(nrow(d), 3);
    expect_equal(ncol(d), 3);
    expect_equal(d[1, "feature_name"], "Hippocampus_L");

    saveResults(d);

    connect2outdb();

    # Get the results
    results <- RJDBC::dbGetQuery(out_conn, "select * from job_result where job_id = ?", job_id);
    data <- results[1,'data'];

    expect_equal(data, "{\"id\":[\"10247\",\"10247\",\"10011\"],\"feature_name\":[\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\"],\"tissue1_volume\":[0.0083559,0.0084571,0.0090518]}");

    print("[ok]");
});

test_that("We can store a list containing a vector and a dataset as results that can be aggregated on the Federation", {
    job_id <- "003";
    Sys.setenv(JOB_ID = job_id);
    Sys.setenv(NODE = "local");
    Sys.setenv(IN_FORMAT = "OTHER");
    Sys.setenv(OUT_FORMAT="INTERMEDIATE_RESULTS");

    df <- data.frame(a=c('a','b','c'), b=c(1,2,3));
    d <- list(var1 = c(1,2,3), var2 = df);

    saveResults(d);

    connect2outdb();

    job_id <- Sys.getenv("JOB_ID");

    # Get the results
    results <- RJDBC::dbGetQuery(out_conn, "select * from job_result where job_id = ?", job_id);
    data <- results[1,'data'];

    expect_equal(data, "{\"var1\":[1,2,3],\"var2\":[{\"a\":\"a\",\"b\":1},{\"a\":\"b\",\"b\":2},{\"a\":\"c\",\"b\":3}]}");

    Sys.setenv(PARAM_query = paste("select * from job_result where job_id=",job_id,"", sep="'"));
    Sys.setenv(IN_FORMAT = "INTERMEDIATE_RESULTS");
    recovered <- fetchData(conn = out_conn);
    Sys.setenv(IN_FORMAT = "OTHER");

    # TODO: type differences in the nested dataframe to resolve
    #    Component “var2”: Component “a”: target is character, current is factor
    # expect_equal(recovered, d);

    print("[ok]");
});

test_that("We can store a list containing a vector and a dataset as results ready to be used on the frontend", {
    job_id <- "004";
    Sys.setenv(JOB_ID = job_id);
    Sys.setenv(NODE = "local");
    Sys.setenv(OUT_FORMAT="PRESENTATION");

    df <- data.frame(a=c('a','b','c'), b=c(1,2,3));
    d <- list(var1 = c(1,2,3), var2 = df);

    saveResults(d);

    connect2outdb();

    job_id <- Sys.getenv("JOB_ID");

    # Get the results
    results <- RJDBC::dbGetQuery(out_conn, "select * from job_result where job_id = ?", job_id);
    data <- results[1,'data'];

    expect_equal(data, "{\"var1\":[1,2,3],\"var2\":{\"a\":[\"a\",\"b\",\"c\"],\"b\":[1,2,3]}}");

    print("[ok]");
});
