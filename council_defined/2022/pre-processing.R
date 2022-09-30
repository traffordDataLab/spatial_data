# Trafford "Localities"
# 2022-09-30
# These are a council-defined construct grouping the electoral wards into 4 groups: North, West, Central and South
# They are unchanged from 2017 when the decision was taken to align the localities exactly to the ward boundaries.
# Prior to 2017 there was an alternative version in use where the boundary between North and West near the Trafford Centre deviated from the ward boundaries, following the M60 instead.
# This 2022 version has been created to preserve the current localities with a referenceable date in preparation for the new ones in 2023 due to the wards changing.

# load necessary packages
library(sf) ; library(tidyverse) ; library(readxl) ; library(httr)


# API parameters specifying the spatial rectangular area containing Trafford
api_geommetry_envelope <- "&geometryType=esriGeometryEnvelope&geometry=%7B%22spatialReference%22%3A%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D%2C%22xmin%22%3A-278455.35481123265%2C%22ymin%22%3A7047642.057770884%2C%22xmax%22%3A-244823.0623658004%2C%22ymax%22%3A7073592.428873666%2C%22type%22%3A%22esriGeometryEnvelope%22%7D"


# Full resolution
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2022-uk-bfc-v2/about
wards_full_res <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_May_2022_UK_BFC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson", api_geommetry_envelope)) %>% 
  filter(LAD22NM == "Trafford") %>%
  select(area_code = WD22CD, area_name = WD22NM, lat = LAT, lon = LONG) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat"))

# Generalised
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2022-uk-bgc-v2/about
wards_generalised_res <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_May_2022_UK_BGC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson", api_geommetry_envelope)) %>% 
  filter(LAD22NM == "Trafford") %>%
  select(area_code = WD22CD, area_name = WD22NM, lat = LAT, lon = LONG) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat"))

# Super Generalised
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2022-uk-bsc-v2/about
wards_super_generalised_res <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_May_2022_UK_BSC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson", api_geommetry_envelope)) %>% 
  filter(LAD22NM == "Trafford") %>%
  select(area_code = WD22CD, area_name = WD22NM, lat = LAT, lon = LONG) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat"))


# Function to create the locality boundaries from the wards ---------
group_wards_into_localities <- function(ward_geometry, resolution_name) {
  ward_geometry %>%
    # Assign the wards into their relevant locality names and collapse the internal boundaries into a single area for each
    mutate(area_name = case_when(
           area_name %in% c("Ashton upon Mersey", "Brooklands", "Priory", "St Mary\'s", "Sale Moor") ~ "Central",
           area_name %in% c("Clifford", "Gorse Hill", "Longford", "Stretford") ~ "North",
           area_name %in% c("Altrincham", "Bowdon", "Broadheath", "Hale Barns", "Hale Central", "Timperley", "Village") ~ "South",
           area_name %in% c("Bucklow-St Martins", "Davyhulme East", "Davyhulme West", "Flixton", "Urmston") ~ "West")) %>% 
    group_by(area_name) %>% 
    summarise() %>%
    
    # Calculate and store the coordinates of each locality's centroid as a "lat" and "lon" property
    mutate(lon = map_dbl(geometry, ~st_centroid(.x)[[1]]),
           lat = map_dbl(geometry, ~st_centroid(.x)[[2]])) %>%
    
    # Create the new spatial file
    st_write(paste0("trafford_localities_", resolution_name, ".geojson"))
}


# Full resolution localities
group_wards_into_localities(wards_full_res, "full_resolution")

# Generalised resolution localities
group_wards_into_localities(wards_generalised_res, "generalised_resolution")

# Super generalised resolution localities
group_wards_into_localities(wards_super_generalised_res, "super_generalised_resolution")
