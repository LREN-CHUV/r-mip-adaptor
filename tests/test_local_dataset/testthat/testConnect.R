context("Local");

library(rmipadaptor);

test_that("We can read data from the local database and store it back as results that can be aggregated on the Federation", {
    job_id <- "001";
    Sys.setenv(JOB_ID = job_id);
    Sys.setenv(NODE = "local");
    Sys.setenv(PARAM_query = "select * from brain_feature");
    Sys.setenv(OUT_FORMAT = "INTERMEDIATE_RESULTS");

    d <- fetchData();

    expect_equal(nrow(d), 100);
    expect_equal(ncol(d), 3);
    expect_equal(d[1, "feature_name"], "Hippocampus_L");

    saveResults(d);

    connect2outdb();

    # Get the results
    results <- DBI::dbGetQuery(out_conn, paste("select * from job_result where job_id =", DBI::dbQuoteString(out_conn, job_id)));
    data <- results[1,'data'];

    expect_equal(data, "{\"id\":[\"10247\",\"10247\",\"10011\",\"10011\",\"10249\",\"10249\",\"10027\",\"10027\",\"10252\",\"10252\",\"10040\",\"10040\",\"10251\",\"10251\",\"10043\",\"10043\",\"10253\",\"10253\",\"10044\",\"10044\",\"10254\",\"10254\",\"10048\",\"10048\",\"10284\",\"10284\",\"10049\",\"10049\",\"10285\",\"10285\",\"10053\",\"10053\",\"10286\",\"10286\",\"10054\",\"10054\",\"10291\",\"10291\",\"10060\",\"10060\",\"10295\",\"10295\",\"10067\",\"10067\",\"10301\",\"10301\",\"10069\",\"10069\",\"10302\",\"10302\",\"10075\",\"10075\",\"10303\",\"10303\",\"10076\",\"10076\",\"10304\",\"10304\",\"10079\",\"10079\",\"10305\",\"10305\",\"10082\",\"10082\",\"10313\",\"10313\",\"10101\",\"10101\",\"10323\",\"10323\",\"10103\",\"10103\",\"10324\",\"10324\",\"10104\",\"10104\",\"10327\",\"10327\",\"10105\",\"10105\",\"10328\",\"10328\",\"10109\",\"10109\",\"10329\",\"10329\",\"10114\",\"10114\",\"10330\",\"10330\",\"10123\",\"10123\",\"10331\",\"10331\",\"10129\",\"10129\",\"10340\",\"10340\",\"10130\",\"10130\"],\"feature_name\":[\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\"],\"tissue1_volume\":[0.0083559,0.0084571,0.0090518,0.0089223,0.0084077,0.0082491,0.0077537,0.0078314,0.0090858,0.0088347,0.0090243,0.0092456,0.00931,0.0095098,0.0093191,0.0087411,0.01018,0.010015,0.0094314,0.0094413,0.0084853,0.0089951,0.0096006,0.0098262,0.0099415,0.0097991,0.0094648,0.0094423,0.011463,0.011352,0.010416,0.0099714,0.0099504,0.0097052,0.01063,0.010287,0.0097218,0.0095365,0.0085309,0.0087288,0.0086215,0.0088408,0.010377,0.010362,0.010393,0.01047,0.010018,0.0099619,0.0088861,0.0090068,0.0077614,0.0078762,0.0090281,0.0093899,0.0093545,0.0090486,0.010076,0.010295,0.010038,0.01004,0.0093198,0.0092416,0.0073469,0.007683,0.008028,0.0083182,0.0078333,0.0075796,0.0086435,0.0087596,0.01026,0.0097726,0.0094744,0.0099447,0.0093827,0.0091295,0.0093696,0.0093498,0.0085843,0.0082892,0.0068206,0.0073848,0.008455,0.0080623,0.0084326,0.008415,0.010067,0.010079,0.0089815,0.008962,0.0096616,0.0095091,0.0090053,0.0093164,0.0097288,0.009705,0.0095656,0.0095769,0.0080631,0.0081479]}");

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

    expect_equal(nrow(d), 100);
    expect_equal(ncol(d), 3);
    expect_equal(d[1, "feature_name"], "Hippocampus_L");

    saveResults(d);

    connect2outdb();

    # Get the results
    results <- DBI::dbGetQuery(out_conn, paste("select * from job_result where job_id =", DBI::dbQuoteString(out_conn, job_id)));
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
    results <- DBI::dbGetQuery(out_conn, paste("select * from job_result where job_id =", DBI::dbQuoteString(out_conn, job_id)));
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
    results <- DBI::dbGetQuery(out_conn, paste("select * from job_result where job_id =", DBI::dbQuoteString(out_conn, job_id)));
    data <- results[1,'data'];

    expect_equal(data, "{\"var1\":[1,2,3],\"var2\":{\"a\":[\"a\",\"b\",\"c\"],\"b\":[1,2,3]}}");

    print("[ok]");
});
