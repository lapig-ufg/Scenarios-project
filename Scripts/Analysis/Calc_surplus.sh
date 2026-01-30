#!/usr/bin/env bash
set -euo pipefail

# Generate hexagonal summaries of binary "surplus" rasters and write a single GeoPackage
# Input: surplus rasters for scenarios BAU, TNC1, TNC2
# Output: vector hex grid with per-hex statistics

# --- inputs ---
BASE="/home/alessandrabertassoni/Biome_Surplus_Calculation"
OUT="${BASE}/out_hexstats"
GRID="/home/alessandrabertassoni/AMZCERPAN.gpkg" # Vector hexagonal grid
LAYER="grade_area_interesse"   
ID="FID_biomas"                        # Unique hexagon identifier

BAU="${BASE}/bau30_surplus.tif"
TNC1="${BASE}/tnc130_surplus.tif"
TNC2="${BASE}/tnc230_surplus.tif"

# --- containers ---
GDAL_SIF="/home/alessandrabertassoni/containers/gdal.sif"
PANGEO_SIF="/home/alessandrabertassoni/pangeo-notebook_latest.sif"

mkdir -p "${OUT}"
HEXID="${OUT}/hexid_30m.tif"
GPKG_OUT="${OUT}/hexstats_all.gpkg"

# 1) Rasterize hex IDs at 30 m (0 = outside grid)
#    Use the original vector grid to ensure all hexagons are included
#    (even those with no surplus in any scenario)

singularity exec "${GDAL_SIF}" gdal_rasterize \
  -l "${LAYER}" \
  -a "${ID}" \
  -tr 30 30 \
  -a_nodata 0 \
  -ot Int32 \
  -of GTiff \
  -co COMPRESS=DEFLATE -co TILED=YES -co BIGTIFF=YES \
  "${GRID}" "${HEXID}"

# 2) For each scenario, align HEXID to scenario grid (nearest) and count pixels per hex:
#    px_total = total pixels in hex, px_surplus = pixels with value>0
#    Convert to km² and calculate % = px_surplus / px_total * 100 (clamped 0–100)

singularity exec "${PANGEO_SIF}" python <<'PY'
import os
import numpy as np
import geopandas as gpd
import rasterio
from rasterio.vrt import WarpedVRT
from rasterio.enums import Resampling

BASE="/home/alessandrabertassoni/Biome_Surplus_Calculation"
OUT=f"{BASE}/out_hexstats"
HEXID=f"{OUT}/hexid_30m.tif"
GPKG_OUT=f"{OUT}/hexstats_all.gpkg"

GRID="/home/alessandrabertassoni/AMZCERPAN.gpkg"
LAYER="grade_area_interesse"
ID="FID_biomas"

SCENARIOS = {
    "bau":  f"{BASE}/bau30_surplus.tif",
    "tnc1": f"{BASE}/tnc130_surplus.tif",
    "tnc2": f"{BASE}/tnc230_surplus.tif",
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
        px_surplus = np.zeros(max_id + 1, dtype=np.uint64)

        # Count pixels per hex (block-wise)
        for _, w in hid.block_windows(1):
            ids = hid.read(1, window=w).astype(np.int64)
            val = rs.read(1, window=w)

            m = (ids != 0)
            if not m.any():
                continue

            ids_m = ids[m]
            px_total += np.bincount(ids_m, minlength=max_id + 1).astype(np.uint64)
            px_surplus += np.bincount(ids_m, weights=(val[m] > 0), minlength=max_id + 1).astype(np.uint64)

    ids_out = np.arange(1, max_id + 1, dtype=np.int64)
    return ids_out, px_total[1:], px_surplus[1:]

# Load hex grid geometry once
gdf = gpd.read_file(GRID, layer=LAYER)[[ID, "geometry"]].copy()

for name, scen in SCENARIOS.items():
    ids_out, tot, exc = zonal_counts(HEXID, scen)

    # Build per-hex dataframe
    df = gpd.GeoDataFrame(
        {
            ID: ids_out,
            "px_total": tot,
            "px_surplus": exc,
            "total_km2_raster": tot * PIX_KM2,
            "surplus_km2": exc * PIX_KM2,
            "surplus_pct_totalhex": np.clip((exc / np.where(tot == 0, 1, tot)) * 100.0, 0, 100),
            "scenario": name,
        }
    )

    # Join stats to grid geometry and write a layer per scenario
    out = gdf.merge(df, on=ID, how="left").fillna(0)
    out.to_file(GPKG_OUT, layer=f"hexstats_{name}", driver="GPKG")
    print(f"OK: wrote layer hexstats_{name} to {GPKG_OUT}")
PY

echo "Done: ${GPKG_OUT} (layers: hexstats_bau, hexstats_tnc1, hexstats_tnc2)"
