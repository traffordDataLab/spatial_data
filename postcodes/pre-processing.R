## ONS Postcode Directory (February 2025) ##

# Source: ONS Open Geography Portal
# Publisher URL: https://geoportal.statistics.gov.uk/datasets/ons::ons-postcode-directory-february-2025-for-the-uk/about
# Licence: Open Government Licence 3.0

# NOTES:
#       Care must be taken to ensure that the boundary data, (wards, MSOAs, LSOAs) is kept up to date otherwise NAs will appear in the data against some postcodes
#       Use the GeoJSON API option from the ONS GeoPortal to obtain the data and then discard the coordinates as the JSON option only returns max 1000 records

# load necessary packages ---------
library(tidyverse) ; library(jsonlite) ; library(httr) ; library(sf)


# Wards ---------
# Obtain lookup for Greater Manchester containing all the wards and their associated LAs
# Source: https://geoportal.statistics.gov.uk/datasets/ons::ward-to-local-authority-district-may-2024-lookup-in-the-uk/about
lookup_ward_la_gm <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD24_LAD24_UK_LU/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
    st_drop_geometry() %>%
    filter(LAD24NM %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
    arrange(LAD24NM, WD24CD) %>%
    select(ward_code = WD24CD,
           ward_name = WD24NM,
           la_code = LAD24CD,
           la_name = LAD24NM)


# Using the MSOA name file from: https://houseofcommonslibrary.github.io/msoanames/
# There is a static URL available with the latest data, however for reproducibility we use the specific version file
msoa <- read_csv("https://houseofcommonslibrary.github.io/msoanames/MSOA-Names-2.2.csv") %>% 
  filter(localauthorityname %in% unique(lookup_ward_la_gm$la_name)) %>%
  select(msoa_code=msoa21cd,msoa_hcl_name=msoa21hclnm)


# Statistical lookup OA -> LSOA -> MSOA -> LAD to get the LSOAs in each Greater Manchester LA
# Source: https://geoportal.statistics.gov.uk/datasets/ons::output-area-2021-to-lsoa-to-msoa-to-lad-december-2021-exact-fit-lookup-in-ew-v3/about
lsoa <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/OA_LSOA_MSOA_EW_DEC_2021_LU_v3/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
    st_drop_geometry() %>%
    filter(LAD22NM %in% unique(lookup_ward_la_gm$la_name)) %>%
    select(lsoa_code = LSOA21CD, lsoa_name = LSOA21NM) %>%
    unique() # Need to remove duplicate LSOA entries (due to LSOAs containing multiple OAs but we've only extracted the LSOAs)


# Now download the actual postcodes file ---------
pcode_file_reference <- "ONSPD_FEB_2025_UK" # makes it easier to change this once here than throughout the code below

# https://geoportal.statistics.gov.uk/datasets/ons::ons-postcode-directory-february-2025-for-the-uk/about
tmp <- tempfile(fileext = ".zip")
GET(url = "https://www.arcgis.com/sharing/rest/content/items/6fb8941d58e54d949f521c92dfb92f2a/data",
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
             ward_name %in% c("Ashton upon Mersey", "Brooklands", "Manor", "Sale Central", "Sale Moor") ~ "Central",
             ward_name %in% c("Gorse Hill & Cornbrook", "Longford", "Lostock & Barton", "Old Trafford", "Stretford & Humphrey Park") ~ "North",
             ward_name %in% c("Altrincham", "Bowdon", "Broadheath", "Hale", "Hale Barns & Timperley South", "Timperley Central", "Timperley North") ~ "South",
             ward_name %in% c("Bucklow-St Martins", "Davyhulme", "Flixton", "Urmston") ~ "West")) %>%
  select(postcode, ward_code, ward_name, msoa_code, msoa_hcl_name, lsoa_code, lsoa_name, locality, la_code, la_name, lon, lat)

# write data ---------
write_csv(postcodes_gm, "gm_postcodes.csv")
write_csv(trafford_postcodes, "trafford_postcodes.csv")


# Tidy up filesystem ---------------------------
unlink(pcode_file_reference, recursive = TRUE)
