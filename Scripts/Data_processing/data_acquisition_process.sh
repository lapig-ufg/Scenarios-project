#!/bin/bash

echo "Parallelized short vegetation data acquisition process"

parallel -j3 "
    gdal_translate --config GDAL_HTTP_UNSAFESSL YES \
    -projwin -74 6 -41 -25  \
    /vsicurl/https://s3.opengeohub.org/gpw/arco/gpw_short.veg.height_egbt_m_30m_s_{1}0101_{1}1231_go_epsg.4326_v1.tif \
    /home/guilherme/Documentos/resultadosCENARIOS/gpw_AmaCerrPan_short_veg_height_lgb_{1}.tif \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES 
    " ::: 2013 2018 2022
