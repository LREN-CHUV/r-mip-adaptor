context("Local");

library(hbpjdbcconnect);

test_that("We can read data from the local database and store it back as results", {

	d <- fetchData();

    expect_equal(nrow(d), 3);
    expect_equal(ncol(d), 3);
    expect_equal(d[1, "feature_name"], "Hippocampus_L");

	saveResults(d);

    connect2outdb();

    job_id <- Sys.getenv("JOB_ID");

    # Get the results
    results <- RJDBC::dbGetQuery(out_conn, "select * from job_result where job_id = ?", job_id);
    data <- results[1,'data'];

    if (Sys.getenv("OUT_FORMAT") == "INTERMEDIATE_RESULTS") {
        expect_equal(data, "[{\"id\":\"10247\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0083559},{\"id\":\"10247\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0084571},{\"id\":\"10011\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0090518}]");
    } else {
        expect_equal(data, "{\"id\":[\"10247\",\"10247\",\"10011\"],\"feature_name\":[\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\"],\"tissue1_volume\":[0.0083559,0.0084571,0.0090518]}");
    }

    print("[ok]");
});

