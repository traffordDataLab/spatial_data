## Local Authority ##

# load necessary packages
library(sf) ; library(tidyverse)

## Greater Manchester -------------------------------

# Full resolution
# Source: http://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2016-full-clipped-boundaries-in-great-britain
st_read("https://opendata.arcgis.com/datasets/686603e943f948acaa13fb5d2b0f1275_0.geojson") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', lad16nm)) %>% 
  select(area_code = lad16cd, area_name = lad16nm, lat, lon = long) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_local_authority_full_resolution.geojson", driver = "GeoJSON")

# Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2016-generalised-clipped-boundaries-in-great-britain
st_read("https://opendata.arcgis.com/datasets/686603e943f948acaa13fb5d2b0f1275_2.geojson") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', lad16nm)) %>% 
  select(area_code = lad16cd, area_name = lad16nm, lat, lon = long) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_local_authority_generalised.geojson", driver = "GeoJSON")

# Super Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2016-super-generalised-clipped-boundaries-in-great-britain
st_read("https://opendata.arcgis.com/datasets/686603e943f948acaa13fb5d2b0f1275_3.geojson") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', lad16nm)) %>% 
  select(area_code = lad16cd, area_name = lad16nm, lat, lon = long) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_local_authority_super_generalised.geojson", driver = "GeoJSON")

## Trafford -------------------------------

# Full resolution
# Source: http://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2016-full-clipped-boundaries-in-great-britain
st_read("https://opendata.arcgis.com/datasets/686603e943f948acaa13fb5d2b0f1275_0.geojson") %>% 
  filter(lad16nm == "Trafford") %>% 
  select(area_code = lad16cd, area_name = lad16nm, lat, lon = long) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("trafford_local_authority_full_resolution.geojson", driver = "GeoJSON")

# Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2016-generalised-clipped-boundaries-in-great-britain
st_read("https://opendata.arcgis.com/datasets/686603e943f948acaa13fb5d2b0f1275_2.geojson") %>% 
  filter(lad16nm == "Trafford") %>% 
  select(area_code = lad16cd, area_name = lad16nm, lat, lon = long) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("trafford_local_authority_generalised.geojson", driver = "GeoJSON")

# Super Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2016-super-generalised-clipped-boundaries-in-great-britain
st_read("https://opendata.arcgis.com/datasets/686603e943f948acaa13fb5d2b0f1275_3.geojson") %>% 
  filter(lad16nm == "Trafford") %>% 
  select(area_code = lad16cd, area_name = lad16nm, lat, lon = long) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("trafford_local_authority_super_generalised.geojson", driver = "GeoJSON")
