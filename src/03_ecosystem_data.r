# Setting the file path to the GeoTIFF
file_path <- "C:/Users/USER/Desktop/Biodiversity conservation/2023_SP/Biodiversity data analysis/_Personal_project/data/WorldEcosystem.tif"

# Reading the raster GeoTIFF
ecosystem_raster <- raster(file_path)

# Extracting, cropping and masking the ecosystems in Switzerland
Switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="Switzerland" )

r2 <- crop(ecosystem_raster, extent(Switzerland))
ecosystem_switzerland <- mask(r2, Switzerland)

# Creating spatial points for extraction
spatial_points <- SpatialPoints(coords = matrix_full_alt[, c("longitude","latitude")], proj4string = CRS("+proj=longlat +datum=WGS84"))

# Extracting and printing ecosystem values
eco_values <- raster::extract(ecosystem_switzerland, spatial_points)

# Reading metadata
metadat_eco <- read.delim("C:/Users/USER/Desktop/Biodiversity conservation/2023_SP/Biodiversity data analysis/_Personal_project/data/WorldEcosystem.metadata.tsv")

# Creating a matrix with species, coordinates and associated ecosystems
matrix_full_alt_eco <- data.frame(matrix_full_alt, eco_values)

matrix_full_alt_eco <- merge(matrix_full_alt_eco,metadat_eco,by.x="eco_values",by.y="Value",all.x=T)

# Removing row names
row.names(matrix_full_alt_eco) <- NULL
