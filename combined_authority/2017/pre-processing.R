## Combined Authority ##

# load necessary packages
library(sf) ; library(tidyverse)

# Full resolution
# Source: http://geoportal.statistics.gov.uk/datasets/combined-authorities-march-2017-full-clipped-boundaries-in-england
st_read("https://opendata.arcgis.com/datasets/89f12fc184d045a1a7ca9dd14fb4df3e_0.geojson") %>% 
  filter(cauth17nm == "Greater Manchester") %>% 
  select(area_code = cauth17cd, area_name = cauth17nm, lat, lon = long) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_combined_authority_full_resolution.geojson", driver = "GeoJSON")

# Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/combined-authorities-march-2017-generalised-clipped-boundaries-in-england
st_read("https://opendata.arcgis.com/datasets/89f12fc184d045a1a7ca9dd14fb4df3e_2.geojson") %>% 
  filter(cauth17nm == "Greater Manchester") %>% 
  select(area_code = cauth17cd, area_name = cauth17nm, lat, lon = long) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_combined_authority_generalised.geojson", driver = "GeoJSON")

# Super Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/combined-authorities-march-2017-super-generalised-clipped-boundaries-in-england
st_read("https://opendata.arcgis.com/datasets/89f12fc184d045a1a7ca9dd14fb4df3e_3.geojson") %>% 
  filter(cauth17nm == "Greater Manchester") %>% 
  select(area_code = cauth17cd, area_name = cauth17nm, lat, lon = long) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_combined_authority_super_generalised.geojson", driver = "GeoJSON")
