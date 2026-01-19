parallel -j3 '
    gdal_calc.py -A pastagem_EVI_norm_{1}.tif \
        --type=Byte \
        --outfile="pastagem_EVI_normalizado_{1}.tif" \
        --calc="((A >= 0) & ( A < 0.4))*1 + ((A >= 0.4) & ( A < 0.6))*2 + ((A >= 0.6) & ( A <=1))*3" \
        --NoDataValue=0 \
        --co="COMPRESS=LZW" \
        --co="BIGTIFF=YES" \
        --co="TILED=YES" && \
    gdaladdo pastagem_EVI_normalizado_{1}.tif 2 4 8 
' ::: {2020..2023}