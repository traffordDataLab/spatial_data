
## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf) ; library(geojsonio)

# read data ---------------------------
geojson <- st_read("http://trafforddatalab.io/spatial_data/town_centres/trafford_town_centres.geojson")

# apply styles ---------------------------
geojson_styles <- geojson_style(geojson,
                                color = "#fc6721",
                                symbol = "city",
                                size = "medium") %>%   
  rename(`marker-color` = marker.color,
         `marker-symbol` = marker.symbol,
         `marker-size` = marker.size)

# write data ---------------------------
st_write(geojson_styles, "trafford_town_centres_styles.geojson")
