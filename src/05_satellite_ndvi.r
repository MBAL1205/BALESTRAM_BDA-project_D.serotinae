# Downloading the boundary of switzerland
map_boundary <- geoboundaries("switzerland")

# Reading in the downloaded NDVI raster data
NDVI_raster <- raster("C:/Users/USER/Desktop/Biodiversity conservation/2023_SP/Biodiversity data analysis/_Personal_project/data/MYD13Q1_NDVI_2020_153.tif")

# Transforming the data
NDVI_raster <- projectRaster(NDVI_raster, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

# Cropping the data
map_boundary <- geoboundaries("switzerland")
NDVI_raster <- raster::mask(NDVI_raster, as_Spatial(map_boundary))

# Dividing values by 10000 to have NDVI values between -1 and 1
gain(NDVI_raster) <- 0.0001

# Assuming matrix_full is the data frame with latitude and longitude columns
spatial_points <- SpatialPoints(coords = matrix_full_alt_eco_clim[, c("longitude","latitude")], proj4string = CRS("+proj=longlat +datum=WGS84"))

# Extracting values
NDVI <- raster::extract(NDVI_raster, spatial_points)

# Adding satellite data to full_matrix
matrix_full_alt_eco_clim_sat <- data.frame(matrix_full_alt_eco_clim,NDVI)

# Removing row names
row.names(matrix_full_alt_eco_clim_sat) <- NULL
