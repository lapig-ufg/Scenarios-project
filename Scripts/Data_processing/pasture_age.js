//To run in Google Earth Engine
//RUN FOR THE YEARS THAT YOU WANT (YEAR BY YEAR)

// Define the study area geometry
var AreaEstudo = ee.FeatureCollection('users/vieiramesquita/ibge_biomas_250_2019');

//Pasture Age Data
var age = ee.Image('projects/mapbiomas-mosaics/assets/COLECAO9/pecuaria-idade/Y2013')



//Filter a featureCollecction by biome code and aply the reducer
var Ae = AreaEstudo.filter(ee.Filter.inList('CD_Bioma',ee.List([1,3,6]))) 
                    .reduceToImage({
                        properties:['CD_Bioma'],
                        reducer:ee.Reducer.count(), //type of reducer
                    }).gt(0).selfMask(); // make a mask for values greater than 0


Map.addLayer(Ae,{min:1,max:1,palette:['gold']},'Máscara') //Visualization parameters


//Make a layer to hold the pasture age 
var idade = age.multiply(Ae)

//Visualization (age)
Map.addLayer(age,{min:1,max:39},'Idade da pastagem')
//print(age);
print(idade)

//Export to Drive
Export.image.toDrive({
  image: idade.toByte(),
  description: 'Idade_Pastagem_2013', //The name of your file
  folder: 'MapBiomas_Idade_Pastagem', // The name of your path
  fileNamePrefix: 'idade_pastagem_2013',
  region:Ae,
  scale: 30, // Spatial Resolution
  maxPixels: 1e13,
  crs: 'EPSG:4326' // Coordinate System
});