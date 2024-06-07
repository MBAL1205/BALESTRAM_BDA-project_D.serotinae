# Creating a SpatialPoints object
spatial_points <- SpatialPoints(coords = matrix_full_alt_eco_clim_sat[, c("longitude", "latitude")], 
                                proj4string = CRS("+proj=longlat +datum=WGS84"))


# Retrieving soild pH data 
gph <- soil_world(var="phh2o", depth=5, path=tempdir())
gph <- raster(gph)

# Extracting temperature values for all occurrences
ph <- raster::extract(gph, spatial_points, method = 'bilinear')
ph <- data.frame(ph)

# Adding soil pH  to full_matrix
clean_matrix <- data.frame(matrix_full_alt_eco_clim_sat,ph)

# Cleaning the matrix from N/A data
clean_matrix <- clean_matrix[complete.cases(clean_matrix), ]

# Cleaning the matrix from duplicated data
clean_matrix <- clean_matrix[!duplicated(clean_matrix),]

# Making some order in the final matrix
clean_matrix <- setNames(clean_matrix, c("eco_values","species","latitude","longitude", "source", "elevation", "temperatur", "moisture", "landcover","landforms", "climate_re", "red", "green", "blue", "ecosystem", "color", "tmax", "tmin", "rain", "ndvi", "ph" ))

# Plotting combined data on a map of Switzerland
p6 <- ggplot(data = Switzerland) +
  geom_sf() +
  geom_point(data = clean_matrix, aes(x = longitude, y = latitude, fill = species), size = 2, shape = 23) +
  theme_classic() +
  ggtitle("Characteristic Species Occurrences with available environmental data (n=2869)") +
  xlab("Longitude") +
  ylab("Latitude") +
  labs(fill = "Species")
