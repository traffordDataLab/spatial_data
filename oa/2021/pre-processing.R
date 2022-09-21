## Output Areas (December 2021) ##
# 2022-09-16

# load necessary packages
library(sf) ; library(tidyverse)

# Load statistical lookup CSV to match the OA area codes to Local Authorities so that we can isolate the OAs for Greater Manchester and Trafford
# Source: https://geoportal.statistics.gov.uk/datasets/output-area-to-lower-layer-super-output-area-to-middle-layer-super-output-area-to-local-authority-district-december-2021-lookup-in-england-and-wales-v2/about
df_lookup <- read_csv("https://www.arcgis.com/sharing/rest/content/items/9f0bc2c6fbc9427ba11db01759e5f6d8/data") %>%
  select(area_code = oa21cd, la_code = lad22cd, la_name = lad22nm)

# Store the LA area codes for all Greater Manchester authorities as we'll use them a few times
gm_la_codes <- c("E08000001","E08000002","E08000003","E08000004","E08000005","E08000006","E08000007","E08000008","E08000009","E08000010")


# Load source boundaries for whole country in all resolutions ---------

# Full resolution
# Source: https://geoportal.statistics.gov.uk/datasets/ons::output-areas-december-2021-boundaries-full-clipped-ew-bfc-2/about
all_full <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/OA_2021_EW_BFC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
  select(area_code = OA21CD) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>%
  left_join(df_lookup)

# Generalised resolution
# Source: https://geoportal.statistics.gov.uk/datasets/ons::output-areas-december-2021-boundaries-generalised-clipped-ew-bgc/about
all_gen <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Output_Areas_December_2021_Boundaries_EW_BGC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
  select(area_code = OA21CD) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>%
  left_join(df_lookup)

# Super generalised resolution
# Source: Not available yet
# all_super_gen <- st_read("") %>%
#   select(area_code = OA21CD) %>% 
#   st_as_sf(crs = 4326, coords = c("long", "lat")) %>%
#   left_join(df_lookup)


# Extract just Greater Manchester boundaries ---------

# Full resolution
# NOTE: FILESIZE EXCEEDS GITHUB LIMITS!
gm_full <- all_full %>%
  filter(la_code %in% gm_la_codes) %>%
  st_write("gm_oa_full_resolution.geojson", driver = "GeoJSON")

# Generalised resolution
gm_gen <- all_gen %>%
  filter(la_code %in% gm_la_codes) %>%
  st_write("gm_oa_generalised.geojson", driver = "GeoJSON")

# Super Generalised resolution
gm_super_gen <- all_super_gen %>%
  filter(la_code %in% gm_la_codes) %>%
  st_write("gm_oa_super_generalised.geojson", driver = "GeoJSON")


# Extract just Trafford boundaries ---------

# Full resolution resolution
traff_full <- all_full %>%
  filter(la_code == "E08000009") %>%
  st_write("trafford_oa_full_resolution.geojson", driver = "GeoJSON")

# Generalised resolution
traff_gen <- all_gen %>%
  filter(la_code == "E08000009") %>%
  st_write("trafford_oa_generalised.geojson", driver = "GeoJSON")

# Super Generalised resolution
traff_super_gen <- all_super_gen %>%
  filter(la_code == "E08000009") %>%
  st_write("trafford_oa_super_generalised.geojson", driver = "GeoJSON")
