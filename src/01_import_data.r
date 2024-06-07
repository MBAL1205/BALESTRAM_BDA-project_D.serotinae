# Creating data frame for each species
Bcon <- c("Bromus condensatus")
Cgry <- c("Chrysopogon gryllus")
Cser <- c("Cleistogenes serotina")
Dalp <- c("Danthonia alpina")
Hcon <- c("Heteropogon contortus")
Tpur <- c("Thliphthisa purpurea")

##########################################################################GBIF

# Downloading GBIF occurrences for all the species
Bcon_gbif <- occ_data(scientificName = Bcon, country = "CH", hasCoordinate = TRUE, limit = 5000)
Cgry_gbif <- occ_data(scientificName = Cgry, country = "CH", hasCoordinate = TRUE, limit = 5000)
Cser_gbif <- occ_data(scientificName = Cser, country = "CH", hasCoordinate = TRUE, limit = 5000)
Dalp_gbif <- occ_data(scientificName = Dalp, country = "CH", hasCoordinate = TRUE, limit = 5000)
Hcon_gbif <- occ_data(scientificName = Hcon, country = "CH", hasCoordinate = TRUE, limit = 5000)
Tpur_gbif <- occ_data(scientificName = Tpur, country = "CH", hasCoordinate = TRUE, limit = 5000)

# Extracting all occurrences for Switzerland
occur <- Bcon_gbif$data
Bcon_gbif_ch <- occur[occur$country == "Switzerland", c("scientificName", "decimalLatitude", "decimalLongitude")]

occur <- Cgry_gbif$data
Cgry_gbif_ch <- occur[occur$country == "Switzerland", c("scientificName", "decimalLatitude", "decimalLongitude")]

occur <- Cser_gbif$data
Cser_gbif_ch <- occur[occur$country == "Switzerland", c("scientificName", "decimalLatitude", "decimalLongitude")]

occur <- Dalp_gbif$data
Dalp_gbif_ch <- occur[occur$country == "Switzerland", c("scientificName", "decimalLatitude", "decimalLongitude")]

occur <- Hcon_gbif$data
Hcon_gbif_ch <- occur[occur$country == "Switzerland", c("scientificName", "decimalLatitude", "decimalLongitude")]

occur <- Tpur_gbif$data
Tpur_gbif_ch <- occur[occur$country == "Switzerland", c("scientificName", "decimalLatitude", "decimalLongitude")]

# Combining all occurences together
all_species_gbif <- rbind(Bcon_gbif_ch, Cgry_gbif_ch, Cser_gbif_ch, Dalp_gbif_ch, Hcon_gbif_ch, Tpur_gbif_ch)

# Retrieving spatial data for Switzerland
Switzerland <- ne_countries(scale = "medium", returnclass = "sf", country = "Switzerland")

# Extracting relevant data from GBIF occurrences
species <- all_species_gbif$scientificName
latitude <- all_species_gbif$decimalLatitude
longitude <- all_species_gbif$decimalLongitude
source <- rep("gbif", length(species))

# Creating a data frame for GBIF data
all_data_gbif <- data.frame(species, latitude, longitude, source)

# Fixing species synonyms
all_data_gbif$species[grep("Andropogon",all_data_gbif$species) ] <- "Heteropogon contortus"
all_data_gbif$species[grep("Asperula",all_data_gbif$species) ] <- "Thliphthisa purpurea"
all_data_gbif$species[grep("Molinia",all_data_gbif$species) ] <- "Cleistogenes serotina"

# Without plant author
all_data_gbif$species[grep("Bromus",all_data_gbif$species) ] <- "Bromus condensatus"
all_data_gbif$species[grep("Chrysopogon",all_data_gbif$species) ] <- "Chrysopogon gryllus"
all_data_gbif$species[grep("Cleistogenes",all_data_gbif$species) ] <- "Cleistogenes serotina"
all_data_gbif$species[grep("Danthonia",all_data_gbif$species) ] <- "Danthonia alpina"
all_data_gbif$species[grep("Heteropogon",all_data_gbif$species) ] <- "Heteropogon contortus"
all_data_gbif$species[grep("Thliphthisa",all_data_gbif$species) ] <- "Thliphthisa purpurea"

###################################################################iNaturalist

# Downloading iNaturalist occurrences for all the species, in Switzerland

# Bcon_inat_ch <- get_inat_obs(query = "Bromus condensatus", place_id = "switzerland")        # No data
Cgry_inat_ch <- get_inat_obs(query = "Chrysopogon gryllus", place_id = "switzerland")
Cser_inat_ch <- get_inat_obs(query = "Cleistogenes serotina", place_id = "switzerland")
Dalp_inat_ch <- get_inat_obs(query = "Danthonia alpina", place_id = "switzerland")
# Hcon_inat_ch <- get_inat_obs(query = "Heteropogon contortus", place_id = "switzerland")     # No data
Tpur_inat_ch <- get_inat_obs(query = "Asperula purpurea", place_id = "switzerland")

# Combining all occurences together
all_data_inat <- rbind(Cgry_inat_ch, Cser_inat_ch, Dalp_inat_ch, Tpur_inat_ch)

# Extracting relevant data from iNaturalist occurrences
species <- all_data_inat$scientific_name
latitude <- all_data_inat$latitude
longitude <- all_data_inat$longitude
source <- rep("inat", length(species))

# Creating a data frame for iNaturalist data
all_data_inat <- data.frame(species, latitude, longitude, source)

#####################################################################InfoFlora

# Loading observations from CSV dataset
all_species_infoflora <- read.csv("C:/Users/USER/Desktop/Biodiversity conservation/2023_SP/Biodiversity data analysis/_Personal_project/data/InfoFlora_data_wgs84.csv", sep = ";")

# Fixing species synonyms
all_species_infoflora$species[grep("Asperula",all_species_infoflora$species) ]      <- "Thliphthisa purpurea"

# Without plant author
all_species_infoflora$species[grep("Bromus",all_species_infoflora$species) ]        <- "Bromus condensatus"
all_species_infoflora$species[grep("Chrysopogon",all_species_infoflora$species) ]   <- "Chrysopogon gryllus"
all_species_infoflora$species[grep("Cleistogenes",all_species_infoflora$species) ]  <- "Cleistogenes serotina"
all_species_infoflora$species[grep("Danthonia",all_species_infoflora$species) ]     <- "Danthonia alpina"
all_species_infoflora$species[grep("Heteropogon",all_species_infoflora$species) ]   <- "Heteropogon contortus"
all_species_infoflora$species[grep("Thliphthisa",all_species_infoflora$species) ]   <- "Thliphthisa purpurea"


######################################################################All_data

# Combining GBIF, iNaturalist and InfoFlora data frames
matrix_full <- rbind(all_data_gbif, all_data_inat, all_species_infoflora)

# Plotting combined data on a map of Switzerland
p1 <- ggplot(data = Switzerland) +
  geom_sf() +
  geom_point(data = matrix_full, aes(x = longitude, y = latitude, fill = species), size = 2, shape = 23) +
  theme_classic() +
  ggtitle("Characteristic Species Occurrences (n=3313)") +
  xlab("Longitude") +
  ylab("Latitude") +
  labs(fill = "Species")
