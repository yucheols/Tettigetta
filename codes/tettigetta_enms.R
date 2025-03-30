# clean up working env
rm(list = ls(all.names = T))
gc()

# Download packages
install.packages(metaRange)
install.packages(terra)

# load packages
library(metaRange)
library(terra)
