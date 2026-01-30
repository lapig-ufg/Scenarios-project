#!/usr/bin/env bash
set -euo pipefail

# =========================
# Files and folders
# =========================
BASE="/home/alessandrabertassoni/Calc_excedentes"
OUT="${BASE}/out_hexstats"
GRID="/home/alessandrabertassoni/AMZCERPAN.gpkg" # Hex grid of study region
LAYER="grade_area_interesse"
ID="FID_biomas"

GDAL="/home/alessandrabertassoni/containers/gdal.sif"
PANGEO="/home/alessandrabertassoni/pangeo-notebook_latest.sif"

BAU="${BASE}/bau30_excedentes.tif"
TNC1="${BASE}/tnc130_excedentes.tif"
TNC2="${BASE}/tnc230_excedentes.tif"

HEXID="${OUT}/hexid_30m.tif"

mkdir -p "${OUT}"

# =========================
# 1) Rasterize hex grid (30 m)
# =========================
singularity exec "${GDAL}" gdal_rasterize \
  -l "${LAYER}" \
  -a "${ID}" \
  -tr 30 30 \
  -a_nodata 0 \
  -ot Int32 \
  -of GTiff \
  -co COMPRESS=DEFLATE -co TILED=YES -co BIGTIFF=YES \
  "${GRID}" "${HEXID}"

# =========================
# 2) Calculate hex statistics (pixels → area → %)
# =========================
singularity exec "${PANGEO}" python <<'PY'
import os, numpy as np, pandas as pd, rasterio, geopandas as gpd
from rasterio.vrt import WarpedVRT
from rasterio.enums import Resampling

BASE="/home/alessandrabertassoni/Calc_excedentes"
OUT=f"{BASE}/out_hexstats"
HEXID=f"{OUT}/hexid_30m.tif"

GRID="/home/alessandrabertassoni/AMZCERPAN.gpkg"
LAYER="grade_area_interesse"
ID="FID_biomas"

SCENARIOS={
 "bau": f"{BASE}/bau30_excedentes.tif",
 "tnc1": f"{BASE}/tnc130_excedentes.tif",
 "tnc2": f"{BASE}/tnc230_excedentes.tif"
}

PIX_M2=30*30
PIX_KM2=PIX_M2/1e6

def stats(hexid, scen):
    # Open raster and hex ID, align grids
    with rasterio.open(scen) as rs, rasterio.open(hexid) as hsrc:
        hid=WarpedVRT(hsrc, crs=rs.crs, transform=rs.transform,
                      width=rs.width, height=rs.height,
                      resampling=Resampling.nearest, nodata=0)
        max_id=0
        for _,w in hid.block_windows(1):
            max_id=max(max_id, int(hid.read(1,window=w).max()))
        px_tot=np.zeros(max_id+1,np.uint64)
        px_exc=np.zeros(max_id+1,np.uint64)
        for _,w in hid.block_windows(1):
            ids=hid.read(1,window=w).astype(int)
            val=rs.read(1,window=w)
            m=ids!=0
            if not m.any(): continue
            ids_m=ids[m]
            px_tot+=np.bincount(ids_m, minlength=max_id+1)
            px_exc+=np.bincount(ids_m, weights=(val[m]>0), minlength=max_id+1)
    # Convert pixels to km²
    df=pd.DataFrame({
        ID: np.arange(1,max_id+1),
        "px_total": px_tot[1:],
        "px_exced": px_exc[1:]
    })
    df["total_km2_raster"]=df.px_total*PIX_KM2
    df["exced_km2"]=df.px_exced*PIX_KM2
    df["exced_pct_totalhex"]=(df.px_exced/df.px_total*100).clip(0,100)
    return df

# Load hex grid
gdf=gpd.read_file(GRID, layer=LAYER)[[ID,"geometry"]]

# Calculate statistics for all scenarios
for name,scen in SCENARIOS.items():
    df=stats(HEXID,scen)
    out=gdf.merge(df,on=ID,how="left").fillna(0)
    out["scenario"]=name
    out.drop(columns="geometry").to_csv(f"{OUT}/{name}_hexstats.csv",index=False)
    out.to_file(f"{OUT}/hexstats_all.gpkg", layer=f"hexstats_{name}", driver="GPKG")
    print(f"OK {name}")
PY  
