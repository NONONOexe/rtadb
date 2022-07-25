## create a connection to the database

db_connect <- function(config_file = "config/database.yml") {
  if(!fs::file_exists(config_file)) {
    # read information about database connection
    host <- readline("host name(or ip address): ")
    port <- readline("port: ")
    user <- readline("user name: ")
    pass <- readline("password: ")
  } else {
    config <- yaml::read_yaml(config_file)
    host <- config$host
    port <- config$port
    user <- config$user
    pass <- config$pass
  }

  # connect to the database of traffic accident analysis
  conn <- DBI::dbConnect(RPostgres::Postgres(),
                         user = user,
                         pass = pass,
                         host = host,
                         port = port,
                         dbname = "traffic_accident_database")
  
  return(conn)
}
