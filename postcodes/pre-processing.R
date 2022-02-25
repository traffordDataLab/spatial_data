## ONS Postcode Directory (August 2021) ##

# Source: ONS Open Geography Portal
# Publisher URL: https://geoportal.statistics.gov.uk/datasets/ons::ons-postcode-directory-february-2022/about
# Licence: Open Government Licence 3.0

# load necessary packages ---------------------------
library(tidyverse) ; library(sf) ; library(jsonlite)

# import and tidy data ---------------------------

gm<- "Greater Manchester"
lookup_ward_la_gm <- fromJSON(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD19_LAD19_CTY19_OTH_UK_LU/FeatureServer/0/query?where=",
URLencode(paste0("CTY19NM = '", gm , "'"), reserved = TRUE),
                       "&outFields=wd19cd,wd19nm,lad19cd,lad19nm&outSR=4326&f=json"), flatten = T) %>%
  pluck("features") %>%
  select(ward_code = attributes.WD19CD,
         ward_name = attributes.WD19NM,
         la_code = attributes.LAD19CD,
         la_name = attributes.LAD19NM)

# Using the MSOA name file from: https://houseofcommonslibrary.github.io/msoanames/
# There is a static URL available with the latest data, however for reproducibility we use the specific version file
msoa <- read_csv("https://houseofcommonslibrary.github.io/msoanames/MSOA-Names-1.16.csv") %>% 
  filter(Laname %in% unique(lookup_ward_la_gm$la_name)) %>%
  select(msoa_code=msoa11cd,msoa_hcl_name=msoa11hclnm)

lsoa <- read_csv("https://www.trafforddatalab.io/spatial_data/lookups/statistical_lookup.csv") %>%
  select(lsoa_code = lsoa11cd, lsoa_name = lsoa11nm) %>%
  unique()

url <- "https://www.arcgis.com/sharing/rest/content/items/3cee8796c4aa408581c55361a5ddc967/data"
download.file(url, dest = "ONSPD_FEB_2022_UK.zip")
unzip("ONSPD_FEB_2022_UK.zip", exdir = "ONSPD_FEB_2022_UK")
file.remove("ONSPD_FEB_2022_UK.zip")

postcodes_gm <- read_csv("ONSPD_FEB_2022_UK/Data/ONSPD_FEB_2022_UK.csv") %>% 
  filter(oslaua %in% unique(lookup_ward_la_gm$la_code)) %>%
  select(postcode = pcds,
         ward_code = osward,
         msoa_code = msoa11,
         lsoa_code = lsoa11,
         la_code = oslaua,
         lon = long,
         lat = lat) %>% 
  left_join(lookup_ward_la_gm %>% select(ward_code,ward_name,la_name), by = "ward_code") %>% 
  left_join(msoa, by = "msoa_code") %>%
  left_join(lsoa, by = "lsoa_code") %>%
  select(postcode, ward_code, ward_name, msoa_code, msoa_hcl_name, lsoa_code, lsoa_name, la_code, la_name, lon, lat)

# write data ---------------------------
write_csv(postcodes_gm, "gm_postcodes.csv")

# add localities info to Trafford ---------------------------

trafford_postcodes <- postcodes_gm %>%
  filter(la_name=="Trafford") %>%
  mutate(locality = 
           case_when(
             ward_name %in% c("Ashton upon Mersey", "Brooklands", "Priory", "St Mary's", "Sale Moor") ~ "Central",
             ward_name %in% c("Clifford", "Gorse Hill", "Longford", "Stretford") ~ "North",
             ward_name %in% c("Altrincham", "Bowdon", "Broadheath", "Hale Barns", "Hale Central", "Timperley", "Village") ~ "South",
             ward_name %in% c("Bucklow-St Martins", "Davyhulme East", "Davyhulme West", "Flixton", "Urmston") ~ "West")) %>%
  select(postcode, ward_code, ward_name, msoa_code, msoa_hcl_name, lsoa_code, lsoa_name, locality, la_code, la_name, lon, lat)


write_csv(trafford_postcodes, "trafford_postcodes.csv")
