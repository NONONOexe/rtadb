## write the specified CSV file to the database

db_import_traffic_volumes_csv <- function(csv_file, conn) {
  # target columns
  keys <-
    c(`時刻`                         = "time",
      `計測地点番号`                 = "point_id",
      `断面交通量`                   = "traffic_volume",
      
      # NOT used
      `計測地点名称`                 = "point_name",
      `情報源コード`                 = "information_code",
      `リンク終端からの距離（×10m）` = "distance_from_link_end",
      `リンク終端からの距離(10m)`    = "distance_from_link_end",
      `2次メッシュコード`            = "second_regional_mesh_code",
      `リンク区分`                   = "link_division",
      `リンクバージョン`             = "link_version",
      `リンク番号`                   = "link_number")
  
  # load the data
  traffic_volumes <-
    
    # read traffic volume data
    readr::read_csv(csv_file,
                    col_types      = readr::cols(.default = "c"),
                    locale         = readr::locale(encoding = "shift_jis"),
                    name_repair    = ~ dplyr::recode(., !!!keys),
                    show_col_types = FALSE,
                    lazy           = FALSE,
                    progress       = FALSE) |>
    
    # select the required items and extract records
    # where the measurement point of that item exists
    dplyr::select(time, point_id, traffic_volume) |>
    dplyr::semi_join(sf::read_sf(conn, "traffic_volume_points"),
                     by = "point_id")
  
  # register the traffic volume data set
  DBI::dbWriteTable(conn      = conn,
                    name      = "traffic_volumes",
                    value     = traffic_volumes,
                    row.names = FALSE,
                    overwrite = FALSE,
                    append    = TRUE)
  
  # registration message
  message(paste0(
    nrow(traffic_volumes)," records registered from ", fs::path_file(csv_file)))
  
  return(invisible())
}


## write the specified zip file to the database

db_import_traffic_volumes <- function(path, conn) {
  # create a temporary directory for unzip
  source("R/fun/unzip_to_temp.R", local = TRUE)
  temp_dir <- unzip_to_temp(path, "traffic-volumes", "UTF-8")
  
  # list the csv file path
  csv_files <- fs::dir_ls(temp_dir,
                          recurse = TRUE,
                          type    = "file",
                          glob    = "*.csv")
  
  # write from a CSV file to a database
  csv_files |> purrr::walk(db_import_traffic_volumes_csv, conn)
  
  # delete a temporary directory
  fs::dir_delete(temp_dir)
  
  return(invisible())
}


## register traffic volume data from each zip file
## in specified directory to the database

db_import_traffic_volumes_dir <- function(dir, conn) {
  # register the data from each zips
  dir_ls(dir, recurse = FALSE, type = "file", glob = "*.zip") |>
    sort(decreasing = FALSE) |>
    walk(db_import_traffic_volumes, conn)
}
