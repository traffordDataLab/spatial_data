## Lookups ##

# Source: Open Goegraphy Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

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

# Codelist - statistical and administrative geography codes for Greater Manchester

statistical_lookup <- read_csv("https://opendata.arcgis.com/datasets/fe6c55f0924b4734adf1cf7104a0173e_0.csv") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', LAD17NM)) %>% 
  select(OA11CD, LSOA11CD, LSOA11NM, MSOA11CD, MSOA11NM, LAD17CD, LAD17NM)

administrative_lookup <- read_csv("https://opendata.arcgis.com/datasets/046394602a6b415e9fe4039083ef300e_0.csv") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', LAD17NM))

oa <- statistical_lookup %>%  
  select(area_code = OA11CD) %>% 
  mutate(area_name = NA, area_type = "Output Areas")

lsoa <- statistical_lookup %>% 
  distinct(LSOA11CD, LSOA11NM) %>% 
  select(area_code = LSOA11CD, area_name = LSOA11NM) %>% 
  mutate(area_type = "Lower Layer Super Output Areas")

msoa <- statistical_lookup %>%  
  distinct(MSOA11CD, MSOA11NM) %>% 
  select(area_code = MSOA11CD, area_name = MSOA11NM) %>% 
  mutate(area_type = "Middle Layer Super Output Areas")

wards <- read_csv("https://opendata.arcgis.com/datasets/63773bdd52e34745be3db659663d5662_0.csv") %>% 
  filter(WD17CD %in% administrative_lookup$WD17CD) %>%
  select(area_code = WD17CD, area_name = WD17NM) %>% 
  mutate(area_type = "Electoral Wards") %>% 
  arrange(area_code)

la <- administrative_lookup %>%  
  distinct(LAD17CD, LAD17NM) %>% 
  select(area_code = LAD17CD, area_name = LAD17NM) %>% 
  mutate(area_type = "Local Authority Districts")

ca <- read_csv("https://opendata.arcgis.com/datasets/729dd1b2bd8141599e05356f284df279_0.csv") %>% 
  filter(CAUTH17NM == "Greater Manchester") %>% 
  select(area_code = CAUTH17CD, area_name = CAUTH17NM) %>% 
  mutate(area_type = "Combined Authority")

bind_rows(oa, lsoa, msoa, wards, la, ca) %>%
  write_csv("codelist.csv")
