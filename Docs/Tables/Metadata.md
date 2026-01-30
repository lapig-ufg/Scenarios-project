# Metadata of Explanatory Variables

    This document describes the units and the meaning of raster values for the explanatory variables.


## Distance Variables

| Variable | Description | Unit | Raster Values |
|----------|------------|------|---------------|
| Distance to Paved Federal and State Roads | Distance to paved federal and state roads | meters | Continuous (≥ 0) |
| Distance to Vicinal Roads | Distance to unpaved local roads | meters | Continuous (≥ 0) |
| Distance to Railways | Distance to railway infrastructure | meters | Continuous (≥ 0) |
| Distance to Rivers | Distance to perennial rivers | meters | Continuous (≥ 0) |
| Distance to Slaughterhouses | Distance to meat processing plants | meters | Continuous (≥ 0) |
| Distance to Silos | Distance to grain storage facilities | meters | Continuous (≥ 0) |
| Distance to Navigable Waterways | Distance to navigable rivers | meters | Continuous (≥ 0) |
| Distance to River Ports | Distance to hydroports | meters | Continuous (≥ 0) |
| Distance to Illegal Mining Sites | Distance to illegal mining sites | meters | Continuous (≥ 0) |
| Distance to LULC Classes | Distance to land-use / land-cover classes of interest | meters | Continuous (≥ 0) |

## Physical Variables

| Variable | Description | Unit | Raster Values |
|----------|------------|------|---------------|
| Slope | Terrain slope | % | Continuous |
| Relief | Elevation above sea level | meters | Continuous |
| 2018  and 2022 Median Vegetation Height | Height of short vegetation | cm | Continuous |

## Land-use / Land-cover and Age

| Variable | Description | Unit | Raster Values |
|----------|------------|------|---------------|
| 2018 and 2023 Land Cover | Land-use / land-cover in 2018 | categorical | MapBiomas classes |
| Deforestation Age | Years since deforestation | years | 1985–2023 |
| 2018 and 2023 Pasture Age | Years since pasture establishment | years | 2018 |

## Vegetation / Productivity

| Variable | Description | Unit | Raster Values |
|----------|------------|------|---------------|
| 2018 and 2023 Pasture Vigor | Pasture productivity (GPP) | kg C / ha / year | 1 = Low, 2 = Medium, 3 = High |

## Socioeconomic / Property

| Variable | Description | Unit | Raster Values |
|----------|------------|------|---------------|
| Property Size | Size of rural property | categorical | 1 = Mini-farm, 2 = Small, 3 = Medium, 4 = Large |
| Population Density | Population density | hab / km² | Continuous |
| Livestock Intensification | Intensification level of pasture | categorical | 0 = None, 1 = Moderate, 2 = High |

## Regulatory / Protected Areas

| Variable | Description | Unit | Raster Values |
|----------|------------|------|---------------|
| Permanent Preservation Area (APP) | Legally protected riparian and sensitive areas | categorical | 0 = No, 1 = Yes |
| Legal Reserve (RL) | Legal forest reserve | categorical | 0 = No, 1 = Yes |
| Strictly Protected Areas (UCPI) | Fully protected conservation units | categorical | 0 = No, 1 = Yes |
| Sustainable Protected Areas (UCUS) | Sustainable-use conservation units | categorical | 0 = No, 1 = Yes |
| Indigenous Land (TI) | Indigenous territories | categorical | 0 = No, 1 = Yes |
| Territorial Unit | Classification of land tenure / management | categorical | 1 = Public, 2 = Private, 3 = Settlement, 4 = Quilombola |
| Brazilian Forest Code | Required forest cover percentages by land parcel | categorical | 1 = 0%, 2 = 20%, 3 = 30%, 4 = 35%, 5 = 50%, 6 = 80% |
| Soybean Suitability | Potential suitability for soybean | categorical | 0 = Not suitable, 1 = Suitable |
| Vegetation Physiognomy | Type of vegetation | categorical | MapBiomas / RADAM categories |


## General Notes
- All rasters share the same spatial extent, projection, resolution, and alignment.
- Categorical variables were used directly or discretized as required by the Weights of Evidence framework.
- Continuous variables were discretized during calibration when necessary.
