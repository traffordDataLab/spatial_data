## ONS Postcode Directory (Latest) Centroids ##

# Source: Office for National Statistics
# Publisher URL: http://geoportal.statistics.gov.uk/datasets/ons-postcode-directory-latest-centroids
# Licence: Open Government Licence 3.0

# load necessary packages ---------------------------
library(tidyverse) ; library(sf)

# read, tidy and write data ---------------------------
sf <- st_read("https://www.trafforddatalab.io/spatial_data/ward/2017/trafford_ward_full_resolution.geojson") %>% 
  select(area_code)

read_csv("http://geoportal.statistics.gov.uk/datasets/75edec484c5d49bcadd4893c0ebca0ff_0.csv") %>% 
  filter(oslaua == "E08000009") %>% 
  select(postcode = pcds, lon = long, lat) %>% 
  st_as_sf(crs = 4326, coords = c("lon", "lat")) %>% 
  mutate(lon = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]])) %>% 
  st_join(sf, join = st_within, left = FALSE) %>% 
  select(1:3, lon, lat) %>% 
  write_csv("trafford_postcodes_2018-11.csv")
