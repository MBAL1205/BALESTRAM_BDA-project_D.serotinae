##### Creating a clustering for each species' ecological niche
# Aggregating and clustering data
df2 <- clean_matrix[, colnames(clean_matrix) %in% c("species", "tmax", "tmin", "rain", "elevation", "ph")]
aggregated_df2 <- aggregate(. ~ species, data = df2, FUN = mean)
df2_hclust <- aggregated_df2[, colnames(aggregated_df2) %in% c("tmax", "tmin", "rain", "elevation", "ph")]
dist_df2 <- vegdist(df2_hclust, method = "euclidean")
hclust_df2 <- hclust(dist_df2, method = "complete")
dendro_df2 <-  as.phylo(hclust_df2)

# Assigning IDs and factors
aggregated_df2$ID <- seq_len(nrow(aggregated_df2))
ID <- as.factor(aggregated_df2$ID)
target_factor <- as.factor(aggregated_df2$species)
g2 <- split(ID, target_factor)

# Creating tree plot
tree_plot2 <- ggtree::groupOTU(dendro_df2, g2, group_name = "Species")

# Defining colors
cols <- distinctColorPalette(length(unique(target_factor)))
cols <- cols[1:(length(unique(target_factor)) + 1)]

# Plotting discrete tree
circ <- ggtree(tree_plot2, aes(color = Species), size = 1) +
  geom_tiplab(size = 3) +
  scale_color_manual(values = cols, name = "Species") +  
  labs(title = "Species Cluster Tree")

circ

### Comment: This data suggests the possibility of a phytosociological differentiation between two potential associations: one predominant at lower altitudes (Cser, Cgry, Tpur), and the other roughly above 800 meters (Dalp, Bcon). The isolation of Hcon might be due to its rarity or its extremely xeric, arid and sun-exposed ecological preference.

###########################################################################

##### Creating a PCA for the habitat ecological niche

# Preparing data
df <- clean_matrix
df <- na.omit(df)
df_continuous <- df[, colnames(df) %in% c("tmax", "tmin", "rain", "elevation", "ph")]
df_continuous <- apply(df_continuous, 2, as.numeric)
df_discrete <- df[, !(colnames(df) %in% c("tmax", "tmin", "rain", "elevation", "ph"))]

# Performing and plotting PCA
pca_res <- prcomp(df_continuous, scale. = TRUE)

pca_var <- autoplot(pca_res, data = df_discrete, colour = 'species',
          loadings = TRUE, loadings.colour = 'black',
         loadings.label = TRUE, loadings.label.size = 3, frame = TRUE, frame.type = 'norm') +
  theme_classic() +
  labs(title = "PCA Analysis of D. serotinae ecological niche, based on characteristic species",
       colour = "species")

### Comment: This data, accounting for 65% of the variability, reveals the overlap of different species' ecological niches, justifying the classification of their presence within a single habitat. The potential centroid point of overlap may represent the optimal habitat conditions where all species can thrive.
### Comment: The narrower niche of Danthonia alpina results from its distribution being strictly confined to the dry grasslands of Mount San Giorgio.

###########################################################################

##### Estimating Kernel density on the PCA to evaluate the habitat's ecological niche

# Cleaning and preparing the data
df <- clean_matrix
df <- na.omit(df)
df_continous <- df[, colnames(df) %in% c("tmax", "tmin", "rain", "elevation", "ph")]
df_discrete <- df[, !(colnames(df) %in% c("tmax", "tmin", "rain", "elevation", "ph"))]

row.names(df_continous) <- 1:nrow(df_continous)

# Calculating the distance matrix and perform PCoA
dist_matt <- vegdist(df_continous, method = "euclidean")

D3_data_dist <- cmdscale(dist_matt, k = 3)
D3_data_dist <- data.frame(D3_data_dist)

cols <- df_discrete$species

# Calculating the KDE on the PCoA
kde <- kde2d(D3_data_dist$X1, D3_data_dist$X2, n = 50)

kde_df <- as.data.frame(expand.grid(x = kde$x, y = kde$y))
kde_df$z <- as.vector(kde$z)

