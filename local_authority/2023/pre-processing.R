# Trafford & Greater Manchester (GM) local authority geographies (December 2023).
# Source: ONS
# URL: https://geoportal.statistics.gov.uk/


# Load the required libraries ---------------------------
library(tidyverse); library(sf);


# Create geographies ---------------------------
# Files are created for Trafford and all local authorities in Greater Manchester (both polygon and polyline versions) at 3 resolutions: full, generalised and super generalised

#########
# Full Resolution (Clipped to the coastline): https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-december-2023-boundaries-uk-bfc-2/about
df_fr <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_December_2023_Boundaries_UK_BFC/FeatureServer/0/query?outFields=*&where=%20(LAD23NM%20%3D%20'BOLTON'%20OR%20LAD23NM%20%3D%20'BURY'%20OR%20LAD23NM%20%3D%20'MANCHESTER'%20OR%20LAD23NM%20%3D%20'OLDHAM'%20OR%20LAD23NM%20%3D%20'ROCHDALE'%20OR%20LAD23NM%20%3D%20'SALFORD'%20OR%20LAD23NM%20%3D%20'STOCKPORT'%20OR%20LAD23NM%20%3D%20'TAMESIDE'%20OR%20LAD23NM%20%3D%20'TRAFFORD'%20OR%20LAD23NM%20%3D%20'WIGAN')%20&f=geojson") %>%
    mutate(area = round(Shape__Area, 3),
           area_units = "Square metres") %>%
    select(area_code = LAD23CD, area_name = LAD23NM, lon = LONG, lat = LAT, area, area_units)

# Save files for GM
write_sf(df_fr, "gm_local_authority_full_resolution.geojson") # standard polygon geometry
write_sf(st_cast(df_fr,"LINESTRING"), "gm_local_authority_full_resolution_overlay.geojson") # linestring geometry for overlays (you can click "through" the layer to ones below)

# Save files for Trafford
write_sf(df_fr %>% filter(area_name == 'Trafford'), "trafford_local_authority_full_resolution.geojson") # standard polygon geometry
write_sf(st_cast(df_fr,"LINESTRING") %>% filter(area_name == 'Trafford'), "trafford_local_authority_full_resolution_overlay.geojson") # linestring geometry for overlays (you can click "through" the layer to ones below)


#########
# Generalised Resolution (Clipped to coastline): https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-december-2023-boundaries-uk-bgc-2/about
df_gen <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_December_2023_Boundaries_UK_BGC/FeatureServer/0/query?outFields=*&where=%20(LAD23NM%20%3D%20'BOLTON'%20OR%20LAD23NM%20%3D%20'BURY'%20OR%20LAD23NM%20%3D%20'MANCHESTER'%20OR%20LAD23NM%20%3D%20'OLDHAM'%20OR%20LAD23NM%20%3D%20'ROCHDALE'%20OR%20LAD23NM%20%3D%20'SALFORD'%20OR%20LAD23NM%20%3D%20'STOCKPORT'%20OR%20LAD23NM%20%3D%20'TAMESIDE'%20OR%20LAD23NM%20%3D%20'TRAFFORD'%20OR%20LAD23NM%20%3D%20'WIGAN')%20&f=geojson") %>%
    mutate(area = round(Shape__Area, 3),
           area_units = "Square metres") %>%
    select(area_code = LAD23CD, area_name = LAD23NM, lon = LONG, lat = LAT, area, area_units)

# Save files for GM
write_sf(df_gen, "gm_local_authority_generalised.geojson") # standard polygon geometry
write_sf(st_cast(df_gen,"LINESTRING"), "gm_local_authority_generalised_overlay.geojson") # linestring geometry for overlays

# Save files for Trafford
write_sf(df_gen %>% filter(area_name == 'Trafford'), "trafford_local_authority_generalised.geojson") # standard polygon geometry
write_sf(st_cast(df_gen,"LINESTRING") %>% filter(area_name == 'Trafford'), "trafford_local_authority_generalised_overlay.geojson") # linestring geometry for overlays


#########
# Super Generalised Resolution (Clipped to coastline): https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-december-2023-boundaries-uk-bsc-2/about
df_super <- read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_December_2023_Boundaries_UK_BSC/FeatureServer/0/query?outFields=*&where=%20(LAD23NM%20%3D%20'BOLTON'%20OR%20LAD23NM%20%3D%20'BURY'%20OR%20LAD23NM%20%3D%20'MANCHESTER'%20OR%20LAD23NM%20%3D%20'OLDHAM'%20OR%20LAD23NM%20%3D%20'ROCHDALE'%20OR%20LAD23NM%20%3D%20'SALFORD'%20OR%20LAD23NM%20%3D%20'STOCKPORT'%20OR%20LAD23NM%20%3D%20'TAMESIDE'%20OR%20LAD23NM%20%3D%20'TRAFFORD'%20OR%20LAD23NM%20%3D%20'WIGAN')%20&f=geojson") %>%
    mutate(area = round(Shape__Area, 3),
           area_units = "Square metres") %>%
    select(area_code = LAD23CD, area_name = LAD23NM, lon = LONG, lat = LAT, area, area_units)

# Save files for GM
write_sf(df_super, "gm_local_authority_super_generalised.geojson") # standard polygon geometry
write_sf(st_cast(df_super,"LINESTRING"), "gm_local_authority_super_generalised_overlay.geojson") # linestring geometry for overlays

# Save files for Trafford
write_sf(df_super %>% filter(area_name == 'Trafford'), "trafford_local_authority_super_generalised.geojson") # standard polygon geometry
write_sf(st_cast(df_super,"LINESTRING") %>% filter(area_name == 'Trafford'), "trafford_local_authority_super_generalised_overlay.geojson") # linestring geometry for overlays
