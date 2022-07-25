## register traffic accident data to database

# create a connection to the database
source("R/fun/db_connect.R")
conn <- db_connect("config/database.yml")

DBI::dbWithTransaction(conn, {
  
  # create the tables
  source("R/fun/db_execute.R")
  if (!DBI::dbExistsTable(conn, "accidents")) {
    db_execute(conn, "sql/ddl/accidents.sql")
  }
  if (!DBI::dbExistsTable(conn, "parties")) {
    db_execute(conn, "sql/ddl/parties.sql")
  }
  
  # register the data for each year
  source("R/fun/db_import_traffic_accidents.R")
  db_import_traffic_accidents(conn, "data-raw/traffic-accidents/2009.xlsx")
  db_import_traffic_accidents(conn, "data-raw/traffic-accidents/2010.xlsx")
  db_import_traffic_accidents(conn, "data-raw/traffic-accidents/2011.xlsx")
  db_import_traffic_accidents(conn, "data-raw/traffic-accidents/2012.xlsx")
  db_import_traffic_accidents(conn, "data-raw/traffic-accidents/2013.xlsx")
  db_import_traffic_accidents(conn, "data-raw/traffic-accidents/2014.xlsx")
  db_import_traffic_accidents(conn, "data-raw/traffic-accidents/2015.xlsx")
  db_import_traffic_accidents(conn, "data-raw/traffic-accidents/2016.xlsx")
  db_import_traffic_accidents(conn, "data-raw/traffic-accidents/2017.xlsx")
  db_import_traffic_accidents(conn, "data-raw/traffic-accidents/2018.xlsx")
  db_import_traffic_accidents(conn, "data-raw/traffic-accidents/2019-2020.xlsx")
  
})

# disconnect from database
dbDisconnect(conn)