# Visualising the density with ggplot
plot_kde <- ggplot(kde_df, aes(x, y)) +
  geom_tile(aes(fill = z)) +
  scale_fill_viridis_c() +
  geom_point(data = D3_data_dist, aes(x = X1, y = X2), color = "red", alpha = 0.5) +
  theme_minimal() +
  labs(title = "Kernel Density Estimation")

# Defining a threshold
threshold <- quantile(kde_df$z, 0.9)       # Modify to be more or less restrictive

# Filtering the points above the threshold
high_density_region <- kde_df[kde_df$z > threshold, ]

high_density_points <- st_as_sf(high_density_region, coords = c("x", "y"))

# Calculating the polygon around the points
high_density_polygon <- st_convex_hull(st_union(high_density_points))

# Check the polygon
quart_kde <- plot(D3_data_dist$X1, D3_data_dist$X2)
quart_kde <- plot(st_geometry(high_density_polygon), add = TRUE)

df <- clean_matrix
df$X1 <- D3_data_dist$X1
df$X2 <- D3_data_dist$X2
df_sf <- st_as_sf(df, coords = c("X1", "X2"))

# Filtering the data inside the polygon
filtered_matrix <- df_sf[st_intersects(df_sf, high_density_polygon, sparse = FALSE), ]

filtered_matrix <- data.frame(filtered_matrix)

# Plotting filtered data
# Histogram for maximal mean temperature
h_tmax <- hist(filtered_matrix$tmax, 
          breaks = 25, 
          xlab = "Maximal mean temperature", 
          main = "Histogram of Maximal Mean Temperature",
          xlim = range(filtered_matrix$tmax, na.rm = TRUE))

# Histogram for minimal mean temperature
h_tmin <- hist(filtered_matrix$tmin, 
          breaks = 10, 
          xlab = "Minimal mean temperature", 
          main = "Histogram of Minimal Mean Temperature",
          xlim = range(filtered_matrix$tmin, na.rm = TRUE))

# Histogram for mean yearly precipitations
h_rain <- hist(filtered_matrix$rain, 
          reaks = 10, 
          xlab = "Mean yearly precipitations", 
          main = "Histogram of Mean Yearly Precipitations",
          xlim = range(filtered_matrix$rain, na.rm = TRUE))

# Histogram for elevation
h_elev <- hist(filtered_matrix$elevation, 
          breaks = 10, 
          xlab = "Elevation", 
          main = "Histogram of Elevation",
          xlim = range(filtered_matrix$elevation, na.rm = TRUE))

# Histogram for soil pH (0-5 cm)
h_ph <- hist(filtered_matrix$ph, 
          breaks = 10, 
          xlab = "Soil pH (0-5 cm)", 
          main = "Histogram of Soil pH (0-5 cm)",
          xlim = range(filtered_matrix$ph, na.rm = TRUE))

### Comment-T: The optimal temperature for most species occurrences falls within mean minimal temperatures above 5°C and maximums below 17-18°C. This aligns with the insubric and temperate climatic conditions of Canton Ticino, where both the species and the habitat are most recurrent. The mean annual temperature above approximately 10°C corresponds with the habitat description from Delarze et al. (2015).
### Comment-R: Most occurrences happen between 105 and 125 mm of rainfall per year, which is below the regional average (200mm). This could be explained by the Mediterranean influences in the southern part of the canton, where the habitat is most prevalent.
### Comment-E: This is truly fascinating. It confirms the distinct occurrence pattern, with a significant cluster between 550 and 600 meters and another between 900 and 1100 meters. Delarze et al. (2015) did not anticipate this, and the Swiss habitat reference only indicates main occurrences below 400m. Conducting phytosociological studies could highlight potential associations within the Diplachnion serotinae alliance.
### Comment-pH: Equally fascinating, D. serotinae is known to thrive on both silicate and calcareous substrates. However, here we observe a strong frequency on more acidic (pH 5.5) superficial soils, likely rendzine type.

### Comment: This addresses everything I wanted to know, and I'm thrilled with the results. Anything beyond this is more for exercise purposes rather than answering my initial question. Thank you!
