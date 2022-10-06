## ONS Postcode Directory (August 2022) ##

# Source: ONS Open Geography Portal
# Publisher URL: https://geoportal.statistics.gov.uk/datasets/ons-postcode-directory-august-2022/about
# Licence: Open Government Licence 3.0

# NOTE: care must be taken to ensure that the boundary data, (wards, MSOAs, LSOAs) is kept up to date otherwise NAs will appear in the data against some postcodes

# load necessary packages ---------
library(tidyverse) ; library(sf) ; library(httr)


# Wards ---------
# Obtain lookup for Greater Manchester containing all the wards and their associated LAs
# Source: https://geoportal.statistics.gov.uk/documents/ward-to-local-authority-district-may-2022-lookup-in-the-united-kingdom/about
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://www.arcgis.com/sharing/rest/content/items/27dee9a199cf4181b63fe2ea9b9c81f0/data",
    write_disk(tmp))

lookup_ward_la_gm <- read_xlsx(tmp) %>%
  filter(LAD22NM %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
  select(ward_code = WD22CD,
         ward_name = WD22NM,
         la_code = LAD22CD,
         la_name = LAD22NM)

# delete the downloaded raw data
unlink(tmp)


# Using the MSOA name file from: https://houseofcommonslibrary.github.io/msoanames/
# There is a static URL available with the latest data, however for reproducibility we use the specific version file
msoa <- read_csv("https://houseofcommonslibrary.github.io/msoanames/MSOA-Names-2.0.csv") %>% 
  filter(localauthorityname %in% unique(lookup_ward_la_gm$la_name)) %>%
  select(msoa_code=msoa21cd,msoa_hcl_name=msoa21hclnm)


# Statistical lookup OA -> LSOA -> MSOA -> LAD to get the LSOAs in each Greater
# Source: https://geoportal.statistics.gov.uk/datasets/output-area-to-lower-layer-super-output-area-to-middle-layer-super-output-area-to-local-authority-district-december-2021-lookup-in-england-and-wales-v2/about
tmp <- tempfile(fileext = ".csv")
GET(url = "https://www.arcgis.com/sharing/rest/content/items/9f0bc2c6fbc9427ba11db01759e5f6d8/data",
    write_disk(tmp))

lsoa <- read_csv(tmp) %>%
  filter(lad22nm %in% unique(lookup_ward_la_gm$la_name)) %>%
  select(lsoa_code = lsoa21cd, lsoa_name = lsoa21nm) %>%
  unique() # Need to remove duplicate LSOA entries (due to LSOAs containing multiple OAs but we've only extracted the LSOAs)

# delete the downloaded raw data
unlink(tmp)


# Now download the actual postcodes file ---------
pcode_file_reference <- "ONSPD_AUG_2022_UK" # makes it easier to change this once here than throughout the code below

# https://geoportal.statistics.gov.uk/datasets/ons-postcode-directory-august-2022/about
tmp <- tempfile(fileext = ".zip")
GET(url = "https://www.arcgis.com/sharing/rest/content/items/8e0d123a946240288c3c84cf9f9cba28/data",
    write_disk(tmp))

unzip(tmp, exdir = pcode_file_reference) # extract the contents of the zip

# delete the downloaded zip
unlink(tmp)

postcodes_gm <- read_csv(paste0(pcode_file_reference, "/Data/", pcode_file_reference, ".csv")) %>% 
  filter(oslaua %in% unique(lookup_ward_la_gm$la_code)) %>%
  select(postcode = pcds,
         ward_code = osward,
         msoa_code = msoa21,
         lsoa_code = lsoa21,
         la_code = oslaua,
         lon = long,
         lat = lat) %>% 
  left_join(lookup_ward_la_gm %>% select(ward_code,ward_name,la_name), by = "ward_code") %>% 
  left_join(msoa, by = "msoa_code") %>%
  left_join(lsoa, by = "lsoa_code") %>%
  select(postcode, ward_code, ward_name, msoa_code, msoa_hcl_name, lsoa_code, lsoa_name, la_code, la_name, lon, lat)

# Filter for just postcodes in Trafford and add localities info
trafford_postcodes <- postcodes_gm %>%
  filter(la_name=="Trafford") %>%
  mutate(locality = 
           case_when(
             ward_name %in% c("Ashton upon Mersey", "Brooklands", "Priory", "St Mary's", "Sale Moor") ~ "Central",
             ward_name %in% c("Clifford", "Gorse Hill", "Longford", "Stretford") ~ "North",
             ward_name %in% c("Altrincham", "Bowdon", "Broadheath", "Hale Barns", "Hale Central", "Timperley", "Village") ~ "South",
             ward_name %in% c("Bucklow-St Martins", "Davyhulme East", "Davyhulme West", "Flixton", "Urmston") ~ "West")) %>%
  select(postcode, ward_code, ward_name, msoa_code, msoa_hcl_name, lsoa_code, lsoa_name, locality, la_code, la_name, lon, lat)

# write data ---------
write_csv(postcodes_gm, "gm_postcodes.csv")
write_csv(trafford_postcodes, "trafford_postcodes.csv")


# Tidy up filesystem ---------------------------
unlink(pcode_file_reference, recursive = TRUE)
