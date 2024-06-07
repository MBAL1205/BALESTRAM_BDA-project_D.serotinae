### Mapping occurencies
# Mapping GBIF occurencies (2008)
ggplot(data = Switzerland) +
  geom_sf() +
  geom_point(data = all_data_gbif, aes(x = longitude, y = latitude, fill = species), size = 2, shape = 23) +
  theme_classic() +
  ggtitle("Observations from GBIF database (n=2008)") +
  xlab("Longitude") +
  ylab("Latitude") +
  labs(fill = "Species")

# Mapping iNaturalist occurencies (8)
ggplot(data = Switzerland) +
  geom_sf() +
  geom_point(data = all_data_inat, aes(x = longitude, y = latitude, fill = species), size = 2, shape = 23) +
  theme_classic() +
  ggtitle("Observations from iNaturalist database (n=8)") +
  xlab("Longitude") +
  ylab("Latitude") +
  labs(fill = "Species")

# Mapping InfoFlora occurencies (1297)
ggplot(data = Switzerland) +
  geom_sf() +
  geom_point(data = all_species_infoflora, aes(x = longitude, y = latitude, fill = species), size = 2, shape = 23) +
  theme_classic() +
  ggtitle("Observations from InfoFlora database (n=1297)") +
  xlab("Longitude") +
  ylab("Latitude") +
  labs(fill = "Species")

# Mapping all occurencies (3313)
print(p1)

# Mapping all occurrences for which data is available (2869)
print(p6)



### Mapping observations within ecosystems
# Extracting and cropping ecosystems
Switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="Switzerland" )

r2 <- crop(ecosystem_raster, extent(Switzerland))
ecosystem_switzerland <- mask(r2, Switzerland)
plot(ecosystem_switzerland)

# Plotting with all species occurencies
spatial_points <- SpatialPoints(coords = clean_matrix[, c("longitude","latitude")], proj4string = CRS("+proj=longlat +datum=WGS84"))
plot(spatial_points,add=T,pch=16,cex=1)



### Mapping NDVI values for all observations
spatial_points <- SpatialPoints(coords = clean_matrix[, c("longitude","latitude")], proj4string = CRS("+proj=longlat +datum=WGS84"))
plot(NDVI_raster)
plot(spatial_points,add=T,pch=16,cex=1)



### 3D mapping of all species and occurencies
sf_use_s2(FALSE)

# Getting the spatial data for Switzerland
Switzerland <- ne_countries(scale = "medium", returnclass = "sf", country = "Switzerland")

# Getting the elevation raster data for Switzerland
elevation_switzerland <- get_elev_raster(Switzerland, z = 8)

# Cropping and masking the elevation data to match Switzerland's boundaries
r2 <- crop(elevation_switzerland, extent(Switzerland))
elevation_switzerland <- mask(r2, Switzerland)

# Converting the elevation raster to a matrix for 3D plotting
elmat <- raster_to_matrix(elevation_switzerland)
attr(elmat, "extent") <- extent(elevation_switzerland)

# Initial 3D plotting of the elevation map
elmat %>% 
  sphere_shade(texture = "bw") %>%
  plot_map()

# Creating a textured 3D version of the elevation map
elmat %>% 
  sphere_shade(texture = "bw") %>%
  plot_3d(elmat, zscale = 150, fov = 0, theta = 135, zoom = 0.75, 
          phi = 45, windowsize = c(1500, 800))

# Loading the elevation texture map
elevation_texture_map <- readPNG("C:/Users/USER/Desktop/Biodiversity conservation/2023_SP/Biodiversity data analysis/_Personal_project/data/Switzerland.png")

# Defining a color palette for each species
species_colors <- viridis(length(unique(clean_matrix$species)), option = "D")
names(species_colors) <- unique(clean_matrix$species)

# Plotting with all species occurrences from the cleaned matrix
spatial_points <- SpatialPoints(coords = clean_matrix[, c("longitude", "latitude")], proj4string = CRS("+proj=longlat +datum=WGS84"))
plot(spatial_points, add = TRUE, pch = 16, cex = 1)

# Creating the 3D interactive map with textured elevation and additional features
elmat %>% 
  sphere_shade(texture = "bw") %>%
  add_overlay(elevation_texture_map, alphacolor = NULL, alphalayer = 0.7) %>%
  add_shadow(cloud_shade(elmat, zscale = 100, start_altitude = 500, end_altitude = 2000), 0) %>%
  add_water(detect_water(elmat), color = "lightblue") %>%
  plot_3d(elmat, zscale = 100, fov = 0, theta = 135, zoom = 0.75, 
          phi = 45, windowsize = c(1500, 800))

# Rendering points on the 3D elevation map with colors for different species
for (spec in unique(clean_matrix$species)) {
  spec_points <- clean_matrix[clean_matrix$species == spec, ]
  render_points(
    extent = extent(Switzerland), size = 10,
    lat = spec_points$latitude, long = spec_points$longitude,
    altitude = spec_points$elevation + 100, zscale = 150, color = species_colors[spec]
  )
}

# Showing the 3D plot
rgl::rglwidget()
