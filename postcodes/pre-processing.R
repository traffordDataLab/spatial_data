## ONS Postcode Directory (Latest) Centroids ##

# Source: ONS Open Geography Portal
# Publisher URL: http://geoportal.statistics.gov.uk/datasets/ons-postcode-directory-latest-centroids
# Licence: Open Government Licence 3.0

# load necessary packages ---------------------------
library(tidyverse) ; library(jsonlite) ; library(sf)

# import and tidy data ---------------------------
lookup <- tibble(
  area_code = paste0("E0", seq(8000001, 8000010, by = 1)),
  area_name = c("Bolton", "Bury", "Manchester", "Oldham", "Rochdale", "Salford", 
                "Stockport", "Tameside", "Trafford", "Wigan"))

query <- paste0("https://ons-inspire.esriuk.com/arcgis/rest/services/Postcodes/ONS_Postcode_Directory_Latest_Centroids/MapServer/0/query?where=UPPER(oslaua)=%27", lookup$area_code, "%27&outFields=pcds,oslaua,lat,long&geometryPrecision=6&outSR=4326&f=json")

postcodes <- map_df(query, function(i) {
  cat(".")
  df <- fromJSON(i, flatten = TRUE) %>% 
    pluck("features") %>% 
    as_tibble() %>% 
    rename(area_code = attributes.oslaua) %>% 
    bind_rows() %>% 
    left_join(lookup, by = "area_code") %>% 
    select(postcode = attributes.pcds,
           area_code, area_name,
           lon = attributes.long,
           lat = attributes.lat)
})

# write data ---------------------------
write_csv(postcodes, "gm_postcodes.csv")

# add ward info to Trafford ---------------------------
wards <- st_read("https://www.trafforddatalab.io/spatial_data/ward/2017/trafford_ward_full_resolution.geojson") %>% 
  select(-lon, -lat) %>% 
  mutate(locality = 
           case_when(
             area_name %in% c("Ashton upon Mersey", "Brooklands", "Priory", "St Mary\'s", "Sale Moor") ~ "Central",
             area_name %in% c("Clifford", "Gorse Hill", "Longford", "Stretford") ~ "North",
             area_name %in% c("Altrincham", "Bowdon", "Broadheath", "Hale Barns", "Hale Central", "Timperley", "Village") ~ "South",
             area_name %in% c("Bucklow-St Martins", "Davyhulme East", "Davyhulme West", "Flixton", "Urmston") ~ "West"))

trafford <- filter(postcodes, area_name == "Trafford") %>% 
  st_as_sf(crs = 4326, coords = c("lon", "lat")) %>% 
  select(postcode) %>% 
  st_join(., wards, join = st_within) %>% 
  mutate(lon = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]])) %>% 
  st_set_geometry(NULL)

write_csv(trafford, "trafford_postcodes.csv")







