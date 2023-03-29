# Trafford ward geographies from May 2023 onward.
# 2023-03-29 James Austin.
# Source: Internal Trafford Planning team. 
# NOTE: This will be supplied to Ordnance Survey and eventually we'll get it via the OS Geography Portal as usual for reproducibility.


# Load the required libraries ---------------------------
library(tidyverse); library(sf);


# Prepare the geography with lat/lon for each ward, rename variables consistently etc. ---------------------------
trafford_wards_2023 <- read_sf("trafford_wards_2023_trafford_planning_team.geojson") %>%
    # Calculate and store the coordinates of each ward's centroid as a "lat" and "lon" property
    mutate(lon = map_dbl(geometry, ~st_centroid(.x)[[1]]),
           lat = map_dbl(geometry, ~st_centroid(.x)[[2]])) %>%
    select(area_name = Ward_name, lat, lon) %>%
    st_write("trafford_ward_full_resolution.geojson")
