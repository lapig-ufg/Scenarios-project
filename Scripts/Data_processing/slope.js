//For run in Google Earth Engine 

// Define the study area geometry (exemple area)
var ae = ee.Geometry.Polygon([
  [
    [-54.337, -25.344],
    [-47.437, -25.483],
    [-47.416, -29.869],
    [-54.789, -29.642],
    [-54.337, -25.344]
  ]
]);

//function to calculate radians
function radians(img) {
    return img.toFloat().multiply(Math.PI).divide(180)
}

// Load NASADEM data
var terrain = ee.Algorithms.Terrain(ee.Image("NASA/NASADEM_HGT/001"))//catch the slope
var decliv = (radians(terrain.select('slope'))).expression('b("slope")*100'); //Selection of the slope band and conversion from deegre to percentage
var elevation = terrain.select('elevation'); //if you want elevation by NASADEM

var slope = decliv.clip(ae) //clip for the study area

// Visualization
//Map.addLayer(elevation,{},'relevo');
Map.addLayer(ae,{}, 'areaestudo');
Map.addLayer(slope,{},'slope')

// Export to Google Drive
Export.image.toDrive({
  image:slope,
  description: 'slope', //The name of your file
  maxPixels: 1E13,
  scale: 30,
  region: ae.bounds(),
  folder:'DEM30_1' }); //The name of your path in Drive