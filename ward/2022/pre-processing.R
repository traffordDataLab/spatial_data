## Electoral wards ##

# load necessary packages
library(sf) ; library(tidyverse) ; library(readxl) ; library(httr)


# API parameters specifying the spatial rectangular area containing Greater Manchester
api_geommetry_envelope <- "&geometryType=esriGeometryEnvelope&geometry=%7B%22spatialReference%22%3A%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D%2C%22xmin%22%3A-332167.44985831855%2C%22ymin%22%3A7018123.647011338%2C%22xmax%22%3A-177341.1915855498%2C%22ymax%22%3A7139099.00293773%2C%22type%22%3A%22esriGeometryEnvelope%22%7D"


# Obtain lookup for Greater Manchester containing all the wards and their associated LAs
# Source: https://geoportal.statistics.gov.uk/documents/ward-to-local-authority-district-may-2022-lookup-in-the-united-kingdom/about
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://www.arcgis.com/sharing/rest/content/items/27dee9a199cf4181b63fe2ea9b9c81f0/data",
    write_disk(tmp))

lookup_gm <- read_xlsx(tmp) %>%
  filter(LAD22NM %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
  select(-WD22NMW) %>%
  setNames(tolower(names(.)))

lookup_trafford <- lookup_gm %>%
  filter(lad22nm == "Trafford")

# delete the downloaded raw data
unlink(tmp)


## Greater Manchester ---------------------------------

# Full resolution
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2022-uk-bfc-v2/about
gm_full_res <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_May_2022_UK_BFC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson", api_geommetry_envelope)) %>% 
  filter(WD22CD %in% lookup_gm$wd22cd) %>%
  select(area_code = WD22CD, area_name = WD22NM, lat = LAT, lon = LONG) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_ward_full_resolution.geojson", driver = "GeoJSON")

# Generalised
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2022-uk-bgc-v2/about
gm_generalised_res <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_May_2022_UK_BGC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson", api_geommetry_envelope)) %>% 
  filter(WD22CD %in% lookup_gm$wd22cd) %>%
  select(area_code = WD22CD, area_name = WD22NM, lat = LAT, lon = LONG) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_ward_generalised.geojson", driver = "GeoJSON")

# Super Generalised
# Source: https://geoportal.statistics.gov.uk/datasets/ons::wards-may-2022-uk-bsc-v2/about
gm_super_generalised_res <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_May_2022_UK_BSC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson", api_geommetry_envelope)) %>% 
  filter(WD22CD %in% lookup_gm$wd22cd) %>%
  select(area_code = WD22CD, area_name = WD22NM, lat = LAT, lon = LONG) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("gm_ward_super_generalised.geojson", driver = "GeoJSON")


## Trafford ---------------------------------

# Full resolution
trafford_full_res <- gm_full_res %>%
  filter(area_code %in% lookup_trafford$wd22cd) %>%
  st_write("trafford_ward_full_resolution.geojson", driver = "GeoJSON")

# Generalised
trafford_generalised_res <- gm_generalised_res %>%
  filter(area_code %in% lookup_trafford$wd22cd) %>%
  st_write("trafford_ward_generalised.geojson", driver = "GeoJSON")

# Super Generalised
trafford_super_generalised_res <- gm_super_generalised_res %>%
  filter(area_code %in% lookup_trafford$wd22cd) %>%
  st_write("trafford_ward_super_generalised.geojson", driver = "GeoJSON")
