#!/bin/bash

## Merge the files in the correct band order (3,2,1) using the 'POP' column from the vector table
## Resample and rasterize the population density data
gdal_rasterize -l PopulationDensity \
    -a POP \
    -ot Int16 \
    -init -9999 \
    -a_nodata -9999 \
    -tr 30 30 \
    -te -1522408.308 822132.912 2078491.692 4209762.912 \
    -co COMPRESS=LZW \
    -co BIGTIFF=YES \
    PopulationDensity.shp \
    PopulationDensity.tif
