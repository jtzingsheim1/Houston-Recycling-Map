# Coursera Data Science Specialization Course 9 Project 1 Script----------------
# Map of Houston Area Recycling Centers


# Acknowledgement for this dataset goes to the City of Houston who make this
# data available through their GIS open data portal which is located at the
# URL: https://cohgis-mycity.opendata.arcgis.com/


# The purpose of this script is to complete the basic requirements behind the
# project 1 peer-graded assignment which is part of the Developing Data Products
# course from Johns Hopkins University within the Data Science Specialization on
# Coursera.
#
# The instructions say:
# "Create a web page using R Markdown that features a map created with Leaflet.
# Host your webpage on either GitHub Pages, RPubs, or NeoCities. Your webpage
# must contain the date that you created the document, and it must contain a map
# created with Leaflet. We would love to see you show off your creativity!
#
# This project will meet the objective by creating a map which shows recycling
# locations in the area of Houston, TX. The input for this document is the
# COHGIS Recycling Center Locations dataset which comes from the URL below. The
# script leaves behind a data objects, but the primary purpose is completing the
# core of the project, so end deliverables can be easily created later.


library(jsonlite)
library(tidyverse)
library(leaflet)


# Part 1) Load and pre-process data-----------------------------------------

# Load in data through API
url1 <- "https://opendata.arcgis.com/datasets/2934190c5b8c4f508d80f22905d8cacc_2.geojson"
data.raw <- fromJSON(url1)$features  # 39 obs. of 3 variables
rec.data <- bind_cols(data.raw$properties, data.raw$geometry)  # 39 obs. of 9

# Split the coordinates column and add to data frame
coordinate.cols <- as.data.frame(do.call(rbind, rec.data$coordinates))  # 39 x 2
rec.data <- bind_cols(rec.data, coordinate.cols)  # 39 obs. of 11 variables
rm(url1, coordinate.cols)


# Part 2) Explore and process data----------------------------------------------

# Remove unneeded columns and convert data types
rec.data <- rec.data %>%
  select(Longitude = V1, Latitude = V2, Location.Name = LOCATION,
         Location.Add = ADDRESS, Location.Status = Status,
         Location.Hours = Hours_1) %>%  # Drop and rename variables
  mutate(Location.Status = as.factor(Location.Status))  # 39 obs. of 6 variables


# Part 3) Generate the map------------------------------------------------------

rec.data %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(lng = rec.data$Longitude, lat = rec.data$Latitude,
             popup = paste("<b>", rec.data$Location.Name, "</b><br>",
                           "Address: ", rec.data$Location.Add, "<br>",
                           "Status: ", rec.data$Location.Status, "<br>",
                           "Hours: ", rec.data$Location.Hours, sep = "")) %>%
  print()

