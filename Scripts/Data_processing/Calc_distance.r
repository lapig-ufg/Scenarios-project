# Mapa de distancia silos -------------------------------------------------

library(rgee)
library(reticulate)
library(terra)
library(sf)
library(dplyr)
install.packages("landscapemetrics")
library(landscapemetrics)
library(purrr)

biomas = vect('./Dados/Biomas_IBGE_AMZ_CER_PAN_Albers.shp')
plot(biomas)

mask=rast("./Dados/bio13_cut.tif")

silos = vect('./Dados/SilosPAC/SilosPAC.shp')
plot(silos)

# Criar um raster vazio com extensão e resolução
raster_base <- rast(ext(biomas), resolution = 30)  # resolução de 100 metros, por exemplo

# Calcula a distância euclidiana de cada célula até o silo mais próximo
dist_raster <- distance(raster_base, silos)

crs(raster_base) <- crs(biomas)

dist_silos = distance(biomas_raster, silos)
x11();plot(dist_raster); plot(silos, add=TRUE)
ext(dist_raster) <- ext(mask)
dist1 <- mask(dist_raster, mask)

writeRaster(dist_raster, "silosdist.tif", overwrite = TRUE, gdal = c("COMPRESS=LZW", "OVERVIEWS=YES"))

install.packages(c("doParallel", "foreach"))
install.packages("WGCNA")

library(terra)
library(sf)
library(raster)

# --- 1. Abrir os dados vetoriais dos frigoríficos ---
shp_path <- "./Dados/Frigoríficos_Mario/Frigorificos_AMZCER.shp"
frigorificos <- st_read(shp_path)

# --- 2. Definir a grade base (resolução 30m) ---
# Use a extensão total da área de interesse (Amazônia, Cerrado, Pantanal)
biomas <- st_read("./Dados/Biomas_IBGE_AMZ_CER_PAN_Albers.shp")

ext <- ext(biomas)  # Pode expandir se quiser
res <- 30  # metros

# Criar raster base
r_base <- rast(extent = ext, resolution = res, crs = st_crs(frigorificos)$wkt)

# --- 3. Rasterizar os frigoríficos ---
# Criar raster binário com 1 onde há frigorífico
frigorificos_vect <- vect(frigorificos)  # converter de sf para SpatVector
r_pts <- rasterize(frigorificos_vect, r_base, field = 1, background = NA)

# --- 4. Calcular a distância em blocos ---
block_height <- 2000
nrow_r <- nrow(r_pts)
blocks <- ceiling(nrow_r / block_height)

# ---- criar raster vazio para saída ---
filename_out <- "distancia_frigo.tif"
r_dist_out <- rast(r_base)
r_dist_out <- writeRaster(r_dist_out, filename_out, overwrite=TRUE)

# --- 4. Configurar blocos para processar ---
block_height <- 2000  # número de linhas por bloco (ajuste conforme memória)
n_rows <- nrow(r_pts)
n_blocks <- ceiling(n_rows / block_height)

# --- 5. Loop para processar cada bloco ---
for (i in 1:n_blocks) {
  cat("Processando bloco", i, "de", n_blocks, "\n")
  
  # Definir intervalo das linhas do bloco
  start_row <- (i - 1) * block_height + 1
  end_row <- min(i * block_height, n_rows)
  
  # Calcular extensão do bloco
  res_y <- res(r_pts)[2]
  ymax_global <- ymax(r_pts)
  ymin_block <- ymax_global - end_row * res_y
  ymax_block <- ymax_global - (start_row - 1) * res_y
  
  ext_block <- ext(xmin(r_pts), xmax(r_pts), ymin_block, ymax_block)
  
  # Cortar raster para o bloco
  r_block <- crop(r_pts, ext_block)
  
  # Calcular distância no bloco
  dist_block <- distance(r_block)
  
  # Salvar resultado do bloco
  filename_block <- sprintf("./distancia_bloco_%02d.tif", i)
  writeRaster(dist_block, filename_block, overwrite=TRUE)
  
  # Limpar memória
  rm(r_block, dist_block)
  gc()
}

# Depois, se quiser, pode juntar assim:
library(terra)

