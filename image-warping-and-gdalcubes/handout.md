# Image Warping and Gdalcubes

### Problems with time series of satellite imagery

When someone is working with collections and time series of satellite imagery it is possible to run into problems quickly.
 Some of these problems are :
  1. Images from different areas of the world may have __different spatial reference systems__
  2. The __pixel size__ of a single image sometimes __differs__ among its spectral bands.
  3. Spatially adjacent image tiles often overlap.
  4. Time series of images are often irregular when the area of interest covers spatial areas larger than the extent of a           single image.
  5. Images from different data products or different satellites are distributed in diverse data formats and structures.

## The gdalcubes package

The gdal package is a programm to help process raster data (data conversion, image processing or generating sublets). 
It is however not possible to work with image time series. 

The R package gdalcubes is aiming to make the work with collections and time series of satellite imagery easier and more interactive.
<hr/>

### The core features of the package are:

1. build regular dense data cubes from large satellite image collections based on a user-defined data cube view          
   (spatiotemporal extent, resolution, and map projection of the cube)
2. apply and chaining operations on data cubes
3. allow for the execution of user-defined functions on data cubes
4. export data cubes as netCDF files, making it easy to process further, e.g., with stars or raster.
<hr/>

### Image Collections
Creating an image collection is one of the first steps when working with gdalcubes. Downloaded satellite data may be stored in a zipped folder first where every image has its own directory containing one GeoTIFF file per band.
<hr/>

### Data Cubes
 <img width="403" alt="image" src="https://github.com/kwundram2602/geosoft2-2023/assets/134778951/2fe44219-fa86-45cf-bf2e-e2475c89f45f">
 
 
To create a raster data cube we need an image collection and define a data cube view.
```{r}
v.overview = cube_view(extent=L8.col, dt="P1Y", dx=1000, dy=1000, srs="EPSG:3857", 
                       aggregation = "median", resampling = "bilinear")
raster_cube(L8.col, v.overview)
```
meaning 1kmx1km pixel size, yearly temporal resolution, covering the full spatiotemporal extent of the image collection, and using the web mercator spatial reference system
The aggregation parameter in the data cube view defines how values from multiple images in the same year shall be combined
#### Cube Operators
<img width="610" alt="image" src="https://github.com/kwundram2602/geosoft2-2023/assets/134778951/c3e01558-da93-4322-ad97-42733d9632ef">



<hr/>

### Collection Formats

Collection formats are defined in gdalcubes and determine how required metadata can be derived from the data.
formats for some Sentinel-2, MODIS, and Landsat products are included.
All formats can be listed with:
1. library(gdalcubes)
2. collection_formats()

## Image Warping
basically editing of imagery:
(reprojection, rescaling, cropping and resampling).


### what is gdalwarp and what does it do ?
https://cran.r-project.org/web/packages/gdalUtilities/gdalUtilities.pdf  p. 12.

gdalwarp is not part of gdalcubes but part of gdal.
"The gdalwarp utility is an image mosaicing, reprojection and warping utility. The program can reproject to any supported projection."
documentation under : https://www.rdocumentation.org/packages/gdalUtils/versions/2.0.3.2/topics/gdalwarp

 ### Arguments for gdawarp : 

__srcfile:__   	&emsp;&emsp;&emsp;&emsp;Character. The source file name(s). <br/>
__dstfile:__	&emsp;&emsp;&emsp;&emsp;Character. The destination file name.<br/>
  __s_srs:__    &emsp;&emsp;&emsp;&emsp;Character. source spatial reference set. The coordinate systems that can be passed are anything supported by the OGRSpatialReference.SetFromUserInput() call, which includes EPSG PCS and GCSes (ie. EPSG:4296), PROJ.4 declarations (as above), or the name of a .prf file containing well known text.<br/>
<br/>
<br/>

## How is gdalwarp used in gdalcubes ?
The gdalwarp function is found in the gdalUtilities package
```{r}
install.packages("gdalUtilities")
library(gdalUtilities)
```
Idee : gdalwarp nutzen um auf das gleiche Referenzsystem bringen bevor man datacube baut.
<hr/>

### Demo in R (also in repo as R file)

```{r}
# 1. install gdalcubes
install.packages("gdalcubes")


# 2. download example data
download.file("https://uni-muenster.sciebo.de/s/e5yUZmYGX0bo4u9/download", destfile = "L8_Amazon.zip")
unzip("L8_Amazon.zip", exdir = "L8_Amazon")


# 3. create image collection
library(gdalcubes)

files = list.files("L8_Amazon", recursive = TRUE, 
                   full.names = TRUE, pattern = ".tif") 
L8.col = create_image_collection(files, format = "L8_SR")
L8.col


# 4. Create a data cube
v= cube_view(extent=L8.col, dt="P1Y", dx=1000, dy=1000, 
             srs="EPSG:3857", aggregation = "median")
x = raster_cube(L8.col, v) 
x

# 5. process data cube and plot
# derive the median values of the RGB bands over time

gdalcubes_options(parallel = 4)
x |>
  select_bands(c("B02","B03","B04")) |>
  reduce_time(c("median(B02)","median(B03)","median(B04)")) |>
  plot(x, rgb=3:1, zlim=c(0,1200))
```

## Further Reading 
gdal documentation: https://gdal.org/index.html <br/>
gdalcubes: https://r-spatial.org/r/2019/07/18/gdalcubes1.html <br/>
gdal Utilites: https://cran.r-project.org/web/packages/gdalUtilities/gdalUtilities.pdf <br/>
gdalwarp documentation: https://www.rdocumentation.org/packages/gdalUtils/versions/2.0.3.2/topics/gdalwarp 
