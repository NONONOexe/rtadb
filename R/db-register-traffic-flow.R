## register traffic volume data to database

# path of zip file included traffic volume measurement points
path_tvp <- "data-raw/traffic-volume-points/54愛知県.zip"

# path of directory included traffic volumes data files
path_tvr <- "data-raw/traffic-volumes/"

# connect the database
source("R/fun/db_connect.R", local = TRUE)
conn <- db_connect("config/database.yml")

DBI::dbWithTransaction(conn, {
  
  # create the tables
  source("R/fun/db_execute.R")
  if (!DBI::dbExistsTable(conn, "traffic_volume_points")) {
    db_execute(conn, "sql/ddl/traffic_volume_points.sql")
  }
  if (!DBI::dbExistsTable(conn, "traffic_volumes")) {
    db_execute(conn, "sql/ddl/traffic_volumes.sql")
  }
  
  # register the traffic volume measurement points
  source("R/fun/db_import_traffic_volume_points.R", local = TRUE)
  db_import_traffic_volume_points(path_tvp, conn)
  
  # register the traffic volume
  source("R/fun/db_import_traffic_volumes.R", local = TRUE)
  db_import_traffic_volumes_dir(path_tvr, conn)
  
})

# disconnect from the database
dbDisconnect(conn)
