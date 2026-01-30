# Data Processing and Standardization

## Objective
This protocol describes the initial data processing procedures applied to all spatial datasets used in the project.

The objective is to ensure that all variables share the same spatial resolution, coordinate reference system, extent, and NoData conventions, allowing their direct integration into the Dinamica EGO modeling framework.

## Spatial Reference Framework

All datasets were processed to meet the following spatial standards:

- Spatial resolution: 30 meters
- Coordinate Reference System (CRS): Albers Equal Area for South America (ESRI:102033)

This projection was selected because it preserves area and minimizes distortion at continental and biome scales.

-- 

## Standard Processing Workflow

Most variables followed a standardized processing workflow, implemented through a shell script that performs the following operations:

- Merging tiled datasets
- Spatial clipping to the study area
- Reprojection to the target CRS
- Resampling to 30 m spatial resolution
- Adjustment of raster visualization parameters for GIS software

[`**Standard processing script**`](Data_processing/merge_clip_resample_reproject.sh)

## Online Data Acquisition

For datasets requiring direct online download (e.g., land use maps and Global 30-m Annual Median Vegetation Height), a dedicated acquisition script was used.

This script:
1. Downloads the datasets from online sources
2. Passes the data to the standard processing workflow

[`**Online acquisition script:** `](Data_processing/Processo_aquisicao_dados_online.sh)


## Reclassification and NoData Handling

When datasets required correction of NoData values or thematic simplification, specific scripts were applied:

1. Script: [`NoData reclassification`](Data_processing/gdal_reclass_nodata.sh)

2. Script: [`MapBiomas class simplification (Collection 9)`](Data_processing/reclassificar_mapbiomas.sh)

3. Script: [`Biomass and vegetation vigor reclassification`](Data_processing/reclassification_values_biomass_vigor.sh)


## Derived Variables

### Deforestation Age
The deforestation age layer was generated using MapBiomas land use data from 1985 to 2023.

- Environment: Google Colab
- Script: [`IdadeDesmatamentoLULC.ipynb`](Data_processing/IdadeDesmatamentoLULC.ipynb)

---

### Pasture Age
Pasture age layers were obtained from pre-processed datasets using Google Earth Engine.

- Script: [`pasture_age.js`](Data_processing/pasture_age.js)

---

### Rasterization and Euclidean Distance

For vector datasets requiring raster conversion or distance calculations:

-  [`Rasterization`](Data_processing/rasterize_vectors.sh)  


- [`Euclidean distance calculation (R language)`](Data_processing/Calc_distance.r)  

---

## Territorial Units Processing

The territorial unit layer was produced by merging four vector datasets.

Processing steps included:
- Attribute harmonization
- Rasterization based on a unique identifier
- Reprojection and resampling

**Script:**  
[`territorial_units.sh`](Data_processing/UnidadesTerritoriais.sh)

---

## Slope Calculation

Slope was derived using a Digital Elevation Model (DEM) processed in Google Earth Engine.

The DEM combines:
- SRTM
- ASTER GDEM
- ICESat
- PRISM

**Script:**  
[`slope.js`](Data_processing/slope.js)

---

## Raster Alignment

After individual processing, all raster layers were spatially aligned to ensure:

- Identical extent
- Pixel-level alignment
- Consistent NoData handling

This step was necessary to avoid allocation errors in Dinamica EGO.

**Script:**  
[`Alinhar_raster.ipynb`](Data_processing/Alinhar_raster.ipynb)

---

## Regional Clipping for Modeling

To prepare datasets for the modeling stage, all processed variables were clipped by modeling regions.

- Regionalization methodology:  
  [`Methodology.md`](../../Projeto_CENARIOS/Regionalization/Methodology.md)

