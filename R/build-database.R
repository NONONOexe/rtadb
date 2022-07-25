## build the sample database

# clean up the environment
rm(list = ls()); gc()

# set the file encoding
options(encoding = "UTF-8")

# load libraries
if(!require("pacman")) install.packages("pacman")
pacman::p_load(celestial,
               DBI,
               fs,
               lubridate,
               readxl,
               RPostgres,
               remotes,
               scales,
               sf,
               sfheaders,
               tidyverse,
               tictoc)
if(!require("jpndistrict")) remotes::install_github("uribo/jpndistrict")
if(!require("jpmesh")) remotes::install_github("uribo/jpmesh")

tictoc::tic(msg = "Road Traffic Accidents")
source("R/db-register-traffic-accidents.R")
tictoc::toc()

tictoc::tic(msg = "Traffic Flow")
source("R/db-register-traffic-flow.R")
tictoc::toc()

tictoc::tic(msg = "Land Use")
source("R/db-register-land-use.R")
tictoc::toc()

tictoc::tic(msg = "Administrative Areas")
source("R/db-register-administrative-areas.R")
tictoc::toc()

tictoc::tic(msg = "Japanese Regional Grid Squares")
source("R/db-register-grid-squares.R")
tictoc::toc()
