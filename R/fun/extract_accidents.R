## extract information on traffic accidents from the provided data

# extract the accident data set from original data.
# if there is not decimal point for latitude/longitude
# (format for 2019-2020), it will be complemented.
extract_accidents <- function(data) {
  # import functions
  source("R/fun/convert_deg.R", local = TRUE)

  # convert day night id to type
  if (!"□昼夜_昼夜名称" %in% names(data) &&
      "□昼夜_昼夜" %in% names(data)) {
    data <- data |>
      dplyr::mutate(
        `□昼夜_昼夜名称` = dplyr::case_when(
          "□昼夜_昼夜" %in% c(3, 8) ~ "明",
          "□昼夜_昼夜" == 4 ~ "昼",
          "□昼夜_昼夜" %in% c(5, 6) ~ "暮",
          "□昼夜_昼夜" == 7 ~ "夜"
        )
      )
  }

  data |>
    dplyr::distinct(`■本票番号（共通）_本票番号`, .keep_all = TRUE) |>
    dplyr::select(
      accident_id        = `■本票番号（共通）_本票番号`,
      occurrence_date    = `■発生_発生年月日`,
      day_of_week        = `■曜日_曜日名称`,
      day_night_type     = `□昼夜_昼夜名称`,
      occurrence_hour    = `□発生時間_発生時`,
      police_office      = `■発生警察署（共通）_発生警察署名称`,
      occurrence_place   = `□発生場所_市区町村名称（大字出力）`,
      latitude           = `□地図情報_Ｘ座標`,
      longitude          = `□地図情報_Ｙ座標`,
      weather            = `■天候_天候名称`,
      road_surface       = `□路面状態_路面状態名称`,
      road_type          = `■路線_路線中種別名称`,
      road_shape         = `□道路形状_道路形状名`,
      road_alignment     = `□道路線形_道路線形中種別名称`,
      carriageway_width  = `■車道幅員_車道幅員名称`,
      traffic_signal     = `■信号機_信号機名称`,
      injury_pattern     = `■事故内容_事故内容名称`,
      fatality           = `□全被害_死者数`,
      severe_injury      = `□全被害_重傷者数`,
      slight_injury      = `□全被害_軽傷者数`,
      impact_type        = `■事故類型_事故類型名称`,
      collision_position = `□衝突地点_衝突地点名称`,
      special_category_1 = `■特殊事故（共通）_特殊事故１名称`,
      special_category_2 = `■特殊事故（共通）_特殊事故２名称`,
      special_category_3 = `■特殊事故（共通）_特殊事故３名称`,
    ) |>
    purrr::map_df(stringr::str_trim) |>
    dplyr::mutate(
      occurrence_date = occurrence_date |> lubridate::ymd(),
      occurrence_hour = occurrence_hour |> as.integer(),
      latitude       = latitude |>
        stringr::str_replace("^([0-9]{3})([0-9]{8})$",
                             "\\1.\\2") |>
        as.numeric(),
      longitude      = longitude |>
        stringr::str_replace("^([0-9]{3})([0-9]{8})$",
                             "\\1.\\2") |>
        as.numeric(),
      fatality       = as.integer(fatality),
      severe_injury  = as.integer(severe_injury),
      slight_injury  = as.integer(slight_injury),
    ) |>
    dplyr::mutate(
      longitude = convert_deg(longitude),
      latitude  = convert_deg(latitude),
    ) |>
    sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
}
