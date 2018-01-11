## Lower-layer Super Output Areas ##

# load necessary packages
library(sf) ; library(tidyverse)

## Greater Manchester ---------------------------------

# Full resolution
# Source: http://geoportal.statistics.gov.uk/datasets/lower-layer-super-output-areas-december-2011-full-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/da831f80764346889837c72508f046fa_0.geojson") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', lsoa11nm)) %>% 
  select(area_code = lsoa11cd, area_name = lsoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_lsoa_full_resolution.geojson", driver = "GeoJSON")

# Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/lower-layer-super-output-areas-december-2011-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/da831f80764346889837c72508f046fa_2.geojson") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', lsoa11nm)) %>% 
  select(area_code = lsoa11cd, area_name = lsoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_lsoa_generalised.geojson", driver = "GeoJSON")

# Super Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/lower-layer-super-output-areas-december-2011-super-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/da831f80764346889837c72508f046fa_3.geojson") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', lsoa11nm)) %>% 
  select(area_code = lsoa11cd, area_name = lsoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_lsoa_super_generalised.geojson", driver = "GeoJSON")

## Trafford ---------------------------------

# Full resolution
# Source: http://geoportal.statistics.gov.uk/datasets/lower-layer-super-output-areas-december-2011-full-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/da831f80764346889837c72508f046fa_0.geojson") %>% 
  filter(grepl('Trafford', lsoa11nm)) %>% 
  select(area_code = lsoa11cd, area_name = lsoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("trafford_lsoa_full_resolution.geojson", driver = "GeoJSON")

# Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/lower-layer-super-output-areas-december-2011-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/da831f80764346889837c72508f046fa_2.geojson") %>% 
  filter(grepl('Trafford', lsoa11nm)) %>% 
  select(area_code = lsoa11cd, area_name = lsoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("trafford_lsoa_generalised.geojson", driver = "GeoJSON")

# Super Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/lower-layer-super-output-areas-december-2011-super-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/da831f80764346889837c72508f046fa_3.geojson") %>% 
  filter(grepl('Trafford', lsoa11nm)) %>% 
  select(area_code = lsoa11cd, area_name = lsoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("trafford_lsoa_super_generalised.geojson", driver = "GeoJSON")
