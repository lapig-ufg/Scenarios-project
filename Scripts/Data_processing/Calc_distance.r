# Silos Distance Map -----------------------------------------------------

library(rgee)
library(reticulate)
library(terra)
library(sf)
library(dplyr)
install.packages("landscapemetrics")
library(landscapemetrics)
library(purrr)

# Load biome polygons
biomes = vect('./Data/Biomes_IBGE_AMZ_CER_PAN_Albers.shp')
plot(biomes)

# Load mask raster
mask = rast("./Data/bio13_cut.tif")

# Load silos points
silos = vect('./Data/SilosPAC/SilosPAC.shp')
plot(silos)

# Create an empty raster with the extent and resolution of the biomes
raster_base <- rast(ext(biomes), resolution = 30)  # resolution 30 meters

# Compute Euclidean distance from each cell to the nearest silo
dist_raster <- distance(raster_base, silos)

crs(raster_base) <- crs(biomes)

# Crop and mask the distance raster to match the mask
dist_raster <- mask(dist_raster, mask)

# Save the raster
writeRaster(dist_raster, "silos_distance.tif", overwrite = TRUE,
            gdal = c("COMPRESS=LZW", "OVERVIEWS=YES"))

# --- Install required packages ---
install.packages(c("doParallel", "foreach"))
install.packages("WGCNA")

library(terra)
library(sf)
library(raster)

# --- 1. Load slaughterhouse vector data ---
shp_path <- "./Data/Slaughterhouses_Mario/Slaughterhouses_AMZCER.shp"
slaughterhouses <- st_read(shp_path)

# --- 2. Define base raster (30 m resolution) ---
biomes <- st_read("./Data/Biomes_IBGE_AMZ_CER_PAN_Albers.shp")
ext <- ext(biomes)
res <- 30  # meters

r_base <- rast(extent = ext, resolution = res, crs = st_crs(slaughterhouses)$wkt)

# --- 3. Rasterize slaughterhouses (1 where present, NA elsewhere) ---
slaughterhouses_vect <- vect(slaughterhouses)
r_pts <- rasterize(slaughterhouses_vect, r_base, field = 1, background = NA)

# --- 4. Compute distances in blocks to manage memory ---
block_height <- 2000
n_rows <- nrow(r_pts)
n_blocks <- ceiling(n_rows / block_height)

r_dist_out <- rast(r_base)
writeRaster(r_dist_out, "dist_slaughterhouses.tif", overwrite=TRUE)

for (i in 1:n_blocks) {
  cat("Processing block", i, "of", n_blocks, "\n")
  start_row <- (i - 1) * block_height + 1
  end_row <- min(i * block_height, n_rows)
  
  # Calculate block extent
  res_y <- res(r_pts)[2]
  ymax_global <- ymax(r_pts)
  ymin_block <- ymax_global - end_row * res_y
  ymax_block <- ymax_global - (start_row - 1) * res_y
  
  ext_block <- ext(xmin(r_pts), xmax(r_pts), ymin_block, ymax_block)
  
  r_block <- crop(r_pts, ext_block)
  dist_block <- distance(r_block)
  
  filename_block <- sprintf("./distance_block_%02d.tif", i)
  writeRaster(dist_block, filename_block, overwrite=TRUE)
  
  rm(r_block, dist_block)
  gc()
}

# --- Merge blocks using minimum distance ---
blocos <- list.files(pattern = "distance_block_\\d+\\.tif$", full.names = TRUE)
r_list <- lapply(blocos, rast)

distance_total <- do.call(mosaic, c(r_list, fun = "min"))
writeRaster(distance_total, "./distance_slaughterhouses_total.tif", overwrite=TRUE)

# Crop/mask final distance raster to deforestation layer
dist <- rast("distance_slaughterhouses_total.tif")
bio <- rast("./deforestation_age_85_2023_pyramided.tif")
dist_crop <- crop(dist, bio)
dist_mask <- mask(dist_crop, bio)
ext(dist_mask) <- ext(bio)

x11(); plot(dist_mask)

# --- Alternative simplified method ---
shp_path <- "./Data/Slaughterhouses_Mario/Slaughterhouses_AMZCER.shp"
slaughterhouses <- vect(shp_path)
biomes <- vect("./Data/Biomes_IBGE_AMZ_CER_PAN_Albers.shp")

r_base <- rast(ext(biomes), resolution = 30)
r_pts <- rasterize(slaughterhouses, r_base, field=1, background=NA)

# Compute complete distance raster
dist_complete <- distance(r_pts)
writeRaster(dist_complete, "./distance_slaughterhouses_final.tif", overwrite=TRUE)
plot(dist_complete)
plot(biomes, add=TRUE, col="red")

# --- Load silos table and convert to spatial points ---
silos <- read_delim("silos.txt", delim=";", escape_double=FALSE, trim_ws=TRUE)
crs(silos)
mask_raster <- raster("deforestation_age_85_2023_pyramided.tif")

points <- SpatialPointsDataFrame(coords = silos[c("lon", "lat")], data = silos,
                                 proj4string = CRS("+proj=aea +lat_0=-32 +lon_0=-60 +lat_1=-5 +lat_2=-42 +x_0=0 +y_0=0 +ellps=aust_SA +units=m +no_defs"))

# Transform CRS to match raster
points <- spTransform(points, crs(mask_raster))
biomes <- spTransform(biomes, crs(mask_raster))

# Convert to sf and export
sf_obj <- st_as_sf(biomes)
st_write(sf_obj, "biomes.shp", delete_layer=TRUE)

# Final distance raster
distances <- distanceFromPoints(mask_raster, xy = points)
distance_raster <- mask(distances, mask_raster)
writeRaster(distance_raster, "./distance_raster.tif", overwrite=TRUE,
            options=c("COMPRESS=LZW","TILED=YES","BIGTIFF=YES"))
plot(distance_raster)
