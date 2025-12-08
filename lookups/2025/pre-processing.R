## Lookups for Greater Manchester based on 2021 statistical and 2025 administrative boundaries ##

# Source: Open Geography Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# load libraries ---------
library(tidyverse) ; library(sf) ; library(readxl) ; library(httr)

# These are used throughout. The vector for "filter %in%" operations and the pipe-separated in grepl()
gm_authorities_vector <- c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")
gm_authorities_pipe_string <- "Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan"


# Statistical lookup (Output Area (2021) to LSOA to MSOA to LAD (December 2021) Exact Fit Lookup in EW (V3)) ---------
# https://geoportal.statistics.gov.uk/datasets/ons::output-area-2021-to-lsoa-to-msoa-to-lad-december-2021-exact-fit-lookup-in-ew-v3/about
# NOTE: Query has parameter to remove the geometry field (which is empty anyway), so we'll receive a warning from sf that there are no geometries present, and the GM LAs are filters in the URL to reduce the amount of data and time when calling the API
statistical_lookup <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/OA_LSOA_MSOA_EW_DEC_2021_LU_v3/FeatureServer/0/query?where=LAD22NM%20%3D%20'BOLTON'%20OR%20LAD22NM%20%3D%20'BURY'%20OR%20LAD22NM%20%3D%20'MANCHESTER'%20OR%20LAD22NM%20%3D%20'OLDHAM'%20OR%20LAD22NM%20%3D%20'ROCHDALE'%20OR%20LAD22NM%20%3D%20'SALFORD'%20OR%20LAD22NM%20%3D%20'STOCKPORT'%20OR%20LAD22NM%20%3D%20'TAMESIDE'%20OR%20LAD22NM%20%3D%20'TRAFFORD'%20OR%20LAD22NM%20%3D%20'WIGAN'&outFields=*&returnGeometry=false&outSR=4326&f=json") %>%
    rename_all(tolower) %>%
    
    # If you prefer to use the GeoJSON URL straight from the page with no parameters you'll need to uncomment the following lines:
    #st_drop_geometry() %>%
    #filter(lad22nm %in% gm_authorities_vector) %>%
    
    select(-ends_with("nmw"), -objectid) %>% # don't need the Welsh names columns as they are all null
    arrange(lad22nm, oa21cd) %>%
    write_csv("statistical_lookup.csv")


# Administrative lookup (Ward to Local Authority District (May 2025) Lookup in the UK (V2)) ---------
# Source: https://geoportal.statistics.gov.uk/datasets/ons::ward-to-local-authority-district-may-2025-lookup-in-the-uk-v2/about
# NOTE: Query has parameter to remove the geometry field (which is empty anyway), so we'll receive a warning from sf that there are no geometries present, and the GM LAs are filters in the URL to reduce the amount of data and time when calling the API
administrative_lookup <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD25_LAD25_UK_LU_v2/FeatureServer/0/query?where=LAD25NM%20%3D%20'BOLTON'%20OR%20LAD25NM%20%3D%20'BURY'%20OR%20LAD25NM%20%3D%20'MANCHESTER'%20OR%20LAD25NM%20%3D%20'OLDHAM'%20OR%20LAD25NM%20%3D%20'ROCHDALE'%20OR%20LAD25NM%20%3D%20'SALFORD'%20OR%20LAD25NM%20%3D%20'STOCKPORT'%20OR%20LAD25NM%20%3D%20'TAMESIDE'%20OR%20LAD25NM%20%3D%20'TRAFFORD'%20OR%20LAD25NM%20%3D%20'WIGAN'&outFields=*&returnGeometry=false&outSR=4326&f=json") %>%
    rename_all(tolower) %>%
    
    # If you prefer to use the GeoJSON URL straight from the page with no parameters you'll need to uncomment the following lines:
    #st_drop_geometry() %>%
    #filter(lad25nm %in% gm_authorities_vector) %>%

    select(-ends_with("nmw"), -objectid) %>% # don't need the Welsh names columns as they are all null
    arrange(lad25nm, wd25cd) %>%
    write_csv("administrative_lookup.csv")