- Regional boundaries:  
  [`Regions shape`](https://drive.google.com/drive/folders/1iDu-_7E0YfGVzNwI_gBjPckpnGJd88H3)

- Clipping script:  
  [`Variables_cut.py`](Data_processing/Variables_cut.py)

---

## Variable Dictionary and Metadata

The table below summarizes all variables used in the project, including data type, NoData value, and download location.

### Output Data Control and Parameter Reference

[//]:#(table)

| Variable | Data type | NoData | File |
| :---: | :---: | :---: | :---: |
| Permanent Preservation Area (Área de Preservação Ambiental - APP) | Byte | 0 | [APPs_AmaCerrPan.tif](https://drive.google.com/file/d/1S6Yvwy3vLhejGpNtzql6kiu2rKjmJlwF/view?usp=drive_link) |
|Soybean Suitability | Byte | 0 | [Potencialidade_soja_entrada_final.tif](https://drive.google.com/file/d/1IHVVhHCKCMyUaynpx57RfOJEv-a0I2Gn/view?usp=drive_link) |
| Brazilian Forest Code | Int16 | 0 | [CodigoFlorestal_final_30m.tif](https://drive.google.com/file/d/13GnfiCbqtcZTGAXOrBZx2kaLMm6YsccY/view?usp=drive_link) |
| Slope | float32 | -9999 | [slope30_final_30m.tif](https://drive.google.com/file/d/1rBIQ9KDUFXeL3TzALM-Nr-fte8474a2q/view?usp=drive_link) |
| Population density | int16 | 0 | [Densidadepop_final_30m.tif](https://drive.google.com/file/d/1lJlZ8EqkPzhxHKgPh4QY61wyQU-4kD0n/view?usp=drive_link) |
| Distance to Rivers | Float32 | -9999 | [dist_drenagem_30.tif](https://drive.google.com/file/d/1yGZqcaS5SLcElYyiCjWW7uBtaL7fcd8e/view?usp=drive_link) |
| Distance to Paved Federal and State Roads| Float32 | -9999 | [estradas_f_e_dist_entrada_final.tif](https://drive.google.com/file/d/1Ry4J0Vy1TGdasAS7aeWKYNsricUjFbRl/view?usp=drive_link) |
| Unpaved Roads | Float32 | -9999 | [dist_vicinais_30_entrada_final.tif](https://drive.google.com/file/d/1XLvCIBVnGoWTuYFTwFjmoXcSCI_mQQ4D/view?usp=drive_link) |
| Distance to Railways| Float32 | -9999 | [dist_ferrovias_30_entrada_final.tif](https://drive.google.com/file/d/1E7bptOO7pMaobcp_WobSXYRioM2ZeDaI/view?usp=drive_link) |
| Distance to Slaughterhouses | Float32 | -9999 | [Frigo_distancia_30M_entrada_final.tif](https://drive.google.com/file/d/1AZ6cTztC6v1-IYumbhEglTJChZ5e2O2m/view?usp=drive_link) |
| Distance to River Ports | uint32 | 0 | [hidroportos_final.tif](https://drive.google.com/file/d/1ISnkesgUkL3njK6cd3n9VFppzGSCx_2Z/view?usp=drive_link) |
| Distance to Navigable Waterways | Float32 | -9999 | [distancia_hidrovia_entrada_final.tif](https://drive.google.com/file/d/1uco9Q2GPcVteEfk7MwR-v9f_MbeKONHQ/view?usp=drive_link) |
| Distanced to Warehouses | Float32 | -9999 | [Distancia_Silo_30m_entrada_final.tif](https://drive.google.com/file/d/1Pj-MZxQUMn2CgRrjGR9tzWWevJynMWxJ/view?usp=drive_link) |
| Distance to Railway Terminals | Float32 | 0 | [terminais_final.tif](https://drive.google.com/file/d/19H7cNfEntoNdqph2wEm2M1b4yLXhGzWE/view?usp=drive_link) |
| Vegetation physiognomy | Int16 | 0 | [fito_AmaCerrPan_30_entrada_final.tif](https://drive.google.com/file/d/19IVlhuDzF-YsCcdtsXx6BD86aR3eCUJU/view?usp=drive_link) |
| Distance to Illegal Mining Sites| Float32 | -9999 | [distancia_garimpos_ilegais.tif](https://drive.google.com/file/d/1TDxXwdFknsfGA6nV4a5wV70XSSHq3lYG/view?usp=drive_link) |
| Deforestation Age | int8 | 127 | [deforestation_age_85_2023_entrada_final.tif](https://drive.google.com/file/d/1KDDlqg7jJsSnmnj5Ge-GrzhR6x226UBR/view?usp=drive_link) |
| 2018 Pasture Age  | int8 | 0 | [IdadePastagem2018_entrada_final.tif](https://drive.google.com/file/d/1J-9vaHbyddPEn8j9Y2eEzpSbwKxZcOjf/view?usp=drive_link) |
| 2023 Pasture Age | int8 | 0 | [IdadePastagem2023_entrada_final.tif](https://drive.google.com/file/d/1Bv6qDyt7f1rdMg_0PFJjLRBjcqPZap3j/view?usp=drive_link) |
| Property Size | int8 | 0 | [Imoveis1_final_30m.tif](https://drive.google.com/file/d/1zJ2N0P0me3cWZ_vSm8XH5-RsS2JTu6a8/view?usp=drive_link) |
| Livestock Intensification | int8 | 0 | [integracao_tnc.tif](https://drive.google.com/file/d/1gbVr084AqWtZwFMOOJshihV_VQar8s1x/view?usp=drive_link) |
| 2018 Land Cover | int8 | 0 | [AMZCERR_2018_final_30m.tif](https://drive.google.com/file/d/17npJX9ycBy3GuLVV-X0Cps5yScqvOeUV/view?usp=drive_link) |
| 2023 Land Cover | int8 | 0 | [AMZCERR_2023_final_30m.tif](https://drive.google.com/file/d/1vPgKKrWT1qP7VFCqXA9QHdE645BZNSAf/view?usp=drive_link) |
| Precipitation| uint16 | 0 | [Precipitacao_30m_entrada_final.tif](https://drive.google.com/file/d/15VMYDuaNhcXIaTsWmsx-Mw1yFbmrrcT2/view?usp=drive_link) |
| Relief | Int16 | -32768 | [geo_dem_30m_entrada_final.tif](https://drive.google.com/file/d/1VdUP6F2k5ZproA75kR2y6cy0FWwZwvro/view?usp=drive_link) |
| Legal Reserve | Int16 | 0 | [RLBRRec_final_30m.tif](https://drive.google.com/file/d/1yxZ9rDDJo-KDUckCDNd0sXMuIpWouxmv/view?usp=drive_link) |
| 2018 Median Vegetation Height | Float32 | -32000 | [gpw_AmaCerrPan_shortveg_height_2018_entrada_final.tif](https://drive.google.com/file/d/18JMA4B-itFeKoaVTmWx5yhXBS4VKf9rn/view?usp=drive_link) |
| 2022 Median Vegetation Height | Float32 | -32000 | [gpw_AmaCerrPan_shortveg_height_2022_entrada_final.tif](https://drive.google.com/file/d/1y1d_BGU1Bt8ysnqNa2iQrXltGAdQeJJm/view?usp=drive_link) |
| Indigenous land | Int16 | 0 | [TI_final_30m.tif](https://drive.google.com/file/d/17uXMXEWdJNor0MNUAlUrLjd6bNN0RfDQ/view?usp=drive_link) |
| Strictly Protected Area | Int16 | 0 | [UCPIfinal_30m.tif](https://drive.google.com/file/d/1-3QeFtZdd6wEsJgR4V9ZEJoCMaRLfLaL/view?usp=drive_link) |
| Sustainable Protected Area | Int16 | 0 | [UCUS_final_30m.tif](https://drive.google.com/file/d/1x2gFvzgKIIq6G_0EmH5g5HpOIZAhIvzb/view?usp=drive_link) |
| Territorial unit | int8 | 0 | [ut_final_amzcerr.tif](https://drive.google.com/file/d/1HeStEgxFoca5ZJTECZevghqW6cTWo5qO/view?usp=drive_link) |
| 2018 Pasture vigor | int8 | 0 | [pastagem_EVI_normalizado_30_2018_entrada_final.tif](https://drive.google.com/file/d/114AsSj_YKjlN2saVRcOkj80YCGt4MfXf/view?usp=drive_link) |
| 2023 Pasture vigor | int8 | 0 | [pastagem_EVI_normalizado_30_2023_entrada_final.tif](https://drive.google.com/file/d/1bnSU_VGtmJRuY-OkeoUd6nNZoow5Z6Y3/view?usp=drive_link) |
</div>
<br>

---

## Outputs
- Fully standardized raster layers
- Region-specific datasets for Dinamica EGO modeling
- [`Metadata table for all variables`](Docs/Tables/Metadata.md)

---

## Dependencies
- GDAL
- QGIS / ArcGIS
- Google Earth Engine
- Google Colab
- Python and R environments