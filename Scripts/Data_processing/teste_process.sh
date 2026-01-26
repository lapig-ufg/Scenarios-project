#!/bin/bash

echo " Starting VRT creation for all .tif files..."

# Define fixed parameters in variables for easier reading and modification
EXTENT="-1522408.308 822132.912 2078491.692 4209762.912"
RESOLUTION="30 30"

# The 'for' loop will iterate over each file ending in .tif
for ARQUIVO_TIF in *.tif; do
  
  # Generate the output .vrt filename from the .tif filename
  # Ex: from "lulc.tif" to "lulc.vrt"
  ARQUIVO_VRT="${ARQUIVO_TIF%.tif}_entrada.vrt"
  
  echo "Processing: ${ARQUIVO_TIF}  ->  Creating: ${ARQUIVO_VRT}"

  # Execute the gdalbuildvrt command
  # Quotes around file variables are VERY important
  # to ensure filenames with spaces or special characters work correctly.
  gdalbuildvrt "${ARQUIVO_VRT}" \
      -te ${EXTENT} \
      -tr ${RESOLUTION} \
      "${ARQUIVO_TIF}"
done

echo "VRT creation finished successfully!"

echo " Starting final conversion from VRT to optimized GeoTIFF..."

EXTENT="-1522408.308 822132.912 2078491.692 4209762.912"
RESOLUTION="30 30"

# Creation options for the output GeoTIFF.
# Grouped in a variable for easier reading.
# - TILED=YES: Improves reading performance in GIS software.
# - COMPRESS=LZW: Lossless compression to save space.
# - BIGTIFF=YES: Allows output files to be larger than 4GB.
CREATION_OPTIONS="-multi -wo NUM_THREADS=4 -t_srs ESRI:102033 -srcnodata 0 -co TILED=YES -co COMPRESS=LZW -co BIGTIFF=YES"

# The 'for' loop will iterate over each file ending in .vrt
for ARQUIVO_VRT in *.vrt; do
  
  # Define a name for the output file, adding "_final" at the end.
  # This is IMPORTANT to avoid overwriting your original .tif files!
  # Ex: from "slope30.vrt" to "slope30_final.tif"
  ARQUIVO_TIF_FINAL="${ARQUIVO_VRT%.vrt}_final.tif"
  
  echo "Processing: ${ARQUIVO_VRT}  ->  Creating: ${ARQUIVO_TIF_FINAL}"

  # Execute gdalwarp with the creation options.
  # Quotes around filenames ensure everything works
  # even if there are spaces or special characters in the names.
  gdalwarp ${CREATION_OPTIONS} \
    -te ${EXTENT} \
    -tr ${RESOLUTION} \
    "${ARQUIVO_VRT}"\
    "${ARQUIVO_TIF_FINAL}"

done

echo "TIFF conversion finished successfully!"
echo "Your new aligned and optimized files have been created with the '_final.tif' suffix."