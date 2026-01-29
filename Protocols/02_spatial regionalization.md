# Protocol 2 – Spatial Regionalization

## Objective
This protocol describes the procedure used to define spatially explicit modeling regions based on land use and land cover transitions.

The regionalization aims to represent spatial heterogeneity in land use dynamics, ensuring that areas grouped within the same region share similar transition patterns and current land use composition.

This regionalization was designed specifically to support large-scale LUCC modeling using Dinamica EGO.

---

## Conceptual Rationale
Different regionalization strategies were evaluated, including:
- Political-administrative units (states, municipalities)
- Hydrographic basins
- Ecological or socio-economic zoning schemes

Given the scope of the project, modeling land use and land cover transitions across major Brazilian biomes, these approaches were considered insufficient to represent the spatial variability of the underlying transition processes.

Therefore, a data-driven regionalization was developed, based on:
- Observed land use transitions
- Current land use composition
- Spatial contiguity

---

## Study Area
The study area includes the following biomes:
- Amazon
- Cerrado
- Pantanal

The Pantanal biome was included due to its spatial proximity and ecological interaction with the Amazon and Cerrado biomes.

---

## Input Data

### Land Use and Land Cover Maps
- Source: MapBiomas Collection 9
- Format: raster
- Spatial resolution: 30 m
- Years used: 2013, 2018 , 2023

### Land Use Classes of Interest
| Class Code | Description |
|----------|-------------|
| 1 | Native vegetation |
| 15 | Pasture |
| 39 | Soybean |
| 21 | Other temporary crops |

All other classes were reclassified as background (0).

---

## Methodological Workflow
The regionalization process was conducted in three main stages:

1. Creation of a hexagonal spatial grid  
2. Calculation of land use transitions  
3. Spatially constrained multivariate clustering  

---

## Step 1 – Hexagonal Grid Generation

### Objective
Create a spatial framework that allows consistent aggregation of land use transitions while minimizing directional bias.

### Procedure
- A hexagonal grid was generated covering the entire study area.
- Cell size: 20 km
- Geometry type: hexagon
- Software used:  ArcMap / QGIS

Each hexagon was assigned a unique identifier (ID), which was used as the spatial unit for subsequent analyses.


![Hexagonal grid with 20 km cells covering the study area]()

---

## Step 2 – Calculation of Land Use Transitions

### Pre-processing
- Land use maps were reclassified to retain only the classes of interest.
- All non-relevant classes were assigned value 0.

### Transition Mapping
Transitions were calculated by summing land use maps from consecutive years:
- T0 + T1
- T1 + T2

This procedure generated multiple transition categories, which were reclassified to retain only transitions of interest:
- Natural → Pasture (NP)
- Natural → Soy (NS)
- Natural → Other (NO)
- Pasture → Soy (PS)
- Other → Soy (OS)

---

### Spatial Aggregation
- The hexagonal grid was overlaid on the transition maps.
- For each hexagon, the area (m²) of each transition class was calculated.
- Tool used: [e.g. Tabulate Area]

The resulting table associates each hexagon ID with the area occupied by each transition.

---

### Attribute Table Construction
- Transition areas were joined to the hexagon attribute table using the hexagon ID.
- Transition classes with zero values were excluded.
- For each hexagon:
  - Proportion of each land use class was calculated for year [T2]
  - Transition rates were calculated for the selected time period.

---

## Step 3 – Spatial Regionalization (Clustering)

### Input Variables
The following attributes were used for clustering:
- Proportion of land use classes in year [T2]
- Transition rates between land use classes
- Time window used for transitions: [e.g. T1–T2]

---

### Spatial Weights Matrix
- Software: GeoDa
- Spatial contiguity criterion: Queen
- Spatial weights were computed to assess spatial dependence among neighboring hexagons.

---

### Clustering Method
The regionalization was performed using the SKATER algorithm (Spatial ‘K’luster Analysis by Tree Edge Removal).

This method:
- Preserves spatial contiguity
- Maximizes internal homogeneity
- Minimizes inter-region heterogeneity

---

### Edge Weight Calculation
- Data transformation method: Range Adjust
- Attribute values were normalized to a 0–1 scale
- Edge weights were calculated based on multivariate dissimilarity

---

### Cluster Definition
- The optimal number of clusters was estimated internally using:
  - Elbow method
  - Analysis of Variance (ANOVA)

The initial solution suggested 25 clusters.

Based on expert knowledge and similarity between adjacent regions, some clusters were merged, resulting in a final set of 24 regions.

---

## Outputs

- Hexagonal grid with cluster labels
- Attribute table with land use proportions and transition rates
- Final regionalization map

Outputs are stored in: 
