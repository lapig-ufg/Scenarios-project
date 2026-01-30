library(sf)
library(dplyr)

# ====== 1) PATHS ======
biomas_shp <- "biomas.shp"      # input shapefile of biomes
out_dir    <- "output"          # output folder

bioma_field <- "bioma"
target_biomes <- c("Amazon", "Cerrado", "Pantanal")

# SIRGAS 2000 / Brazil Polyconic Albers (ESRI:102033)
crs_albers <- 102033

# Hexagon size: 20 km -> 20,000 meters
hex_size_m <- 20000

# ====== 2) READ SHAPEFILE AND FILTER BIOMES ======
biomes <- st_read(biomas_shp, quiet = TRUE)

biomes <- st_make_valid(biomes)

# Filter target biomes
region <- biomes %>%
  filter(.data[[bioma_field]] %in% target_biomes)

# Dissolve into a single region
region <- region %>%
  st_union() %>%
  st_as_sf() %>%
  mutate(name = "AMZ_CER_PAN")

# ====== 3) REPROJECT TO ALBERS ======
region_albers <- st_transform(region, crs_albers)

# ====== 4) CREATE HEXAGONAL GRID (20 km) ======
# st_make_grid: cellsize in CRS units (meters)
hex_grid <- st_make_grid(
  region_albers,
  cellsize = hex_size_m,
  square = FALSE  # FALSE => hexagons
)

hex_sf <- st_as_sf(hex_grid) %>%
  mutate(hex_id = row_number())

# ====== 5) CLIP GRID ======
hex_cut <- st_filter(hex_sf, region_albers, .predicate = st_intersects) |>
  st_intersection(region_albers) |>
  st_make_valid()

hex_cut <- hex_cut[!st_is_empty(hex_cut), ]

# ====== 6) EXPORT ======
st_write(
  hex_cut,
  dsn = file.path(out_dir, "AMZCCERR_albers.shp"),
  driver = "ESRI Shapefile",
  delete_layer = TRUE,
  quiet = TRUE
)
