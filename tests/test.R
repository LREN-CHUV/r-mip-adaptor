# how to name? DBI
# remove irelevant and add the relevant ones
# save error

rm(list = ls())
source("R/fetchData.R")
source("R/connect2indb.R")
source("R/connect2outdb.R")
source("R/disconnectdbs.R")
source("R/saveResults.R")
Sys.setenv(
  PARAM_query   = "SELECT * FROM iris",
  IN_DBI_DRIVER = "PostgreSQL",
  IN_DBI_DBNAME = "data",
  IN_DBI_HOST   = "localhost",
  IN_DBI_PORT   = 5432,
  IN_DBI_USER   = "data",
  IN_DBI_PASSWORD = "data",
  OUT_DBI_DRIVER = "PostgreSQL",
  OUT_DBI_DBNAME = "woken",
  OUT_DBI_HOST   = "localhost",
  OUT_DBI_PORT   = 5432,
  OUT_DBI_USER   = "woken",
  OUT_DBI_PASSWORD = "woken")

library(RPostgreSQL)
library(jsonlite)

connect2indb()
dbExistsTable(in_conn, "sample_data");
connect2outdb()
dbListTables(out_conn)

ExistsTable(out_conn, "sample_data");
data_in <- fetchData()
saveResults(results = data_in, shape = "r_dataframe_columns")

disconnectdbs()
