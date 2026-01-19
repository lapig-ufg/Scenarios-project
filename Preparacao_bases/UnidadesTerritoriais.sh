#!/bin/bash

echo "Iniciando o processamento..."

##Para rodar o codigo e necessario ter o vetor bem definido
##Rasterizar o dado (precisa do vetor das estradas com 1 campo de valores 1)
gdal_rasterize -l quilombos \
    -a rasterizar \
    -ot UInt16 \
    -init 0 \
    -tr 30 30 \
    -te -1744011.283400000 771901.560800000 2131869.966600000 4255670.310800000 \
    -co COMPRESS=LZW \
    -co BIGTIFF=YES \
    quilombos.shp \
    quilombos.tif && \

gdal_rasterize -l assentamentos \
    -a rasterizar \
    -ot UInt16 \
    -init 0 \
    -tr 30 30 \
    -te -1744011.283400000 771901.560800000 2131869.966600000 4255670.310800000 \
    -co COMPRESS=LZW \
    -co BIGTIFF=YES \
    assentamentos.shp \
    assentamentos.tif && \

gdal_rasterize -l areasprivadas \
    -a rasterizar \
    -ot UInt16 \
    -init 0 \
    -tr 30 30 \
    -te -1744011.283400000 771901.560800000 2131869.966600000 4255670.310800000 \
    -co COMPRESS=LZW \
    -co BIGTIFF=YES \
    areasprivadas.shp \
    areasprivadas.tif && \

gdal_rasterize -l areaspublicas \
    -a rasterizar \
    -ot UInt16 \
    -init 0 \
    -tr 30 30 \
    -te -1744011.283400000 771901.560800000 2131869.966600000 4255670.310800000 \
    -co COMPRESS=LZW \
    -co BIGTIFF=YES \
    areaspublicas.shp \
    areaspublicas.tif && \

##juntar os arquivos na ordem certa dos valores das bandas (3,2,1)
gdalbuildvrt ut.vrt \
    quilombos.tif assentamentos.tif areasprivadas.tif areaspublicas.tif &&\

##transformar em raster
gdal_translate ut.vrt \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES \
    ut.tif && \

##Redimensionar para 30 metros
gdalwarp -tr 30 30 \
    -r near \
    ut.tif \
    unidadesterritoriais.tif \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES && \

##Piramidar para a visualizacao
gdaladdo unidadesterritoriais.tif 2 4 8

echo "Processamento concluido!"
