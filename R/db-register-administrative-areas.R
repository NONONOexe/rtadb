## register administrative area data to database

# load the data
# administrative area data, see:
# https://www.pref.aichi.jp/soshiki/chiho-sosei/ken-vision-senryaku.html
areas <-
  readr::read_csv("data-raw/administrative-areas/aichi.csv",
                  col_types = readr::cols(.default = "c")) |>
  dplyr::mutate(jpmesh_code = dplyr::coalesce(ward_code, city_code)) |>
  dplyr::inner_join(jpndistrict::jpn_pref(admin_name = "愛知県"),
                    by = c("jpmesh_code" = "city_code")) |>
  sf::st_sf()

# population data, see:
# https://www.e-stat.go.jp/stat-search/files?page=1&layout=datalist&toukei=00200521&tstat=000001049104&cycle=0&tclass1=000001049105&stat_infid=000032143614&tclass2val=0
populations <-
  suppressMessages(readxl::read_xlsx(
    path      = "data-raw/population-census/major_results_2020.xlsx",
    col_types = "text",
    col_names = FALSE,
    skip      = 8
  )) |>
  dplyr::mutate(
    city_code_name = purrr::map(`...2`, stringr::str_split, "_"),
    city_code_name = purrr::map(city_code_name, 1)
  ) |>
  dplyr::mutate(dplyr::across(dplyr::everything(), dplyr::na_if, "-")) |>
  dplyr::transmute(
    city_code                      = purrr::map_chr(city_code_name, 1),
    population_total               = as.integer(`...5`),
    population_male                = as.integer(`...6`),
    population_female              = as.integer(`...7`),
    population_density             = as.double(`...12`),
    age_mean                       = as.double(`...13`),
    age_median                     = as.double(`...14`),
    population_age_under_15        = as.integer(`...15`),
    population_age_15_to_64        = as.integer(`...16`),
    population_age_over_65         = as.integer(`...17`),
    population_age_male_under_15   = as.integer(`...21`),
    population_age_male_15_to_64   = as.integer(`...22`),
    population_age_male_over_65    = as.integer(`...23`),
    population_age_female_under_15 = as.integer(`...27`),
    population_age_female_15_to_64 = as.integer(`...28`),
    population_age_female_over_65  = as.integer(`...29`),
    population_japanese            = as.integer(`...34`),
    population_foreigner           = as.integer(`...35`),
    household_total                = as.integer(`...36`),
    household_general              = as.integer(`...37`),
    household_facility             = as.integer(`...38`)
  )

# tidy data
first_regional_blocks <- areas |>
  dplyr::select(
    first_regional_block_id,
    first_regional_block_name
  ) |>
  dplyr::group_by(
    first_regional_block_id,
    first_regional_block_name
  ) |>
  dplyr::summarise(
    geometry = sf::st_union(geometry) |> sfheaders::sf_remove_holes(),
    .groups  = "drop"
  )

second_regional_blocks <- areas |>
  dplyr::select(
    second_regional_block_id,
    first_regional_block_id,
    second_regional_block_name
  ) |>
  dplyr::group_by(
    second_regional_block_id,
    first_regional_block_id,
    second_regional_block_name
  ) |>
  dplyr::summarise(
    geometry = sf::st_union(geometry) |> sfheaders::sf_remove_holes(),
    .groups  = "drop"
  )

cities <- areas |>
  dplyr::select(
    city_code,
    second_regional_block_id,
    city_name,
    city_kana
  ) |>
  dplyr::group_by(
    city_code,
    second_regional_block_id,
    city_name,
    city_kana
  ) |>
  dplyr::summarise(
    geometry = sf::st_union(geometry) |> sfheaders::sf_remove_holes(),
    .groups  = "drop"
  )

wards <- areas |>
  dplyr::filter(!is.na(ward_code)) |>
  dplyr::select(
    ward_code,
    city_code,
    ward_name,
    ward_kana
  ) |>
  dplyr::group_by(
    ward_code,
    city_code,
    ward_name,
    ward_kana
  ) |>
  dplyr::summarise(
    geometry = sf::st_union(geometry) |> sfheaders::sf_remove_holes(),
    .groups  = "drop"
  )

city_populations <- populations |>
  dplyr::inner_join(cities |>
                      sf::st_drop_geometry() |>
                      dplyr::select(city_code),
                    by = "city_code")

ward_populations <- populations |>
  dplyr::rename(ward_code = city_code) |>
  dplyr::inner_join(wards |>
                      sf::st_drop_geometry() |>
                      dplyr::select(ward_code),
                    by = "ward_code")

# connect the database
source("R/fun/db_connect.R")
conn <- db_connect("config/database.yml")

# create and register the data sets
source("R/fun/db_execute.R")
DBI::dbWithTransaction(conn, {
  
  # first regional blocks
  if (!DBI::dbExistsTable(conn, "first_regional_blocks")) {
    db_execute(conn, "sql/ddl/first_regional_blocks.sql")
  }
  dbWriteTable(conn      = conn,
               name      = "first_regional_blocks",
               value     = first_regional_blocks,
               row.names = FALSE,
               overwrite = FALSE,
               append    = TRUE)

  # second regional blocks
  if (!DBI::dbExistsTable(conn, "second_regional_blocks")) {
    db_execute(conn, "sql/ddl/second_regional_blocks.sql")
  }
  dbWriteTable(conn      = conn,
               name      = "second_regional_blocks",
               value     = second_regional_blocks,
               row.names = FALSE,
               overwrite = FALSE,
               append    = TRUE)
  
  # cities
  if (!DBI::dbExistsTable(conn, "cities")) {
    db_execute(conn, "sql/ddl/cities.sql")
  }
  dbWriteTable(conn      = conn,
               name      = "cities",
               value     = cities,
               row.names = FALSE,
               overwrite = FALSE,
               append    = TRUE)
  
  # wards
  if (!DBI::dbExistsTable(conn, "wards")) {
    db_execute(conn, "sql/ddl/wards.sql")
  }
  dbWriteTable(conn      = conn,
               name      = "wards",
               value     = wards,
               row.names = FALSE,
               overwrite = FALSE,
               append    = TRUE)
  
  # city_populations
  if (!DBI::dbExistsTable(conn, "city_populations")) {
    db_execute(conn, "sql/ddl/city_populations.sql")
  }
  # register the city population data set
  dbWriteTable(conn      = conn,
               name      = "city_populations",
               value     = city_populations,
               row.names = FALSE,
               overwrite = FALSE,
               append    = TRUE)

  # ward_populations
  if (!DBI::dbExistsTable(conn, "ward_populations")) {
    db_execute(conn, "sql/ddl/ward_populations.sql")
  }
  dbWriteTable(conn      = conn,
               name      = "ward_populations",
               value     = ward_populations,
               row.names = FALSE,
               overwrite = FALSE,
               append    = TRUE)

})

# disconnect from the database
RPostgres::dbDisconnect(conn)
