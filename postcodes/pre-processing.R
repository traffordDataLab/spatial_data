## ONS Postcode Directory (Latest) Centroids ##

# Source: Office for National Statistics
# Publisher URL: http://geoportal.statistics.gov.uk/datasets/ons-postcode-directory-latest-centroids
# Licence: Open Government Licence 3.0

library(tidyverse) ; library(sf)

postcodes <- read_csv("http://geoportal.statistics.gov.uk/datasets/75edec484c5d49bcadd4893c0ebca0ff_0.csv") %>% 
  filter(oslaua == "E08000009") %>% 
  select(postcode = pcds, lat, long) %>% 
  write_csv("trafford_postcodes_2018-02.csv")

