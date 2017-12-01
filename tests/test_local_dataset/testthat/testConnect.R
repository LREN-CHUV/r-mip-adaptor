context("Local");

library(rmipadaptor);

test_that("We can read data from the local database and store it back as results that can be aggregated on the Federation", {
    job_id <- "001";
    Sys.setenv(JOB_ID = job_id);
    Sys.setenv(NODE = "local");
    Sys.setenv(PARAM_query = "select * from brain_feature");
    Sys.setenv(OUT_FORMAT = "PARTIAL_RESULTS");

    d <- fetchData();

    expect_equal(nrow(d), 100);
    expect_equal(ncol(d), 3);
    expect_equal(d[1, "feature_name"], "Hippocampus_L");

    saveResults(d);

    connect2outdb();

    # Get the results
    results <- DBI::dbGetQuery(out_conn, paste("select * from job_result where job_id =", DBI::dbQuoteString(out_conn, job_id)));
    data <- results[1,'data'];

    expect_equal(data, "[{\"id\":\"10247\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0083559},{\"id\":\"10247\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0084571},{\"id\":\"10011\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0090518},{\"id\":\"10011\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0089223},{\"id\":\"10249\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0084077},{\"id\":\"10249\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0082491},{\"id\":\"10027\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0077537},{\"id\":\"10027\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0078314},{\"id\":\"10252\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0090858},{\"id\":\"10252\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0088347},{\"id\":\"10040\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0090243},{\"id\":\"10040\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0092456},{\"id\":\"10251\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.00931},{\"id\":\"10251\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0095098},{\"id\":\"10043\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0093191},{\"id\":\"10043\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0087411},{\"id\":\"10253\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.01018},{\"id\":\"10253\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.010015},{\"id\":\"10044\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0094314},{\"id\":\"10044\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0094413},{\"id\":\"10254\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0084853},{\"id\":\"10254\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0089951},{\"id\":\"10048\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0096006},{\"id\":\"10048\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0098262},{\"id\":\"10284\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0099415},{\"id\":\"10284\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0097991},{\"id\":\"10049\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0094648},{\"id\":\"10049\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0094423},{\"id\":\"10285\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.011463},{\"id\":\"10285\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.011352},{\"id\":\"10053\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.010416},{\"id\":\"10053\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0099714},{\"id\":\"10286\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0099504},{\"id\":\"10286\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0097052},{\"id\":\"10054\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.01063},{\"id\":\"10054\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.010287},{\"id\":\"10291\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0097218},{\"id\":\"10291\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0095365},{\"id\":\"10060\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0085309},{\"id\":\"10060\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0087288},{\"id\":\"10295\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0086215},{\"id\":\"10295\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0088408},{\"id\":\"10067\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.010377},{\"id\":\"10067\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.010362},{\"id\":\"10301\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.010393},{\"id\":\"10301\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.01047},{\"id\":\"10069\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.010018},{\"id\":\"10069\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0099619},{\"id\":\"10302\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0088861},{\"id\":\"10302\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0090068},{\"id\":\"10075\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0077614},{\"id\":\"10075\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0078762},{\"id\":\"10303\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0090281},{\"id\":\"10303\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0093899},{\"id\":\"10076\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0093545},{\"id\":\"10076\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0090486},{\"id\":\"10304\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.010076},{\"id\":\"10304\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.010295},{\"id\":\"10079\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.010038},{\"id\":\"10079\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.01004},{\"id\":\"10305\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0093198},{\"id\":\"10305\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0092416},{\"id\":\"10082\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0073469},{\"id\":\"10082\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.007683},{\"id\":\"10313\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.008028},{\"id\":\"10313\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0083182},{\"id\":\"10101\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0078333},{\"id\":\"10101\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0075796},{\"id\":\"10323\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0086435},{\"id\":\"10323\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0087596},{\"id\":\"10103\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.01026},{\"id\":\"10103\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0097726},{\"id\":\"10324\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0094744},{\"id\":\"10324\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0099447},{\"id\":\"10104\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0093827},{\"id\":\"10104\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0091295},{\"id\":\"10327\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0093696},{\"id\":\"10327\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0093498},{\"id\":\"10105\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0085843},{\"id\":\"10105\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0082892},{\"id\":\"10328\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0068206},{\"id\":\"10328\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0073848},{\"id\":\"10109\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.008455},{\"id\":\"10109\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0080623},{\"id\":\"10329\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0084326},{\"id\":\"10329\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.008415},{\"id\":\"10114\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.010067},{\"id\":\"10114\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.010079},{\"id\":\"10330\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0089815},{\"id\":\"10330\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.008962},{\"id\":\"10123\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0096616},{\"id\":\"10123\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0095091},{\"id\":\"10331\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0090053},{\"id\":\"10331\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0093164},{\"id\":\"10129\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0097288},{\"id\":\"10129\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.009705},{\"id\":\"10340\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0095656},{\"id\":\"10340\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0095769},{\"id\":\"10130\",\"feature_name\":\"Hippocampus_L\",\"tissue1_volume\":0.0080631},{\"id\":\"10130\",\"feature_name\":\"Hippocampus_R\",\"tissue1_volume\":0.0081479}]");

    # Read the results back as if we were on the Federation

    Sys.setenv(PARAM_query = paste("select * from job_result where job_id=",job_id,"", sep="'"));
    Sys.setenv(IN_FORMAT = "PARTIAL_RESULTS");
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

    expect_equal(data, "{\"id\":[\"10247\",\"10247\",\"10011\",\"10011\",\"10249\",\"10249\",\"10027\",\"10027\",\"10252\",\"10252\",\"10040\",\"10040\",\"10251\",\"10251\",\"10043\",\"10043\",\"10253\",\"10253\",\"10044\",\"10044\",\"10254\",\"10254\",\"10048\",\"10048\",\"10284\",\"10284\",\"10049\",\"10049\",\"10285\",\"10285\",\"10053\",\"10053\",\"10286\",\"10286\",\"10054\",\"10054\",\"10291\",\"10291\",\"10060\",\"10060\",\"10295\",\"10295\",\"10067\",\"10067\",\"10301\",\"10301\",\"10069\",\"10069\",\"10302\",\"10302\",\"10075\",\"10075\",\"10303\",\"10303\",\"10076\",\"10076\",\"10304\",\"10304\",\"10079\",\"10079\",\"10305\",\"10305\",\"10082\",\"10082\",\"10313\",\"10313\",\"10101\",\"10101\",\"10323\",\"10323\",\"10103\",\"10103\",\"10324\",\"10324\",\"10104\",\"10104\",\"10327\",\"10327\",\"10105\",\"10105\",\"10328\",\"10328\",\"10109\",\"10109\",\"10329\",\"10329\",\"10114\",\"10114\",\"10330\",\"10330\",\"10123\",\"10123\",\"10331\",\"10331\",\"10129\",\"10129\",\"10340\",\"10340\",\"10130\",\"10130\"],\"feature_name\":[\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\",\"Hippocampus_L\",\"Hippocampus_R\"],\"tissue1_volume\":[0.0083559,0.0084571,0.0090518,0.0089223,0.0084077,0.0082491,0.0077537,0.0078314,0.0090858,0.0088347,0.0090243,0.0092456,0.00931,0.0095098,0.0093191,0.0087411,0.01018,0.010015,0.0094314,0.0094413,0.0084853,0.0089951,0.0096006,0.0098262,0.0099415,0.0097991,0.0094648,0.0094423,0.011463,0.011352,0.010416,0.0099714,0.0099504,0.0097052,0.01063,0.010287,0.0097218,0.0095365,0.0085309,0.0087288,0.0086215,0.0088408,0.010377,0.010362,0.010393,0.01047,0.010018,0.0099619,0.0088861,0.0090068,0.0077614,0.0078762,0.0090281,0.0093899,0.0093545,0.0090486,0.010076,0.010295,0.010038,0.01004,0.0093198,0.0092416,0.0073469,0.007683,0.008028,0.0083182,0.0078333,0.0075796,0.0086435,0.0087596,0.01026,0.0097726,0.0094744,0.0099447,0.0093827,0.0091295,0.0093696,0.0093498,0.0085843,0.0082892,0.0068206,0.0073848,0.008455,0.0080623,0.0084326,0.008415,0.010067,0.010079,0.0089815,0.008962,0.0096616,0.0095091,0.0090053,0.0093164,0.0097288,0.009705,0.0095656,0.0095769,0.0080631,0.0081479]}");

    print("[ok]");
});

test_that("We can store a list containing a vector and a dataset as results that can be aggregated on the Federation", {
    job_id <- "003";
    Sys.setenv(JOB_ID = job_id);
    Sys.setenv(NODE = "local");
    Sys.setenv(IN_FORMAT = "OTHER");
    Sys.setenv(OUT_FORMAT="PARTIAL_RESULTS");

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
    Sys.setenv(IN_FORMAT = "PARTIAL_RESULTS");
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
