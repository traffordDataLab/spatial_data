# Trafford "Localities"
# 2023-03-30, updated 2023-12-21, 2025-03-11
# These are a council-defined construct grouping the electoral wards into 4 groups: North, West, Central and South
# They are aligned to the new ward boundaries which came into effect in May 2023.
# Source: ONS
# URL: https://geoportal.statistics.gov.uk/


# Load the required libraries ---------------------------
library(sf) ; library(tidyverse) ; library(nngeo) ;


# Create geographies ---------------------------
# Files are created (both polygon and polyline versions) at 3 resolutions: full, generalised and super generalised

#########
# Full Resolution (Clipped to the coastline): https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bfc/about
df_fr <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BFC/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=geojson") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area)


#########
# Generalised Resolution (Clipped to coastline): https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bgc/about
df_gen <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BGC/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=geojson") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area)


#########
# Super Generalised Resolution (Clipped to coastline): https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bsc/about
df_super <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BSC/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=geojson") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area)


# =========
# VERY IMPORTANT NOTE REGARDING SF PACKAGE AND COORDINATE WINDING ORDER 2023-12-21:
# The IETF standard for GeoJSON has made certain changes over the original non-IETF specification.  The changes can be viewed here: https://datatracker.ietf.org/doc/html/rfc7946#appendix-B
# One key change is that polygon rings MUST follow the right-hand rule for orientation (counter-clockwise external rings, clockwise internal rings).
# This change has caused issues with certain libraries which have historically used the left-hand rule, i.e. clockwise for outer rings and counter-clockwise for interior rings.
# D3-Geo, Vega-Lite and versions of sf below 1.0.0 (default behaviour) use the GEOS library for performing flat-space calculations, known as R^2 (R-squared) which produce polygons wound to the left-hand rule.
# The sf package from version 1.0.0 onwards now uses the S2 library by default which performs S^2 (S-squared) spherical calculations and returns polygons wound according to the right-hand rule.
# At the time of writing, if we want our geography files to work in D3 and Vega-Lite, they must use the left-hand rule and so we need sf to use the GEOS library not S2.
# More information regarding this can be found at: https://r-spatial.github.io/sf/articles/sf7.html#switching-between-s2-and-geos
# =========
sf_vers <- package_version(packageVersion('sf')) # packageVersion returns a character string, package_version converts that into numeric version numbers (major.minor.patch) e.g. 1.0.0

# Only run the following if we are using sf version 1.0.0 or above
if (sf_vers$major >= 1) {
    useS2 <- sf_use_s2()    # store boolean to indicating if sf is currently using the s2 spherical geometry package for geographical coordinate operations
    sf_use_s2(FALSE)        # force sf to use R^2 flat space calculations using GEOS which returns polygons with left-hand windings
}


# Function to create the locality boundaries from the wards ---------
group_wards_into_localities <- function(ward_geometry) {

    ward_geometry %>%
        # Assign the wards into their relevant locality names and collapse the internal boundaries into a single area for each
        mutate(area_name = case_when(
               area_name %in% c("Ashton upon Mersey", "Brooklands", "Manor", "Sale Central", "Sale Moor") ~ "Central",
               area_name %in% c("Gorse Hill & Cornbrook", "Longford", "Lostock & Barton", "Old Trafford", "Stretford & Humphrey Park") ~ "North",
               area_name %in% c("Altrincham", "Bowdon", "Broadheath", "Hale", "Hale Barns & Timperley South", "Timperley Central", "Timperley North") ~ "South",
               area_name %in% c("Bucklow-St Martins", "Davyhulme", "Flixton", "Urmston") ~ "West")) %>% 
        group_by(area_name) %>% 
        summarise(area = sum(area)) %>%
        
        # Calculate and store the coordinates of each locality's centroid as a "lat" and "lon" property
        mutate(lon = round(map_dbl(geometry, ~st_centroid(.x)[[1]]), 5),
               lat = round(map_dbl(geometry, ~st_centroid(.x)[[2]]),5),
               area = round(area, 3),
               area_units = "Square metres") %>%
        
        # Some "artifacts" (small polygons) seem to be present within the Central and South localities - probably loose ends when creating the ward boundaries. This removes them    
        st_remove_holes() %>%
        
        select(area_name, lon, lat, area, area_units)
}


# Full resolution localities
write_sf(group_wards_into_localities(df_fr), "trafford_localities_full_resolution.geojson") # standard polygon geometry
write_sf(st_cast(group_wards_into_localities(df_fr), "LINESTRING"), "trafford_localities_full_resolution_overlay.geojson") # linestring geometry for overlays (you can click "through" the layer to ones below)

# Generalised resolution localities
write_sf(group_wards_into_localities(df_gen), "trafford_localities_generalised_resolution.geojson") # see comments above
write_sf(st_cast(group_wards_into_localities(df_gen), "LINESTRING"), "trafford_localities_generalised_resolution_overlay.geojson") # see comments above

# Super generalised resolution localities
write_sf(group_wards_into_localities(df_super), "trafford_localities_super_generalised_resolution.geojson") # see comments above
write_sf(st_cast(group_wards_into_localities(df_super), "LINESTRING"), "trafford_localities_super_generalised_resolution_overlay.geojson") # see comments above


# Ensure sf_use_s2() is reset to the state it was in before running the code above, i.e. whether to use the S2 library (for S^2 spherical coordinates) or GEOS (for R^2 flat space coordinates). Only if using v1 or above of the sf package
if (sf_vers$major >= 1) sf_use_s2(useS2)
