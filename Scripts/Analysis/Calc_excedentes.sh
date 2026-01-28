#!/usr/bin/env bash
set -euo pipefail

#Criar resumos hexagonais de rasters binários de "excedente" e escrever um GeoPackage único
# Input: rasters de excedente para cenários BAU, TNC1, TNC2
#Output: hexagonal grid vetorial com estatísticas por hexágono

# --- inputs ---
BASE="/home/alessandrabertassoni/Calc_excedentes"
OUT="${BASE}/out_hexstats"
GRID="/home/alessandrabertassoni/AMZCERPAN.gpkg" # Grid hexagonal vetorial
LAYER="grade_area_interesse"   
ID="FID_biomas"                        # Identificador único do hexágono

BAU="${BASE}/bau30_excedentes.tif"
TNC1="${BASE}/tnc130_excedentes.tif"
TNC2="${BASE}/tnc230_excedentes.tif"

# --- containers ---
GDAL_SIF="/home/alessandrabertassoni/containers/gdal.sif"
PANGEO_SIF="/home/alessandrabertassoni/pangeo-notebook_latest.sif"

mkdir -p "${OUT}"
HEXID="${OUT}/hexid_30m.tif"
GPKG_OUT="${OUT}/hexstats_all.gpkg"

# 1) Rasterizar IDs hexagonais a 30 m (0 = fora do grid)
#    Usar o grid vetorial original para garantir que todos os hexágonos estão presentes
#    (mesmo os que não têm excedente em nenhum cenário)

singularity exec "${GDAL_SIF}" gdal_rasterize \
  -l "${LAYER}" \
  -a "${ID}" \
  -tr 30 30 \
  -a_nodata 0 \
  -ot Int32 \
  -of GTiff \
  -co COMPRESS=DEFLATE -co TILED=YES -co BIGTIFF=YES \
  "${GRID}" "${HEXID}"

# 2) Para cada cenário, alinhar HEXID à grade do cenário (nearest) e contar pixels por hex:
#    px_total = total de pixels no hex, px_exced = pixels com valor>0 (excedente)
#    Converter para km² e calcular % = px_exced/px_total*100 (garantindo 0–100)

singularity exec "${PANGEO_SIF}" python <<'PY'
import os
import numpy as np
import geopandas as gpd
import rasterio
from rasterio.vrt import WarpedVRT
from rasterio.enums import Resampling

BASE="/home/alessandrabertassoni/Calc_excedentes"
OUT=f"{BASE}/out_hexstats"
HEXID=f"{OUT}/hexid_30m.tif"
GPKG_OUT=f"{OUT}/hexstats_all.gpkg"

GRID="/home/alessandrabertassoni/AMZCERPAN.gpkg"
LAYER="grade_area_interesse"
ID="FID_biomas"

SCENARIOS = {
    "bau":  f"{BASE}/bau30_excedentes.tif",
    "tnc1": f"{BASE}/tnc130_excedentes.tif",
    "tnc2": f"{BASE}/tnc230_excedentes.tif",
}

PIX_M2  = 30.0 * 30.0
PIX_KM2 = PIX_M2 / 1e6

def zonal_counts(hexid_path, scen_path):
    with rasterio.open(scen_path) as rs, rasterio.open(hexid_path) as hsrc:
        # Align HEXID to the scenario grid without creating a new file
        hid = WarpedVRT(
            hsrc,
            crs=rs.crs,
            transform=rs.transform,
            width=rs.width,
            height=rs.height,
            resampling=Resampling.nearest,
            nodata=0
        )

        # Find max hex id (block-wise)
        max_id = 0
        for _, w in hid.block_windows(1):
            max_id = max(max_id, int(hid.read(1, window=w).max()))

        px_total = np.zeros(max_id + 1, dtype=np.uint64)
        px_exced = np.zeros(max_id + 1, dtype=np.uint64)

        # Count pixels (block-wise)
        for _, w in hid.block_windows(1):
            ids = hid.read(1, window=w).astype(np.int64)
            val = rs.read(1, window=w)

            m = (ids != 0)
            if not m.any():
                continue

            ids_m = ids[m]
            px_total += np.bincount(ids_m, minlength=max_id + 1).astype(np.uint64)
            px_exced += np.bincount(ids_m, weights=(val[m] > 0), minlength=max_id + 1).astype(np.uint64)

    ids_out = np.arange(1, max_id + 1, dtype=np.int64)
    return ids_out, px_total[1:], px_exced[1:]

# Load hex grid geometry once
gdf = gpd.read_file(GRID, layer=LAYER)[[ID, "geometry"]].copy()

for name, scen in SCENARIOS.items():
    ids_out, tot, exc = zonal_counts(HEXID, scen)

    # Build per-hex table
    df = gpd.GeoDataFrame(
        {
            ID: ids_out,
            "px_total": tot,
            "px_exced": exc,
            "total_km2_raster": tot * PIX_KM2,
            "exced_km2": exc * PIX_KM2,
            "exced_pct_totalhex": np.clip((exc / np.where(tot == 0, 1, tot)) * 100.0, 0, 100),
            "scenario": name,
        }
    )

    # Join stats to grid geometry and write a layer per scenario
    out = gdf.merge(df, on=ID, how="left").fillna(0)
    out.to_file(GPKG_OUT, layer=f"hexstats_{name}", driver="GPKG")
    print(f"OK: wrote layer hexstats_{name} to {GPKG_OUT}")
PY

echo "Done: ${GPKG_OUT} (layers: hexstats_bau, hexstats_tnc1, hexstats_tnc2)"
