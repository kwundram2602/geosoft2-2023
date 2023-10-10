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

Image Collections 
```{r}
Image collection object, referencing 180 images with 10 bands
Images:
                                      name      left       top    bottom     right
1 LC08_L1TP_226063_20140719_20170421_01_T1 -54.15776 -3.289862 -5.392073 -52.10338
2 LC08_L1TP_226063_20140820_20170420_01_T1 -54.16858 -3.289828 -5.392054 -52.11418
3 LC08_L1GT_226063_20160114_20170405_01_T2 -54.16317 -3.289845 -5.392064 -52.10878
4 LC08_L1TP_226063_20160724_20170322_01_T1 -54.16317 -3.289845 -5.392064 -52.10878
5 LC08_L1TP_226063_20170609_20170616_01_T1 -54.17399 -3.289810 -5.392044 -52.11958
6 LC08_L1TP_226063_20170711_20170726_01_T1 -54.15506 -3.289870 -5.392083 -52.09798
             datetime        srs
1 2014-07-19T00:00:00 EPSG:32622
2 2014-08-20T00:00:00 EPSG:32622
3 2016-01-14T00:00:00 EPSG:32622
4 2016-07-24T00:00:00 EPSG:32622
5 2017-06-09T00:00:00 EPSG:32622
6 2017-07-11T00:00:00 EPSG:32622
[ omitted 174 images ] 

Bands:
        name offset scale unit       nodata image_count
1    AEROSOL      0     1                           180
2        B01      0     1      -9999.000000         180
3        B02      0     1      -9999.000000         180
4        B03      0     1      -9999.000000         180
5        B04      0     1      -9999.000000         180
6        B05      0     1      -9999.000000         180
7        B06      0     1      -9999.000000         180
8        B07      0     1      -9999.000000         180
9   PIXEL_QA      0     1                           180
10 RADSAT_QA      0     1                           180
```

image_count means : how many images cover this band ?
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

```{r}
Dimensions:
                low              high count pixel_size chunk_size
t        2013-01-01        2019-12-31     7        P1Y          1
y -764014.387686915 -205014.387686915   559       1000        512
x -6582280.06164712 -5799280.06164712   783       1000        512

Bands:
        name offset scale nodata unit
1    AEROSOL      0     1    NaN     
2        B01      0     1    NaN     
3        B02      0     1    NaN     
4        B03      0     1    NaN     
5        B04      0     1    NaN     
6        B05      0     1    NaN     
7        B06      0     1    NaN     
8        B07      0     1    NaN     
9   PIXEL_QA      0     1    NaN     
10 RADSAT_QA      0     1    NaN     


```
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
gdalwarp is not part of gdalcubes instead it is a gdal utility. <br/>
gdalwarp is a function used to helping with image mosaicing and warping. Its main function is to reproject to any projection
<br/>

## How is gdalwarp used in gdalcubes ?
The gdalwarp function is found in the gdalUtilities package
```{r}
install.packages("gdalUtilities")
library(gdalUtilities)

gdalwarp()
```
gdalcubes uses gdalwarp to reproject, resize and resample a GDAL dataset <br/>
idea: use gdalwarp to reproject imagery before using gdalcubes for further 
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
