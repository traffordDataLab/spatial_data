## Output Areas ##

# load necessary packages
library(sf) ; library(tidyverse)

## Greater Manchester ---------------------------------

# Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/output-area-december-2011-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/09b8a48426e3482ebbc0b0c49985c0fb_2.geojson") %>% 
  filter(lad11cd %in% c("E08000001","E08000002","E08000003","E08000004","E08000005","E08000006","E08000007","E08000008","E08000009","E08000010")) %>%  
  select(area_code = oa11cd, la_name = lad11cd) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_oa_generalised.geojson", driver = "GeoJSON")

## Trafford ---------------------------------

# Generalised
# Source: http://geoportal.statistics.gov.uk/datasets/lower-layer-super-output-areas-december-2011-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/09b8a48426e3482ebbc0b0c49985c0fb_2.geojson") %>% 
  filter(lad11cd == "E08000009") %>%  
  select(area_code = oa11cd, la_name = lad11cd) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("trafford_oa_generalised.geojson", driver = "GeoJSON")
