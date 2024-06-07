sf_use_s2(FALSE)

# Getting the spatial data for Switzerland
Switzerland <- ne_countries(scale = "medium", returnclass = "sf", country = "Switzerland")

# Getting the elevation raster data for Switzerland
elevation_switzerland <- get_elev_raster(Switzerland, z = 8)

# Cropping and masking the elevation data to match Switzerland's boundaries
r2 <- crop(elevation_switzerland, extent(Switzerland))
elevation_switzerland <- mask(r2, Switzerland)

# Extracting coordinates from matrix_full
latitude <- matrix_full$latitude
longitude <- matrix_full$longitude

# Creating a data frame for all coordinates
all_coord <- data.frame(longitude, latitude)

# Creating spatial points
ll_prj <- "EPSG:4326"
points <- sp::SpatialPoints(all_coord, proj4string = sp::CRS(ll_prj))

# Extracting elevation values at all occurrences
elevation_points <- raster::extract(elevation_switzerland, points)

# Creating a data frame for elevation points
elevation_df <- data.frame(elevation = elevation_points)

# Adding elevation to matrix_full
matrix_full_alt <- data.frame(matrix_full, elevation_df)

# Removing row names
row.names(matrix_full_alt) <- NULL
