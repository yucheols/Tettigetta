#####  try the metaRange package == raster and pop based mechanistic SDM

# the package basically requires a simulation object that contains raster-based environments and species object containing traits and processes.
# a trait will not be a single number but a matrix that has the same size as the raster data in the environment, 
# where each value represents the trait value for one population in the corresponding grid cell of the environment. 
# Based on this, most processes will describe population (and meta population) dynamics and not individual based mechanisms. 

# clean up working env
rm(list = ls(all.names = T))
gc()

# load packages
library(metaRange)
library(terra)


#########  01. introduction 
#####  part 1 ::: setting up a simulation ----------

# load landscape data and scale it
raster_file <- system.file('ex/elev.tif', package = 'terra')
r <- rast(raster_file)
r <- scale(r, center = F, scale = T)

print(r)
plot(r)

# turn this raster with one layer into an SDS (SpatRasterDataset) that has multiple layer (one for each time step)
r <- rep(r, 10)
landscape <- sds(r)
names(landscape) = c('habitat_quality')

print(landscape)

# pre setup == enable extensive reporting ::: 0 = no reporting / 1 = a bit of info / 2 = very verbose
set_verbosity(2)


#####  part 2 ::: create simulation ----------
# basic simulation without species added
sim <- create_simulation(source_environment = landscape,
                         ID = 'example_simulation',
                         seed = 1)

summary(sim)

# add species
sim$add_species('species_1')

# add traits == there is no limit to the number of traits that can be added == naming convention == trait_name = trait_value
# here we will have three traits == abundance, carrying_capacity, and reproduction_rate
sim$add_traits(species = 'species_1',
               population_level = T,
               abundance = 100,
               reproduction_rate = 0.5,
               carrying_capacity = 1000)

print(sim$species_1$traits)


# add processes == use the 'add_process()' method == components are 'species', 'process_name', and 'process_fun'. The latter describes a function
# that will be called when the process is executed
# the argument 'execution_priority' gives the process a priority “weight” # 
# and decides in which order the processes are executed within one time step. The smaller the number, the earlier the process will be executed
# In the case two (or more) processes have the same priority, it is assumed that they are independent from each other 
# and that their execution order does not matter.
sim$add_process(species = 'species_1',
                process_name = 'reproduction',
                process_fun = function() {
                  
                  # use a ricker reproduction model
                  # to calculate the new abundance
                  # and let the carrying capacity
                  # depend on the habitat quality
                  
                  ricker_reproduction_model(self$traits$abundance,
                                            self$traits$reproduction_rate,
                                            self$traits$carrying_capacity * self$sim$environment$current$habitat_quality)
                  
                  # print out the current mean abundance
                  print(paste0('mean_abundance:', mean(self$traits$abundance)))
                },
                execution_priority = 1)


#####  part 3 ::: execute simulation, plot results, and save simulation ----------

# execute
sim$begin()

# plot 
# define a nice color palette
plot_cols <- hcl.colors(100, "BluYl", rev = TRUE)

plot(sim, 
     obj = 'species_1', # species name
     name = 'abundance', # name of the trait to plot
     col = plot_cols)

# save simulation
save_species(sim$species_1, traits = c('abundance', 'reproduction_rate', 'carrying_capacity'),
             path = 'output/tutorial/01_Introduction')
