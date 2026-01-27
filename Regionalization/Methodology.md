<h2 align="center">Regionalization Methodology</h2>

![alt text](../Figures/Infografico.png)

A data-driven regionalization was developed to represent land-use and land-cover (LULC) transitions across the Amazon, Cerrado, and Pantanal biomes. Instead of administrative boundaries, regions were defined based on current land-use patterns and transition dynamics.

A 20 km hexagonal grid was used as the basic spatial unit. Land-use maps from MapBiomas Collection 9 (2013, 2018, 2023) were reclassified to four classes: Native Vegetation, Pasture, Other (Mosaic), and Soy. Transition maps were generated for the periods 2013–2018 and 2018–2023, and transition areas were calculated for each hexagon.

Regionalization was performed in GeoDa (https://geodacenter.github.io/) using spatially constrained multivariate clustering (SKATER method), based on LULC proportions (2023) and transition rates (2018–2023). Spatial dependence was modeled using queen contiguity. The final regionalization resulted in 24 homogeneous regions, used as inputs for the spatial simulations.


