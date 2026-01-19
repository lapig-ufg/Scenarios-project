##juntar os arquivos na ordem certa dos valores das bandas (3,2,1)
gdalbuildvrt ut.vrt \
    quilombos.tif assentamentos.tif areasprivadas.tif areaspublicas.tif &&\

##transformar em raster
gdal_translate mapeamento_2022_finalizado_compress.tif \
    -co COMPRESS=LZW \
    -co TILED=YES \
    -co BIGTIFF=YES \
    mapeamento_2022_finalizado.tif && \


gdal_rasterize -l Densidadepop \
    -a POP \
    -ot Int16 \
    -init -9999 \
    -a_nodata -9999 \
    -tr 30 30 \
    -te -1522408.308 822132.912 2078491.692 4209762.912 \
    -co COMPRESS=LZW \
    -co BIGTIFF=YES \
    Densidadepop.shp \
    Densidadepop.tif