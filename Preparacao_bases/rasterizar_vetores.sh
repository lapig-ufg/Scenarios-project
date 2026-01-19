#!/bin/bash
echo "Iniciando o processamento..."
##Para rodar o codigo e necessario ter o vetor bem definido
##Rasterizar o dado (precisa do vetor das estradas com 1 campo de valores 1)
gdal_rasterize -l hidroportosrecorte \
    -a rasterizar \
    -ot UInt32 \
    -init 0 \
    -a_nodata 0 \
    -tr 30 30 \
    -te -1522408.308 822132.912 2078491.692 4209762.912 \
    -co COMPRESS=LZW \
    -co BIGTIFF=YES \
    hidroportosrecorte.shp \
    hidroportos_raster.tif && \

##Calcular a distancia
gdal_proximity.py hidroportos_raster.tif hpr_dist.tif \
    -values 1 \
    -distunits GEO \
    -co COMPRESS=LZW \
    -co BIGTIFF=YES \
    -ot UInt32 && \

##Calcular o recorte para a area de estudo
gdalwarp \
    -cutline DissolvidoAreaEstudo.shp \
    -crop_to_cutline \
    hpr_dist.tif \
    distancia_hidroportos.tif \
    -srcnodata 99999 \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES && \

##Redimensionar para 30 metros
gdalwarp -tr 30 30 \
    -r near \
    distancia_hidroportos.tif \
    hidroportos.tif \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES && \

##Piramidar para a visualizacao
gdaladdo hidroportos.tif 2 4 8

echo "Processamento concluido!"
