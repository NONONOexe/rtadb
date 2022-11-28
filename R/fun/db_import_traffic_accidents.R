## write data from the Excel file at the specified path to the database

db_import_traffic_accidents <- function(conn, path) {
  # read the original data of traffic accidents
  data <-
    readxl::read_excel(path,
                       trim_ws = TRUE,
                       .name_repair = ~ make.unique(.x, "_")) |>
    dplyr::filter(!is.na(`□地図情報_Ｘ座標`) & !is.na(`□地図情報_Ｙ座標`))
  
  # extract accident data
  source("R/fun/extract_accidents.R", local = TRUE)
  accidents <- data |> extract_accidents()

  # extract party data
  source("R/fun/extract_parties.R", local = TRUE)
  parties <- data |> extract_parties()

  # register the accident data set
  DBI::dbWriteTable(conn      = conn,
                    name      = "accidents",
                    value     = accidents,
                    row.names = FALSE,
                    overwrite = FALSE,
                    append    = TRUE)

  # register the party data set
  DBI::dbWriteTable(conn      = conn,
                    name      = "parties",
                    value     = parties,
                    row.names = FALSE,
                    overwrite = FALSE,
                    append    = TRUE)
  
  return(invisible())
}
