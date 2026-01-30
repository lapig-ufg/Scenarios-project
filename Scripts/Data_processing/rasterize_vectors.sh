#!/bin/bash

echo "Starting processing..."
## To run this code, a well-defined vector is required
## Rasterize the data (requires the roads vector with one field containing values = 1)
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

## Calculate distance
gdal_proximity.py hidroportos_raster.tif hpr_dist.tif \
    -values 1 \
    -distunits GEO \
    -co COMPRESS=LZW \
    -co BIGTIFF=YES \
    -ot UInt32 && \

## Clip to the study area
gdalwarp \
    -cutline DissolvidoAreaEstudo.shp \
    -crop_to_cutline \
    hpr_dist.tif \
    distancia_hidroportos.tif \
    -srcnodata 99999 \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES && \

## Resample to 30 meters
gdalwarp -tr 30 30 \
    -r near \
    distancia_hidroportos.tif \
    hidroportos.tif \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES && \

## Build overviews for visualization
gdaladdo hidroportos.tif 2 4 8

echo "Processing completed!"
