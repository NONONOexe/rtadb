## executes SQL for the specified file

db_execute <- function(conn, file) {
  readr::read_file(file) |>
    stringr::str_remove_all("--(.*)\\r\\n") |>
    stringr::str_split(";\\r\\n", simplify = TRUE) |>
    stringr::str_replace_all("\\r\\n", " ") |>
    purrr::discard(~ .x == "") |>
    purrr::walk(~ DBI::dbExecute(conn, .x))

  return(invisible())
}
