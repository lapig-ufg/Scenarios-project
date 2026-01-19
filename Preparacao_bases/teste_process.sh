#!/bin/bash

echo " Iniciando a criaco de VRTs para todos os arquivos .tif..."

# Define os parametros fixos em variaveis para facilitar a leitura e modificacao
EXTENT="-1522408.308 822132.912 2078491.692 4209762.912"
RESOLUTION="30 30"

# O loop 'for' vai iterar sobre cada arquivo que termina com .tif
for ARQUIVO_TIF in *.tif; do
  
  # Gera o nome do arquivo de saida .vrt a partir do nome do .tif
  # Ex: de "lulc.tif" para "lulc.vrt"
  ARQUIVO_VRT="${ARQUIVO_TIF%.tif}_entrada.vrt"
  
  echo "Processando: ${ARQUIVO_TIF}  ->  Criando: ${ARQUIVO_VRT}"

  # Executa o comando gdalbuildvrt
  # As aspas em volta das variaveis de arquivo sao MUITO importantes
  # para que nomes com espacos ou caracteres especiais funcionem corretamente.
  gdalbuildvrt "${ARQUIVO_VRT}" \
      -te ${EXTENT} \
      -tr ${RESOLUTION} \
      "${ARQUIVO_TIF}"
done

echo "Criacao de VRTs finalizada com sucesso!"

echo " Iniciando a conversao final de VRT para GeoTIFF otimizado..."

EXTENT="-1522408.308 822132.912 2078491.692 4209762.912"
RESOLUTION="30 30"

# Opocoes de criacao para o GeoTIFF de saida.
# Agrupadas em uma variavel para facilitar a leitura.
# - TILED=YES: Melhora a performance de leitura em softwares GIS.
# - COMPRESS=LZW: Compressao sem perdas para economizar espaco.
# - BIGTIFF=YES: Permite que os arquivos de saida sejam maiores que 4GB.
CREATION_OPTIONS="-multi -wo NUM_THREADS=4 -t_srs ESRI:102033 -srcnodata 0 -co TILED=YES -co COMPRESS=LZW -co BIGTIFF=YES"

# O loop 'for' vai iterar sobre cada arquivo que termina com .vrt
for ARQUIVO_VRT in *.vrt; do
  
  # Define um nome para o arquivo de saida, adicionando "_final" no final.
  # Isso e IMPORTANTE para nao sobrescrever os seus arquivos .tif originais!
  # Ex: de "slope30.vrt" para "slope30_final.tif"
  ARQUIVO_TIF_FINAL="${ARQUIVO_VRT%.vrt}_final.tif"
  
  echo "Processando: ${ARQUIVO_VRT}  ->  Criando: ${ARQUIVO_TIF_FINAL}"

  # Executa o gdal_translate com as opcoes de criacao.
  # As aspas em volta dos nomes dos arquivos garantem que tudo funcione
  # mesmo que haja espacos ou caracteres especiais nos nomes.
  gdalwarp ${CREATION_OPTIONS} \
    -te ${EXTENT} \
    -tr ${RESOLUTION} \
    "${ARQUIVO_VRT}"\
    "${ARQUIVO_TIF_FINAL}"

done

echo "Conversao para TIFF finalizada com sucesso!"
echo "Seus novos arquivos alinhados e otimizados foram criados com o sufixo '_final.tif'."

