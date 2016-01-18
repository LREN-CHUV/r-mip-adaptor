context("Local");

library(hbpjdbcconnect);

test_that("We can read data from the local database and store it back as results", {

	d <- fetchData();

    expect_equal(nrow(d), 3);
    expect_equal(ncol(d), 3);
    expect_equal(d[1, "feature_name"], "Hippocampus_L");

	saveResults(d);

    print("[ok]");
});

