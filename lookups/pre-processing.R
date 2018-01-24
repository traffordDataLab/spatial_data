## Pre-processing ##

library(tidyverse) ; library(sf)

# source: https://ons.maps.arcgis.com/home/item.html?id=baf6566ca08949c6bbd61ff81d9526da
lsoa_to_local_authority <- read_csv("OA11_LSOA11_MSOA11_LAD11_EW_LUv2.csv") %>% 
  filter(LAD11NM %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
  select(lsoa_code = LSOA11CD, lsoa_name = LSOA11NM, la_code = LAD11CD, la_name = LAD11NM) %>% 
  arrange(la_name)

write_csv(lsoa_to_local_authority, "lsoa_to_local_authority.csv")

# source: http://geoportal.statistics.gov.uk/datasets/ward-to-local-authority-district-december-2017-lookup-in-the-united-kingdom
ward_to_local_authority <- st_read("https://opendata.arcgis.com/datasets/046394602a6b415e9fe4039083ef300e_0.geojson") %>% 
  filter(LAD17NM %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>%
  select(ward_code = WD17CD, ward_name = WD17NM, la_code = LAD17CD, la_name = LAD17NM) %>% 
  st_set_geometry(value = NULL) %>% 
  arrange(la_name)

write_csv(ward_to_local_authority, "ward_to_local_authority.csv")

