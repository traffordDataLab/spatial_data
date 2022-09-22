## Local Authority ##
# 2022-09-22

# load necessary packages
library(sf) ; library(tidyverse)


# Load source boundaries for whole country in all resolutions ---------

# Full resolution
# Source: https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-december-2021-gb-bfc/about
all_full <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_December_2021_GB_BFC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
  select(area_code = LAD21CD, area_name = LAD21NM) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat"))

# Generalised resolution
# Source: https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-december-2021-gb-bgc/about
all_gen <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_December_2021_GB_BGC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
  select(area_code = LAD21CD, area_name = LAD21NM) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat"))

# Ultra generalised resolution
# Source: https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-december-2021-gb-buc/about
all_ultra_gen <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_December_2021_GB_BUC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
  select(area_code = LAD21CD, area_name = LAD21NM) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat"))


# Extract just Greater Manchester boundaries ---------

# Full resolution
gm_full <- all_full %>%
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', area_name)) %>%
  st_write("gm_local_authority_full_resolution.geojson", driver = "GeoJSON")

# Generalised resolution
gm_gen <- all_gen %>%
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', area_name)) %>%
  st_write("gm_local_authority_generalised.geojson", driver = "GeoJSON")

# Ultra Generalised resolution
gm_ultra_gen <- all_ultra_gen %>%
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', area_name)) %>%
  st_write("gm_local_authority_ultra_generalised.geojson", driver = "GeoJSON")


# Extract just Trafford boundaries ---------

# Full resolution resolution
traff_full <- all_full %>%
  filter(grepl('Trafford', area_name)) %>%
  st_write("trafford_local_authority_full_resolution.geojson", driver = "GeoJSON")

# Generalised resolution
traff_gen <- all_gen %>%
  filter(grepl('Trafford', area_name)) %>%
  st_write("trafford_local_authority_generalised.geojson", driver = "GeoJSON")

# Ultra Generalised resolution
traff_ultra_gen <- all_ultra_gen %>%
  filter(grepl('Trafford', area_name)) %>%
  st_write("trafford_local_authority_ultra_generalised.geojson", driver = "GeoJSON")
