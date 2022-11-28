# install.packages("pdftools")
library(pdftools)

text <- pdftools::pdf_text("codebook_2021.pdf")

extract_table <- function(page = -1, col = c("code", "name")) {
  table <-
    text[page] |>
    purrr::map(stringr::str_split, "\n", simplify = TRUE) |>
    purrr::map(stringr::str_trim) |>
    purrr::flatten_chr() |>
    purrr::discard(~ stringr::str_length(.x) == 0) |>
    purrr::discard(~ length(stringr::str_split(.x, " +", simplify = TRUE)) != length(col)) |>
    purrr::discard(~ is.na(stringr::str_match(.x, "^[0-9]+"))) |>
    tibble::as_tibble() |>
    tidyr::separate(col = value, into = col, sep = " +")
  
  return(table)
}

# 資料区分
document_codes <-
  extract_table(page = 1,
                col  = c("document_code",
                         "document_division"))

# 都道府県コード
prefecture_codes <-
  extract_table(page = 2,
                col  = c("prefecture_code",
                         "prefecture_name"))

# 警察署等コード
police_office <-
  extract_table(page = 3:20,
                col  = c("prefecture_code",
                         "police_office_code",
                         "prefecture_name",
                         "police_office_name")) |>
  dplyr::select(!prefecture_name)

# 事故内容
accident


table(police_office$code)
  

document <- text[1] |>
  stringr::str_split("\n", simplify = TRUE) |>
  purrr::map_chr(stringr::str_trim) |>
  tibble::as_tibble() |>
  dplyr::slice(6:8) |>
  tidyr::separate(col = value, into = c("code", "name"), sep = " +")

# 都道府県コード
prefecture <- text[2] |>
  stringr::str_split("\n", simplify = TRUE) |>
  purrr::map_chr(stringr::str_trim) |>
  tibble::as_tibble() |>
  dplyr::slice(6:56) |>
  tidyr::separate(col = value, into = c("code", "name"), sep = " +")

# 警察署等コード
police_office <- text[3:20] |>
  purrr::map(stringr::str_split, "\n", simplify = TRUE) |>
  purrr::map(stringr::str_trim) |>
  purrr::map(tibble::as_tibble) |>
  purrr::map(s)

text[1] |>
  purrr::map(stringr::str_split, "\n", simplify = TRUE) |>
  purrr::map(stringr::str_trim) |>
  purrr::flatten_chr() |>
  purrr::discard(~ stringr::str_length(.x) == 0) |>
  purrr::discard(~ length(stringr::str_split(.x, " +", simplify = TRUE)) != 2) |>
  purrr::discard(~ is.na(stringr::str_match(.x, "^[0-9]+"))) |>
  tibble::as_tibble() |>
  tidyr::separate(col = value, into = c("code", "name"), sep = " +")
