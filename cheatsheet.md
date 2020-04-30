## Retrieving vector boundary layers from [ONS Open Geography Portal](https://geoportal.statistics.gov.uk/) #

#### Load necessary R packages
```
library(tidyverse) ; library(sf) ; library(jsonlite)
```

#### Create a string object with the name of your local authority
```
id <- "Trafford"
```

- **Local authority boundary**
```
la <- st_read(paste0("https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Local_Authority_Districts_December_2018_Boundaries_UK_BGC/MapServer/0/query?where=UPPER(lad18nm)%20like%20'%25", URLencode(toupper(id), reserved = TRUE), "%25'&outFields=lad18cd,lad18nm,long,lat&outSR=4326&f=geojson"), quiet = TRUE) %>% 
  select(area_code = lad18cd, area_name = lad18nm, lon = long, lat)
```

- **Multiple local authority boundaries**
```
multiple_ids <- c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")

las <- st_read(paste0("https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Local_Authority_Districts_DEC_2018_Boundaries/FeatureServer/2/query?where=", URLencode(paste0("lad18nm IN (", paste(shQuote(multiple_ids), collapse = ", "), ")")), "&outFields=%2A&geometryPrecision=6&f=geojson"), quiet = TRUE)
```

- **Electoral wards**
```
lookup <- read_csv("https://opendata.arcgis.com/datasets/e169bb50944747cd83dcfb4dd66555b1_0.csv") %>% 
  filter(LAD19NM == id) %>% 
  pull(WD19CD)

wards <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD_DEC_2019_UK_BGC/FeatureServer/0/query?where=", 
                        URLencode(paste0("wd19cd IN (", paste(shQuote(lookup), collapse = ", "), ")")), 
                        "&outFields=wd19cd,wd19nm&outSR=4326&f=geojson"))
```

- **Middle Super Output Areas**
```
codes <- fromJSON(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/OA11_LSOA11_MSOA11_LAD11_EW_LUv2/FeatureServer/0/query?where=LAD11NM%20like%20'%25", URLencode(toupper(id), reserved = TRUE), "%25'&outFields=MSOA11CD,LAD11NM&outSR=4326&f=json"), flatten = TRUE) %>% 
  pluck("features") %>% 
  as_tibble() %>% 
  distinct(attributes.MSOA11CD) %>% 
  pull(attributes.MSOA11CD)

msoa <- st_read(paste0("https://ons-inspire.esriuk.com/arcgis/rest/services/Census_Boundaries/Middle_Super_Output_Areas_December_2011_Boundaries/MapServer/2/query?where=", 
                       URLencode(paste0("msoa11cd IN (", paste(shQuote(codes), collapse = ", "), ")")), 
                       "&outFields=msoa11cd,msoa11nm&outSR=4326&f=geojson"))
```

- **Lower-layer Super Output Areas**
```
lsoa <- st_read(paste0("https://ons-inspire.esriuk.com/arcgis/rest/services/Census_Boundaries/Lower_Super_Output_Areas_December_2011_Boundaries/MapServer/2/query?where=UPPER(lsoa11nm)%20like%20'%25", URLencode(toupper(id), reserved = TRUE), "%25'&outFields=lsoa11cd,lsoa11nm&outSR=4326&f=geojson")) %>% 
  select(area_code = lsoa11cd, area_name = lsoa11nm)
```

- **Output Areas**
```
code <- fromJSON(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LAD_DEC_2018_UK_NC/FeatureServer/0/query?where=LAD18NM%20like%20'%25", URLencode(toupper(id), reserved = TRUE), "%25'&outFields=LAD18CD&outSR=4326&f=json"), flatten = TRUE) %>% 
  pluck("features") %>% 
  as_tibble() %>% 
  distinct(attributes.LAD18CD) %>% 
  pull(attributes.LAD18CD)

oa <- st_read(paste0("https://ons-inspire.esriuk.com/arcgis/rest/services/Census_Boundaries/Output_Area_December_2011_Boundaries/MapServer/2/query?where=UPPER(lad11cd)%20like%20'%25", URLencode(toupper(code), reserved = TRUE), "%25'&outFields=oa11cd&outSR=4326&f=geojson")) %>% 
  select(area_code = oa11cd)
```