blocos <- list.files(pattern = "distancia_bloco_\\d+\\.tif$", full.names = TRUE)
r_list <- lapply(blocos, rast)

distancia_total <- do.call(mosaic, c(r_list, fun = "min"))  # mosaic com mínimo para manter distância

writeRaster(distancia_total, "./distancia_frigorificos_total.tif", overwrite=TRUE)

dist <- rast("Dist_frigos.tiff")
bio <- rast("./deforestation_age_85_2023_piramidado.tif")

dist1 <- crop(dist,bio)
dist2 <- mask(dist1, bio)
ext(dist1) <- ext(bio)

x11();plot(dist1)


######################################333

library(terra)

# --- 1. Carregar os dados vetoriais ---
shp_path <- "./Dados/Frigoríficos_Mario/Frigorificos_AMZCER.shp"
frigorificos <- vect(shp_path)

biomas <- vect("./Dados/Biomas_IBGE_AMZ_CER_PAN_Albers.shp")

# --- 2. Criar raster base ---
ext_biomas <- ext(biomas)
res <- 30
r_base <- rast(ext_biomas, resolution = res))

# --- 3. Rasterizar frigoríficos ---
r_pts <- rasterize(frigorificos, r_base, field=1, background=NA)

# --- 4. Calcular distância no raster completo ---
# Esta é a linha chave que muda tudo:
dist_completa <- distance(r_pts)

# --- 5. Salvar e Plotar o resultado final ---
writeRaster(dist_completa, "./distancia_frigorificos_final.tif", overwrite=TRUE)

# Opcional: Plotar para visualizar em R
plot(dist_completa)
# Você pode adicionar as fronteiras dos biomas por cima para contextualizar
# plot(biomas, add=TRUE, col="red")

install.packages("rgdal")
library(raster)
library(rgdal)
library(sp)
library(leaflet)

library(readr)
silos <- read_delim("silos.txt", 
                     delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(silos)
crs(silos)
mascara  <- raster("deforestation_age_85_2023_piramidado.tif")

plot(silos[c("lon", "lat")])

ghsl_crs <- '+proj=aea +lat_0=-32 +lon_0=-60 +lat_1=-5 +lat_2=-42 +x_0=0 +y_0=0 +ellps=aust_SA +units=m +no_defs'

# Read the hospitals data 
points <- SpatialPointsDataFrame(coords = silos[c("lon", "lat")], data = silos,
                                 proj4string = CRS("+proj=aea +lat_0=-32 +lon_0=-60 +lat_1=-5 +lat_2=-42 +x_0=0 +y_0=0 +ellps=aust_SA +units=m +no_defs"))

# Transform the CRS
points <- spTransform(x = points, CRSobj = ghsl_crs)

biomas <- shapefile("./Dados/Biomas_IBGE_AMZ_CER_PAN_Albers.shp")

x11();plot(biomas);plot(points, add=TRUE, color="red")

library(sp)

# CRS correto para coordenadas em graus decimais (WGS84)
crs_geo <- CRS("+proj=longlat +datum=WGS84 +no_defs")

# Criar pontos com CRS geográfico
points <- SpatialPointsDataFrame(coords = silos[c("lon", "lat")], data = silos,
                                 proj4string = crs_geo)
library(sf)
# CRS do raster
mascara_crs <- crs(mascara)

# Reprojetar pontos
points <- spTransform(points, mascara_crs)

biomas <- spTransform(biomas, mascara_crs)



# Converter SpatialPointsDataFrame para sf
sf_obj <- st_as_sf(biomas)  # spdf é o seu SpatialPointsDataFrame

# Exportar para shapefile
st_write(sf_obj, "biomas.shp", delete_layer = TRUE)

x11()
plot(biomas)
plot(points, add=TRUE, col="red", pch=20)

distances <- distanceFromPoints(object = mascara, xy = points)


distance_raster <- mask(x = distances, mask = mascara)

writeRaster(distance_raster, filename = "./distance_raster.tif", overwrite = TRUE,  options = c("COMPRESS=LZW", "TILED=YES", "BIGTIFF=YES"))
plot(distance_raster)
