# Trafford "Localities"
# 2023-03-30, updated 2023-08-22
# These are a council-defined construct grouping the electoral wards into 4 groups: North, West, Central and South
# They are aligned to the new ward boundaries which come into effect from May 2023.

# load necessary packages
library(sf) ; library(tidyverse) ; library(nngeo) ;


# Full resolution
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bfc/about
wards_full_res <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BFC/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=json") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area)

# Generalised
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bgc/about
wards_generalised_res <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BGC/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=json") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area)

# Super Generalised
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bsc/about
wards_super_generalised_res <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BSC/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=json") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area)


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
    
    # Some "artifacts" (small polygons) seem to be present within the Central and South localities - probably loose ends when creating the ward boundaries. This removes them    
    st_remove_holes() %>%
    
    # Create the new spatial file
    st_write(paste0("trafford_localities_", resolution_name, ".geojson"))
}


# Full resolution localities
group_wards_into_localities(wards_full_res, "full_resolution")

# Generalised resolution localities
group_wards_into_localities(wards_generalised_res, "generalised_resolution")

# Super generalised resolution localities
group_wards_into_localities(wards_super_generalised_res, "super_generalised_resolution")
