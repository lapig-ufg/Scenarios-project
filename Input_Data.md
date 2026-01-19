#
# Dados Antrópicos

<br>

| Dado | Descrição |Ano| Fonte |
| :---: | :--- |:---:| :---: |
| Distância de Estradas Pavimentadas | Vetor reprojetado para Albers; Recorte para a área de interesse; Rasterização do vetor; Mudança de resolução para 30m; Cálculo de distância euclidiana. || [DNIT](https://servicos.dnit.gov.br/vgeo/) |
| Distância de Estradas Vicinais | Vetor reprojetado para Albers; Recorte para a área de interesse; Rasterização do vetor; Mudança de resolução para 30m; Cálculo de distância euclidiana. || [IBGE](https://geoftp.ibge.gov.br/cartas_e_mapas/bases_cartograficas_continuas/bc250/versao2023/shapefile/) |
| Distância de ferrovias | Vetor reprojetado para Albers; Recorte para a área de interesse; Rasterização do vetor; Mudança de resolução para 30m; Cálculo de distância euclidiana. || [DNIT](https://servicos.dnit.gov.br/vgeo/) |
| Distância de Hidrovias | Vetor reprojetado para Albers; Recorte para a área de interesse; Rasterização do vetor; Mudança de resolução para 30m; Cálculo de distância euclidiana. || [DNIT](https://servicos.dnit.gov.br/vgeo/) |
| Distância de Silos | Vetor reprojetado para Albers; Recorte para a área de interesse; Rasterização do vetor; Mudança de resolução para 30m; Cálculo de distância euclidiana. || [MapBiomas](https://brasil.mapbiomas.org/dados-de-infraestrutura/) |
| Distância de Frigoríficos | Vetor reprojetado para Albers; Recorte para a área de interesse; Rasterização do vetor; Mudança de resolução para 30m; Cálculo de distância euclidiana. || ABIEC, IMAZON, GISMAPS, IMAFLORA e [ABRAFRIGO](https://www.abrafrigo.com.br/index.php/links-uteis/) |
| Densidade Populacional | A partir dos dados vetoriais brutos em grade, foi realizada a junção dos arquivos, seguida do recorte para a área de interesse e da conversão para o formato raster. Posteriormente, os arquivos foram reprojetados, redimensionados e alinhados com os demais rasters. || [IBGE](https://www.ibge.gov.br/geociencias/downloads-geociencias.html) |
| Idade do Desmatamento | Processados dados de uso e cobertura de áreas naturais de toda a série histórica do Mapbiomas coleção 9, para identificar o ano de desmatamento. O resultado foi reprojetado e teve sua resolução espacial redimensionada para 30 metros. || [MapBiomas](https://brasil.mapbiomas.org/dados-de-infraestrutura/) |
| Idade da Pastagem | Raster adquirido do Mapbiomas coleção 9 já processados. Foi então realizado recorte, reprojetado e sua resolução espacial foi redimensionada para 30 metros quadrados. || [MapBiomas](https://brasil.mapbiomas.org/dados-de-infraestrutura/) |
| Vigor da Pastagem | Os dados brutos (MODIS-EVI) foram reclassificados em três classes, de 1 a 3, correspondendo a baixo vigor (1), vigor moderado (2) e alto vigor (3). Em seguida, o dado foi reprojetado, redimensionado e alinhado com os demais. || [LAPIG/MapBiomas](https://brasil.mapbiomas.org/wp-content/uploads/sites/4/2024/08/ATBD-Collection-9-v2.docx-1.pdf); |
| Aptidão para soja | Filtragem das áreas com potencial para o cultivo de soja; recorte para a área de estudo; reclassificação das classes conforme o grau de potencialidade, sendo elas: moderada, boa e muito boa; Redimensionado para 30m e reprojetado para Albers. || [IBGE](https://agenciadenoticias.ibge.gov.br/agencia-noticias/2012-agencia-de-noticias/noticias/35693-publicacao-inedita-do-ibge-mostra-elevado-potencial-natural-para-a-agricultura-no-pais) |
| Sistema Nacional de Cadastro Rural - SNCR | As duas bases vetoriais foram unidas possuindo o mesmo valor, então reclassificadas pelo tamanho da propriedade em 4 classes (minifúndio, pequena, média e grande propriedade). Os dados são rasterizados, reprojetados, redimensionados e em seguida alinhados com os outros. || [INCRA](https://www.gov.br/incra/pt-br) |
| Sistema de Gestão Fundiária - SIGEF | As duas bases vetoriais foram unidas possuindo o mesmo valor, então reclassificadas pelo tamanho da propriedade em 4 classes (minifúndio, pequena, média e grande propriedade). Os dados são rasterizados, reprojetados, redimensionados e em seguida alinhados com os outros. || [INCRA](https://www.gov.br/incra/pt-br) |
| Cadastro Ambiental Rural - CAR | A base vetorial foi separada em duas, sendo de APP e RL. Ambas foram recortadas somente as que estavam dentro da área de estudo. Em seguida, rasterizados, reprojetados, redimensionados e em seguida alinhados com os outros. || [SICAR](https://car.gov.br/#/) |
| Unidades Territoriais | Compreende a categorização dos vetores em: áreas públicas (1), áreas privadas (2), áreas de assentamentos (3) e áreas de comunidades quilombolas (4). Os dados foram rasterizados e unidos, reprojetados, redimensionados e alinhados com os demais. || [MMA e INCRA](https://brasil.mapbiomas.org/tabela-de-camadas/) |
| Terras Indígenas | A base vetorial foi reprojetado para o sistema Albers, rasterizado, redimensionado para 30 metros de resolução e recortado, considerando apenas as terras localizadas dentro da área de interesse. || [FUNAI](https://brasil.mapbiomas.org/tabela-de-camadas/) |
| Aplicação do Código Florestal | Foi realizada a sobreposição dos vetores dos biomas, dos estados brasileiros e das fitofisionomias do Projeto Radar da Amazônia (RADAM). A nova classificação foi definida da seguinte forma: 0% (classe 1), 20% (classe 2), 30% (classe 3), 35% (classe 4), 50% (classe 5) e 80% (classe 6). Após a reclassificação, foi feito o reprojetamento para o sistema Albers e o redimensionamento para 30 metros. || [IBGE](https://www.ibge.gov.br/geociencias/downloads-geociencias.html) |


<br>

#
# Dados Naturais

<br>

| Dado | Descrição |Ano| Fonte |
| :---: | :--- |:---:|:---: |
| Unidades de Conservação | Os vetores foram separados em Unidades de Conservação de Proteção Integral e de Uso Sustentável. Cada um deles foi reprojetado para o sistema Albers, rasterizado, redimensionado para 30 metros de resolução e recortado, considerando apenas as áreas localizadas dentro da área de interesse. || [MMA](https://brasil.mapbiomas.org/tabela-de-camadas/) |
| Distância de Rios | Vetor reprojetado para Albers; Recorte para a área de interesse; Rasterização do vetor; Mudança de resolução para 30m; Cálculo de distância euclidiana. || [SNIRH](https://metadados.snirh.gov.br/geonetwork/srv/por/catalog.search#/home) |
| Precipitação no trimestre mais quente | Adquirida na resolução de 30 arc seconds (~1 km), a camada foi recortada para a área de interesse, reprojetado para Albers, redimensionada para 30 metros, e alinhada com os demais rasters. || [Chelsa](https://www.chelsa-climate.org/) |
| Global 30-m Annual Median Vegetation Height (ShortVeg)| Rasters adquiridos diretamente com os autores dos dados. Os dados foram recortados, reprojetados, redimensionados e alinhados com os demais rasters. || [LAPIG/GPW](https://www.researchsquare.com/article/rs-6521333/v1) |
| Relevo | Raster gerado pelas cenas do Alos Palsar disponíveis no ASF Data Search com resolução espacial de 12,5 metros. Após unir as cenas o dado foi reprojetado, redimensionado para 30 metros e alinhado com os demais rasters. || [ASF Data Search](https://search.asf.alaska.edu/#/) |
| Declividade | Raster processado em porcentagem no Google Earth Engine (GEE) utilizando o modelo para 30 metros do modelo digital de elevação da Nasa (NASADEM), posteriormente foi mosaicado, reprojetado, e redimensionado para uma resolução espacial de 30 metros quadrados. || [NASA](https://www.earthdata.nasa.gov/data/catalog/lpcloud-nasadem-hgt-001) |



