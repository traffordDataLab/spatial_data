## Lookups ##

# Source: Open Goegraphy Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse)

# https://ons.maps.arcgis.com/home/item.html?id=baf6566ca08949c6bbd61ff81d9526da
read_csv("OA11_LSOA11_MSOA11_LAD11_EW_LUv2.csv") %>% 
  filter(LAD11NM %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
  select(-LAD11NMW) %>% 
  setNames(tolower(names(.))) %>% 
  write_csv("statistical_lookup.csv")

# source: http://geoportal.statistics.gov.uk/datasets/ward-to-local-authority-district-december-2017-lookup-in-the-united-kingdom
admiministrative <- read_csv("https://opendata.arcgis.com/datasets/046394602a6b415e9fe4039083ef300e_0.csv") %>% 
  filter(LAD17NM %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
  select(-WD17NMW, -FID) %>% 
  setNames(tolower(names(.))) %>%
  write_csv("administrative_lookup.csv")

