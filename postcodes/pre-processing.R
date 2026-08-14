## ONS Postcode Directory (May 2026) ##

# Source: ONS Open Geography Portal
# Publisher URL: https://geoportal.statistics.gov.uk/datasets/ons::ons-postcode-directory-may-2026/about
# Licence: Open Government Licence 3.0

# NOTES:
#       Care must be taken to ensure that the boundary data, (wards, MSOAs, LSOAs) is kept up to date otherwise NAs will appear in the data against some postcodes
#       Use the GeoJSON API option from the ONS GeoPortal to obtain the data and then discard the coordinates as the JSON option only returns max 1000 records

# load necessary packages ---------
library(tidyverse) ; library(jsonlite) ; library(httr) ; library(sf)


# Ward lookup ---------
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


# MSOA names lookup ---------
# Using the MSOA name file from: https://houseofcommonslibrary.github.io/msoanames/
# There is a static URL available with the latest data, however for reproducibility we use the specific version file
msoa <- read_csv("https://houseofcommonslibrary.github.io/msoanames/MSOA-Names-2.2.csv") %>% 
  filter(localauthorityname %in% unique(lookup_ward_la_gm$la_name)) %>%
  select(msoa_code=msoa21cd,msoa_hcl_name=msoa21hclnm)


# LSOA names lookup ---------
# Statistical lookup OA -> LSOA -> MSOA -> LAD to get the LSOAs in each Greater Manchester LA
# Source: https://geoportal.statistics.gov.uk/datasets/ons::output-area-2021-to-lsoa-to-msoa-to-lad-december-2021-exact-fit-lookup-in-ew-v3/about
lsoa <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/OA_LSOA_MSOA_EW_DEC_2021_LU_v3/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
    st_drop_geometry() %>%
    filter(LAD22NM %in% unique(lookup_ward_la_gm$la_name)) %>%
    select(lsoa_code = LSOA21CD, lsoa_name = LSOA21NM) %>%
    unique() # Need to remove duplicate LSOA entries (due to LSOAs containing multiple OAs but we've only extracted the LSOAs)


# Download the postcodes file ---------
pcode_file_reference <- "ONSPD_MAY_2026_UK" # makes it easier to change this once here than throughout the code below

# https://geoportal.statistics.gov.uk/datasets/ons::ons-postcode-directory-may-2026/about
tmp <- tempfile(fileext = ".zip")
GET(url = "https://www.arcgis.com/sharing/rest/content/items/6fff67d204fd4f339591ed667a6e3642/data",
    write_disk(tmp))

unzip(tmp, exdir = pcode_file_reference) # extract the contents of the zip

# delete the downloaded zip
unlink(tmp)


# Process the downloaded data ---------

# **TO INCLUDE THE ICB CODE AND NAME, RUN THE FOLLOWING CODE AND THEN USE THIS IN ANOTHER left_join(icb, by = "icb_code") IN THE CODE BLOCK AFTER**
# We don't need to do this as the ICB for all postcodes in GM is E54000057 NHS Greater Manchester Integrated Care Board.
# This could also be used to add any other lookup data included in the download as required.
# pull out the Integrated Care Board (ICB) lookup (NOTE: using a regular expression here as we can't guarantee the "as at ..." date will stay the same and we don't want to have to manually look!).
icb_filename <- list.files(paste0(pcode_file_reference, "/Documents"), pattern="ICB Integrated Care Board names and codes UK as at [0-9]{2}_[0-9]{2}.csv")
icb <- read_csv(paste0(pcode_file_reference, "/Documents/", icb_filename)) %>%
    select(icb_code = ICB26CD,
           icb_name = ICB26NM)

# process the postcodes for the whole of GM and match to all the lookup files
gm_postcodes <- read_csv(paste0(pcode_file_reference, "/Data/", pcode_file_reference, ".csv")) %>% 
  filter(lad25cd %in% unique(lookup_ward_la_gm$la_code)) %>%
  select(postcode = pcds,
         date_introduced = dointr,
         date_terminated = doterm,
         ward_code = wd25cd,
         msoa_code = msoa21cd,
         lsoa_code = lsoa21cd,
         oa_code = oa21cd,
         la_code = lad25cd,
         lon = long,
         lat = lat) %>% 
  mutate(date_introduced = str_replace(as.character(date_introduced), "([0-9]{4})([0-9]{2})", "\\1-\\2"), # Convert the introduction date from YYYYMM to YYYY-MM
         date_terminated = str_replace(as.character(date_terminated), "([0-9]{4})([0-9]{2})", "\\1-\\2"), # Same as above for the terminated date
         is_active = if_else(is.na(date_terminated), TRUE, FALSE)) %>% # Boolean to indicate if the postcode is currently active (i.e. doesn't have a termination date)
  left_join(lookup_ward_la_gm %>% select(ward_code,ward_name,la_name), by = "ward_code") %>% 
  left_join(msoa, by = "msoa_code") %>%
  left_join(lsoa, by = "lsoa_code") %>%
  select(postcode, date_introduced, date_terminated, is_active, la_code, la_name, ward_code, ward_name, msoa_code, msoa_hcl_name, lsoa_code, lsoa_name, oa_code, lon, lat)

# Filter for just postcodes in Trafford and add localities info
trafford_postcodes <- gm_postcodes %>%
  filter(la_name=="Trafford") %>%
  mutate(locality = 
           case_when(
             ward_name %in% c("Ashton upon Mersey", "Brooklands", "Manor", "Sale Central", "Sale Moor") ~ "Central",
             ward_name %in% c("Gorse Hill & Cornbrook", "Longford", "Lostock & Barton", "Old Trafford", "Stretford & Humphrey Park") ~ "North",
             ward_name %in% c("Altrincham", "Bowdon", "Broadheath", "Hale", "Hale Barns & Timperley South", "Timperley Central", "Timperley North") ~ "South",
             ward_name %in% c("Bucklow-St Martins", "Davyhulme", "Flixton", "Urmston") ~ "West")) %>%
  select(postcode, date_introduced, date_terminated, is_active, la_code, la_name, locality, ward_code, ward_name, msoa_code, msoa_hcl_name, lsoa_code, lsoa_name, oa_code, lon, lat)

# Test for any NAs - resolve if any are found
colSums(is.na(gm_postcodes))
colSums(is.na(trafford_postcodes))


# Write data ---------
write_csv(gm_postcodes, "gm_postcodes.csv")
write_csv(trafford_postcodes, "trafford_postcodes.csv")


# Tidy up filesystem ---------------------------
unlink(pcode_file_reference, recursive = TRUE)
