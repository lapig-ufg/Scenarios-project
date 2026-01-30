import os
from qgis.core import QgsVectorLayer
import processing

# 📍 Paths
tif_folder = r"E:/Ale_Marisa_Cenarios_TNC/Vraveis_dinamica"
# Change the shapefile according to the region of interest
shapefile = r"E:/Ale_Marisa_Cenarios_TNC/DINAMICA/dados_entrada/Regiao_1/Regiao_1.shp"

# 📍 Check shapefile
vlayer = QgsVectorLayer(shapefile, "region", "ogr")
if not vlayer.isValid():
    raise Exception("❌ Invalid shapefile!")

# 📍 List all rasters in the folder
tif_files = [
    os.path.join(tif_folder, f) for f in os.listdir(tif_folder) if f.endswith(".tif")
]

if not tif_files:
    raise RuntimeError(f"❌ No .tif raster files found in: {tif_folder}")

for file in tif_files:
    print(f"📐 Processing: {os.path.basename(file)}")

    # Output: filename with "_1" suffix
    cropped = file.replace(".tif", "_1.tif")

    # 📍 Single step: clip with mask, keeping original NoData and data type
    processing.run("gdal:cliprasterbymasklayer", {
        'INPUT': file,
        'MASK': shapefile,
        'SOURCE_CRS': None,
        'TARGET_CRS': None,
        'NODATA': None,                # keep original NoData
        'ALPHA_BAND': False,
        'CROP_TO_CUTLINE': True,
        'KEEP_RESOLUTION': True,
        'OPTIONS': 'COMPRESS=LZW',     # compression
        'DATA_TYPE': 0,                # keep original data type
        'EXTRA': '',
        'OUTPUT': cropped
    })

    print(f"✅ Saved: {os.path.basename(cropped)}")

print("🎯 All rasters have been clipped with the mask, keeping original NoData and data type, and compressed with LZW.")
