library(sf)
library(dplyr)

# ====== 1) CAMINHOS  ======
biomas_shp <- "biomas.shp"   
out_dir    <- "output"        

bioma_field <- "bioma"
biomas_alvo <- c("Amazônia", "Cerrado", "Pantanal")

# SIRGAS 2000 / Brazil Polyconic Albers (ESRI:102033)
crs_albers <- 102033

# Tamanho do hexágono: 20 km -> 20.000 metros
hex_size_m <- 20000

# ====== 2) LER SHAPEFILE E FILTRAR BIOMAS ======
biomas <- st_read(biomas_shp, quiet = TRUE)

biomas <- st_make_valid(biomas)

# filtra
regiao <- biomas %>%
  filter(.data[[bioma_field]] %in% biomas_alvo)

# dissolve (vira uma região única)
regiao <- regiao %>%
  st_union() %>%
  st_as_sf() %>%
  mutate(name = "AMZ_CER_PAN")

# ====== 3) REPROJETAR PARA ALBERS ======
regiao_albers <- st_transform(regiao, crs_albers)

# ====== 4) CRIAR GRADE HEXAGONAL (20 km) ======
# st_make_grid: cellsize em unidades do CRS (metros)
hex_grid <- st_make_grid(
  regiao_albers,
  cellsize = hex_size_m,
  square = FALSE  # FALSE => hexágonos
)

hex_sf <- st_as_sf(hex_grid) %>%
  mutate(hex_id = row_number())

# ====== 5) CORTE ======
hex_cut <- st_filter(hex, regiao_albers, .predicate = st_intersects) |>
  st_intersection(regiao_albers) |>
  st_make_valid()

hex_cut <- hex_cut[!st_is_empty(hex_cut), ]

st_write(
  hex_cut,
  dsn = file.path(out_dir, "AMZCCERR_albers.shp"),
  driver = "ESRI Shapefile",
  delete_layer = TRUE,
  quiet = TRUE
)