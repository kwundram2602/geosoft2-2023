
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
