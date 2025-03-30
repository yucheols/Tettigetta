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

#### 01. introduction 
#### part 1 ::: setting up a simulation

# load landscape data and scale it
raster_file <- system.file('ex/elev.tif', package = 'terra')
r <- rast(raster_file)
r <- scale(r, center = F, scale = T)

# verification
print(r)
plot(r)


# Road env data
climate_data <- stack("")

# Prepare for occurrence data
species_occurrence <- data.frame(
  longitude = c(), latitude = c()
  )

species_sp <- SpatialPoints(species_occurrence, proj4string = CRS("+proj=longlat +datum=WGS84"))
