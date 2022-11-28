## extract the information of the parties involved in the traffic accident 
## from the provided data

extract_parties <- function(data) {
  data |>
    dplyr::select(
      accident_id      = `■本票番号（共通）_本票番号`,
      car_id           = `■当事車番号_当事車番号`,
      passenger_id     = `□同乗者番号_同乗者番号`,
      party_rank       = `■乗車別_乗車別名称`,
      violation_type   = `■法令違反_法令違反中種別名称`,
      violation_detail = `■法令違反_法令違反名称`,
      cause_road       = `□事故原因_道路環境的原因名称`,
      cause_car        = `□事故原因_車両的原因名称`,
      cause_human      = `□事故原因_人的原因名称`,
      action_type      = `■行動類型_行動類型名称`,
      move_direction   = `□本票（当事者）_進行方向`,
      car_light_state  = `□本票（当事者）_ライト点灯状況`,
      party_type       = `■当事者種別_当事者大種別名称`,
      party_subtype    = `■当事者種別_当事者中種別名称`,
      party_subsubtype = `■当事者種別_当事者種別名称`,
      car_tire         = `□本票（当事者）_タイヤ等の状況名称`,
      use_type         = `■用途_用途別中種別名称`,
      use_detail       = `■用途_用途別名称`,
      injured_part     = `■人身損傷主部位_負傷主部位名称`,
      injury_level     = `□負傷程度_負傷程度名称`,
      seat_belt        = `□本票（当事者）_シートベルト名称`,
      helmet           = `□本票（当事者）_ヘルメット名称`,
      air_bag          = `□本票（当事者）_エアバック名称`,
      side_air_bag     = `□本票（当事者）_サイドエアバック名称`,
      alcohol_intake   = `□飲酒運転_飲酒運転名称`,
      cell_phone       = `□本票（当事者）_携帯電話名称`,
      car_nav_system   = `□本票（当事者）_カーナビ名称`,
      critical_speed   = `□本票（当事者）_危険認知速度名称`,
      party_gender     = `■当事者_性別名称`,
      party_age        = `■当事者_年齢`,
      home_prefecture  = `□居住_居住県名称`,
      home_address     = `□居住_居住市区町村名称`,
      home_distance    = `□本票（当事者）_自宅距離名称`,
      party_job        = `□職業_職業名称`,
      purpose          = `■通行目的_通行目的名称`,
    ) |>
    purrr::map_df(stringr::str_trim) |>
    dplyr::mutate(party_age = as.integer(party_age))
}
