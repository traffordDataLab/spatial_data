## Lookups ##

# Source: Open Goegraphy Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse)

# Statistical lookup
read_csv("OA11_LSOA11_MSOA11_LAD11_EW_LUv2.csv") %>% 
  filter(LAD11NM %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
  select(-LAD11NMW) %>% 
  setNames(tolower(names(.))) %>% 
  write_csv("statistical_lookup.csv")

# Administrative lookup
admiministrative <- read_csv("https://opendata.arcgis.com/datasets/046394602a6b415e9fe4039083ef300e_0.csv") %>% 
  filter(LAD17NM %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
  select(-WD17NMW, -FID) %>%
  setNames(tolower(names(.))) %>%
  write_csv("administrative_lookup.csv")

# Best-fit lookup between LSOAs and wards
lookup <- read_csv("https://opendata.arcgis.com/datasets/500d4283cbe54e3fa7f358399ba3783e_0.csv") %>% 
  filter(LAD17NM %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
  select(-LSOA11NM, -WD17NMW, -FID) %>% 
  setNames(tolower(names(.)))

lsoa <- st_read("https://opendata.arcgis.com/datasets/da831f80764346889837c72508f046fa_2.geojson") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', lsoa11nm)) %>% 
  select(lsoa11cd, lsoa11nm)

lsoa_to_ward <- left_join(lsoa, lookup, by = "lsoa11cd")

write_csv(lookup, "lsoa_to_ward_best-fit_lookup.csv")
st_write(lsoa_to_ward, "lsoa_to_ward_best-fit_lookup.geojson")
