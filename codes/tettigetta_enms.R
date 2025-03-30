# clean up working env
rm(list = ls(all.names = T))
gc()

# Download packages
install.packages("dismo")
install.packages("raster")

install.packages("metaRange")
install.packages("terra")

# load packages
library(dismo)
library(raster)
library(metaRange)
library(terra)

# Road env data
climate_data <- stack("")
