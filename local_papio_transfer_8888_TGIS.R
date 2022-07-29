#'---
#'author: Jugal Patel
#'date: 08/2020
#'title: Convert decision boundaries to raster surfaces 
#'---

# Directory ----
setwd("C:/Users/jugal/Dropbox/Research/Movement Ecology/Papers & Proposals/Feb2019_IJGIS Special Issue on Computational Movement Analysis/Submission 2 - August 2019")

# Import: ----

# distance rasters
library(raster)
r_tree <- raster("Distfromtrees.tif") #individual tree; Raja's layer
r_trail <- raster("Distfromtrail2.tif") #trail; Raja's layer
r_clearing <- raster("Distfromclearing.tif") #clearing; Raja's layer
r_river <- raster("distfromriver.tif") #river; Raja's layer

#Checking coordinate system
r_tree@crs
r_trail@crs
r_clearing@crs
r_river@crs

r_tree <- resample(r_tree, r_trail)
r_river <- resample(r_river, r_trail)
r_clearing <- resample(r_clearing, r_trail)

# Check to ensure our rasters are stackable
#stackable <- stack(r_tree, r_trail, r_clearing, r_river)
#image(stackable)

image(r_tree)
image(r_trail)
image(r_clearing)
image(r_river)


# Movement Surface ----
# moving transfer when nodal rule suggests y1
transfer_move <- function(r_feature) {ifelse(r_feature > threshold, 0, 1*(1-gini))}

# null transfer when nodal rule suggests y0
transfer_null <- function(r_feature) {ifelse(r_feature > threshold, 0, -1*(1-gini))}

# node_0 ---- 
image(r_river)
r_feature <- r_river
gini <- 0.5
threshold <- 950.908

node_0 <- overlay((r_feature), fun = transfer_null)
image(node_0)

# node_1 ----
image(r_trail)
r_feature <- r_trail
gini <- 0.454
threshold <- 215.246

node_1 <- overlay((r_feature), fun = transfer_move)
image(node_1)

# node_2 ----
image(r_river)
r_feature <- r_river
gini <- 0.397
threshold <- 21.213

node_2 <- overlay((r_feature), fun = transfer_move)
image(node_2)

# node_3 ----
image(r_trail)
r_feature <- r_trail
gini <- 0.136
threshold <- 76.379

node_3 <- overlay((r_feature), fun = transfer_move)
image(node_3)

# node_4 ----
image(r_trail)
r_feature <- r_trail
gini <- 0.09
threshold <- 27.457

node_4 <- overlay((r_feature), fun = transfer_move)
image(node_4)

# node_5 ----
image(r_tree)
r_feature <- r_tree
gini <- 0.381
threshold <- 14.173

node_5 <- overlay((r_feature), fun = transfer_move)
image(node_5)

# node_6 ----
image(r_river)
r_feature <- r_river
gini <- 0.436
threshold <- 726.514

node_6 <- overlay((r_feature), fun = transfer_move)
image(node_6)

# node_7 ----
image(r_river)
r_feature <- r_river
gini <- 0.422
threshold <- 368.151

node_7 <- overlay((r_feature), fun = transfer_move)
image(node_7)

# node_8 ----
image(r_clearing)
r_feature <- r_clearing
gini <- 0.5
threshold <- 60.037

node_8 <- overlay((r_feature), fun = transfer_move)
image(node_8)

# node_9 ----
image(r_trail)
r_feature <- r_trail
gini <- 0.456
threshold <- 363.625

node_9 <- overlay((r_feature), fun = transfer_null)
image(node_9)

# node_10 ----
image(r_tree)
r_feature <- r_tree
gini <- 0.498
threshold <- 108.69

node_10 <- overlay((r_feature), fun = transfer_null)
image(node_10)

# node_11 ----
image(r_river)
r_feature <- r_river
gini <- 0.451
threshold <- 267.572

node_11 <- overlay((r_feature), fun = transfer_null)
image(node_11)

# node_12 ----
image(r_river)
r_feature <- r_river
gini <- 0.473
threshold <- 286.402

node_12 <- overlay((r_feature), fun = transfer_move)
image(node_12)

# node_13 ----
image(r_trail)
r_feature <- r_trail
gini <- 0.203
threshold <- 442.042

node_13 <- overlay((r_feature), fun = transfer_null)
image(node_13)

# node_14 ----
image(r_tree)
r_feature <- r_tree
gini <- 0.347
threshold <- 53.465

node_14 <- overlay((r_feature), fun = transfer_null)
image(node_14)

# node_15 ----
image(r_trail)
r_feature <- r_trail
gini <- 0.045
threshold <- 475.091

node_15 <- overlay((r_feature), fun = transfer_null)
image(node_15)

# node_16 ----
image(r_river)
r_feature <- r_river
gini <- 0
threshold <- 959.196

node_16 <- overlay((r_feature), fun = transfer_null)
image(node_16)

# node_17 ----
image(r_river)
r_feature <- r_river
gini <- 0.031
threshold <- 955.332

node_17 <- overlay((r_feature), fun = transfer_null)
image(node_17)

# node_18 ----
image(r_river)
r_feature <- r_river
gini <- 0.001
threshold <- 952.506

node_18 <- overlay((r_feature), fun = transfer_null)
image(node_18)

# Need to combine into one surface to run an ABM; we do this with map algebra 
# geoubound is a sample of all; geound_movement of movement signal; geobound_null is null or uncertinity 
geobound <- stack(node_0,
                  node_1,
                  node_2,
                  node_3,
                  node_4,
                  node_5,
                  node_6,
                  node_7,
                  node_8,
                  node_9,
                  node_9,
                  node_10,
                  node_11,
                  node_12,
                  node_13,
                  node_14,
                  node_15,
                  node_16,
                  node_17,
                  node_18)

s_nodes <- sum(geobound)

# Normalize / standardize our function
rasterRescale <- function(r){
  ((r-cellStats(r,"min"))/(cellStats(r,"max")-cellStats(r,"min")))
}

ss_nodes <- rasterRescale(s_nodes)
image(ss_nodes)


#geobound_movement
geobound_movement <- stack(node_1,
                           node_2,
                           node_3,
                           node_4,
                           node_5,
                           node_6,
                           node_7,
                           node_8,
                           node_12)

geobound_movement <- sum(geobound_movement)

movement_nodes <- rasterRescale(geobound_movement)
image(movement_nodes)

geobound_null <- stack(node_0,
                       node_9,
                       node_10,
                       node_11,
                       node_13,
                       node_14,
                       node_15,
                       node_16,
                       node_17,
                       node_18)

geobound_null <- sum(geobound_null)

null_nodes <- rasterRescale(geobound_null)
image(null_nodes)


setwd("C:/Users/jugal/Dropbox/Research/Movement Ecology/Papers & Proposals/Transactions in GIS")

writeRaster(movement_nodes, 
            filename = "movementselection_8888",
            "GTiff", 
            overwrite = T)

r_movementselection <- raster("movementselection_8888.tif") #movement selection
image(r_movementselection)

writeRaster(null_nodes, 
            filename = "uncertain_8888",
            "GTiff", 
            overwrite = T)

r_uncertain_selection <- raster("uncertain_8888.tif") #movement selection
image(r_uncertain_selection)



samplestack <- stack(node_3,
                       node_4,
                     node_5)

samplestack <- sum(samplestack)

samplenodes <- rasterRescale(samplestack)
image(samplestack)
