## build the sample database

# set the file encoding
options(encoding = "UTF-8")

# load libraries
library(celestial)
library(DBI)
library(fs)
library(jpndistrict)
library(jpmesh)
library(lubridate)
library(readxl)
library(RPostgres)
library(remotes)
library(scales)
library(sf)
library(sfheaders)
library(tidyverse)
library(tictoc)
library(conflicted)

# set winner functions for conflicts
conflict_prefer("filter","dplyr")
conflict_prefer("map", "purrr")
conflict_prefer("tic", "tictoc")
conflict_prefer("toc", "tictoc")

tic(msg = "Road Traffic Accidents")
source("R/db-register-traffic-accidents.R")
toc()

tic(msg = "Traffic Flow")
source("R/db-register-traffic-flow.R")
toc()

tic(msg = "Land Use")
source("R/db-register-land-use.R")
toc()

tic(msg = "Administrative Areas")
source("R/db-register-administrative-areas.R")
toc()

tic(msg = "Japanese Regional Grid Squares")
source("R/db-register-grid-squares.R")
toc()
