<h2 align="center">Regionalization Methodology</h2>

<div align="center">
    <img src="Figures/Infografico.png" width="80%" alt="">
    <p><i>Figure 1: Infographic</i></p>
</div>

To represent land-use and land-cover (LULC) transitions across Brazil’s largest biomes, we developed a specific regionalization. Rather than relying on predefined political or administrative units (e.g., states, municipalities, or river basins), we implemented a data-driven regionalization tailored to current land-use patterns and transition dynamics. This approach ensures that regions reflect homogeneous LULC behavior relevant to the modeling objectives.

The regionalization process followed three main steps:

1. Hexagonal grid creation
2. Calculation of land-use transitions
3. Spatially constrained regionalization

<h3 align="left">1. Hexagonal grid creation</h3>

The study area covers the Amazon and Cerrado biomes, with the Pantanal included due to its spatial proximity and extent. A hexagonal grid with 20 km cells was created to spatially integrate the three biomes. This grid served as the basic spatial unit for calculating land-use transitions and regional attributes.

<h3 align="left">2. Calculation of land-use transitions</h3>

Land-use and land-cover maps from MapBiomas Collection 9 were used for the years 2013, 2018, and 2023. The analysis focused on four classes: Native Vegetation, Pasture, Mosaic (grouped as “Other”), and Soy. All remaining classes were excluded from the analysis.

Transition maps were generated for the periods 2013–2018 and 2018–2023, and reclassified to retain only the transitions of interest (e.g., natural vegetation to pasture, natural vegetation to soy, pasture to soy). Using the hexagonal grid, the area of each transition class was calculated per cell. For each hexagon, we derived:
- The proportion of each LULC class in 2023;
- Transition rates between classes for the analyzed periods.

<h3 align="left">3. Spatially constrained regionalization</h3>

Regionalization was performed in GeoDa (https://geodacenter.github.io/) using multivariate clustering with spatial constraints. Input variables included:

- Proportions of LULC classes in 2023;
- Transition rates for the 2018–2023 period.

Spatial weights were computed using a **queen contiguity criterion** to account for spatial dependence. Clustering was conducted using the SKATER method (Spatial ‘K’luster Analysis by Tree Edge Removal), which groups spatially contiguous and internally homogeneous regions. Variables were normalized using the Range Adjust method, and the optimal number of clusters was estimated using internal variance criteria (ANOVA-based).

The method initially suggested 25 clusters. Based on expert knowledge and similarity between regions, two clusters were merged, resulting in 24 final regions, which were subsequently used as spatial units in the modeling framework.


