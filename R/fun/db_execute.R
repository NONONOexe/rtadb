## executes SQL for the specified file

db_execute <- function(conn, file) {
  readr::read_file(file) |>
    stringr::str_remove_all("--.*\\r{0,1}\\n") |>
    stringr::str_split(";\\r{0,1}\\n", simplify = TRUE) |>
    stringr::str_replace_all("\\r{0,1}\\n", " ") |>
    purrr::discard(~ .x == "") |>
    purrr::walk(~ DBI::dbExecute(conn, .x))

  return(invisible())
}