# Best-fit lookup between LSOAs and wards (LSOA (2021) to Electoral Ward (2025) to LAD (2025) Best Fit Lookup in EW (V2)) ---------
# Source: https://geoportal.statistics.gov.uk/datasets/ons::lsoa-2021-to-electoral-ward-2025-to-lad-2025-best-fit-lookup-in-ew-v2/about
# NOTE: Query has parameter to remove the geometry field (which is empty anyway), so we'll receive a warning from sf that there are no geometries present, and the GM LAs are filters in the URL to reduce the amount of data and time when calling the API
lsoa_to_ward_best_fit_lookup <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LSOA21_WD25_LAD25_EW_LU_v2/FeatureServer/0/query?where=LAD25NM%20%3D%20'BOLTON'%20OR%20LAD25NM%20%3D%20'BURY'%20OR%20LAD25NM%20%3D%20'MANCHESTER'%20OR%20LAD25NM%20%3D%20'OLDHAM'%20OR%20LAD25NM%20%3D%20'ROCHDALE'%20OR%20LAD25NM%20%3D%20'SALFORD'%20OR%20LAD25NM%20%3D%20'STOCKPORT'%20OR%20LAD25NM%20%3D%20'TAMESIDE'%20OR%20LAD25NM%20%3D%20'TRAFFORD'%20OR%20LAD25NM%20%3D%20'WIGAN'&outFields=*&returnGeometry=false&outSR=4326&f=json") %>%
    rename_all(tolower) %>%
    
    # If you prefer to use the GeoJSON URL straight from the page with no parameters you'll need to uncomment the following lines:
    #st_drop_geometry() %>%
    #filter(lad25nm %in% gm_authorities_vector) %>%
    
    select(-ends_with("nmw"), -objectid) %>% # don't need the Welsh names columns as they are all null
    arrange(lad25nm, wd25nm, lsoa21cd) %>%
    write_csv("lsoa_to_ward_best-fit_lookup.csv")
    

# Generalised resolution LSOAs
# Source: https://geoportal.statistics.gov.uk/datasets/ons::lower-layer-super-output-areas-december-2021-boundaries-ew-bgc-v5-2/about
lsoa_to_ward_best_fit_geometry <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Lower_layer_Super_Output_Areas_December_2021_Boundaries_EW_BGC_V5/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
    filter(grepl(gm_authorities_pipe_string, LSOA21NM)) %>%
    select(lsoa21cd = LSOA21CD) %>% # we only want the LSOA codes to join on and the geometry
    left_join(lsoa_to_ward_best_fit_lookup, by = "lsoa21cd") %>%
    arrange(lad25nm, wd25nm, lsoa21cd) %>%
    st_write("lsoa_to_ward_best-fit_lookup.geojson")


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
  select(area_code = wd25cd, area_name = wd25nm) %>% 
  mutate(area_type = "Electoral Ward") %>%
  arrange(area_code)

la <- administrative_lookup %>%  
  distinct(lad25cd, lad25nm) %>% 
  select(area_code = lad25cd, area_name = lad25nm) %>% 
  mutate(area_type = "Local Authority District") %>%
  arrange(area_code)


# Combined Authorities
# Source: https://geoportal.statistics.gov.uk/datasets/ons::local-authority-district-to-combined-authority-may-2025-lookup-in-en/about
# NOTE: No geometry present but as the output is JSON we can use st_read, we'll just receive a warning from sf that there are no geometries present. GM combined authority is a filter in the URL to reduce the amount of data and time when calling the API
ca <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LAD25_CAUTH25_EN_LU/FeatureServer/0/query?where=CAUTH25NM%20%3D%20'GREATER%20MANCHESTER'&outFields=*&outSR=4326&f=json") %>%
    select(area_code = CAUTH25CD, area_name = CAUTH25NM) %>%
    distinct(area_code, area_name) %>% 
    mutate(area_type = "Combined Authority")


# Bind all code lists together and save ---------
bind_rows(oa, lsoa, msoa, wards, la, ca) %>%
  write_csv("codelist.csv")
