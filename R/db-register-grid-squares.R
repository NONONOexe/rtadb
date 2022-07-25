## register Japanese region grid square data to database

# tidy data
first_grid_squares <-
  jpmesh::administration_mesh(23, "80") |>
  dplyr::rename(first_grid_square_code = meshcode)

second_grid_squares <-
  jpmesh::administration_mesh(23, "10") |>
  dplyr::transmute(
    second_grid_square_code = meshcode,
    first_grid_square_code  = stringr::str_sub(meshcode, 1L, 4L),
    geometry
  )

basic_grid_squares <-
  jpmesh::administration_mesh(23, "1") |>
  dplyr::transmute(
    basic_grid_square_code = meshcode,
    second_grid_square_code   = stringr::str_sub(meshcode, 1L, 6L),
    geometry
  )

half_grid_squares <-
  jpmesh::administration_mesh(23, "0.5") |>
  dplyr::transmute(
    half_grid_square_code     = meshcode,
    basic_grid_square_code = stringr::str_sub(meshcode, 1L, 8L),
    geometry
  )

# connect the database
source("R/fun/db_connect.R")
conn <- db_connect("config/database.yml")

# create and register the data sets
source("R/fun/db_execute.R")
DBI::dbWithTransaction(conn, {
  
  # first grid squares
  if (!DBI::dbExistsTable(conn, "first_grid_squares")) {
    db_execute(conn, "sql/ddl/first_grid_squares.sql")
  }
  DBI::dbWriteTable(conn      = conn,
                    name      = "first_grid_squares",
                    value     = first_grid_squares,
                    row.names = FALSE,
                    overwrite = FALSE,
                    append    = TRUE)
  
  # second grid squares
  if (!DBI::dbExistsTable(conn, "second_grid_squares")) {
    db_execute(conn, "sql/ddl/second_grid_squares.sql")
  }
  DBI::dbWriteTable(conn      = conn,
                    name      = "second_grid_squares",
                    value     = second_grid_squares,
                    row.names = FALSE,
                    overwrite = FALSE,
                    append    = TRUE)
  
  # standard grid squares
  if (!DBI::dbExistsTable(conn, "basic_grid_squares")) {
    db_execute(conn, "sql/ddl/basic_grid_squares.sql")
  }
  DBI::dbWriteTable(conn      = conn,
                    name      = "basic_grid_squares",
                    value     = basic_grid_squares,
                    row.names = FALSE,
                    overwrite = FALSE,
                    append    = TRUE)
  
  # half grid squares
  if (!DBI::dbExistsTable(conn, "half_grid_squares")) {
    db_execute(conn, "sql/ddl/half_grid_squares.sql")
  }
  DBI::dbWriteTable(conn      = conn,
                    name      = "half_grid_squares",
                    value     = half_grid_squares,
                    row.names = FALSE,
                    overwrite = FALSE,
                    append    = TRUE)
  
})

# disconnect from the database
RPostgres::dbDisconnect(conn)
