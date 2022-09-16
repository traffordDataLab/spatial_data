## Middle-layer Super Output Areas ##
# 2022-09-14

# load necessary packages
library(sf) ; library(tidyverse)

# Load source boundaries for whole country in all resolutions ---------

# Full resolution
# Source: https://geoportal.statistics.gov.uk/datasets/ons::middle-layer-super-output-areas-december-2021-boundaries-full-clipped-ew-bfc/about
all_full <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/MSOA_2021_EW_BFC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
  select(area_code = MSOA21CD, area_name = MSOA21NM) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat"))

# Generalised resolution
# Source: https://geoportal.statistics.gov.uk/datasets/ons::middle-layer-super-output-areas-december-2021-boundaries-generalised-clipped-ew-bgc/about
all_gen <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Middle_layer_Super_Output_Areas_December_2021_EW_BGC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
  select(area_code = MSOA21CD, area_name = MSOA21NM) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat"))

# Super generalised resolution
# Source: Not available yet
# all_super_gen <- st_read("") %>%
#   select(area_code = MSOA21CD, area_name = MSOA21NM) %>% 
#   st_as_sf(crs = 4326, coords = c("long", "lat"))


# Extract just Greater Manchester boundaries ---------

# Full resolution
gm_full <- all_full %>%
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', area_name)) %>%
  st_write("gm_msoa_full_resolution.geojson", driver = "GeoJSON")

# Generalised resolution
gm_gen <- all_gen %>%
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', area_name)) %>%
  st_write("gm_msoa_generalised.geojson", driver = "GeoJSON")

# Super Generalised resolution
gm_super_gen <- all_super_gen %>%
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', area_name)) %>%
  st_write("gm_msoa_super_generalised.geojson", driver = "GeoJSON")


# Extract just Trafford boundaries ---------

# Full resolution resolution
traff_full <- all_full %>%
  filter(grepl('Trafford', area_name)) %>%
  st_write("trafford_msoa_full_resolution.geojson", driver = "GeoJSON")

# Generalised resolution
traff_gen <- all_gen %>%
  filter(grepl('Trafford', area_name)) %>%
  st_write("trafford_msoa_generalised.geojson", driver = "GeoJSON")

# Super Generalised resolution
traff_super_gen <- all_super_gen %>%
  filter(grepl('Trafford', area_name)) %>%
  st_write("trafford_msoa_super_generalised.geojson", driver = "GeoJSON")
