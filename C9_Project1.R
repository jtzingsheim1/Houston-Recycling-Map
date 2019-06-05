# Coursera Data Science Specialization Course 9 Project 1 Script----------------
# Create a Webpage that Features a Map Created with Leaflet


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


library(tidyverse)
library(leaflet)


# Part 1) Loading and preprocessing the data------------------------------------

# Check if the file exists in the directory before downloading it again
file.name <- "Recycling_Center_Locations.csv"
if (!file.exists(file.name)) {
  url <- "https://opendata.arcgis.com/datasets/2934190c5b8c4f508d80f22905d8cacc_2.csv"
  download.file(url, file.name)
  rm(url)
}

# Load in the raw data
rec.data <- read.csv(file.name, stringsAsFactors = FALSE, na.strings = " ")
# 39 obs. of 9 variables
rm(file.name)


# Part 2) Explore and process data----------------------------------------------

# Preview the data
# str(rec.data)  # The first two columns are longitude and latitude
col1.name <- names(rec.data)[1]  # First column name is unusual, extract
# summary(rec.data)  # Columns 3 and 5 are indicies, column 9 is an ID

# Remove unneeded columns and convert data types
rec.data <- rec.data %>%
  select(Longitude = col1.name, Latitude = Y, Location.Name = LOCATION,
         Location.Add = ADDRESS, Location.Status = Status,
         Location.Hours = Hours_1) %>%  # Drop and rename variables
  mutate(Location.Status = as.factor(Location.Status))  # 39 obs. of 6 variables
rm(col1.name)


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

