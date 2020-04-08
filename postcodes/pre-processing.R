## ONS Postcode Directory (Latest) Centroids ##

# Source: ONS Open Geography Portal
# Publisher URL: https://geoportal.statistics.gov.uk/datasets/ons-postcode-directory-february-2020
# Licence: Open Government Licence 3.0

# load necessary packages ---------------------------
library(tidyverse) ; library(sf)

# import and tidy data ---------------------------
lookup <- tibble(
  area_code = paste0("E0", seq(8000001, 8000010, by = 1)),
  area_name = c("Bolton", "Bury", "Manchester", "Oldham", "Rochdale", "Salford", 
                "Stockport", "Tameside", "Trafford", "Wigan"))

url <- "https://www.arcgis.com/sharing/rest/content/items/82889274464b48ae8bf3e9458588a64b/data"
download.file(url, dest = "ONSPD_FEB_2020_UK.zip")
unzip("ONSPD_FEB_2020_UK.zip", exdir = ".")
file.remove("ONSPD_FEB_2020_UK.zip")

postcodes <- read_csv("ONSPD_FEB_2020_UK/Data/ONSPD_FEB_2020_UK.csv") %>% 
  select(postcode = pcds,
         area_code = oslaua,
         lon = long,
         lat = lat) %>% 
  left_join(lookup, by = "area_code") %>% 
  filter(!is.na(area_name)) %>% 
  select(postcode, area_code, area_name, lon, lat)

# write data ---------------------------
write_csv(postcodes, "gm_postcodes.csv")

# add ward info to Trafford ---------------------------
wards <- st_read("https://www.trafforddatalab.io/spatial_data/ward/2017/trafford_ward_full_resolution.geojson") %>% 
  select(-lon, -lat) %>% 
  mutate(locality = 
           case_when(
             area_name %in% c("Ashton upon Mersey", "Brooklands", "Priory", "St Mary\'s", "Sale Moor") ~ "Central",
             area_name %in% c("Clifford", "Gorse Hill", "Longford", "Stretford") ~ "North",
             area_name %in% c("Altrincham", "Bowdon", "Broadheath", "Hale Barns", "Hale Central", "Timperley", "Village") ~ "South",
             area_name %in% c("Bucklow-St Martins", "Davyhulme East", "Davyhulme West", "Flixton", "Urmston") ~ "West"))

trafford <- filter(postcodes, area_name == "Trafford") %>% 
  st_as_sf(crs = 4326, coords = c("lon", "lat")) %>% 
  select(postcode) %>% 
  st_join(., wards, join = st_within) %>% 
  mutate(lon = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]])) %>% 
  st_set_geometry(NULL)

write_csv(trafford, "trafford_postcodes.csv")