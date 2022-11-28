#' extract the specified archive file to a temporary directory
#' 
#' @param zip_path path of zip file to unzip
#' @param dir_name target directory
#' @param charset  character encoding for Windows archives, default is Shift_JIS 
unzip_to_temp <- function(zip_path, dir_name, charset = "Shift_JIS") {

  # create a temporary directory for unzip
  temp_dir <- str_c(path_temp(), dir_name, sep = "/")
  if(dir_exists(temp_dir)) dir_delete(temp_dir)
  dir_create(temp_dir)

  # unzip the archive file
  case_when(
    Sys.info()["sysname"] == "Windows" ~
      "powershell -command Expand-Archive {zip_path} {temp_dir} -Force",
    Sys.info()["sysname"] == "Linux" ~
      "unzip -O {charset} {zip_path} -d {temp_dir}"
  ) |>
    str_glue() |>
    system()

  return(temp_dir)
}
