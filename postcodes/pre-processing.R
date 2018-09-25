## ONS Postcode Directory (Latest) Centroids ##

# Source: Office for National Statistics
# Publisher URL: http://geoportal.statistics.gov.uk/datasets/ons-postcode-directory-latest-centroids
# Licence: Open Government Licence 3.0

# load necessary packages ---------------------------
library(tidyverse)

# read and write data ---------------------------
read_csv("http://geoportal.statistics.gov.uk/datasets/75edec484c5d49bcadd4893c0ebca0ff_0.csv") %>% 
  filter(oslaua %in% c("E08000001", "E08000002", "E08000003", "E08000004", "E08000005", "E08000006", 
    "E08000007", "E08000008", "E08000009", "E08000010")) %>% 
  select(postcode = pcds, lon = long, lat) %>% 
  write_csv("GM_postcodes_2018-08.csv")

read_csv("http://geoportal.statistics.gov.uk/datasets/75edec484c5d49bcadd4893c0ebca0ff_0.csv") %>% 
  filter(oslaua == "E08000009") %>% 
  select(postcode = pcds, lon = long, lat) %>% 
  write_csv("trafford_postcodes_2018-08.csv")
