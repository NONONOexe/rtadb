## extract the specified archive file to a temporary directory

unzip_to_temp <- function(zip_path, dir_name) {
  
  # create a temporary directory for unzip
  temp_dir <- stringr::str_c(fs::path_temp(), dir_name, sep = "/")
  if(fs::dir_exists(temp_dir)) fs::dir_delete(temp_dir)
  fs::dir_create(temp_dir)
  
  # unzip the archive file
  system(stringr::str_c("powershell -command Expand-Archive",
                        zip_path,
                        temp_dir,
                        "-Force",
                        sep = " "))
  
  return(temp_dir)
}
