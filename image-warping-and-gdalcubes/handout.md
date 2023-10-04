# Image Warping and Gdalcubes
When someone is working with collections and time series of satellite imagery it is possible to get problems very fast.
 Some of these problems are :
  1. Images from different areas of the world may have __different spatial reference systems__
  2. The __pixel size__ of a single image sometimes __differs__ among its spectral bands.
  3. Spatially adjacent image tiles often overlap.
  4. Time series of images are often irregular when the area of interest covers spatial areas larger than the extent of a           single image.
  5. Images from different data products or different satellites are distributed in diverse data formats and structures.

There is already the normal gdal R-package that can adress some of the problems but gdal does not know about time series.
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
 




<hr/>

### Collection Formats

Collection formats are defined in gdalcubes and determine how required metadata can be derived from the data.
formats for some Sentinel-2, MODIS, and Landsat products are included.
All formats can be listed with:
1. library(gdalcubes)
2. collection_formats()

## What is image warping ?
resize, and resample

## what is gdalwarp and what does it do ?

## How is gdalwarp used in gdalcubes ?
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

gdalcubes_options(parallel = 4)
x |>
  select_bands(c("B02","B03","B04")) |>
  reduce_time(c("median(B02)","median(B03)","median(B04)")) |>
  plot(x, rgb=3:1, zlim=c(0,1200))
```

