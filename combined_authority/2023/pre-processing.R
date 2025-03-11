# Greater Manchester (GM) Combined Authority geographies (December 2023)
# Source: ONS
# URL: https://geoportal.statistics.gov.uk/


# Load the required libraries ---------------------------
library(tidyverse); library(sf);


# Create geographies ---------------------------
# Files are created for Greater Manchester (both polygon and polyline versions) at 3 resolutions: full, generalised and super generalised

#########
# Full Resolution (Clipped to the coastline): https://geoportal.statistics.gov.uk/datasets/ons::combined-authorities-december-2023-boundaries-en-bfc/about
df_fr <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Combined_Authorities_December_2023_Boundaries_EN_BFC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
    filter(CAUTH23NM == "Greater Manchester") %>%
    mutate(area = round(Shape__Area, 3),
           area_units = "Square metres") %>%
    st_cast("POLYGON") %>% # convert from MULTIPOLYGON to POLYGON for simplicity
    select(area_code = CAUTH23CD, area_name = CAUTH23NM, lon = LONG, lat = LAT, area, area_units)

# Save files for GM
write_sf(df_fr, "gm_combined_authority_full_resolution.geojson") # standard polygon geometry
write_sf(st_cast(df_fr,"LINESTRING"), "gm_combined_authority_full_resolution_overlay.geojson") # linestring geometry for overlays (you can click "through" the layer to ones below)


#########
# Generalised Resolution (Clipped to the coastline): https://geoportal.statistics.gov.uk/datasets/ons::combined-authorities-december-2023-boundaries-en-bgc/about
df_gen <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Combined_Authorities_December_2023_Boundaries_EN_BGC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
    filter(CAUTH23NM == "Greater Manchester") %>%
    mutate(area = round(Shape__Area, 3),
           area_units = "Square metres") %>%
    st_cast("POLYGON") %>% # convert from MULTIPOLYGON to POLYGON for simplicity
    select(area_code = CAUTH23CD, area_name = CAUTH23NM, lon = LONG, lat = LAT, area, area_units)

# Save files for GM
write_sf(df_gen, "gm_combined_authority_generalised.geojson") # standard polygon geometry
write_sf(st_cast(df_gen,"LINESTRING"), "gm_combined_authority_generalised_overlay.geojson") # linestring geometry for overlays


#########
# Super Generalised Resolution (Clipped to the coastline): https://geoportal.statistics.gov.uk/datasets/ons::combined-authorities-december-2023-boundaries-en-bsc/about
df_super <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Combined_Authorities_December_2023_Boundaries_EN_BSC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson") %>%
    filter(CAUTH23NM == "Greater Manchester") %>%
    mutate(area = round(Shape__Area, 3),
           area_units = "Square metres") %>%
    st_cast("POLYGON") %>% # convert from MULTIPOLYGON to POLYGON for simplicity
    select(area_code = CAUTH23CD, area_name = CAUTH23NM, lon = LONG, lat = LAT, area, area_units)

# Save files for GM
write_sf(df_super, "gm_combined_authority_super_generalised.geojson") # standard polygon geometry
write_sf(st_cast(df_super,"LINESTRING"), "gm_combined_authority_super_generalised_overlay.geojson") # linestring geometry for overlays
