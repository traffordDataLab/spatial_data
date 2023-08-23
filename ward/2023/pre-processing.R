# Trafford ward geographies from May 2023 onward.
# Source: ONS
# URL: https://geoportal.statistics.gov.uk/


# Load the required libraries ---------------------------
library(tidyverse); library(sf);

df_fr <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BFC/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=json") %>%
  select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area)

st_write(df_fr, "trafford_ward_full_resolution.geojson")

df_gen <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BGC/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=json") %>%
  select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area)

st_write(df_gen, "trafford_ward_generalised.geojson")

df_super <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BSC/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=json") %>%
  select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area)

st_write(df_super, "trafford_ward_super_generalised.geojson")



# Same as the above but for all wards within Greater Manchester ---------------------------

## https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bfc/about
df_gm_fr <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BFC/FeatureServer/0/query?where=%20(LAD23NM%20%3D%20'BOLTON'%20OR%20LAD23NM%20%3D%20'BURY'%20OR%20LAD23NM%20%3D%20'MANCHESTER'%20OR%20LAD23NM%20%3D%20'OLDHAM'%20OR%20LAD23NM%20%3D%20'ROCHDALE'%20OR%20LAD23NM%20%3D%20'SALFORD'%20OR%20LAD23NM%20%3D%20'STOCKPORT'%20OR%20LAD23NM%20%3D%20'TAMESIDE'%20OR%20LAD23NM%20%3D%20'TRAFFORD'%20OR%20LAD23NM%20%3D%20'WIGAN')%20&outFields=*&outSR=4326&f=json") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area, local_authority_area_code = LAD23CD, local_authority_area_name = LAD23NM)

st_write(df_gm_fr, "gm_ward_full_resolution.geojson")

## https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bgc/about
df_gm_gen <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BGC/FeatureServer/0/query?where=%20(LAD23NM%20%3D%20'BOLTON'%20OR%20LAD23NM%20%3D%20'BURY'%20OR%20LAD23NM%20%3D%20'MANCHESTER'%20OR%20LAD23NM%20%3D%20'OLDHAM'%20OR%20LAD23NM%20%3D%20'ROCHDALE'%20OR%20LAD23NM%20%3D%20'SALFORD'%20OR%20LAD23NM%20%3D%20'STOCKPORT'%20OR%20LAD23NM%20%3D%20'TAMESIDE'%20OR%20LAD23NM%20%3D%20'TRAFFORD'%20OR%20LAD23NM%20%3D%20'WIGAN')%20&outFields=*&outSR=4326&f=json") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area, local_authority_area_code = LAD23CD, local_authority_area_name = LAD23NM)

st_write(df_gm_gen, "gm_ward_generalised.geojson")

## https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2023-boundaries-uk-bsc/about
df_gm_super <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_MAY_2023_UK_BSC/FeatureServer/0/query?where=%20(LAD23NM%20%3D%20'BOLTON'%20OR%20LAD23NM%20%3D%20'BURY'%20OR%20LAD23NM%20%3D%20'MANCHESTER'%20OR%20LAD23NM%20%3D%20'OLDHAM'%20OR%20LAD23NM%20%3D%20'ROCHDALE'%20OR%20LAD23NM%20%3D%20'SALFORD'%20OR%20LAD23NM%20%3D%20'STOCKPORT'%20OR%20LAD23NM%20%3D%20'TAMESIDE'%20OR%20LAD23NM%20%3D%20'TRAFFORD'%20OR%20LAD23NM%20%3D%20'WIGAN')%20&outFields=*&outSR=4326&f=json") %>%
    select(area_code = WD23CD, area_name = WD23NM, lon = LONG, lat = LAT, area = Shape__Area, local_authority_area_code = LAD23CD, local_authority_area_name = LAD23NM)

st_write(df_gm_super, "gm_ward_super_generalised.geojson")

