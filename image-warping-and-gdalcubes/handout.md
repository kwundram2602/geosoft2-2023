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

### The core features of the package are:

1. build regular dense data cubes from large satellite image collections based on a user-defined data cube view          
   (spatiotemporal extent, resolution, and map projection of the cube)
2. apply and chaining operations on data cubes
3. allow for the execution of user-defined functions on data cubes
4. export data cubes as netCDF files, making it easy to process further, e.g., with stars or raster.

### Data Cubes
 <img width="403" alt="image" src="https://github.com/kwundram2602/geosoft2-2023/assets/134778951/2fe44219-fa86-45cf-bf2e-e2475c89f45f">
 



### Image Collections
Creating an image collection is one of the first steps when working with gdalcubes. Downloaded satellite data may be stored in a zipped folder first where every image has its own directory containing one GeoTIFF file per band.

### Collection Formats

Collection formats are defined in gdalcubes and determine how required metadata can be derived from the data.
formats for some Sentinel-2, MODIS, and Landsat products are included.
All formats can be listed with:
1. library(gdalcubes)
2. collection_formats()

## What is image warping ?

## what is gdalwarp and what does it do ?

## How is gdalwarp used in gdalcubes ?
