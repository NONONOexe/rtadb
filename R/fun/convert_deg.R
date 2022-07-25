## convert form of latitude and longitude from DMS to DEG

convert_deg <- function(dms) {
  dms_str <- dms |>
    as.numeric() |>
    scales::number(accuracy = .00000001, digits = 8)
  
  d <- dms_str |>
    stringr::str_replace("^(.+)\\..{8}$", "\\1") |>
    stringr::str_replace_na(0)
  m <- dms_str |>
    stringr::str_replace("^.+\\.(.{2}).{6}$", "\\1") |>
    stringr::str_replace_na(0)
  s <- dms_str |>
    stringr::str_replace("^.+\\..{2}(.{2})(.{4})$", "\\1.\\2") |>
    stringr::str_replace_na(0)
  
  deg <- dplyr::if_else(is.na(dms), dms, celestial::dms2deg(d, m, s))
  
  return(deg)
}
