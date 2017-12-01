context("Federation");

library(rmipadaptor);

test_that("We can read intermediate results from the federation database and store it back as results", {

    Sys.setenv(JOB_ID='003');
    Sys.setenv(PARAM_query="select * from job_result where job_id = '003'");

    d <- fetchData();

    expect_equal(nrow(d), 3);
    expect_equal(ncol(d), 3);
    expect_equal(d[1, "feature_name"], "Hippocampus_L");

    saveResults(d);

    print("[ok]");
});
