import os
from qgis.core import QgsVectorLayer
import processing

# 📍 Caminhos
pasta_tif = r"E:/Ale_Marisa_Cenarios_TNC/Vraveis_dinamica"
#Mudando o shapefile de acordo com a região de interesse
shapefile = r"E:/Ale_Marisa_Cenarios_TNC/DINAMICA/dados_entrada/Regiao_1/Regiao_1.shp"

# 📍 Verifica shapefile
vlayer = QgsVectorLayer(shapefile, "regiao", "ogr")
if not vlayer.isValid():
    raise Exception("❌ Shapefile inválido!")

# 📍 Lista os rasters na pasta
arquivos_tif = [
    os.path.join(pasta_tif, f) for f in os.listdir(pasta_tif) if f.endswith(".tif")
]

if not arquivos_tif:
    raise RuntimeError(f"❌ Nenhum raster .tif encontrado em: {pasta_tif}")

for arq in arquivos_tif:
    print(f"📐 Processando: {os.path.basename(arq)}")

    # Saída: nome com sufixo "_1"
    cropped = arq.replace(".tif", "_1.tif")

    # 📍 Passo único: clip com máscara, mantendo NoData e tipo originais
    processing.run("gdal:cliprasterbymasklayer", {
        'INPUT': arq,
        'MASK': shapefile,
        'SOURCE_CRS': None,
        'TARGET_CRS': None,
        'NODATA': None,                 # mantém NoData original
        'ALPHA_BAND': False,
        'CROP_TO_CUTLINE': True,
        'KEEP_RESOLUTION': True,
        'OPTIONS': 'COMPRESS=LZW',     # compressão
        'DATA_TYPE': 0,                # mantém tipo original
        'EXTRA': '',
        'OUTPUT': cropped
    })

    print(f"✅ Salvo: {os.path.basename(cropped)}")

print("🎯 Todos os rasters foram recortados com máscara, mantendo NoData e tipo originais, e comprimidos em LZW.")
