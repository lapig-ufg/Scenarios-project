##Reclassificar
for entrada in *.tif; do
    final="${entrada%.tif}_recalculado.tif"
    echo "Processando ${entrada}  ->  ${final}"
    gdal_calc.py -A ${entrada} \
        --type=Byte \
        --outfile= ${final} \
        --calc="( A == 1)*63 + ( A == 2)*64 + ( A == 3)*65" \
        --NoDataValue=0 \
        --co="COMPRESS=LZW" \
        --co="BIGTIFF=YES" \
        --co="TILED=YES"
done
