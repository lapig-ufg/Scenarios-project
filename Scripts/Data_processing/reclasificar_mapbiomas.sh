#!/bin/bash

## Convert and simplify raw MapBiomas classes
gdal_calc.py -A brazil_coverage_2024_mapbiomas.tif \
    --type=Byte \
    --outfile="brazil_coverage_2024_mapbiomas_resumido.tif" \
    --calc="((A==0)|(A==29)|(A==14)|(A==36)|(A==46)|(A==47)|(A==35)|(A==48)|(A==9)|(A==22)|(A==23)|(A==24)|(A==30)|(A==25)|(A==26)|(A==33)|(A==31)|(A==27)|(A==18))*0 + \
           (A==15)*15 + \
           ((A==1)|(A==3)|(A==4)|(A==5)|(A==6)|(A==49)|(A==10)|(A==12)|(A==32)|(A==50)|(A==11))*1 + \
           ((A==21)|(A==19)|(A==20)|(A==40)|(A==62)|(A==41))*21 + \
           (A==39)*39" \
    --NoDataValue=0 \
    --co="COMPRESS=LZW" \
    --co="BIGTIFF=YES" \
    --co="TILED=YES"