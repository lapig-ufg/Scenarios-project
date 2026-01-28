#!/bin/bash

echo "Starting processing..."
## A well-defined vector file is required to run the code
## Rasterize the data (requires a vector with an attribute field containing the value 1)
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

## Combine files into a VRT in the correct band order
gdalbuildvrt ut.vrt \
    quilombos.tif assentamentos.tif areasprivadas.tif areaspublicas.tif && \

## Convert VRT to GeoTIFF raster
gdal_translate ut.vrt \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES \
    ut.tif && \

## Resample/Resize to 30-meter resolution
gdalwarp -tr 30 30 \
    -r near \
    ut.tif \
    unidadesterritoriais.tif \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES && \

## Build overviews (pyramids) for faster visualization
gdaladdo unidadesterritoriais.tif 2 4 8

echo "Processing completed!"