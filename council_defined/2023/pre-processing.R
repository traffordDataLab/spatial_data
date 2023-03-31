# Trafford "Localities"
# 2023-03-30
# These are a council-defined construct grouping the electoral wards into 4 groups: North, West, Central and South
# They are aligned to the new ward boundaries which come into effect from May 2023.

# load necessary packages
library(sf) ; library(tidyverse) ;


## NOTE: The following code contains a lot of lines/sections commented out. This is because at the time of writing the new ward boundaries are not available from the OS Geography Portal. Using our locally created file for now.


# API parameters specifying the spatial rectangular area containing Trafford
#api_geommetry_envelope <- "&geometryType=esriGeometryEnvelope&geometry=%7B%22spatialReference%22%3A%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D%2C%22xmin%22%3A-278455.35481123265%2C%22ymin%22%3A7047642.057770884%2C%22xmax%22%3A-244823.0623658004%2C%22ymax%22%3A7073592.428873666%2C%22type%22%3A%22esriGeometryEnvelope%22%7D"


# Full resolution
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2022-uk-bfc-v2/about
#wards_full_res <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_May_2022_UK_BFC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson", api_geommetry_envelope)) %>% 
#  filter(LAD22NM == "Trafford") %>%
#  select(area_code = WD22CD, area_name = WD22NM, lat = LAT, lon = LONG) %>% 
#  st_as_sf(crs = 4326, coords = c("long", "lat"))
wards_full_res <- st_read("https://www.trafforddatalab.io/spatial_data/ward/2023/trafford_ward_full_resolution.geojson")

# Generalised
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2022-uk-bgc-v2/about
#wards_generalised_res <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_May_2022_UK_BGC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson", api_geommetry_envelope)) %>% 
#  filter(LAD22NM == "Trafford") %>%
#  select(area_code = WD22CD, area_name = WD22NM, lat = LAT, lon = LONG) %>% 
#  st_as_sf(crs = 4326, coords = c("long", "lat"))

# Super Generalised
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2022-uk-bsc-v2/about
#wards_super_generalised_res <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_May_2022_UK_BSC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson", api_geommetry_envelope)) %>% 
#  filter(LAD22NM == "Trafford") %>%
#  select(area_code = WD22CD, area_name = WD22NM, lat = LAT, lon = LONG) %>% 
#  st_as_sf(crs = 4326, coords = c("long", "lat"))


# Function to create the locality boundaries from the wards ---------
group_wards_into_localities <- function(ward_geometry, resolution_name) {
  ward_geometry %>%
    # Assign the wards into their relevant locality names and collapse the internal boundaries into a single area for each
    mutate(area_name = case_when(
           area_name %in% c("Ashton upon Mersey", "Brooklands", "Manor", "Sale Central", "Sale Moor") ~ "Central",
           area_name %in% c("Gorse Hill & Cornbrook", "Longford", "Lostock & Barton", "Old Trafford", "Stretford & Humphrey Park") ~ "North",
           area_name %in% c("Altrincham", "Bowdon", "Broadheath", "Hale", "Hale Barns & Timperley South", "Timperley Central", "Timperley North") ~ "South",
           area_name %in% c("Bucklow-St Martins", "Davyhulme", "Flixton", "Urmston") ~ "West")) %>% 
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
#group_wards_into_localities(wards_generalised_res, "generalised_resolution")

# Super generalised resolution localities
#group_wards_into_localities(wards_super_generalised_res, "super_generalised_resolution")
