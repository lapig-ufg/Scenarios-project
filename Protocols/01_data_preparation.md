[//]: #(Introducao)
<h2 align="center">Processamento Inicial</h2>
<div align="justify"> 
    Todas as variáveis foram processadas para que tivessem a mesma resolução espacial e estivessem projetadas no mesmo sistema de coordenadas. A resolução escolhida foi de 30 metros por célula, de modo que os padrões pudessem ser melhor percebidos nas análises. A projeção adotada foi a Albers para a América do Sul (ESRI:102033), por se tratar de uma projeção que preserva a área e apresenta baixa distorção em comparação a outras projeções. 
</div>

[//]:#(processamento_padrao)
<br>
<div align="justify">
    Maior parte das variáveis utilizou os mesmos métodos para processamento, sendo esse o script de <a href="Data_processing/merge_clip_resample_reproject.sh">procedimento de processamento padrão </a> que une as cenas separadas dos arquivos (dados grandes), recorta, reprojeta e deixa todos os pixels com resolução espacial cravada em 30 metros e ajusta um modo de visualização do dado em programas gis.
</div>

[//]:#(aquisicao_dados_online)
<br>
<div align="justify">
    Para os dados que houvesse necessidade de baixar direto como links, como uso e cobertura e Global 30-m Annual Median Vegetation Height o script de <a href="Data_processing/Processo_aquisicao_dados_online.sh">procedimento de aquisição de dados online </a> que faz o download dos dados e então é passado novamente para o script de <a href="Data_processing/merge_clip_resample_reproject.sh">procedimento de processamento padrão </a> 
</div>

[//]:#(reclass)
<br>
<div align="justify">
    Quando os dados precisam de correção de valor sem dados e de reclassificação:
    <ul>
        <li><b>1- </b> De valores o script de <a href="Data_processing/gdal_reclass_nodata.sh">reclassificação de nodata</a>.</li>
        <li><b>2-</b> Para simplificar a classificação feita pelo mapbiomas (coleção 9) usar o código de <a href="Data_processing/reclassificar_mapbiomas.sh">reclassificação dados mapbiomas</a> .</li>
        <li><b>3-</b> Para dados de biomassa foi utilizado o script de <a href="Data_processing\reclassification_values_biomass_vigor.sh">reclassificação de ranges de biomassa</a></li>
        </li>
    </ul>    
</div>

[//]:#(deforestation_age)
<br>
<div align="justify">
    A camada de idade do desmatamento foi gerada usando os dados do mapbiomas de 1985 a 2023 usando o script de <a href="Data_processing\IdadeDesmatamentoLULC.ipynb">calcular idade de desmatamento</a> feito no ambiente do google colab.
</div>

[//]:#(pasture_age)
<br>
<div align="justify">
    A camada de idade de idade da pastagem foi adquirida dos dados pre processados usando o script de <a href="Data_processing/pasture_age.js">idade da pastagem</a> feito no ambiente do google earth engine.
</div>

[//]:#(rasterizar_e_distancia_euclidiana)
<br>
<div align="justify">
    Em casos de dados vetoriais que necessitavam de conversão para raster ou calculo de distancia euclidiana foi usando o script de <a href="Data_processing/rasterizar_vetores.sh">rasterizar vetores</a> e apenas para distância euclidiana o script de <a href="Data_processing\Calc_distance.r"> calcular distância</a> em linguagem r.
</div>

[//]:#(ut_process)
<br>
<div align="justify">
    No processamento da camada de unidade territorial foi realizada a junção de 4 camadas de dadods vetoriais que foram processadas tendo valor único em um dos campos para rasterizar, e os dados foram novamente redimensionados usando o script de <a href="Data_processing/UnidadesTerritoriais.sh"> de união e reprojeção </a> dos dados.
</div>

[//]:#(slope)
<br>
<div align="justify">
    No processamento da camada de declividade, foi necessário utilizar dentro do google earth engine os dados do  Modelo Digitam de Elevação (DEM) da Nasa que é um reprocessamento dos dados do SRTM melhorados com os dados do ASTER GDEM, ICESat e PRISM usando o script de <a href="Data_processing/slope.js"> de calculo de declividade</a>.
</div>

[//]:#(realinhamento)
<br>
<div align="justify">
    Após todas as variáveis serem processadas, era necessário que elas entre si fossem alinhadas entre si para evitar problemas no DinâmicaEGO, foi realizado usando então um script de <a href="Data_processing/Alinhar_raster.ipynb"> realinhamento </a> dentro de uma pasta onde todas as variáveis fossem inseridas
[//]:#(Recorte_regioes)
</div>

<br>
<div align="justify">
    Após finalizar a preparação das bases de dados, foi necessário para a etapa de <a href="../../Projeto_CENARIOS/Model_DinamicaEGO/About.md"> modelagem </a>, que todos os arquivos fossem recortados por regiões (disponíveis no <a href="https://drive.google.com/drive/folders/1iDu-_7E0YfGVzNwI_gBjPckpnGJd88H3?usp=drive_link"> link</a>). Para isso foi utilizado um script que fosse capaz de realizar o <a href="Data_processing\Variables_cut.py"> recorte por regiões</a>, para recortar as regiões descritas no <a href="../../Projeto_CENARIOS/Regionalization/Methodology.md"> método de regionalização </a>.
</div>

[//]:#(table_introducao)
<br>
<h2 align="justify"> Dicionário de Variáveis e Metadados </h2>
<div align="justify">
    A seguinte tabela contém a relação de todas as variáveis utilizadas no processamento, seus tipos de dados e links para download no Google Drive.
</div>
<br>
<div align="center">

[//]:#(table)

| Variável | Tipo de Dado | NoData | Arquivo (Link do Drive) |
| :---: | :---: | :---: | :---: |
| Áreas de Preservação Permanente(APP) | Byte | 0 | [APPs_AmaCerrPan.tif](https://drive.google.com/file/d/1S6Yvwy3vLhejGpNtzql6kiu2rKjmJlwF/view?usp=drive_link) |
| Aptidão Soja | Byte | 0 | [Potencialidade_soja_entrada_final.tif](https://drive.google.com/file/d/1IHVVhHCKCMyUaynpx57RfOJEv-a0I2Gn/view?usp=drive_link) |
| Código Florestal | Int16 | 0 | [CodigoFlorestal_final_30m.tif](https://drive.google.com/file/d/13GnfiCbqtcZTGAXOrBZx2kaLMm6YsccY/view?usp=drive_link) |
| Declividade | float32 | -9999 | [slope30_final_30m.tif](https://drive.google.com/file/d/1rBIQ9KDUFXeL3TzALM-Nr-fte8474a2q/view?usp=drive_link) |
| Densidade Populacional | int16 | 0 | [Densidadepop_final_30m.tif](https://drive.google.com/file/d/1lJlZ8EqkPzhxHKgPh4QY61wyQU-4kD0n/view?usp=drive_link) |
| Distância Drenagem | Float32 | -9999 | [dist_drenagem_30.tif](https://drive.google.com/file/d/1yGZqcaS5SLcElYyiCjWW7uBtaL7fcd8e/view?usp=drive_link) |
| Distância Estradas | Float32 | -9999 | [estradas_f_e_dist_entrada_final.tif](https://drive.google.com/file/d/1Ry4J0Vy1TGdasAS7aeWKYNsricUjFbRl/view?usp=drive_link) |
| Distância Estradas Vicinais | Float32 | -9999 | [dist_vicinais_30_entrada_final.tif](https://drive.google.com/file/d/1XLvCIBVnGoWTuYFTwFjmoXcSCI_mQQ4D/view?usp=drive_link) |
| Distância Ferrovias | Float32 | -9999 | [dist_ferrovias_30_entrada_final.tif](https://drive.google.com/file/d/1E7bptOO7pMaobcp_WobSXYRioM2ZeDaI/view?usp=drive_link) |
| Distância Frigoríficos | Float32 | -9999 | [Frigo_distancia_30M_entrada_final.tif](https://drive.google.com/file/d/1AZ6cTztC6v1-IYumbhEglTJChZ5e2O2m/view?usp=drive_link) |
| Distância Hidroportos | uint32 | 0 | [hidroportos_final.tif](https://drive.google.com/file/d/1ISnkesgUkL3njK6cd3n9VFppzGSCx_2Z/view?usp=drive_link) |
| Distância Hidrovia | Float32 | -9999 | [distancia_hidrovia_entrada_final.tif](https://drive.google.com/file/d/1uco9Q2GPcVteEfk7MwR-v9f_MbeKONHQ/view?usp=drive_link) |
| Distância Silo | Float32 | -9999 | [Distancia_Silo_30m_entrada_final.tif](https://drive.google.com/file/d/1Pj-MZxQUMn2CgRrjGR9tzWWevJynMWxJ/view?usp=drive_link) |
| Distância Terminais | Float32 | 0 | [terminais_final.tif](https://drive.google.com/file/d/19H7cNfEntoNdqph2wEm2M1b4yLXhGzWE/view?usp=drive_link) |
| Fitofisionomia | Int16 | 0 | [fito_AmaCerrPan_30_entrada_final.tif](https://drive.google.com/file/d/19IVlhuDzF-YsCcdtsXx6BD86aR3eCUJU/view?usp=drive_link) |
| Garimpos Ilegais | Float32 | -9999 | [distancia_garimpos_ilegais.tif](https://drive.google.com/file/d/1TDxXwdFknsfGA6nV4a5wV70XSSHq3lYG/view?usp=drive_link) |
| Idade Desmatamento | int8 | 127 | [deforestation_age_85_2023_entrada_final.tif](https://drive.google.com/file/d/1KDDlqg7jJsSnmnj5Ge-GrzhR6x226UBR/view?usp=drive_link) |
| Idade Pastagem 2018 | int8 | 0 | [IdadePastagem2018_entrada_final.tif](https://drive.google.com/file/d/1J-9vaHbyddPEn8j9Y2eEzpSbwKxZcOjf/view?usp=drive_link) |
| Idade Pastagem 2023 | int8 | 0 | [IdadePastagem2023_entrada_final.tif](https://drive.google.com/file/d/1Bv6qDyt7f1rdMg_0PFJjLRBjcqPZap3j/view?usp=drive_link) |
| Imóveis | int8 | 0 | [Imoveis1_final_30m.tif](https://drive.google.com/file/d/1zJ2N0P0me3cWZ_vSm8XH5-RsS2JTu6a8/view?usp=drive_link) |
| Integração | int8 | 0 | [integracao_tnc.tif](https://drive.google.com/file/d/1gbVr084AqWtZwFMOOJshihV_VQar8s1x/view?usp=drive_link) |
| Mapbiomas 2018 | int8 | 0 | [AMZCERR_2018_final_30m.tif](https://drive.google.com/file/d/17npJX9ycBy3GuLVV-X0Cps5yScqvOeUV/view?usp=drive_link) |
| Mapbiomas 2023 | int8 | 0 | [AMZCERR_2023_final_30m.tif](https://drive.google.com/file/d/1vPgKKrWT1qP7VFCqXA9QHdE645BZNSAf/view?usp=drive_link) |
| Precipitação | uint16 | 0 | [Precipitacao_30m_entrada_final.tif](https://drive.google.com/file/d/15VMYDuaNhcXIaTsWmsx-Mw1yFbmrrcT2/view?usp=drive_link) |
| Relevo | Int16 | -32768 | [geo_dem_30m_entrada_final.tif](https://drive.google.com/file/d/1VdUP6F2k5ZproA75kR2y6cy0FWwZwvro/view?usp=drive_link) |
| Reserva Legal | Int16 | 0 | [RLBRRec_final_30m.tif](https://drive.google.com/file/d/1yxZ9rDDJo-KDUckCDNd0sXMuIpWouxmv/view?usp=drive_link) |
| ShortVeg 2018 | Float32 | -32000 | [gpw_AmaCerrPan_shortveg_height_2018_entrada_final.tif](https://drive.google.com/file/d/18JMA4B-itFeKoaVTmWx5yhXBS4VKf9rn/view?usp=drive_link) |
| ShortVeg 2022 | Float32 | -32000 | [gpw_AmaCerrPan_shortveg_height_2022_entrada_final.tif](https://drive.google.com/file/d/1y1d_BGU1Bt8ysnqNa2iQrXltGAdQeJJm/view?usp=drive_link) |
| Território Indígena | Int16 | 0 | [TI_final_30m.tif](https://drive.google.com/file/d/17uXMXEWdJNor0MNUAlUrLjd6bNN0RfDQ/view?usp=drive_link) |
| UC Proteção Integral | Int16 | 0 | [UCPIfinal_30m.tif](https://drive.google.com/file/d/1-3QeFtZdd6wEsJgR4V9ZEJoCMaRLfLaL/view?usp=drive_link) |
| UC Uso Sustentável | Int16 | 0 | [UCUS_final_30m.tif](https://drive.google.com/file/d/1x2gFvzgKIIq6G_0EmH5g5HpOIZAhIvzb/view?usp=drive_link) |
| Unidade Territorial | int8 | 0 | [ut_final_amzcerr.tif](https://drive.google.com/file/d/1HeStEgxFoca5ZJTECZevghqW6cTWo5qO/view?usp=drive_link) |
| Vigor 2018 | int8 | 0 | [pastagem_EVI_normalizado_30_2018_entrada_final.tif](https://drive.google.com/file/d/114AsSj_YKjlN2saVRcOkj80YCGt4MfXf/view?usp=drive_link) |
| Vigor 2023 | int8 | 0 | [pastagem_EVI_normalizado_30_2023_entrada_final.tif](https://drive.google.com/file/d/1bnSU_VGtmJRuY-OkeoUd6nNZoow5Z6Y3/view?usp=drive_link) |
</div>
<br>
<div align="center">
Controle de dados de saída e gabarito de parametros (No Data/ Formato de dados).
</div>
