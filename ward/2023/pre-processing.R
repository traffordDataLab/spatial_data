# Trafford & Greater Manchester (GM) ward geographies (May 2023)
# Source: ONS
# URL: https://geoportal.statistics.gov.uk/


# Load the required libraries ---------------------------
library(tidyverse); library(sf);


# Create geographies ---------------------------
# Files are created for Trafford and Greater Manchester (both polygon and polyline versions) at 3 resolutions: full, generalised and super generalised

#########
# Full Resolution (Clipped to the coastline): https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bfc/about
df_fr <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BFC/FeatureServer/0/query?where=%20(LAD23NM%20%3D%20'BOLTON'%20OR%20LAD23NM%20%3D%20'BURY'%20OR%20LAD23NM%20%3D%20'MANCHESTER'%20OR%20LAD23NM%20%3D%20'OLDHAM'%20OR%20LAD23NM%20%3D%20'ROCHDALE'%20OR%20LAD23NM%20%3D%20'SALFORD'%20OR%20LAD23NM%20%3D%20'STOCKPORT'%20OR%20LAD23NM%20%3D%20'TAMESIDE'%20OR%20LAD23NM%20%3D%20'TRAFFORD'%20OR%20LAD23NM%20%3D%20'WIGAN')%20&outFields=*&outSR=4326&f=geojson") %>%
    mutate(area = round(Shape__Area, 3),
           area_units = "Square metres") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area, area_units, local_authority_area_code = LAD23CD, local_authority_area_name = LAD23NM)

write_sf(df_fr, "gm_ward_full_resolution.geojson") # standard polygon geometry
write_sf(st_cast(df_fr,"LINESTRING"), "gm_ward_full_resolution_overlay.geojson") # linestring geometry for overlays (you can click "through" the layer to ones below)

df_fr %>%
    filter(local_authority_area_name == "Trafford") %>%
    select(-local_authority_area_code, -local_authority_area_name) %>%
    write_sf("trafford_ward_full_resolution.geojson") %>%
    st_cast("LINESTRING") %>%
    write_sf("trafford_ward_full_resolution_overlay.geojson")


#########
# Generalised Resolution (Clipped to coastline): https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bgc/about
df_gen <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BGC/FeatureServer/0/query?where=%20(LAD23NM%20%3D%20'BOLTON'%20OR%20LAD23NM%20%3D%20'BURY'%20OR%20LAD23NM%20%3D%20'MANCHESTER'%20OR%20LAD23NM%20%3D%20'OLDHAM'%20OR%20LAD23NM%20%3D%20'ROCHDALE'%20OR%20LAD23NM%20%3D%20'SALFORD'%20OR%20LAD23NM%20%3D%20'STOCKPORT'%20OR%20LAD23NM%20%3D%20'TAMESIDE'%20OR%20LAD23NM%20%3D%20'TRAFFORD'%20OR%20LAD23NM%20%3D%20'WIGAN')%20&outFields=*&outSR=4326&f=geojson") %>%
    mutate(area = round(Shape__Area, 3),
           area_units = "Square metres") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area, area_units, local_authority_area_code = LAD23CD, local_authority_area_name = LAD23NM)

write_sf(df_gen, "gm_ward_generalised.geojson") # standard polygon geometry
write_sf(st_cast(df_gen,"LINESTRING"), "gm_ward_generalised_overlay.geojson") # linestring geometry for overlays

df_gen %>%
    filter(local_authority_area_name == "Trafford") %>%
    select(-local_authority_area_code, -local_authority_area_name) %>%
    write_sf("trafford_ward_generalised.geojson") %>%
    st_cast("LINESTRING") %>%
    write_sf("trafford_ward_generalised_overlay.geojson")


#########
# Super Generalised Resolution (Clipped to coastline): https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bsc/about
df_super <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BSC/FeatureServer/0/query?where=%20(LAD23NM%20%3D%20'BOLTON'%20OR%20LAD23NM%20%3D%20'BURY'%20OR%20LAD23NM%20%3D%20'MANCHESTER'%20OR%20LAD23NM%20%3D%20'OLDHAM'%20OR%20LAD23NM%20%3D%20'ROCHDALE'%20OR%20LAD23NM%20%3D%20'SALFORD'%20OR%20LAD23NM%20%3D%20'STOCKPORT'%20OR%20LAD23NM%20%3D%20'TAMESIDE'%20OR%20LAD23NM%20%3D%20'TRAFFORD'%20OR%20LAD23NM%20%3D%20'WIGAN')%20&outFields=*&outSR=4326&f=geojson") %>%
    mutate(area = round(Shape__Area, 3),
           area_units = "Square metres") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area, area_units, local_authority_area_code = LAD23CD, local_authority_area_name = LAD23NM)

write_sf(df_super, "gm_ward_super_generalised.geojson") # standard polygon geometry
write_sf(st_cast(df_super,"LINESTRING"), "gm_ward_super_generalised_overlay.geojson") # linestring geometry for overlays

df_super %>%
    filter(local_authority_area_name == "Trafford") %>%
    select(-local_authority_area_code, -local_authority_area_name) %>%
    write_sf("trafford_ward_super_generalised.geojson") %>%
    st_cast("LINESTRING") %>%
    write_sf("trafford_ward_super_generalised_overlay.geojson")
