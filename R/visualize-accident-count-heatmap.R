## tutorial

# set the file encoding
options(encoding = "UTF-8")

# load libraries
library(DBI)
library(RPostgres)
library(sf)
library(tidyverse)
library(RColorBrewer)

tictoc::tic()

# connect the database
source("R/fun/db_connect.R")
conn <- db_connect("config/database.yml")

accidents <- sf::read_sf(conn, "accidents") |>
  dplyr::filter(lubridate::year(occurrence_date) == 2020)
grid_squares <- sf::read_sf(conn, "standard_grid_squares")
cities <- sf::read_sf(conn, "cities")

accident_count <-
  sf::st_join(accidents, grid_squares) |>
  sf::st_drop_geometry() |>
  dplyr::filter(!is.na(standard_grid_square_code)) |>
  dplyr::group_by(standard_grid_square_code) |>
  dplyr::summarise(count = dplyr::n()) |>
  dplyr::inner_join(grid_squares,
                    by = "standard_grid_square_code") |>
  sf::st_as_sf()

plot <- ggplot2::ggplot() +
  ggplot2::geom_sf(data = cities, fill = "lightgray", colour = "transparent") +
  ggplot2::geom_sf(data = accident_count,
                   ggplot2::aes(fill = count), colour = "transparent") +
  ggplot2::scale_fill_gradientn(colours = RColorBrewer::brewer.pal(5, "Reds")) +
  ggplot2::geom_sf(data = cities, fill = "transparent", colour = "darkgray") +
  ggplot2::theme_void() +
  ggplot2::theme(legend.position = "none")

ggplot2::ggsave(
  file   = "plot/accident_count_heatmap.png",
  plot   = plot,
  width  = 100,
  height = 100,
  units  = "mm",
)

DBI::dbDisconnect(conn)

tictoc::toc()
