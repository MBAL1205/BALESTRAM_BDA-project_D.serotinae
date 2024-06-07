# Retrieving maximal temperature data for Switzerland
sw_clim <- worldclim_country("switzerland", var = "tmax", path = tempdir())
sw_clim_br <- brick(sw_clim)

matrix_temp = NULL
vec_colname_temp = NULL

for (i in 1:12) {
  raster_month_temp <- sw_clim_br[[i]]
  vec_colname_temp <- c(vec_colname_temp, names(raster_month_temp))
  
  raster_month_temp <- raster::extract(raster_month_temp, spatial_points, method = 'bilinear')
  matrix_temp <- cbind(matrix_temp, raster_month_temp)
}

colnames(matrix_temp) <- vec_colname_temp

vec_mean_temp <- as.vector(rowMeans(matrix_temp))
matrix_temp <- data.frame(matrix_temp, vec_mean_temp)

# Retrieving minimal temperature data for Switzerland
sw_clim <- worldclim_country("switzerland", var = "tmin", path = tempdir())
sw_clim_br <- brick(sw_clim)

matrix_temp2 = NULL
vec_colname_temp2 = NULL

for (i in 1:12) {
  raster_month_temp2 <- sw_clim_br[[i]]
  vec_colname_temp2 <- c(vec_colname_temp2, names(raster_month_temp2))
  
  raster_month_temp2 <- raster::extract(raster_month_temp2, spatial_points, method = 'bilinear')
  matrix_temp2 <- cbind(matrix_temp2, raster_month_temp2)
}

colnames(matrix_temp2) <- vec_colname_temp2

vec_mean_temp2 <- as.vector(rowMeans(matrix_temp2))
matrix_temp2 <- data.frame(matrix_temp, vec_mean_temp2)

# Retrieving precipitation data for Switzerland
sw_clim_pec <- worldclim_country("switzerland", var = "prec", path = tempdir())
sw_clim_pec <- brick(sw_clim_pec)

matrix_rain = NULL
vec_colname_rain = NULL

for (i in 1:12)
{
raster_month_rain <- sw_clim_pec[[i]]
vec_colname_rain <- c(vec_colname_rain, names(raster_month_rain))

raster_month_rain <- raster::extract(raster_month_rain, spatial_points, method = 'bilinear')
matrix_rain <- cbind(matrix_rain, raster_month_rain)
}

colnames(matrix_rain) <- vec_colname_rain

vec_mean_rain <- as.vector(rowMeans(matrix_rain))
matrix_rain <- data.frame(matrix_rain, vec_mean_rain)

# Integrating climate data to matrix_full
matrix_full_alt_eco_clim <- data.frame(matrix_full_alt_eco,matrix_temp$vec_mean_temp,matrix_temp2$vec_mean_temp2,matrix_rain$vec_mean_rain)

# Removing row names
row.names(matrix_full_alt_eco_clim) <- NULL
