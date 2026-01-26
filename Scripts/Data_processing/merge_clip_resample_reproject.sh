#!/bin/bash

#This code will merge, clip, resample, and reproject all scenes of the same file type, provided they are in the same directory.

echo "Iniciando o processamento..."

##Make the .vrt
gdalbuildvrt decliv.vrt slope-*.tif && \

##Convert .vrt for .tif
gdal_translate decliv.vrt \
    declividadeWGS.tif \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES && \

## Clip 
gdalwarp \
    -cutline /home/gui/Documentos/AreaEstudoDissolv/AmaCerrPanREPROJ.shp \
    -crop_to_cutline \
    /home/gui/Documentos/DEM30/declividadeWGS.tif \
    declividade_clip.tif \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES && \

##Reproject
gdalwarp -t_srs ESRI:102033 \
    declividade_clip.tif \
    decliv_reproj.tif \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES && \

##Resampling for 30 meters
gdalwarp -tr 30 30 \
    -r near \
    decliv_reproj.tif \
    slope30.tif \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES && \

#Make a faster visualization file
gdaladdo slope30.tif 2 4 8

echo "Processamento concluido!"