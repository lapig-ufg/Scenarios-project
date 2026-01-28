#Projeto LAPIG/TNC 
#Pipeline de análise de ganho/perda de classes em cenários de uso da terra baseados em mapas simulados de uso da terra.
#Passos: binarizar (classe alvo=1; outras=0; NoData=255) -> ganho/perda (2030/2025)
#Classes Vegetação nativa(1), Pastagem (15), Mosaico (21), Soja (39) -> ganho/perda -> estatística zonal (por hexágonos) -> ha/% -> 
#Índice de Moran global para cálculo de autocorrelação das mudanças + LISA (local indicators of spatial association) para identificar clusters espaciais de ganho/perda.

#Autores: Marisa Novaes (LAPIG) e Alessandra Bertassoni (LAPIG).

#A análise foi realizada em ambiente Linux Ubuntu 20.04 LTS com Singularity para execução de containers. 

# Requisitos: gdal.sif e pangeo-notebook_latest.sif

set -euo pipefail

# --- containers
GDAL_SIF=/home/alessandrabertassoni/containers/gdal.sif
PY_SIF=/home/alessandrabertassoni/pangeo-notebook_latest.sif

# --- entradas (mosaicos categóricos)
BAU_2025=/home/alessandrabertassoni/BAU2025_lan/bau_2025_mosaic.tif
BAU_2030=/home/alessandrabertassoni/BAU2030/bau_2030_mosaic.tif
TNC1_2025=/home/alessandrabertassoni/TNC1_2025/tnc1_2025_mosaic.tif
TNC1_2030=/home/alessandrabertassoni/TNC1_2030/tnc1_2030_mosaic.tif
TNC2_2025=/home/alessandrabertassoni/TNC2_2025/tnc2_2025_mosaic.tif
TNC2_2030=/home/alessandrabertassoni/TNC2_2030/tnc2_2030_mosaic.tif

# --- Polígonos hexagonais da área de estudo
HEX=/home/alessandrabertassoni/AMZCERPAN.gpkg
IDCOL=FID_biomas

# --- Organização das pastas de trabalho
WORK=/home/alessandrabertassoni/temp/landuse_pipeline
BIN=$WORK/bin
GL=$WORK/gain_loss
OUT=$WORK/out
mkdir -p "$BIN" "$GL" "$OUT"

# --- Classes alvo
CLASSES=(1 15 21 39)   # 1=veg, 15=pastagem, 21=mosaico, 39=soja
SCENS=(bau tnc1 tnc2) # cenários
YEARS=(2025 2030) # anos

# --- Seleciona o raster por cenário/ano
get_in() {
  local scen=$1 yr=$2
  if   [[ "$scen" == "bau"  && "$yr" == "2025" ]]; then echo "$BAU_2025"
  elif [[ "$scen" == "bau"  && "$yr" == "2030" ]]; then echo "$BAU_2030"
  elif [[ "$scen" == "tnc1" && "$yr" == "2025" ]]; then echo "$TNC1_2025"
  elif [[ "$scen" == "tnc1" && "$yr" == "2030" ]]; then echo "$TNC1_2030"
  elif [[ "$scen" == "tnc2" && "$yr" == "2025" ]]; then echo "$TNC2_2025"
  elif [[ "$scen" == "tnc2" && "$yr" == "2030" ]]; then echo "$TNC2_2030"
  else
    echo "ERRO: combinação inválida $scen $yr" >&2; exit 1
  fi
}

# 1) BINARIZAR (classe alvo=1; outras=0; NoData=255). Assume NoData original = 0 (MapBiomas comum).
for cls in "${CLASSES[@]}"; do
  for scen in "${SCENS[@]}"; do
    for yr in "${YEARS[@]}"; do
      IN=$(get_in "$scen" "$yr")
      OUTBIN=$BIN/${scen}_${yr}_c${cls}_bin.tif
      singularity exec --bind /home/alessandrabertassoni:/home/alessandrabertassoni \
        "$GDAL_SIF" gdal_calc.py \
          -A "$IN" \
          --calc="where(A==0,255, where(A==${cls},1,0))" \
          --type=Byte \
          --NoDataValue=255 \
          --co COMPRESS=LZW --co TILED=YES --co BIGTIFF=YES \
          --outfile "$OUTBIN" --overwrite
    done
  done
done

# 2) GANHO/PERDA (preserva NoData=255)
for cls in "${CLASSES[@]}"; do
  for scen in "${SCENS[@]}"; do
    A=$BIN/${scen}_2030_c${cls}_bin.tif
    B=$BIN/${scen}_2025_c${cls}_bin.tif

    singularity exec --bind /home/alessandrabertassoni:/home/alessandrabertassoni \
      "$GDAL_SIF" gdal_calc.py \
        -A "$A" -B "$B" \
        --calc="where((A==255)|(B==255),255,((A==1)&(B==0)).astype(uint8))" \
        --type=Byte --NoDataValue=255 \
        --co COMPRESS=LZW --co TILED=YES --co BIGTIFF=YES \
        --outfile "$GL/gain_${scen}_c${cls}.tif" --overwrite

    singularity exec --bind /home/alessandrabertassoni:/home/alessandrabertassoni \
      "$GDAL_SIF" gdal_calc.py \
        -A "$A" -B "$B" \
        --calc="where((A==255)|(B==255),255,((A==0)&(B==1)).astype(uint8))" \
        --type=Byte --NoDataValue=255 \
        --co COMPRESS=LZW --co TILED=YES --co BIGTIFF=YES \
        --outfile "$GL/loss_${scen}_c${cls}.tif" --overwrite
  done
