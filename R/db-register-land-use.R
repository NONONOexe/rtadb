## register land use data to database

# load land use categories data
# https://nlftp.mlit.go.jp/kokjo/inspect/landclassification/land/chikei_bunrui.html
source("R/fun/unzip_to_temp.R")
temp_dir <- unzip_to_temp("data-raw/land-use/23.zip", "land-use-categories")

# tidy data
land_use <-
  fs::dir_ls(temp_dir, recurse = TRUE, type = "file", glob = "*.shp") |>
  purrr::pluck(2) |>
  sf::read_sf(options = "ENCODING=CP932") |>
  sf::st_zm() |>
  sf::st_make_valid() |>
  dplyr::group_by(land_use_category = `属性2`) |>
  dplyr::summarise(geometry = sf::st_union(geometry) |> sfheaders::sf_remove_holes()) |>
  sf::st_set_crs(4612) |>
  sf::st_transform(crs = 4326) |>
  tibble::rowid_to_column("land_use_id")

# delete a temporary directory
fs::dir_delete(temp_dir)

# connect the database
source("R/fun/db_connect.R")
conn <- db_connect("config/database.yml")

# execute codes with transaction
DBI::dbWithTransaction(conn, {
  # create the table
  source("R/fun/db_execute.R")
  if (!DBI::dbExistsTable(conn, "land_use")) {
    db_execute(conn, "sql/ddl/land_use.sql")
  }
  
  # register the first regional block data set
  dbWriteTable(conn      = conn,
               name      = "land_use",
               value     = land_use,
               row.names = FALSE,
               overwrite = FALSE,
               append    = TRUE)
})

# disconnect from the database
RPostgres::dbDisconnect(conn)
