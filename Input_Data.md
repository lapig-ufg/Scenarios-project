# Anthropogenic Data

| Variable | Description | Year | Source |
| :---: | :--- | :---: | :---: |
| Distance to Paved Federal and State Roads | Vector reprojected to Albers; clipped to the area of interest; vector rasterized; resampled to 30 m; Euclidean distance calculated. | 2021, 2022 | [DNIT](https://servicos.dnit.gov.br/vgeo/) |
| Unpaved Roads | Vector reprojected to Albers; clipped to the area of interest; vector rasterized; resampled to 30 m; Euclidean distance calculated. | 2023 | [IBGE](https://geoftp.ibge.gov.br/cartas_e_mapas/bases_cartograficas_continuas/bc250/versao2023/shapefile/) |
| Distance to Railways | Vector reprojected to Albers; clipped to the area of interest; vector rasterized; resampled to 30 m; Euclidean distance calculated. | 2020 | [DNIT](https://servicos.dnit.gov.br/vgeo/) |
| Distance to Navigable Waterways | Vector reprojected to Albers; clipped to the area of interest; vector rasterized; resampled to 30 m; Euclidean distance calculated. | 2022 | [DNIT](https://servicos.dnit.gov.br/vgeo/) |
| Distanced to Warehouses | Vector reprojected to Albers; clipped to the area of interest; vector rasterized; resampled to 30 m; Euclidean distance calculated. | 2024 | [MapBiomas](https://brasil.mapbiomas.org/dados-de-infraestrutura/) |
| Distance to Slaughterhouses | Vector reprojected to Albers; clipped to the area of interest; vector rasterized; resampled to 30 m; Euclidean distance calculated. | 2021 | ABIEC, IMAZON, GISMAPS, IMAFLORA and [ABRAFRIGO](https://www.abrafrigo.com.br/index.php/links-uteis/) |
| Population Density | Raw gridded vector data were merged, clipped to the area of interest, and converted to raster format. Subsequently, rasters were reprojected, resampled, and aligned with the other layers. | 2010 | [IBGE](https://www.ibge.gov.br/geociencias/downloads-geociencias.html) |
| Deforestation Age | Land use and land cover data of natural areas from the full historical series of MapBiomas Collection 9 were processed to identify the year of deforestation. The result was reprojected and resampled to 30 m resolution. | 2024 | [MapBiomas](https://brasil.mapbiomas.org/dados-de-infraestrutura/) |
| 2023 Pasture Age | Raster obtained from MapBiomas Collection 9 (pre-processed). The data were clipped, reprojected, and resampled to 30 m resolution. | 2023 | [MapBiomas](https://brasil.mapbiomas.org/dados-de-infraestrutura/) |
| 2023 Pasture Vigor | Raw MODIS-EVI data were reclassified into three classes: low vigor (1), moderate vigor (2), and high vigor (3). The raster was then reprojected, resampled, and aligned with the other layers. | 2023 | [LAPIG/MapBiomas](https://brasil.mapbiomas.org/wp-content/uploads/sites/4/2024/08/ATBD-Collection-9-v2.docx-1.pdf) |
| Soybean Suitability | Areas with potential for soybean cultivation were filtered; clipped to the study area; reclassified into moderate, good, and very good suitability classes; reprojected to Albers and resampled to 30 m. | — | [IBGE](https://agenciadenoticias.ibge.gov.br/agencia-noticias/2012-agencia-de-noticias/noticias/35693-publicacao-inedita-do-ibge-mostra-elevado-potencial-natural-para-a-agricultura-no-pais) |
| Property Size (SNCR) | Two vector datasets were merged and reclassified into four property size classes (smallholding, small, medium, and large). The data were rasterized, reprojected, resampled, and aligned with the other layers. | — | [INCRA](https://www.gov.br/incra/pt-br) |
| Property Size (SIGEF) | Two vector datasets were merged and reclassified into four property size classes (smallholding, small, medium, and large). The data were rasterized, reprojected, resampled, and aligned with the other layers. | — | [INCRA](https://www.gov.br/incra/pt-br) |
| Permanent Preservation Area (Área de Preservação Ambiental - APP) | The vector dataset was divided into APP and Legal Reserve layers. Both were clipped to the study area, rasterized, reprojected, resampled, and aligned with the other layers. | — | [SICAR](https://car.gov.br/#/) |
| Territorial Unit | Vector data were categorized into public lands (1), private lands (2), settlement areas (3), and quilombola communities (4). The data were rasterized, merged, reprojected, resampled, and aligned with the other layers. | 2022, 2025 | [MMA and INCRA](https://brasil.mapbiomas.org/tabela-de-camadas/) |
| Indigenous Land | Vector data were reprojected to Albers, rasterized, resampled to 30 m resolution, and clipped to include only areas within the study region. | 2025 | [FUNAI](https://brasil.mapbiomas.org/tabela-de-camadas/) |
| Brazilian Forest Code | Vectors of biomes, Brazilian states, and RADAM vegetation physiognomies were overlaid. The resulting classification was defined as 0% (class 1), 20% (class 2), 30% (class 3), 35% (class 4), 50% (class 5), and 80% (class 6). The layer was reprojected to Albers and resampled to 30 m. | 2023 | [IBGE](https://www.ibge.gov.br/geociencias/downloads-geociencias.html) |

---

# Natural Data

| Variable | Description | Year | Source |
| :---: | :--- | :---: | :---: |
| Strictly Protected Area | Protected Area vectors were separated into Strict Protection and Sustainable Use categories. Each dataset was reprojected to Albers, rasterized, resampled to 30 m resolution, and clipped to the study area. | 2025 | [MMA](https://brasil.mapbiomas.org/tabela-de-camadas/) |
| Distance to Rivers | ANA drainage vector reprojected to Albers; clipped to the area of interest; rasterized; resampled to 30 m; Euclidean distance calculated. | 2017 | [SNIRH](https://metadados.snirh.gov.br/geonetwork/srv/por/catalog.search#/home) |
| Precipitation | Originally acquired at 30 arc-second resolution (~1 km). The layer was clipped to the study area, reprojected to Albers, resampled to 30 m resolution, and aligned with the other rasters. | 2021 | [Chelsa](https://www.chelsa-climate.org/) |
| Global 30-m Annual Median Vegetation Height (ShortVeg) | Rasters obtained directly from the data authors. The data were clipped, reprojected, resampled, and aligned with the other rasters. | 2023 | [LAPIG/GPW](https://www.researchsquare.com/article/rs-6521333/v1) |
| Relief | Raster generated from ALOS PALSAR scenes available via ASF Data Search with 12.5 m spatial resolution. After mosaicking, the data were reprojected, resampled to 30 m, and aligned with the other rasters. | 2015 | [ASF Data Search](https://search.asf.alaska.edu/#/) |
| Slope | Raster processed as percent slope in Google Earth Engine (GEE) using the 30 m NASADEM digital elevation model. The data were mosaicked, reprojected, and resampled to 30 m resolution. | 2020 | [NASA](https://www.earthdata.nasa.gov/data/catalog/lpcloud-nasadem-hgt-001) |
