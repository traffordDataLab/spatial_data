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


