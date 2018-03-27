## Middle Layer Super Output Areas ##

# load necessary packages
library(sf) ; library(tidyverse)

## Greater Manchester ---------------------------------

# Full resolution
# Source: http://geoportal.statistics.gov.uk/datasets/middle-layer-super-output-areas-december-2011-full-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/826dc85fb600440889480f4d9dbb1a24_0.geojson") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', msoa11nm)) %>% 
  select(area_code = msoa11cd, area_name = msoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_msoa_full_resolution.geojson", driver = "GeoJSON")

# Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/middle-layer-super-output-areas-december-2011-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/826dc85fb600440889480f4d9dbb1a24_2.geojson") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', msoa11nm)) %>% 
  select(area_code = msoa11cd, area_name = msoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_msoa_generalised.geojson", driver = "GeoJSON")

# Super Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/middle-layer-super-output-areas-december-2011-super-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/826dc85fb600440889480f4d9dbb1a24_3.geojson") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', msoa11nm)) %>% 
  select(area_code = msoa11cd, area_name = msoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_msoa_super_generalised.geojson", driver = "GeoJSON")

## Trafford ---------------------------------

# Full resolution
# Source: http://geoportal.statistics.gov.uk/datasets/middle-layer-super-output-areas-december-2011-full-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/826dc85fb600440889480f4d9dbb1a24_0.geojson") %>%  
  filter(grepl('Trafford', msoa11nm)) %>% 
  select(area_code = msoa11cd, area_name = msoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("trafford_msoa_full_resolution.geojson", driver = "GeoJSON")

# Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/middle-layer-super-output-areas-december-2011-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/826dc85fb600440889480f4d9dbb1a24_2.geojson") %>% 
  filter(grepl('Trafford', msoa11nm)) %>% 
  select(area_code = msoa11cd, area_name = msoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("trafford_msoa_generalised.geojson", driver = "GeoJSON")

# Super Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/middle-layer-super-output-areas-december-2011-super-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/826dc85fb600440889480f4d9dbb1a24_3.geojson") %>% 
  filter(grepl('Trafford', msoa11nm)) %>% 
  select(area_code = msoa11cd, area_name = msoa11nm) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("trafford_msoa_super_generalised.geojson", driver = "GeoJSON")

