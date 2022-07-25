## write traffic volume measurement points 
## from the specified ZIP file to the database

db_import_traffic_volume_points <- function(path, conn) {
  # create a temporary directory for unzip
  source("R/fun/unzip_to_temp.R", local = TRUE)
  temp_dir <- unzip_to_temp(path, "traffic-volume-points")
  
  # list the csv file path
  csv_file <- fs::dir_ls(temp_dir,
                         recurse = TRUE,
                         type    = "file",
                         glob    = "*.csv")[1]
  
  # target columns
  keys <- c(`計測地点番号`     = "point_id",
            `計測地点名`       = "point_name",
            `経度`             = "lon",
            `緯度`             = "lat",
            
            # NOT used
            `情報源コード`     = "information_code",
            `２次メッシュ番号` = "second_mesh_code",
            `UTMSリンク番号`   = "link_number")
  
  # load the data
  traffic_volume_points <-
    
    # read traffic volume measurement point data
    readr::read_csv(csv_file,
                    col_types      = readr::cols(.default = "c"),
                    locale         = readr::locale(encoding = "shift_jis"),
                    skip           = 1,
                    name_repair    = ~ dplyr::recode(., !!!keys),
                    show_col_types = FALSE,
                    lazy           = FALSE) |>
    
    # select the required items and exclude invalid records.
    dplyr::select(point_id, point_name, lon, lat) |>
    dplyr::distinct(point_id, .keep_all = TRUE) |>
    tidyr::drop_na() |>
    
    # generate geometry from coordinates
    sf::st_as_sf(coords = c("lon", "lat"), crs = 4326)
  
  # delete the temporary directory
  fs::dir_delete(temp_dir)

  # register the traffic volume point data set
  DBI::dbWriteTable(conn      = conn,
                    name      = "traffic_volume_points",
                    value     = traffic_volume_points,
                    row.names = FALSE,
                    overwrite = FALSE,
                    append    = TRUE)
  
  return(invisible())
}
