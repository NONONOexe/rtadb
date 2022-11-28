## register administrative area data to database

# load the data
# administrative area data, see:
# https://www.pref.aichi.jp/soshiki/chiho-sosei/ken-vision-senryaku.html
areas <-
  read_csv("data-raw/administrative-areas/aichi.csv",
                  col_types = cols(.default = "c")) |>
  mutate(jpmesh_code = coalesce(ward_code, city_code)) |>
  inner_join(jpn_pref(admin_name = "愛知県"),
             by = c("jpmesh_code" = "city_code")) |>
  st_sf()

# population data, see:
# https://www.e-stat.go.jp/stat-search/files?page=1&layout=datalist&toukei=00200521&tstat=000001049104&cycle=0&tclass1=000001049105&stat_infid=000032143614&tclass2val=0
populations <-
  suppressMessages(read_xlsx(
    path      = "data-raw/population-census/major_results_2020.xlsx",
    col_types = "text",
    col_names = FALSE,
    skip      = 9
  )) |>
  mutate(across(everything(), na_if, "-")) |>
  transmute(
    city_code                      = str_replace(`...2`, "(.+)_.+", "\\1"),
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
  select(
    first_regional_block_id,
    first_regional_block_name
  ) |>
  group_by(
    first_regional_block_id,
    first_regional_block_name
  ) |>
  summarise(
    geometry = st_union(geometry) |> sf_remove_holes(),
    .groups  = "drop"
  )

second_regional_blocks <- areas |>
  select(
    second_regional_block_id,
    first_regional_block_id,
    second_regional_block_name
  ) |>
  group_by(
    second_regional_block_id,
    first_regional_block_id,
    second_regional_block_name
  ) |>
  summarise(
    geometry = st_union(geometry) |> sf_remove_holes(),
    .groups  = "drop"
  )

cities <- areas |>
  select(
    city_code,
    second_regional_block_id,
    city_name,
    city_kana
  ) |>
  group_by(
    city_code,
    second_regional_block_id,
    city_name,
    city_kana
  ) |>
  summarise(
    geometry = st_union(geometry) |> sf_remove_holes(),
    .groups  = "drop"
  )

wards <- areas |>
  filter(!is.na(ward_code)) |>
  select(
    ward_code,
    city_code,
    ward_name,
    ward_kana
  ) |>
  group_by(
    ward_code,
    city_code,
    ward_name,
    ward_kana
  ) |>
  summarise(
    geometry = st_union(geometry) |> sf_remove_holes(),
    .groups  = "drop"
  )

city_populations <- populations |>
  inner_join(cities |>
               st_drop_geometry() |>
               select(city_code),
             by = "city_code")

ward_populations <- populations |>
  rename(ward_code = city_code) |>
  inner_join(wards |>
                      st_drop_geometry() |>
                      select(ward_code),
                    by = "ward_code")

# connect the database
source("R/fun/db_connect.R")
conn <- db_connect("config/database.yml")

# create and register the data sets
source("R/fun/db_execute.R")
dbWithTransaction(conn, {
  
  # first regional blocks
  if (!dbExistsTable(conn, "first_regional_blocks")) {
    db_execute(conn, "sql/ddl/first_regional_blocks.sql")
  }
  dbWriteTable(conn      = conn,
               name      = "first_regional_blocks",
               value     = first_regional_blocks,
               row.names = FALSE,
               overwrite = FALSE,
               append    = TRUE)

  # second regional blocks
  if (!dbExistsTable(conn, "second_regional_blocks")) {
    db_execute(conn, "sql/ddl/second_regional_blocks.sql")
  }
  dbWriteTable(conn      = conn,
               name      = "second_regional_blocks",
               value     = second_regional_blocks,
               row.names = FALSE,
               overwrite = FALSE,
               append    = TRUE)
  
  # cities
  if (!dbExistsTable(conn, "cities")) {
    db_execute(conn, "sql/ddl/cities.sql")
  }
  dbWriteTable(conn      = conn,
               name      = "cities",
               value     = cities,
               row.names = FALSE,
               overwrite = FALSE,
               append    = TRUE)
  
  # wards
  if (!dbExistsTable(conn, "wards")) {
    db_execute(conn, "sql/ddl/wards.sql")
  }
  dbWriteTable(conn      = conn,
               name      = "wards",
               value     = wards,
               row.names = FALSE,
               overwrite = FALSE,
               append    = TRUE)
  
  # city_populations
  if (!dbExistsTable(conn, "city_populations")) {
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
  if (!dbExistsTable(conn, "ward_populations")) {
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
dbDisconnect(conn)
