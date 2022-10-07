## Lookups for Greater Manchester based on 2021 statistical and 2022 administrative boundaries ##

# Source: Open Geography Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# load libraries ---------
library(tidyverse) ; library(sf) ; library(readxl) ; library(httr)

# These are used throughout. The vector for "filter %in%" operations and the pipe-separated in grepl()
gm_authorities_vector <- c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")
gm_authorities_pipe_string <- "Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan"


# Statistical lookup (OA > LSOA > MSOA > LA) ---------
# https://geoportal.statistics.gov.uk/datasets/output-area-to-lower-layer-super-output-area-to-middle-layer-super-output-area-to-local-authority-district-december-2021-lookup-in-england-and-wales-v2/about
tmp <- tempfile(fileext = ".csv")
GET(url = "https://www.arcgis.com/sharing/rest/content/items/9f0bc2c6fbc9427ba11db01759e5f6d8/data",
    write_disk(tmp))

statistical_lookup <- read_csv(tmp) %>%
  filter(lad22nm %in% gm_authorities_vector) %>%
  select(-lad22nmw) %>%
  write_csv("statistical_lookup.csv")
  
# delete the downloaded data
unlink(tmp)


# Administrative lookup (wards to local authority) ---------
# Source: https://geoportal.statistics.gov.uk/documents/ward-to-local-authority-district-may-2022-lookup-in-the-united-kingdom/about
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://www.arcgis.com/sharing/rest/content/items/27dee9a199cf4181b63fe2ea9b9c81f0/data",
    write_disk(tmp))

administrative_lookup <- read_xlsx(tmp) %>%
  filter(LAD22NM %in% gm_authorities_vector) %>% 
  setNames(tolower(names(.))) %>%
  select(wd22cd, wd22nm, lad22cd, lad22nm) %>%
  write_csv("administrative_lookup.csv")

# delete the downloaded raw data
unlink(tmp)


# Best-fit lookup between LSOAs and wards.
# Source: https://geoportal.statistics.gov.uk/datasets/ons::lsoa-2021-to-ward-to-lower-tier-local-authority-may-2022-lookup-for-england-and-wales/about
lsoa_to_ward_best_fit_lookup <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LSOA21_WD22_LTLA22_EW_LU/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
  filter(LTLA22NM %in% gm_authorities_vector) %>%
  st_drop_geometry() %>% # NOTE: although a GeoJSON file the geometry is empty so we'll get that by joining to the LSOAs file in the next step
  select(-WD22NMW, -LTLA22NMW, -ObjectId) %>% 
  setNames(tolower(names(.))) %>%
  rename(lad22cd = ltla22cd,
         lad22nm = ltla22nm) # Local Authority District (lad) naming is more common in our files than Lower Tier Local Authority (ltla)

# Generalised resolution LSOAs
# Source: https://geoportal.statistics.gov.uk/datasets/ons::lower-layer-super-output-areas-december-2021-boundaries-generalised-clipped-ew-bgc/about
lsoa_to_ward_best_fit_geometry <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Lower_layer_Super_Output_Areas_Decemeber_2021_EW_BGC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
  filter(grepl(gm_authorities_pipe_string, LSOA21NM)) %>%
  select(lsoa21cd = LSOA21CD) %>% # we only want the LSOA codes to join on and the geometry
  left_join(lsoa_to_ward_best_fit_lookup, by = "lsoa21cd")

write_csv(lsoa_to_ward_best_fit_lookup, "lsoa_to_ward_best-fit_lookup.csv")
st_write(lsoa_to_ward_best_fit_geometry, "lsoa_to_ward_best-fit_lookup.geojson")


# Codelist - statistical and administrative geography codes for Greater Manchester ---------
oa <- statistical_lookup %>%  
  select(area_code = oa21cd) %>% 
  mutate(area_name = NA, area_type = "Output Area") %>%
  arrange(area_code)

lsoa <- statistical_lookup %>% 
  distinct(lsoa21cd, lsoa21nm) %>% 
  select(area_code = lsoa21cd, area_name = lsoa21nm) %>% 
  mutate(area_type = "Lower-layer Super Output Area") %>%
  arrange(area_code)

msoa <- statistical_lookup %>%  
  distinct(msoa21cd, msoa21nm) %>% 
  select(area_code = msoa21cd, area_name = msoa21nm) %>% 
  mutate(area_type = "Middle-layer Super Output Area") %>%
  arrange(area_code)

wards <- administrative_lookup %>% 
  select(area_code = wd22cd, area_name = wd22nm) %>% 
  mutate(area_type = "Electoral Ward") %>%
  arrange(area_code)

la <- administrative_lookup %>%  
  distinct(lad22cd, lad22nm) %>% 
  select(area_code = lad22cd, area_name = lad22nm) %>% 
  mutate(area_type = "Local Authority District") %>%
  arrange(area_code)

# Combined Authorities
# Source: https://geoportal.statistics.gov.uk/documents/local-authority-district-to-combined-authority-december-2021-lookup-in-england-v2/about
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://www.arcgis.com/sharing/rest/content/items/93720e02514b408eb16cad5be13a2899/data",
    write_disk(tmp))

ca <- read_xlsx(tmp) %>%
  filter(CAUTH21NM == "Greater Manchester") %>% 
  select(area_code = CAUTH21CD, area_name = CAUTH21NM) %>%
  distinct(area_code, area_name) %>% 
  mutate(area_type = "Combined Authority")

# delete the downloaded raw data
unlink(tmp)

# Bind all code lists together and save
bind_rows(oa, lsoa, msoa, wards, la, ca) %>%
  write_csv("codelist.csv")
