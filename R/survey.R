library(pdftools)



# 2021年の交通事故データ
traffic_accidents <- readxl::read_excel("data-raw/traffic-accidents/2021.xlsx",
                                        trim_ws = TRUE,
                                        .name_repair = ~ make.unique(.x, "_"))

police_office <- traffic_accidents |>
  dplyr::select(`□警察署名_警察署`,
                `■発生警察署（共通）_発生警察署名称`,
                `■発生警察署（共通）_発生警察署中種別名称`) |>
  dplyr::distinct()

injury_pattern <- traffic_accidents |>
  dplyr::select(`■事故内容_事故内容名称`,
                `■事故内容_事故内容中種別名称`) |>
  dplyr::distinct()

traffic_accidents |>
  dplyr::select(`□発生場所_市区町村名称`,
                `□発生場所_市区町村名称（大字出力）`) |>
  dplyr::distinct()

traffic_accidents |>
  dplyr::select(#`■路線_路線種別コード`,
                #`■路線_路線中種別名称`,
                `■路線_路線名`,
                ) |>
  dplyr::distinct() -> test

# 警察庁オープンデータ 交通事故データ コード仕様書
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

# 警察署等コード
police_office_codes <-
  extract_table(page = 3:20,
                col  = c("prefecture_code",
                         "police_office_code",
                         "prefecture_name",
                         "police_office_name")) |>
  dplyr::select(!prefecture_name)

# ---
police_office |>
  dplyr::full_join(police_office_codes |>
                     dplyr::filter(prefecture_code == 54),
                   by = c("□警察署名_警察署" = "police_office_code")) -> check

enc <- readr::locale(encoding = "Shift_JIS")
honhyo <- readr::read_csv("data-raw/traffic-accidents/honhyo_2021.csv", locale = enc)
honhyo <- honhyo |> dplyr::filter(都道府県コード == 54)


kyotu <- honhyo |>
  dplyr::mutate(`本票番号` = paste0(警察署等コード, 2021, 本票番号)) |>
  dplyr::inner_join(traffic_accidents, by = c("本票番号" = "■本票番号（共通）_本票番号"))
kyotu |>
  dplyr::select(`路線コード`,
                `■路線_路線大種別名称`,
                `■路線_路線中種別名称`,
                `■路線_路線名`) |>
  dplyr::distinct() |>
  dplyr::arrange(`路線コード`) -> rosen
kyotu |>
  dplyr::select(`地点　緯度（北緯）`,
                `地点　経度（東経）`,
                `□地図情報_Ｘ座標`,
                `□地図情報_Ｙ座標`) |>
  dplyr::distinct()

length(unique(rosen$路線コード))
rosen |>
  dplyr::group_by(`路線コード`) |>
  dplyr::filter(1 < dplyr::n())

kyotu |>
  dplyr::select(`事故類型`,
                `■事故類型_事故類型大種別名称`,
                `■事故類型_事故類型`,
                `■事故類型_事故類型中種別名称`,
                `■事故類型_事故類型名称`) |>
  dplyr::distinct() |>
  dplyr::arrange(`事故類型`, `■事故類型_事故類型`) -> test