done

# 3) Estatística zonal por hexágonos (soma de pixels) 

PY=$WORK/compute_hex_moran_lisa.py
cat > "$PY" << 'PYCODE'
import os, numpy as np, geopandas as gpd
from rasterstats import zonal_stats
import rasterio
from libpysal.weights import Queen
from esda.moran import Moran, Moran_Local

HEX = "/home/alessandrabertassoni/AMZCERPAN.gpkg"
IDCOL = "FID_biomas"
GL = "/home/alessandrabertassoni/temp/landuse_pipeline/gain_loss"
OUT_GPKG = "/home/alessandrabertassoni/temp/landuse_pipeline/out/hex_gain_loss_allclasses.gpkg"
OUT_LISA = "/home/alessandrabertassoni/temp/landuse_pipeline/out/hex_gain_loss_allclasses_LISA.gpkg"
OUT_MORAN_CSV = "/home/alessandrabertassoni/temp/landuse_pipeline/out/moran_global_allclasses.csv"

CLASSES = [1,15,21,39]
SCENS = ["bau","tnc1","tnc2"]

gdf = gpd.read_file(HEX)

# pixel area (ha) a partir de um raster qualquer
ref = os.path.join(GL, "gain_bau_c1.tif")
with rasterio.open(ref) as ds:
    px_ha = abs(ds.transform.a * ds.transform.e) / 10000.0

# zonal sum (pixels) para ganho/perda
for cls in CLASSES:
    for scen in SCENS:
        for kind in ["gain","loss"]:
            r = os.path.join(GL, f"{kind}_{scen}_c{cls}.tif")
            zs = zonal_stats(gdf, r, stats=["sum"], nodata=255)
            col_px = f"{kind}_px_{scen}_c{cls}"
            gdf[col_px] = [z["sum"] if z["sum"] is not None else 0 for z in zs]

            # hectares
            col_ha = f"{kind}_ha_{scen}_c{cls}"
            gdf[col_ha] = gdf[col_px].astype(float) * px_ha

## 4) Hectares/percentuais por hex

# Percentuais por hex (usando a quantidade de pixels válidos dentro do hex)
# (se Area não existir, pula)
if "Area" in gdf.columns:
    area_px = gdf["Area"].replace({0: np.nan}).astype(float)
    for cls in CLASSES:
        for scen in SCENS:
            for kind in ["gain","loss"]:
                col_px = f"{kind}_px_{scen}_c{cls}"
                col_pct = f"{kind}_pct_{scen}_c{cls}"
                gdf[col_pct] = 100.0 * (gdf[col_px].astype(float) / area_px)

# 5) Índice de Moran global + LISA 

assert IDCOL in gdf.columns, f"Falta coluna {IDCOL}"
w = Queen.from_dataframe(gdf, ids=gdf[IDCOL])
w.transform = "r"

def moran_one(var):
    y = gdf[var].fillna(0).astype(float).values
    if np.nanstd(y) == 0:
        return None
    mi = Moran(y, w)
    return (mi.I, mi.p_sim)

def lisa_one(var):
    y = gdf[var].fillna(0).astype(float).values
    if np.nanstd(y) == 0:
        return None
    ml = Moran_Local(y, w)
    return (ml.q, ml.p_sim)

rows = []
for cls in CLASSES:
    for scen in SCENS:
        for kind in ["gain","loss"]:
            var = f"{kind}_px_{scen}_c{cls}"
            m = moran_one(var)
            if m is None:
                rows.append((cls, scen, kind, var, None, None))
                continue
            I, p = m
            rows.append((cls, scen, kind, var, float(I), float(p)))

            l = lisa_one(var)
            if l is not None:
                q, p_loc = l
                gdf[f"LISA_{var}_q"] = q
                gdf[f"LISA_{var}_p"] = p_loc

# salvar saídas
gdf.to_file(OUT_GPKG, driver="GPKG")
gdf.to_file(OUT_LISA, driver="GPKG")

import csv
with open(OUT_MORAN_CSV, "w", newline="") as f:
    wcsv = csv.writer(f)
    wcsv.writerow(["class","scenario","metric","variable","moran_I","p_sim"])
    for r in rows:
        wcsv.writerow(r)

print("OK")
print("GPKG:", OUT_GPKG)
print("LISA:", OUT_LISA)
print("MORAN:", OUT_MORAN_CSV)
print("pixel_ha:", px_ha)
PYCODE

singularity exec \
  --bind /home/alessandrabertassoni:/home/alessandrabertassoni \
  "$PY_SIF" python "$PY"

echo "Concluído."
echo "Resultados:"
echo "  $OUT/hex_gain_loss_allclasses.gpkg"
echo "  $OUT/hex_gain_loss_allclasses_LISA.gpkg"
echo "  $OUT/moran_global_allclasses.csv"
